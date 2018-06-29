unit trace;

interface

uses  DISQLite3Database, DISystemCompat, VirtualTrees, SysUtils, classes, routine_strings, Variants;

implementation

uses debugger, isbl_debugger_frm, dock_isbl_tree_unit, routine_debug, dock_breaks, variable_table_unit, forms;

procedure StartDebug(InterpreterID: Integer; const ProgramCaption, Text, CallStack: WideString);
var
  i : integer;
  parent_node, prev_node, seek_node, node, new_object_node : PVirtualNode;
  parent_data, prev_data, seek_data, new_node_data         : PVSTDebugObject;
  parent_name                     : string;
  work_strings                    : TStringList;
  vars                            : ^TList;
  count                           : integer;
  current_object_description      : string;
  current_object_type_description : string;
  cur_level                       : integer;
  seek_interpreter                : integer;
  parent_id                       : Integer;
  mem_start                       : LongInt;
  mem_end                         : longInt;
begin
//  isbl_debugger.MarqueeProgressBar1.Position := 1;
  isbl_debugger.counter_started_scripts := isbl_debugger.counter_started_scripts + 1;
  isbl_debugger.status.Panels[2].Text := 'Обработки: ' + inttostr( isbl_debugger.counter_started_scripts );

  try
    mem_start   := GetTakenMem();
    parent_node := nil;

      work_strings      := TStringList.Create;
      work_strings.Text := CallStack;

      if work_strings.Text = '' then
        work_strings.Text := 'Нет данных';

      try
        cur_level              := work_strings.Count;
        if cur_level > 1 then
        begin
          parent_name := work_strings[1];
          parent_data := dock_isbl_tree.tree.GetNodeData( isbl_debugger.last_object_node );
          if Assigned( parent_data ) then
          if parent_data^.friendly_name = parent_name then
          begin
            parent_node := isbl_debugger.last_object_node ;
            parent_id   := parent_data.interpreterID;
          end;
        end;
        dock_isbl_tree.tree.ClearSelection();
      except
         ON e:Exception do
         begin
          DebugMessage( 'TDebugger.StartDebug: исключение. Код(1). ' + e.Message );
          ShowDebug();
         end;
      end;

      //--------------------------------------------------------------------------
      new_object_node := dock_isbl_tree.tree.AddChild( parent_node );

      if dock_isbl_tree.tree.TotalCount = 1 then
         isbl_debugger.first_object_node := new_object_node;

      dock_isbl_tree.tree.ValidateNode(new_object_node, False);

      new_node_data   := dock_isbl_tree.tree.GetNodeData( new_object_node );
      new_node_data.Create();
      new_node_data^.system_code                     := SubString( ProgramCaption, '.', 1 );
      new_node_data^.caption                         := SubString( ProgramCaption, new_node_data^.system_code + '.', 2 );
//      new_node_data^.code_cache_position             := code_cache.AddCode( Text );
      new_node_data^.my_node                         := new_object_node;
      new_node_data^.friendly_name                   := work_strings[0];
//      new_node_data^.call_stack                      := CallStack;
      new_node_data^.level                           := cur_level;
      new_node_data^.interpreterID                   := InterpreterID;
      new_node_data^.variable_table.step_count       := 0;
      new_node_data^.enviroment_variables.step_count := 0;
      current_object_description                     := work_strings[0];
      work_strings.Text := text;

      new_node_data^.variable_table.InitFaststeps( work_strings.Count );
      new_node_data^.enviroment_variables.InitFaststeps( work_strings.Count );

      if Assigned( parent_node ) then
      begin
        new_node_data^.parent_data          := dock_isbl_tree.tree.GetNodeData( parent_node );
        new_node_data^.parent_interpreterID := parent_id;
      end
      else
        new_node_data^.parent_interpreterID := -1;

      current_object_type_description := SubString( current_object_description, ' ', 1 );

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
      //------------------------------------------------------------------------

      isbl_debugger.stop_line              := 1;
      isbl_debugger.current_node_data      := Addr(new_node_data^);
      isbl_debugger.current_node           := Addr(new_object_node^);
      isbl_debugger.last_interpreterID     := InterpreterID;
      isbl_debugger.last_interpreter_level := new_node_data^.level;


      //Чистка------------------------
      work_strings.Free;
      mem_end := GetTakenMem;

  except
    ON  E:Exception do
    begin
      DebugMessage('TDebugger.StartDebug необработанная ошибка: InterpreterID: '+ #13 + IntToStr(InterpreterID) + #13 + 'ProgramCaption: ' + ProgramCaption + #13 + ' Text:' + Text + #13 + 'CallStack: ' + CallStack + #13 + #13 + #13 + #13 + e.Message);
      ShowDebug();
    end;
  end;
end;

procedure FinishDebug(InterpreterID: Integer);
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

procedure GotoLine(InterpreterID, LineNumber: Integer; Variables, EnvironmentVariables: OleVariant);
var
  str           : string;
  str_converted : string;
  step          : integer;
  vars_ammount  : integer;
  var_name      : string;
  save_position : integer;
  steps_count   : integer;
  I:integer;
  variable      : PVariable;
  strings_vars  : PVarsHistory;
  node          : PVirtualNode;
  data          : PVSTDebugObject;
  break_point   : PVSTStepPointObject;
  variable_search : PVariable;
  steps_node   : PVirtualNode;
  prev_line : integer;
  prev_step : integer;
  name, value : string;

  // trace
  variable_id   : integer;

  label loop;
begin
  try
    isbl_debugger.counter_rendered_lines             := isbl_debugger.counter_rendered_lines + 1;
    isbl_debugger.status.Panels[3].Text              := 'Строки: ' + inttostr( isbl_debugger.counter_rendered_lines );

      try

         if not Assigned( isbl_debugger.current_node ) then exit;
           data := dock_isbl_tree.tree.GetNodeData( isbl_debugger.current_node );

         isbl_debugger.last_object_node   := isbl_debugger.current_node;
         isbl_debugger.last_interpreterID := InterpreterID;

         //рабочая переменная для работы с данными ноды
      except
         DebugMessage('TDebugger.GotoLine: исключение Код ( 1 ). '+ #13 + 'InterpreterID: ' + IntToStr( InterpreterID ) + #13 + ' LineNumber: ' + IntToStr( LineNumber ) + #13 );
         ShowDebug();
      end;

      //цикл для того чтобы стопориться на точке останова
    loop:
      if isbl_debugger.last_rendered_line <> LineNumber then
      begin
        try
        //ВИЗУАЛЬНАЯ ЧАСТЬ--------------------------------------------------------
        if Assigned( data ) then
        begin
          //сохраняем информацию
          //сейчас мы на такой-то строчке
          PVSTDebugObject( data )^.line_number                      := LineNumber;
          PVSTDebugObject( data )^.variable_table.step_count        := PVSTDebugObject( data )^.variable_table.step_count        + 1;
          PVSTDebugObject( data )^.enviroment_variables.step_count  := PVSTDebugObject( data )^.enviroment_variables.step_count  + 1;
          step := PVSTDebugObject( data )^.variable_table.step_count;
          //выделять надо строчку такую-то
          isbl_debugger.last_step_line := LineNumber;
          isbl_debugger.SetLastRenderedLine( LineNumber );
        end;
        //------------------------------------------------------------------------
       except
         DebugMessage('TDebugger.GotoLine: исключение Код ( 2 ). '+ #13 + 'InterpreterID: ' + IntToStr( InterpreterID ) + #13 + ' LineNumber: ' + IntToStr( LineNumber ) + #13 );
         ShowDebug();
       end;

        if Assigned( data ) then
        begin
          try
            //создаем точку останова информацию о которой передал нам проводник
            vars_ammount := VarArrayHighBound( Variables, 1 ) - VarArrayLowBound( Variables, 1 ) ;

            // ОБРАБОТКА ПЕРЕМЕННЫХ------------------------------------------------
            i := VarArrayLowBound(Variables, 1);
            while i <= VarArrayHighBound( Variables, 1 ) do
            begin
              New( variable );
              name      := Variables[ i,0 ];
              value     := Variables[ i,1 ];
              prev_line := PVSTDebugObject( data )^.variable_table.GetLastStepPointLine;
              prev_step := PVSTDebugObject( data )^.variable_table.GetLastStepPointStep;
              variable_search := PVSTDebugObject( data )^.variable_table.GetVariableByName( name );

              if not Assigned( variable_search ) then
                 PVSTDebugObject( data )^.variable_table.AddVariable( name, script_variable_type );

              PVSTDebugObject( data )^.variable_table.AddVariableValue( name, value,  prev_line, prev_step );

              Inc( i );
            end;

         except
             DebugMessage('TDebugger.GotoLine: исключение Код ( 3 ). '+ #13 + 'InterpreterID: ' + IntToStr( InterpreterID ) + #13 + ' LineNumber: ' + IntToStr( LineNumber ) + #13 );
             ShowDebug();
         end;

         try
            //сохраняем информацию о точке останова в ноде
            // ОБРАБОТКА ПЕРЕМЕННЫХ ОКРУЖЕНИЯ-----------------------------------
            i := VarArrayLowBound( EnvironmentVariables, 1 );
            while i <= VarArrayHighBound( EnvironmentVariables, 1 ) do
            begin
              New( variable );
              name      := EnvironmentVariables[ i,0 ];
              value     := EnvironmentVariables[ i,1 ];

              prev_line := PVSTDebugObject( data )^.enviroment_variables.GetLastStepPointLine;
              prev_step := PVSTDebugObject( data )^.enviroment_variables.GetLastStepPointStep;
              variable_search := PVSTDebugObject( data )^.enviroment_variables.GetVariableByName( name );
                if not Assigned( variable_search ) then
                   PVSTDebugObject( data )^.enviroment_variables.AddVariable( name, global_variable_type );
              PVSTDebugObject( data )^.enviroment_variables.AddVariableValue( name, value,  prev_line, prev_step );
              Inc( i );

            end;
            //--------------------------------------------------------------------
          except
            DebugMessage('TDebugger.GotoLine: исключение Код ( 4 ). '+ #13 + 'InterpreterID: ' + IntToStr( InterpreterID ) + #13 + ' LineNumber: ' + IntToStr( LineNumber ) + #13 );
            ShowDebug();
          end;
       end;

         PVSTDebugObject( data )^.variable_table.AddStepPoint( lineNumber );
         PVSTDebugObject( data )^.enviroment_variables.AddStepPoint( lineNumber );
         steps_count := PVSTDebugObject( data )^.variable_table.steps.Count;
         steps_node  := dock_steps_form.AddStepPoint( lineNumber, steps_count );
      end;

      if not isbl_debugger.on_hold then
        if data.stop_points.stops_fast_access[ LineNumber ] = '1'  then
        begin
          isbl_debugger.SetOnHold();
        end;

  except
    DebugMessage(' TDebugger.GotoLine необработанная ошибка. ' + #13 + 'InterpreterID: ' + IntToStr( InterpreterID ) + #13 + ' LineNumber: ' + IntToStr( LineNumber ) + #13 );
    ShowDebug();
  end;

end;

end.
