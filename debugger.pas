unit debugger;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, directum_debugger_TLB, StdVcl,
  Dialogs, SysUtils, Classes, VirtualTrees, Forms,
  Variants, variable_table_unit, synedit, Zlib,
  psapi, windows, JclDebug;

function GetTakenMem():LongInt;


type
   TAutomationObjectType = (
      function_type,
      script_type,
      route_event_type,
      route_type,
      reference_event_type,
      document_event_type,
      report_type,
      workflow_block_event,
      requisite_change_event
     );

type
  PStopInfo = ^stopinfo;
  stopinfo = record
    line : integer;
end;

type
   TStops = class
      stops : TList;
      stops_fast_access : TStringList;

      constructor Create();
      procedure PlaceMarks();
      procedure DeleteMark( line:integer );
      procedure AddMark( line:integer );
   end;

//ОБЪЕКТ ОТЛАДКИ. По простому сценарий, событие, расчет, шаблон итд-------------
 PVSTDebugObject = ^TVSTDebugObject;
   TVSTDebugObject = record
    line_number          : Integer;
    code_strings         : string;
    call_stack           : string;
    interpreterID        : Integer;
    level                : integer;
    parent_data          : PVSTDebugObject;
    my_node              : PVirtualNode;
    finished             : boolean;
    stop_points          : TStops;
    code_cache_position  : integer;
    text_filtered        : boolean;
    system_code          : string;
    search_highlighted   : boolean;
    parent_interpreterID : integer;
    variable_table       : TVariablesTable;
    enviroment_variables : TVariablesTable;
    automation_type      : TAutomationObjectType;
    caption              : string;
    friendly_name        : string;
    parent, next_sibling, previous_sibling : PVirtualNode;

    procedure Create();
    procedure Free();
 end;
//------------------------------------------------------------------------------

type
  TDebugger = class(TAutoObject, IDebugger)
  private
    procedure AddStepToObject(LineNumber: Integer; data: PVSTDebugObject);
    procedure ParseVariableTable(VariablesInfo: OleVariant; var
        variables_table:TVariablesTable);
    procedure FinishSteppingOver;
    /// Отмечает последнюю обработанную строчку
    procedure GotoLine_SetLastRenderedLine(LineNumber: Integer);
    procedure GotoLine_Start_VisualRoutine;
    procedure SetAutomationType(current_object_type_description, current_object_description: string; var new_node_data: PVSTDebugObject);
    procedure SetCurrentInterpterAsLast;
    procedure SetEditorCurrentNode(node: PVirtualNode);
    procedure SetEditorSelectedNode(node: PVirtualNode);
    procedure StartDebug_Finishing_SetEditor(new_object_node: PVirtualNode);
    procedure UpdateObjectWithLastLine(LineNumber: Integer; data: PVSTDebugObject);
  protected
    procedure FinishDebug(InterpreterID: Integer); safecall;
    procedure GotoLine(InterpreterID, LineNumber: Integer; Variables, EnvironmentVariables: OleVariant); safecall;
    procedure Ping; safecall;
    procedure StartDebug(InterpreterID: Integer; const ProgramCaption, Text, CallStack: WideString); safecall;
end;

type
  startInfo = record
   InterpreterID  : Integer;
   ProgramCaption : WideString;
   Text           : WideString;
   CallStack      : WideString;
end;

type
  lineInfo = record
   InterpreterID, LineNumber: Integer;
   Variables, EnvironmentVariables: OleVariant;

end;

type
  TCodeCache = class
    list : TList;
    constructor Create();
    function AddCode( code:string ):integer;
    function CodeHash( code: string):integer;
    function GetCode( position:integer ):string;
    procedure Clear;
end;

var
 code_cache : TCodeCache;

implementation

uses ComServ, isbl_debugger_frm, routine_strings, dock_isbl_tree_unit, dock_breaks, routine_debug, DISQLite3Database, DISystemCompat;

// trace
//procedure InsertStartDebug( system_code, caption, friendly_name, text, call_stack:string; level, interpreterID:integer; object_type:string );
//const
//  InsertSQL = 'INSERT INTO Objects( caption, text, friendly_name, call_stack, system_code, interpreterID, object_type ) VALUES ( ?,?,?,?,?,?,? );';
//var
//  ID, r: Integer;
//  Stmt: TDISQLite3Statement;
//begin
//  { Prepare a insert statement. }
//  Stmt := FDatabase.Prepare16(InsertSQL);
//  try
//    { We bind all columns as strings. DISQLite3 will convert them to
//      integers or floats as appropriate. }
//    Stmt.Bind_Str16(1, caption);
//    Stmt.Bind_Str16(2, text);
//    Stmt.Bind_Str16(3, friendly_name);
//    Stmt.Bind_Str16(4, call_stack);
//    Stmt.Bind_Str16(5, system_code);
//    Stmt.Bind_Str16(6, inttostr(interpreterID));
//    Stmt.Bind_Str16(7, object_type);
//
//    { Step once to execute statement and insert data. }
//    Stmt.Step;
//    { Retrieve the RowID of the newly inserted record. }
//    //ID := FDatabase.LastInsertRowID;
//  finally
//    Stmt.Free;
//  end;
//end;

// trace
procedure InsertVariableValue( variableID, interpreterID:integer; value:string; line,step:integer; local:boolean );
const
  InsertSQLLocal = 'INSERT INTO variables_values( interpreterID, variableID, step, line, value ) VALUES ( ?,?,?,?,? );';
  InsertSQLEnv = 'INSERT INTO env_variables_values( interpreterID, variableID, step, line, value ) VALUES ( ?,?,?,?,? );';
var
  ID, r: Integer;
  Stmt: TDISQLite3Statement;
begin
  if local then
    Stmt := FDatabase.Prepare16(InsertSQLLocal)
  else
    Stmt := FDatabase.Prepare16(InsertSQLEnv);
  try
    Stmt.Bind_Int( 1, interpreterID );
    Stmt.Bind_Int( 2, variableID );
    Stmt.Bind_Int( 3, step );
    Stmt.Bind_Int( 4, line );
    Stmt.Bind_Str16(5, value);
    Stmt.Step;
    ID := FDatabase.LastInsertRowID;
  finally
    Stmt.Free;
  end;
end;

procedure InsertLocalVariableValue( variableID, interpreterID:integer; value:string; line,step:integer );
begin
  InsertVariableValue( variableID, interpreterID, value, line,step, true );
end;

procedure InsertEnvironmentVariableValue( variableID, interpreterID:integer; value:string; line,step:integer );
begin
  InsertVariableValue( variableID, interpreterID, value, line, step, false );
end;

function GetVariableIDFromTrace(name:string; local:boolean):integer;
const
  InsertSQLLocal = 'INSERT INTO Variables( name ) VALUES ( ? );';
  SelectSQLLocal = 'SELECT RowID FROM Variables WHERE Name = ? ';

  InsertSQLEnv = 'INSERT INTO env_variables( name ) VALUES ( ? );';
  SelectSQLEnv = 'SELECT RowID FROM env_variables WHERE Name = ? ';
var
 Stmt: TDISQLite3Statement;
 field_id:integer;
 id : integer;
 RowCount:integer;
 state : integer;
begin

  if local then
    Stmt := FDatabase.Prepare16( SelectSQLLocal )
  else
    Stmt := FDatabase.Prepare16( SelectSQLEnv );

   try
    Stmt.Bind_Str16( 1, name );
    RowCount := 1;
    while Stmt.Step = 100 do
      begin
        ID       := Stmt.Column_Int( 0 );
        state := 100;
      end;
  finally
    Stmt.Free;
  end;

  if local then
    Stmt := FDatabase.Prepare16( InsertSQLLocal )
  else
    Stmt := FDatabase.Prepare16( InsertSQLEnv );

  if state <> 100 then
  begin
      try
        Stmt.Bind_Str16(1, name);
        Stmt.Step;
        { Retrieve the RowID of the newly inserted record. }
        ID := FDatabase.LastInsertRowID;
      finally
        stmt.Free;
      end;
  end;

  result := ID;
end;

function GetLocalVariableIDFromTrace( name:string ):integer;
begin
  result := GetVariableIDFromTrace( name, true );
end;

function GetEnvironmentVariableIDFromTrace( name:string ):integer;
begin
  result := GetVariableIDFromTrace( name, false );
end;

function GetTakenMem():LongInt;
var
   pmc: PPROCESS_MEMORY_COUNTERS;
   cb: Integer;
   text : string;
   size : integer;
 begin
   cb := SizeOf(_PROCESS_MEMORY_COUNTERS);
   GetMem(pmc, cb);
   pmc^.cb := cb;

   if GetProcessMemoryInfo( GetCurrentProcess(), pmc, cb ) then
   begin
     size := pmc^.WorkingSetSize;
     result := size;
   end
   else
   FreeMem(pmc);
 end;

function ZCompressString(aText: string; aCompressionLevel: TZCompressionLevel): string;
var
  strInput,
  strOutput: TStringStream;
  Zipper: TZCompressionStream;
begin
  Result:= '';
  strInput:= TStringStream.Create(aText);
  strOutput:= TStringStream.Create;
  try
    Zipper:= TZCompressionStream.Create(strOutput, aCompressionLevel);
    try
      Zipper.CopyFrom(strInput, strInput.Size);
    finally
      Zipper.Free;
    end;
    Result:= strOutput.DataString;
  finally
    strInput.Free;
    strOutput.Free;
  end;
end;

function ZDecompressString(aText: string): string;
var
  strInput,
  strOutput: TStringStream;
  Unzipper: TZDecompressionStream;
begin
  Result:= '';
  strInput:= TStringStream.Create(aText);
  strOutput:= TStringStream.Create;
  try
    Unzipper:= TZDecompressionStream.Create(strInput);
    try
      strOutput.CopyFrom(Unzipper, Unzipper.Size);
    finally
      Unzipper.Free;
    end;
    Result:= strOutput.DataString;
  finally
    strInput.Free;
    strOutput.Free;
  end;
end;

constructor TCodeCache.Create;
var
  i:integer;
begin
  list := TList.Create;
  for i := 0 to 100000 do
  begin
    list.Add(nil);
  end;
end;

procedure TCodeCache.Clear;
var
  i:integer;
begin
  list.Clear;
  for i := 0 to 100000 do
  begin
    list.Add(nil);
  end;
end;

function TCodeCache.AddCode( code:string ):integer;
var
  position : integer;
  code_strings : ^TStringList;
  code_text : ^string;
begin
  try
    position := CodeHash( code );
    if not Assigned( list[position] )  then
    begin
    {
      New( code_strings );
      code_strings^     := TStringList.Create;
      code_strings.Text := ZCompressString( code, zcMax );
      }
      New(code_text);
      code_text^ := ZCompressString( code, zcMax );
      list[position]    := code_text;
    end;
    Result := position;
  except
    ON E:Exception do  DebugMessageAndShow(  e.Message );
  end;
end;

function TCodeCache.GetCode( position:integer ):string;
var
  code_text : ^String;
begin
  try
    code_text := list[position];
    result    := ZDecompressString(  code_text^  );
  except
    ON E:Exception do  DebugMessageAndShow(  e.Message );
  end;
end;

//Считаю хеш для того чтобы хранить только уникальные строки
function TCodeCache.CodeHash( code: string ):integer;
var
  i:cardinal;
begin
  Result := 0;
  for i := 0 to length(code) do
    Result := Result + Ord( code[ i ] );

  Result := Result mod list.Count;
end;

procedure TStops.PlaceMarks;
var
  i:integer;
var
  amark : TSynEditMark;
begin
  isbl_debugger.isbl_text.Marks.Clear;
  for i := 0 to stops.Count - 1 do
  begin
    amark            := TSynEditMark.Create( isbl_debugger.isbl_text );
    amark.Line       := PStopInfo( stops[i] ).line;
    amark.ImageIndex := 2;
    amark.Visible    := true;
    isbl_debugger.isbl_text.Marks.Add(amark);
  end;
end;

procedure TStops.DeleteMark( line:integer );
var
  i:integer;
begin
try
  stops_fast_access[ line ] := '0';
  for i := 0 to stops.Count-1 do
    if PStopInfo( stops[i] ).line = line then
    begin
      stops.Delete(i);
      isbl_debugger.isbl_text.Marks.ClearLine( line );
      break;
    end;
  except
    ON E:Exception do  DebugMessageAndShow(  e.Message );
  end;
end;

procedure TStops.AddMark( line:integer );
var
  amark     : TSynEditMark;
  stop_info : PStopInfo;
begin
  amark                     := TSynEditMark.Create( isbl_debugger.isbl_text );
  amark.Line                := line;
  amark.ImageIndex          := 2;
  amark.Visible             := true;
  stops_fast_access[ line ] := '1';
  New( stop_info );
  stop_info^.line           := line;
  stops.Add( stop_info );
  isbl_debugger.isbl_text.Marks.Add( amark );
end;

constructor TStops.Create;
var
  i:integer;
begin
  stops             := TList.Create;
  stops_fast_access := TStringList.Create;

  for i := 0 to 2000 do
    stops_fast_access.Add('0');
end;

procedure TVSTDebugObject.Create();
begin
  variable_table              := TVariablesTable.Create;
  variable_table.isLocalTable := True;
  variable_table.isEnvTable   := false;

  enviroment_variables              := TVariablesTable.Create;
  enviroment_variables.isLocalTable := False;
  enviroment_variables.isEnvTable   := True;

  stop_points          := TStops.Create;
end;

procedure TVSTDebugObject.Free();
begin
  line_number   := 0;
  code_strings  := '';
  call_stack    := '';
  interpreterID := 0;
  level         := 0;
  parent_data   := nil;
  my_node       := nil;
  finished      := false;
  stop_points.stops.Clear;

  code_cache_position := 0;

  try
    variable_table.variables.Clear;
    variable_table.steps_fast_table.Clear;
    variable_table.steps.Clear;
  finally

  end;

  try
    enviroment_variables.variables.Clear;
    enviroment_variables.steps_fast_table.Clear;
    enviroment_variables.steps.Clear;
  finally

  end;

  caption       := '';
  friendly_name := '';

  stop_points.Free;
end;

procedure TDebugger.AddStepToObject(LineNumber: Integer; data: PVSTDebugObject);
var
  steps_count: integer;
  steps_node : PVirtualNode;
begin
  try
    PVSTDebugObject( data )^.variable_table.AddStepPoint( lineNumber );
    PVSTDebugObject( data )^.enviroment_variables.AddStepPoint( lineNumber );
    steps_count := PVSTDebugObject( data )^.variable_table.steps.Count;
  except
    ON E:Exception do  DebugMessageAndShow(  e.Message );
  end;
end;

procedure TDebugger.ParseVariableTable(VariablesInfo: OleVariant; var
    variables_table:TVariablesTable);
var
  I              : integer;
  variable       : PVariable;
  variable_search: PVariable;
  prev_line      : integer;
  prev_step      : integer;
  name           : string;
  value          : string;
  variablesCount : Integer;
  variableType: TDIRVarType;
  variable_id    : integer;
begin
  //сохраняем информацию о точке останова в ноде
  // ОБРАБОТКА ПЕРЕМЕННЫХ ОКРУЖЕНИЯ-----------------------------------
  i := VarArrayLowBound( VariablesInfo, 1 );
  variablesCount := VarArrayHighBound( VariablesInfo, 1 );
  while i <= variablesCount do
  begin
    name            := VariablesInfo[ i,0 ];
    value           := VariablesInfo[ i,1 ];
    prev_line       := variables_table.GetLastStepPointLine;
    prev_step       := variables_table.GetLastStepPointStep;

    // найти переменную и либо заполнить её, либо создать и заполнить
    variable_search := variables_table.GetVariableByName( name );

    if variables_table.isEnvTable then
      variableType := global_variable_type;

    if variables_table.isLocalTable then
      variableType := script_variable_type;


    if not Assigned( variable_search ) then
       variables_table.AddVariable( name, variableType );

    // внести значение из текущей строки
    variables_table.AddVariableValue( name, value,  prev_line, prev_step );
    Inc( i );
  end;
  //--------------------------------------------------------------------;
end;

procedure TDebugger.StartDebug(InterpreterID: Integer; const ProgramCaption, Text, CallStack: WideString);
var
  code_strings                     : TStringList;
  parent_node, new_object_node     : PVirtualNode;
  parent_data, new_node_data       : PVSTDebugObject;
  parent_name                      : string;
  work_strings                     : TStringList;
  current_object_description       : string;
  current_object_type_description  : string;
  cur_level                        : integer;
  parent_id                        : Integer;
  mem_start                        : LongInt;
  mem_end                          : longInt;
  program_caption                  : string;
  system_code                      : string;
begin
  parent_id := -1;
  isbl_debugger.MarqueeProgressBar1.Position := 1;
  isbl_debugger.counter_started_scripts      := isbl_debugger.counter_started_scripts + 1;
  isbl_debugger.status.Panels[ 2 ].Text      := 'Обработки: ' + inttostr( isbl_debugger.counter_started_scripts );

  try
    mem_start   := GetTakenMem();
    parent_node := nil;
    if isbl_debugger.on_off_state then
    begin
      isbl_debugger.last_rendered_line := -1;

      try
        work_strings      := TStringList.Create;
        code_strings      := TStringList.Create;
        code_strings.Text := text;
        work_strings.Text := CallStack;
        if work_strings.Text = '' then
          work_strings.Text := 'Нет данных';
        cur_level := work_strings.Count; // по строчке на уровень, можно опираться на это. Не очень красиво.

        if cur_level > 1 then
        begin
          parent_name := work_strings[ 1 ];
          parent_data := dock_isbl_tree.tree.GetNodeData( isbl_debugger.last_object_node );
          if Assigned( parent_data ) and ( parent_data^.friendly_name = parent_name ) then
          begin
            parent_node := isbl_debugger.last_object_node ;
            parent_id   := parent_data.interpreterID;
          end;
        end;

      except
        ON E:Exception do  DebugMessageAndShow(  e.Message );
      end;

      //--------------------------------------------------------------------------
      new_object_node := dock_isbl_tree.tree.AddChild( parent_node );

      if dock_isbl_tree.tree.TotalCount = 1 then
         isbl_debugger.first_object_node := new_object_node;

      new_node_data   := dock_isbl_tree.tree.GetNodeData( new_object_node );
      new_node_data.Create();

      system_code     := SubString( ProgramCaption, '.', 1 );
      program_caption := SubString( ProgramCaption, system_code + '.', 2 );

      new_node_data^.system_code                     := system_code;
      new_node_data^.caption                         := program_caption;
      new_node_data^.code_cache_position             := code_cache.AddCode( Text );
      new_node_data^.my_node                         := new_object_node;
      new_node_data^.friendly_name                   := work_strings[0];
      new_node_data^.call_stack                      := CallStack;
      new_node_data^.level                           := cur_level;
      new_node_data^.interpreterID                   := InterpreterID;
      new_node_data^.variable_table.step_count       := 0;
      new_node_data^.enviroment_variables.step_count := 0;
      current_object_description                     := work_strings[0];

   {
     InsertStartDebug(
         SubString( ProgramCaption, '.', 1 ),
         SubString( ProgramCaption, new_node_data^.system_code + '.', 2 ), // system code
         work_strings[0], // friendly name
         text,
         CallStack,
         cur_level,
         interpreterID,
         current_object_description );
         }

      if Assigned( parent_node ) then
      begin
        new_node_data^.parent_data          := dock_isbl_tree.tree.GetNodeData( parent_node );
        new_node_data^.parent_interpreterID := parent_id;
      end
      else
        new_node_data^.parent_interpreterID := -1;

      current_object_type_description := SubString( current_object_description, ' ', 1 );
      SetAutomationType( current_object_type_description, current_object_type_description, new_node_data );
      StartDebug_Finishing_SetEditor( new_object_node );

      work_strings.Free();
      code_strings.Free();
      mem_end := GetTakenMem();
    end;
  except
    ON E:Exception do  DebugMessageAndShow(  e.Message );
  end;
end;

procedure TDebugger.FinishDebug(InterpreterID: Integer);
var
  node : PVirtualNode;
  data : PVSTDebugObject;
begin
  if isbl_debugger.on_off_state then
  begin
    node := dock_isbl_tree.SeekNodeByInterpreterID( InterpreterID );
    if Assigned( node ) then
    begin
      data          := dock_isbl_tree.tree.GetNodeData( node );
      dock_isbl_tree.tree.Refresh;
      data.Finished := true;
    end;
  end;
end;

procedure TDebugger.FinishSteppingOver;
begin
  isbl_debugger.SetOnHold();
  isbl_debugger.step_over_parentID := -1;
  isbl_debugger.stepping_over      := false;
end;

procedure TDebugger.GotoLine(InterpreterID, LineNumber: Integer; Variables, EnvironmentVariables: OleVariant);
const
  break_point_here = '1';
var
  node  : PVirtualNode;
  data  : PVSTDebugObject;
  label loop;
begin

  if not isbl_debugger.on_off_state then
    Exit();

  try
     GotoLine_Start_VisualRoutine();

     //установить текущую ноду по номеру интерпретатора
     //Визуально переключаем выбранную ноду---------------------------------
     node := dock_isbl_tree.SeekNodeByInterpreterID( InterpreterID );
     data := dock_isbl_tree.tree.GetNodeData( isbl_debugger.current_node );
     if isbl_debugger.current_node <> node then
       SetEditorCurrentNode( node );
     if (isbl_debugger.stepping_over) and ( InterpreterID = isbl_debugger.step_over_parentID ) then
       SetEditorSelectedNode( node );
     //---------------------------------------------------------------------

     //ШАГАЕМ НАД-----------------------------------------------------------
     //Если шагаем обратно в родителя откуда выбрали пропустить подчиненную функцию
     if InterpreterID = isbl_debugger.step_over_parentID then
       FinishSteppingOver();
     if not Assigned( isbl_debugger.current_node ) then
       exit();
    SetCurrentInterpterAsLast();

    // петля для удерживания DIRECTUM в ожидании отладчика
    loop:

      if isbl_debugger.last_rendered_line <> LineNumber then
      begin
        if Assigned( data ) then
        begin
          GotoLine_SetLastRenderedLine( LineNumber );
          UpdateObjectWithLastLine( LineNumber, data );

          ParseVariableTable( Variables,            data.variable_table );
          ParseVariableTable( EnvironmentVariables, data.enviroment_variables );

          AddStepToObject( LineNumber, data );
        end;
      end;

      //Если тут точка останова, тогда здесь надо остановиться.
      if ( not isbl_debugger.on_hold ) and
         ( data.stop_points.stops_fast_access[ LineNumber ] = break_point_here ) then
           isbl_debugger.SetOnHold();

      //точка останова------------------------------------------------------------
      if isbl_debugger.on_hold then
        if isbl_debugger.hold_this_line then
        begin
          Application.ProcessMessages;
          Sleep( 10 );
          goto loop;
        end;
      //--------------------------------------------------------------------------

      if isbl_debugger.on_hold then
         isbl_debugger.hold_this_line := true;

  except
    DebugMessage(' TDebugger.GotoLine необработанная ошибка. ' + #13 + 'InterpreterID: ' + IntToStr( InterpreterID ) + #13 + ' LineNumber: ' + IntToStr( LineNumber ) + #13 );
    ShowDebug();
  end;

end;

procedure TDebugger.GotoLine_SetLastRenderedLine(LineNumber: Integer);
begin
  isbl_debugger.last_step_line := LineNumber;
  isbl_debugger.SetLastRenderedLine( LineNumber );
end;

procedure TDebugger.GotoLine_Start_VisualRoutine;
begin
  isbl_debugger.MarqueeProgressBar1.Visible        := true;

  if not isbl_debugger.display_how_debug_goes then
    isbl_debugger.group_background_working.Visible := true;

  isbl_debugger.Timer_hide_status.Enabled          := true;
  isbl_debugger.counter_rendered_lines             := isbl_debugger.counter_rendered_lines + 1;
  isbl_debugger.status.Panels[3].Text              := 'Строки: ' + inttostr( isbl_debugger.counter_rendered_lines );
  isbl_debugger.MarqueeProgressBar1.Position       := 1;
  isbl_debugger.MarqueeProgressBar2.Position       := 1;
end;

procedure TDebugger.Ping;
begin
  // Ничего не делаем, даем немедленный возврат.
  // Это говорит о том, что мы живы.
end;

procedure TDebugger.SetAutomationType( current_object_type_description,  current_object_description: string; var new_node_data: PVSTDebugObject );
begin
  //Определить тип события чтобы проставить пиктограмму---------------------
  if current_object_type_description = 'Блок' then
    new_node_data^.automation_type := workflow_block_event;
  if current_object_type_description = 'Функция' then
    new_node_data^.automation_type := function_type;
  if current_object_type_description = 'Сценарий' then
    new_node_data^.automation_type := script_type;
  if current_object_type_description = 'Событие' then
  begin
    if FindSubString( current_object_description, 'типового маршрута' )  then
      new_node_data^.automation_type := route_event_type;

    if FindSubString( current_object_description, 'набора данных' )  then
      new_node_data^.automation_type := reference_event_type;

    if FindSubString( current_object_description, 'реквизита' )  then
      new_node_data^.automation_type := requisite_change_event;
  end;
  //------------------------------------------------------------------------;
end;

procedure TDebugger.SetCurrentInterpterAsLast;
var
  data: PVSTDebugObject;
begin
  isbl_debugger.last_object_node   := isbl_debugger.current_node;
  data := dock_isbl_tree.tree.GetNodeData( isbl_debugger.current_node );
  if Assigned( data ) then  
  isbl_debugger.last_interpreterID := data.interpreterID;
end;

procedure TDebugger.SetEditorCurrentNode(node: PVirtualNode);
begin
  isbl_debugger.current_node := node;
  dock_isbl_tree.tree.ClearSelection();
  dock_isbl_tree.tree.FocusedNode := isbl_debugger.current_node;
end;

procedure TDebugger.SetEditorSelectedNode(node: PVirtualNode);
begin
  dock_isbl_tree.tree.ClearSelection();
  dock_isbl_tree.tree.FocusedNode := isbl_debugger.current_node;
  dock_isbl_tree.tree.Selected[ isbl_debugger.current_node ] := true;
end;

procedure TDebugger.StartDebug_Finishing_SetEditor( new_object_node: PVirtualNode );
var
  new_node_data: PVSTDebugObject;
begin
  new_node_data := dock_isbl_tree.tree.GetNodeData( new_object_node );
  isbl_debugger.stop_line              := 1;
  isbl_debugger.current_node_data      := Addr( new_node_data^ );
  isbl_debugger.current_node           := Addr( new_object_node^ );
  isbl_debugger.last_interpreterID     := new_node_data.interpreterID;
  isbl_debugger.last_interpreter_level := new_node_data^.level;

  //Визуально переключаем ноду----------------------------------------------
  if not isbl_debugger.stepping_over then
  begin
    dock_isbl_tree.tree.Selected[ new_object_node ] := true;   //Выделение нового узла
    dock_isbl_tree.tree.FocusedNode                 := new_object_node;      //Фокусировка нового узла
    dock_isbl_tree.ApplyVirtualVisibility( dock_isbl_tree.tree );
    dock_steps_form.steps_tree.Clear;
  end;
  //------------------------------------------------------------------------;
end;

procedure TDebugger.UpdateObjectWithLastLine(LineNumber: Integer; data:
    PVSTDebugObject);
begin
  PVSTDebugObject( data )^.line_number                      := LineNumber;
  PVSTDebugObject( data )^.variable_table.step_count        := PVSTDebugObject( data )^.variable_table.step_count        + 1;
  PVSTDebugObject( data )^.enviroment_variables.step_count  := PVSTDebugObject( data )^.enviroment_variables.step_count  + 1;
end;

initialization
  //Настройка COM сервера-------------------------------------------------------
  TAutoObjectFactory.Create(ComServer, TDebugger, Class_Debugger,
   ciMultiInstance, tmApartment);
  //отключаю уведомление о подключенынх клиентах когда закрываю программу.
  ComServer.UIInteractive := false;
  //----------------------------------------------------------------------------
  code_cache := TCodeCache.Create;


end.
