unit variable_table_unit;



interface

  uses Classes, Dialogs, SysUtils, JclDebug, Arrays;


function compareValuesByLine(Item1 : Pointer; Item2 : Pointer) : Integer;
function compareValuesByHistoryIndex(Item1 : Pointer; Item2 : Pointer) : Integer;

//Устаревает--------------------------------------------------------------------
  type
    TDIRVarType = ( script_variable_type, global_variable_type );

  type
   PVarsHistory = ^VarsHistory;
   VarsHistory = record
     variables   : TList;
     environment : TList;
   end;
//------------------------------------------------------------------------------

//ТАБЛИЦА ПЕРЕМЕННЫХ------------------------------------------------------------
  type
  PVariableValue = ^TVariableValue;
    TVariableValue = record
      value         : string;
      linenumber    : integer;
      history_index : integer;
      step : integer;
  end;

 type
  PVariable = ^TVariable;
    TVariable = record
      name     : string;
      var_type : TDIRVarType;
      values   : TList;
      public
       function GetValueCount():integer;
       property ValueCount : integer read GetValueCount;
       function AddValue( value:string; line_number:integer; step:integer ):PVariableValue;
       function GetValuesForLine(line:integer):string;
  end;

  //Таблица переменных----------------------------------------------------------
  TVariablesTable = class(TObject)
    isLocalTable     : boolean;
    isEnvTable       : boolean;
    variables        : TList;
//  steps_fast_table : TStringList;
    steps_fast_table : IIntArray;
    steps            : TStringList;
    step_count       : integer;

    constructor Create() overload;
    procedure Free();
    protected

    public
      /// Функция создает переменную в реестре переменных объекта при обработке таблиц
      /// переменных в GotoLine
      function AddVariable(var_name:string; given_variable_type:TDIRVarType):
          PVariable;
      function GetVariablesCount():integer;
      property VariablesCount: integer read GetVariablesCount;
      procedure AddVariableValue( name:string; value:string; line_number:integer; step:integer );
      function GetVariableByName( name:string ):PVariable;
      function GetVariableByIndex( index:integer ):PVariable;
      function VariableExists( name:string ):boolean;
      procedure AddStepPoint( line:integer );
      function GetLastStepPointLine():integer;
      function GetLastStepPointStep():integer;
      procedure InitFastSteps( string_count:integer );
  end;
  //----------------------------------------------------------------------------

   PVSTStepPointObject = ^TVSTStepPointObject;
     TVSTStepPointObject = record
     line_number   : integer;
     step          : integer;
     text          : string;
     highlight     : boolean;
   end;
//------------------------------------------------------------------------------

implementation

uses dock_variables_list_frm, routine_debug, isbl_debugger_frm;

function compareValuesByLine(Item1 : Pointer; Item2 : Pointer) : Integer;
var
  value1, value2 : TVariableValue;
begin
  value1 := TVariableValue(Item1^);
  value2 := TVariableValue(Item2^);

  // Теперь сравнение строк
  if      value1.linenumber > value2.linenumber
    then Result := 1
  else
  if value1.linenumber = value2.linenumber
    then Result := 0
  else
    Result := -1;
end;

function compareValuesByHistoryIndex(Item1 : Pointer; Item2 : Pointer) : Integer;
var
  value1, value2 : TVariableValue;
begin
  value1 := TVariableValue(Item1^);
  value2 := TVariableValue(Item2^);

  // Теперь сравнение строк
  if value1.history_index > value2.history_index
    then Result := 1
  else
  if value1.history_index = value2.history_index
    then Result := 0
  else
    Result := -1;
end;

function TVariable.GetValueCount():integer;
begin
  result := values.Count;
end;

function TVariable.GetValuesForLine(line:integer):string;
var
  i:integer;
  current_line : integer;
  last_line    : integer;
  results      : TStringList;
  last_result : string;
begin
  try
      last_result       := '';
      last_line         := 0;
      results           := TStringList.Create;
      results.Delimiter := ';';
      for i := 0 to values.count - 1 do
      begin
        current_line := PVariableValue( values.items[i] )^.linenumber;
        if current_line <= line then
        begin
          if current_line > last_line  then
            last_result := PVariableValue( values.items[i] )^.value
          else
            results.Add( last_result );
          last_line := current_line;
        end;
      end;
      results.Add( last_result );
      Result := results.DelimitedText;
  except
     ShowMessage( ProcByLevel() + ': Ошибка при работе с: ' + inttostr(i) );
     exit();
  end;

end;

function TVariablesTable.GetLastStepPointLine: integer;
begin
  result := 1;
  if steps.Count > 0 then
     result := StrToInt( steps[ steps.Count - 1] );
end;

function TVariablesTable.GetLastStepPointStep: integer;
begin
  result := 1;
    if steps.Count > 0 then
      result := steps.Count;
end;

procedure TVariablesTable.AddStepPoint( line:integer );
begin
  try
    steps.Add( IntToStr( line ) );
   steps_fast_table[ line ]:= 1
//  if steps_fast_table.Count >= line+1  then
//    steps_fast_table[ line ]:= 1
//  else
//     DebugMessageAndShow( 'Количество элементов fast_table недостаточно для хранения информации о строке. Сейчас это: ' + IntToStr( steps_fast_table.Count  ) + ' из ' + IntToStr(line) );
  except
    ON E:Exception do DebugMessageAndShow(  e.Message );
  end;
end;

function TVariable.AddValue( value:string; line_number:integer; step:integer ):PVariableValue;
var
  value_obj : PVariableValue;
begin
  try
    new(value_obj);
    value_obj^.value         := value;
    value_obj^.linenumber    := line_number;
    value_obj^.history_index := values.Count;
    value_obj^.step := step;
    values.Add( value_obj );
    result := value_obj;
  except
    ON E:Exception do  DebugMessageAndShow(  e.Message );
  end;
end;

function TVariablesTable.GetVariablesCount():integer;
begin
  result := variables.Count;
end;

constructor TVariablesTable.Create();
begin
  inherited Create();
  variables         := TList.Create;
  steps            := TStringList.Create;
//  steps_fast_table := TStringList.Create;
  steps_fast_table := CreateArray();
end;


procedure TVariablesTable.InitFastSteps( string_count:integer );
var
i:integer;
begin
  try
    steps_fast_table := CreateArray();
  except
    ON E:Exception do  DebugMessageAndShow(  e.Message );
  end;
end;

procedure TVariablesTable.Free();
begin
  inherited Free;
  steps.Free;
//  steps_fast_table.Free;
end;


procedure TVariablesTable.AddVariableValue( name:string; value:string; line_number:integer; step:integer );
var
  variable  : PVariable;
  value_obj : PVariableValue;
begin
  try
  
    try
      variable  := GetVariableByName( name );
    except
       DebugMessage( 'TVariablesTable.AddVariableValue: variable  := GetVariableByName( name );' );
       ShowDebug();
    end;
    
    try
      value_obj := variable.AddValue( value, line_number, step );
    except
      DebugMessage( 'TVariablesTable.AddVariableValue: value_obj := variable.AddValue( value, line_number, step );' );
      ShowDebug();
    end;

    try
      if isbl_debugger.display_how_debug_goes then
        dock_variables_list.AddValue( value_obj, nil, variable^.name );
    except
      DebugMessage( 'TVariablesTable.AddVariableValue: dock_variables_list.AddValue( value_obj, nil, variable^.name );' );
      ShowDebug();
    end;

  except
    ON E:Exception do  DebugMessageAndShow(  e.Message );
  end;
end;

function TVariablesTable.AddVariable(var_name:string;
    given_variable_type:TDIRVarType): PVariable;
var
 variable :  PVariable;
begin
ProcByLevel();
  try
    New(variable);
    variable^.name   := var_name;
    variables.Add( variable );
    variable^.values := TList.Create;
    result           := variable;
    dock_variables_list.AddVariable( variable, given_variable_type );
  except
    ON E:Exception do  DebugMessageAndShow(  e.Message );
  end;
end;

function TVariablesTable.GetVariableByName( name:string ):PVariable;
var
  i:integer;
begin
  result := nil;
  for i := 0 to variables.Count -1 do
    begin
     if PVariable( variables.Items[ i ] )^.name = name then
      result := variables.Items[ i ];
    end;
end;

function TVariablesTable.GetVariableByIndex( index:integer ):PVariable;
var
  i:integer;
begin
  result := nil;
  result := variables.Items[index];
end;

function TVariablesTable.VariableExists( name:string ):boolean;
var
  i:integer;
begin
  result := false;
  for i := 0 to variables.Count -1 do
    begin
     result := true;
    end;
end;

end.

