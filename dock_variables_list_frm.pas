unit dock_variables_list_frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, Grids, SynEdit, DockPanel, ExtCtrls, KControls, KGrids, StdCtrls, sEdit, 
  sLabel, sPanel, VirtualTrees, debugger, variable_table_unit, JvComponentBase,
  JvDockControlForm, ComCtrls, ToolWin, sToolBar, sCheckBox, Menus, Clipbrd, JCLDebug;

type
  Tdock_variables_list = class(TForm)
    filter_panel: TsPanel;
    filter_ed_variable: TsEdit;
    variable_tree: TVirtualStringTree;
    Группа: TsPanel;
    JvDockClient1: TJvDockClient;
    sPanel3: TsPanel;
    filter_ed_value: TsEdit;
    Инструменты: TsToolBar;
    tool_collapse: TToolButton;
    tool_expand: TToolButton;
    Panel3: TsPanel;
    box_show_current: TsCheckBox;
    tool_variables: TToolButton;
    tool_enviroment_variables: TToolButton;
    variablestree_popup: TPopupMenu;
    popup_value_copy: TMenuItem;
    popup_variable_monitor: TMenuItem;
    popup_value_show_in_window: TMenuItem;
    N1: TMenuItem;
    popup_variable_copy: TMenuItem;
    popup_variable_copy_ps: TMenuItem;
    tool_copy_pseudo: TToolButton;
    popup_variable_show_value: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure variable_treeGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure variable_treeFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure FormResize(Sender: TObject);
    procedure VariablesList_FeelForObject();
    procedure ApplyVirtualVisibility();
    procedure filter_ed_valueChange(Sender: TObject);
    procedure filter_ed_variableChange(Sender: TObject);
    procedure tool_collapseClick(Sender: TObject);
    procedure tool_expandClick(Sender: TObject);
    procedure variable_treeDblClick(Sender: TObject);
    procedure variable_treeGetImageIndex(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: Boolean; var ImageIndex: Integer);
    procedure variable_treeBeforeCellPaint(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      CellPaintMode: TVTCellPaintMode; CellRect: TRect; var ContentRect: TRect);
    procedure box_show_currentClick(Sender: TObject);
    procedure tool_variablesClick(Sender: TObject);
    procedure tool_enviroment_variablesClick(Sender: TObject);
    procedure popup_value_copyClick(Sender: TObject);
    procedure popup_variable_monitorClick(Sender: TObject);
    procedure variable_treeContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure popup_value_show_in_windowClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure popup_variable_copyClick(Sender: TObject);
    procedure popup_variable_copy_psClick(Sender: TObject);
    procedure tool_copy_pseudoClick(Sender: TObject);
    procedure popup_variable_show_valueClick(Sender: TObject);
    procedure variable_treeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
    function AddVariable( variable:PVariable; given_variable_type:TDIRVarType ):PVirtualNode;
    procedure HighlightStepVariables( step:integer );
    procedure UpdateVariablesInfo( line:integer );
    procedure AddVariableFull( variable:PVariable; given_variable_type:TDIRVarType );
    procedure AddValue( variable_value:PVariableValue; variable_node:PVirtualNode; variable_name:string );
    procedure HighlightLineVariables( line:integer );
    function LocateVariableNodeByName( name:string ):PVirtualNode;
    procedure SaveControlsPositions();
    procedure RestoreControls();
    procedure OnRun();
    procedure Popup_AddToVisible( current_context:string; tree_popup:TPopupMenu );
    procedure Popup_HideAll( tree_popup:TPopupMenu );
    procedure ShowVariableCurValueInWindow( node : PVirtualNode );
    procedure ShowValueInWindow( node:PVirtualNode );
  end;

type
  PVSTVariableNodeData = ^TVariableNodeData;
    TVariableNodeData = record
      text      : string;
      value_col : string;
      value     : PVariableValue;
      variable  : PVariable;
      highlight : Boolean;
      inuse     : boolean;
      monitor   : boolean;
  end;

var
  dock_variables_list: Tdock_variables_list;

const
  pic_index_script_variable = 2;
  pic_index_global_variable = 5;

implementation

uses dock_isbl_tree_unit, isbl_debugger_frm, routine_debug, routine_strings,
  dock_breaks, frm_nonvisual, main, DISQLite3Database, DISystemCompat;

{$R *.dfm}

function RGBToColor(R, G, B: Byte): TColor;
begin
  Result := B shl 16 or G shl 8 or R;
end;

procedure Tdock_variables_list.OnRun;
begin
  RestoreControls();
end;

procedure Tdock_variables_list.SaveControlsPositions();
begin
  configuration.WriteBool('vars', 'tool_variables', tool_variables.down );
  configuration.WriteBool('vars', 'tool_enviroment_variables', tool_enviroment_variables.down );
  configuration.WriteBool('vars', 'box_show_current', box_show_current.checked );
end;

procedure Tdock_variables_list.RestoreControls();
begin
  tool_variables.down            := configuration.ReadBool('vars', 'tool_variables', tool_variables.Down );
  tool_enviroment_variables.down := configuration.ReadBool('vars', 'tool_enviroment_variables', tool_enviroment_variables.down );
  box_show_current.checked       := configuration.ReadBool('vars', 'box_show_current', box_show_current.checked );
end;

procedure Tdock_variables_list.HighlightStepVariables( step:integer );
var
  i,j           : integer;
  value_node    : PVirtualNode;
  variable_node : PVirtualNode;
  variable_data : PVSTVariableNodeData;
  data          : PVSTVariableNodeData;
begin

  for I := 0 to variable_tree.TotalCount - 1 do
    begin
      //Подготовка шага цикла---------------------------------------------------
      if I <> 0 then
        value_node := variable_tree.GetNext(value_node)
      else
        value_node := variable_tree.GetFirst;

      //по умолчанию узел отображается до тех пор пока его не скроет один из механизмов ниже
      data := variable_tree.GetNodeData( value_node );
      if assigned( data ) then
      begin

        if Assigned( data^.variable ) then
          data^.highlight := false;

        if Assigned( data^.value ) then
        begin
          variable_data := variable_tree.GetNodeData( value_node.Parent );
          if data^.value^.step = step then
          begin
             variable_data.Highlight := true;
             data^.highlight := True;
          end
            else
              data^.highlight := false;
        end;

      end;
    end;
  ApplyVirtualVisibility;
end;


procedure Tdock_variables_list.HighlightLineVariables( line:integer );
var
  i,j:integer;
  value_node : PVirtualNode;
  variable_node : PVirtualNode;
  variable_data : PVSTVariableNodeData;
  data : PVSTVariableNodeData;
  words         : TStringList;
  line_str : PWideChar;
begin
try
  line_str := PWideChar(isbl_debugger.isbl_text.Lines[ line-1 ]);
  words := TStringList.Create;
  CollectWord( line_str, words );

  for I := 0 to variable_tree.TotalCount - 1 do
    begin
      //Подготовка шага цикла---------------------------------------------------
      if I <> 0 then
        value_node := variable_tree.GetNext(value_node)
      else
        value_node := variable_tree.GetFirst;

      //по умолчанию узел отображается до тех пор пока его не скроет один из механизмов ниже
      data := variable_tree.GetNodeData( value_node );
      if assigned( data ) then
      begin

        if Assigned( data^.variable ) then
        begin
          data^.highlight := false;
          data^.inuse     := false;
          try
            for j := 0 to words.count -1 do
              if data^.variable^.name = words[j] then
               data^.inuse := true;
          except ON E:Exception do  DebugMessageAndShow(  e.Message ); end;
        end;

        if Assigned( data^.value ) then
        begin

          variable_data := variable_tree.GetNodeData( value_node.Parent );
          if data^.value^.linenumber = line then
          begin
             variable_data.Highlight := true;
             data^.highlight := true;
          end
            else
             data^.highlight := false;


        end;
      end;
    end;
    ApplyVirtualVisibility;
    except ON E:Exception do  DebugMessageAndShow(  e.Message ); end;
end;

procedure Tdock_variables_list.UpdateVariablesInfo( line:integer );
var
  i:integer;
  node : PVirtualNode;
  data : PVSTVariableNodeData;
begin
  try
    //data.variable.values.Sort(compareValuesByLine );
  except ON E:Exception do  DebugMessageAndShow(  e.Message ); end;

  try
    for I := 0 to variable_tree.TotalCount - 1 do
      begin
        //Подготовка шага цикла-------------------------------------------------
        try
          if I <> 0 then
            node := variable_tree.GetNext(node)
          else
            node := variable_tree.GetFirst;
            data := variable_tree.GetNodeData( node );
        except ON E:Exception do  DebugMessageAndShow(  e.Message ); end;
        //----------------------------------------------------------------------

        //Получить значения-----------------------------------------------------
        try
          if assigned(data) then
          if not Assigned( data.value ) then
          if Assigned( data^.variable ) then
            data^.value_col := data^.variable^.GetValuesForLine(line);
        except ON E:Exception do  DebugMessageAndShow(  e.Message ); end;
        //----------------------------------------------------------------------
      end;

      variable_tree.Refresh;

    except ON E:Exception do  DebugMessageAndShow(  e.Message ); end;
end;

procedure Tdock_variables_list.ApplyVirtualVisibility();
var
  i,j           : integer;
  node          : PVirtualNode;
  data          : PVSTVariableNodeData;
  visible_state : boolean;
begin
  for I := 0 to variable_tree.TotalCount - 1 do
    begin
      //Подготовка шага цикла---------------------------------------------------
      if I <> 0 then
        node := variable_tree.GetNext(node)
      else
        node := variable_tree.GetFirst;
      //по умолчанию узел отображается до тех пор пока его не скроет один из механизмов ниже
      visible_state := true;

      data := variable_tree.GetNodeData( node );
      if assigned( data ) then
      begin
        //Выводить только подсвеченные------------------------------------------
        if Assigned( data^.variable ) and ( box_show_current.Checked ) then
        begin
         if ( data^.highlight = False  )
          then visible_state := false;

         if ( data^.monitor = False  )
          then visible_state := false;

         if ( data^.highlight = true )
          then visible_state := true;

         if ( data^.monitor = true )
           then visible_state := true;

         if ( data^.inuse = true )
           then visible_state := true;
        end;

        if Assigned( data^.variable ) and ( not tool_variables.Down ) then
          if data^.variable^.var_type = script_variable_type then
            visible_state := false;

        if Assigned( data^.variable ) and ( not tool_enviroment_variables.Down ) then
          if data^.variable^.var_type = global_variable_type then
            visible_state := false;

        //НАЗВАНИЕ ПЕРЕМЕННОЙ ФИЛЬТР ПО ТЕКСТОВОМУ КРИТЕРИЮ---------------------
        if StringAssigned( filter_ed_variable.text ) then
          if Assigned( data^.variable ) then
          if not FindSubString( data.text, filter_ed_variable.text ) then
            visible_state := false;

        //ЗНАЧЕНИЕ ПЕРЕМЕННОЙ ФИЛЬТР ПО ТЕКСТОВОМУ КРИТЕРИЮ---------------------
        if StringAssigned( filter_ed_value.text ) then
          if Assigned( data^.value ) then
          if not FindSubString( data^.value^.value , filter_ed_value.text ) then
            visible_state := false;

        variable_tree.IsVisible[ node ] := visible_state;
      end;
    end;


    //Скрыть все родительские узлы, дочерние узлы которых были скрыты------------
    for I := 0 to variable_tree.TotalCount - 1 do
    begin
      //Подготовка шага цикла
      if I <> 0 then
        node := variable_tree.GetNext( node )
      else
        node := variable_tree.GetFirst;
        if Assigned( node ) then
          begin
          data := variable_tree.GetNodeData( node );
            if Assigned( data^.variable ) then
            if vsAllChildrenHidden in node.States then
            begin
              variable_tree.IsVisible[ node ] := false;
            end;
          end;
    end;

    variable_tree.Refresh;
end;

procedure Tdock_variables_list.box_show_currentClick(Sender: TObject);
begin
  ApplyVirtualVisibility();
end;

procedure Tdock_variables_list.filter_ed_valueChange(Sender: TObject);
begin
  ApplyVirtualVisibility();
end;

procedure Tdock_variables_list.filter_ed_variableChange(Sender: TObject);
begin
  ApplyVirtualVisibility();
end;

procedure Tdock_variables_list.FormCreate(Sender: TObject);
begin
  variable_tree.NodeDataSize := SizeOf( TVariableNodeData );
end;

procedure Tdock_variables_list.FormDestroy(Sender: TObject);
begin
  SaveControlsPositions();
end;

procedure Tdock_variables_list.FormResize(Sender: TObject);
begin
  if Assigned( dock_variables_list ) then
  begin
     filter_ed_variable.Width := dock_variables_list.Width - filter_ed_variable.Left - 5;
     filter_ed_value.Width    := dock_variables_list.Width - filter_ed_variable.Left - 5;
  end;
end;

procedure Tdock_variables_list.ShowVariableCurValueInWindow( node : PVirtualNode );
var
  data : PVSTVariableNodeData;
begin
  if Assigned( node ) then
  begin
    //Собираем данные. после установки фильтра ноды умрут вместе с Data
    data := variable_tree.GetNodeData( node );
    if Assigned( data ) then
    begin
        EditText( data.value_col );
    end;
  end;
end;

procedure Tdock_variables_list.popup_variable_show_valueClick(Sender: TObject);
var
  node : PVirtualNode;
  data : PVSTVariableNodeData;
begin
  node  := variable_tree.FocusedNode;
  if Assigned( node ) then
  begin
     ShowVariableCurValueInWindow( node );
  end;
  variable_tree.Refresh;
end;

procedure Tdock_variables_list.tool_collapseClick(Sender: TObject);
begin
  variable_tree.FullCollapse();
end;

procedure Tdock_variables_list.tool_copy_pseudoClick(Sender: TObject);
var
  i:integer;
  node : PVirtualNode;
  data : PVSTVariableNodeData;
  pseudo_code : string;
begin
 pseudo_code := '';
 for I := 0 to variable_tree.TotalCount - 1 do
    begin
      //Подготовка шага цикла
      if I <> 0 then
        node := variable_tree.GetNext( node )
      else
        node := variable_tree.GetFirst;
        if variable_tree.IsVisible[ node ] then

        if Assigned( node ) then
        begin
          data := variable_tree.GetNodeData( node );
          if Assigned( data.variable ) then
          begin
            pseudo_code := pseudo_code + data^.variable^.name + ' = ' + data^.value_col + #13;
          end;
        end;

    end;
  if length( pseudo_code ) >0 then
    Clipboard.asText := pseudo_code;

end;

procedure Tdock_variables_list.tool_enviroment_variablesClick(Sender: TObject);
begin
  ApplyVirtualVisibility();
end;

procedure Tdock_variables_list.tool_expandClick(Sender: TObject);
begin
  variable_tree.FullExpand();
end;

procedure Tdock_variables_list.tool_variablesClick(Sender: TObject);
begin
  ApplyVirtualVisibility();
end;

procedure Tdock_variables_list.variable_treeBeforeCellPaint(
  Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode;
  Column: TColumnIndex; CellPaintMode: TVTCellPaintMode; CellRect: TRect;
  var ContentRect: TRect);
var
  data : PVSTVariableNodeData;
begin
  data := variable_tree.GetNodeData( node );

  //отслеживаемая
  data := variable_tree.GetNodeData( node );
  if Assigned( data^.variable ) then
    if ( data^.monitor ) and ( Column = 0 ) then
    begin
      CellRect.Left := CellRect.Left;
      TargetCanvas.Brush.Color :=  RGBToColor( 255,119,144 );
      //TargetCanvas.RoundRect(CellRect, 5, 5);
      TargetCanvas.FillRect(CellRect);
      InflateRect(ContentRect, -1, -1);
    end;

  //используемая в строке
  data := variable_tree.GetNodeData( node );
  if Assigned( data^.variable ) then
    if ( data^.inuse ) and ( Column = 0 ) and ( not data^.highlight ) then
    begin
      CellRect.Left := CellRect.Left;
      TargetCanvas.Brush.Color :=  RGBToColor( 158, 255, 164 );
      //TargetCanvas.RoundRect(CellRect, 5, 5);
      TargetCanvas.FillRect(CellRect);
      InflateRect(ContentRect, -1, -1);
    end;

  //подсвеченная
  if Assigned( data^.variable ) then
    if ( data^.highlight ) and ( Column = 0 ) then
    begin
      CellRect.Left := CellRect.Left;
      TargetCanvas.Brush.Color := clSkyBlue;
      //TargetCanvas.RoundRect(CellRect, 5, 5);
      TargetCanvas.FillRect(CellRect);
      InflateRect(ContentRect, -1, -1);
    end;

  //значение
  if Assigned( data^.value ) then
    if ( data^.highlight ) and ( Column = 1 ) then
    begin
      CellRect.Left := CellRect.Left;
      TargetCanvas.Brush.Color := TColor($A9F2D8);
      TargetCanvas.FillRect(CellRect);
      InflateRect(ContentRect, -1, -1);
    end;
end;

procedure Tdock_variables_list.variable_treeContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
var
   selected_node         : PVirtualNode;
   treeView_under        : TVirtualStringTree;
   data : PVSTVariableNodeData;
begin
   treeView_under := TVirtualStringTree(sender) ;
   selected_node  := variable_tree.GetNodeAt( MousePos.X, MousePos.Y ) ;
   variable_tree.Selected[ selected_node ] := true;
   variable_tree.FocusedNode := selected_node;
   Popup_HideAll( variablestree_popup );
   if Assigned( selected_node ) then
   begin
     data := variable_tree.GetNodeData( selected_node );
     if Assigned( data.value ) then
       Popup_AddToVisible( 'value' , variablestree_popup );
     if Assigned( data.variable ) then
       Popup_AddToVisible( 'variable' , variablestree_popup );
   end;
end;

procedure Tdock_variables_list.variable_treeDblClick(Sender: TObject);
var
  data : PVSTVariableNodeData;
begin
  if Assigned( variable_tree.FocusedNode ) then
  begin
    data := variable_tree.GetNodeData( variable_tree.FocusedNode );
    if assigned( data^.value ) then
    begin
      isbl_debugger.SetLineOfInterest( data^.value^.linenumber );
      dock_steps_form.LocateBreakPointForLineAndStep( data^.value^.linenumber, data^.value^.step );
      dock_variables_list.HighlightStepVariables( data^.value^.step );
      ApplyVirtualVisibility();
    end;
  end;
end;

procedure Tdock_variables_list.variable_treeFreeNode(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var
 Data: PVSTVariableNodeData;
begin
 try
   Data := Sender.GetNodeData(Node);
   if Assigned(Data) then
   begin
    Finalize(Data^);
   end;
   except ON E:Exception do  DebugMessageAndShow(  e.Message ); end;
end;

procedure Tdock_variables_list.variable_treeGetImageIndex(
  Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind;
  Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: Integer);
var
   data : PVSTVariableNodeData;
begin
  data := variable_tree.GetNodeData( node );
  if Assigned( data.variable ) then
    if column = 0 then
    begin
      if data^.variable^.var_type = script_variable_type then
        ImageIndex := pic_index_script_variable;

      if data^.variable^.var_type = global_variable_type then
        ImageIndex := pic_index_global_variable;
    end;

  if Assigned( data.value ) then
  begin
    if Column = 0 then
      ImageIndex := 3;
    if Column = 1 then
      ImageIndex := 4;
  end;

end;

procedure Tdock_variables_list.variable_treeGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
var
  data : PVSTVariableNodeData;
begin
  try
     //считываем
     data := variable_tree.GetNodeData( node );
     if assigned( data ) then
     begin
       //строка переменной
       if Assigned( data^.variable ) then
       begin
         //Колонка Название
         if column = 0 then
          celltext := data^.text;

         //Колонка значение
         if column = 1 then
         begin
          if not variable_tree.Expanded[ node ] then
            celltext := data^.value_col
          else CellText := '';
         end;

       end;

       if Assigned( data^.value ) then
       begin
         if column = 0 then celltext := 'Строка: ' + IntToStr( data^.value^.linenumber ) + ' Шаг: ' + IntToStr( data^.value^.step  );
         if column = 1 then celltext := data^.value^.value;
       end;

  //     if column = 1 then celltext := data^.second_text;
     end;
    except ON E:Exception do  DebugMessageAndShow(  e.Message ); end;
end;

procedure Tdock_variables_list.variable_treeKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
var
  node : PVirtualNode;
  data : PVSTVariableNodeData;
begin
  if Key = VK_F2 then
  begin
    node  := variable_tree.FocusedNode;
    if Assigned( node ) then
    begin
      //Собираем данные. после установки фильтра ноды умрут вместе с Data
      data := variable_tree.GetNodeData( node );
      if Assigned( data ) then
      begin
        if Assigned( data^.variable ) then
          popup_variable_show_value.Click();
        if Assigned( data^.value ) then
          popup_value_show_in_window.Click();
      end;
    end;

  end;
end;

function Tdock_variables_list.LocateVariableNodeByName( name:string ):PVirtualNode;
var
  i:integer;
  node : PVirtualNode;
  data : PVSTVariableNodeData;
begin
 result := nil;
 for I := 0 to variable_tree.TotalCount - 1 do
    begin
      //Подготовка шага цикла
      if I <> 0 then
        node := variable_tree.GetNext( node )
      else
        node := variable_tree.GetFirst;
        if Assigned( node ) then
        begin
          data := variable_tree.GetNodeData( node );
          if Assigned( data.variable ) then
            if data^.variable^.name = name then
              result := node;
        end;
    end;
end;

procedure Tdock_variables_list.popup_value_copyClick(Sender: TObject);
var
  node : PVirtualNode;
  data : PVSTVariableNodeData;
  str : string;
begin
  node  := variable_tree.FocusedNode;
  if Assigned( node ) then
  begin
    //Собираем данные. после установки фильтра ноды умрут вместе с Data
    data := variable_tree.GetNodeData( node );
    if Assigned( data ) then
    begin

      if Assigned( data^.value ) then
      begin
        str :=data^.value^.value;

        if str[1] = '''' then
        begin
          str[1] := ' ';
        end;
        if str[ length( str ) ] = '''' then
          str[ length( str ) ] := ' ';

        Clipboard.AsText := str;
      end;

      if Assigned( data^.variable ) then
         Clipboard.AsText :=  data^.variable^.name;

    end;
  end;
end;

procedure Tdock_variables_list.popup_variable_copyClick(Sender: TObject);
var
  node : PVirtualNode;
  data : PVSTVariableNodeData;
begin
  node  := variable_tree.FocusedNode;
  if Assigned( node ) then
  begin
    //Собираем данные. после установки фильтра ноды умрут вместе с Data
    data := variable_tree.GetNodeData( node );
    if Assigned( data ) then
    begin
       Clipboard.AsText := data.value_col;
    end;
  end;
  variable_tree.Refresh;
end;

procedure Tdock_variables_list.popup_variable_copy_psClick(Sender: TObject);
var
  node : PVirtualNode;
  data : PVSTVariableNodeData;
begin
  node  := variable_tree.FocusedNode;
  if Assigned( node ) then
  begin
    //Собираем данные. после установки фильтра ноды умрут вместе с Data
    data := variable_tree.GetNodeData( node );
    if Assigned( data ) then
    begin
       Clipboard.AsText :=  data.variable.name + ' = ' + data.value_col + '';
    end;
  end;
  variable_tree.Refresh;
end;


procedure Tdock_variables_list.popup_variable_monitorClick(Sender: TObject);
var
  node : PVirtualNode;
  data : PVSTVariableNodeData;
begin
  node  := variable_tree.FocusedNode;
  if Assigned( node ) then
  begin
    //Собираем данные. после установки фильтра ноды умрут вместе с Data
    data := variable_tree.GetNodeData( node );
    if Assigned( data ) then
      if Assigned( data^.variable ) then
      begin
         data^.monitor := not data^.monitor;
         variable_tree.Refresh;
      end;
  end;
  variable_tree.Refresh;
end;

procedure Tdock_variables_list.Popup_AddToVisible( current_context:string; tree_popup:TPopupMenu );
var
  i:integer;
  context_name:string;
begin
 for i:=0 to tree_popup.Items.Count - 1 do
 begin
    if FindSubString( tree_popup.Items.Items[i].Name, 'popup_' ) then
    begin
      context_name := SubString( tree_popup.Items.Items[i].Name, 'popup_', 2 );
      context_name := SubString( context_name, '_', 1 );
      if context_name = current_context then
        tree_popup.Items.Items[i].Visible := true;
    end;
 end;
end;

procedure Tdock_variables_list.Popup_HideAll( tree_popup:TPopupMenu );
var
  i:integer;
  context_name:string;

begin

 for i:=0 to tree_popup.Items.Count - 1 do
        tree_popup.Items.Items[i].Visible := false;

end;

procedure Tdock_variables_list.ShowValueInWindow( node:PVirtualNode );
var
  data : PVSTVariableNodeData;
  str : string;
begin
try
  if Assigned( node ) then
  begin
    //Собираем данные. после установки фильтра ноды умрут вместе с Data
    data := variable_tree.GetNodeData( node );
    if Assigned( data ) then
      if Assigned( data^.value ) then
      begin
        str :=data^.value^.value;
        if str[1] = '''' then
        begin
          str[1] := ' ';
        end;
        if str[ length( str ) ] = '''' then
          str[ length( str ) ] := ' ';
        EditText( str );
      end;
  end;
except ON E:Exception do DebugMessageAndShow( e.Message ); end;
end;


procedure Tdock_variables_list.popup_value_show_in_windowClick(Sender: TObject);
var
  node : PVirtualNode;
  data : PVSTVariableNodeData;
  str : string;
begin
  node  := variable_tree.FocusedNode;
  if Assigned( node ) then
  begin
    ShowValueInWindow( node );
  end;
  variable_tree.Refresh;
end;

procedure Tdock_variables_list.AddValue( variable_value:PVariableValue; variable_node:PVirtualNode; variable_name:string );
var
 node_value    : PVirtualNode;
 data_value    : PVSTVariableNodeData;
begin
  try
    if not Assigned( variable_node ) then
    begin
      variable_node := LocateVariableNodeByName( variable_name );
    end;
    node_value                := dock_variables_list.variable_tree.AddChild( variable_node );
    data_value                := dock_variables_list.variable_tree.GetNodeData( node_value );
    data_value^.text          := variable_value^.value;
    data_value^.value         := variable_value;
    except ON E:Exception do  DebugMessageAndShow(  e.Message ); end;
end;

procedure Tdock_variables_list.AddVariableFull( variable:PVariable; given_variable_type:TDIRVarType );
var
 i,j,z          : Integer;
 vars_count     : integer;
 variable_name  : string;
 node_variable  : PVirtualNode;
 variable_value : PVariableValue;
begin
  node_variable := AddVariable( variable, given_variable_type );
  if Assigned( variable ) then
  for j := 0 to variable.ValueCount - 1 do
  begin
    variable_value := PVariableValue( variable^.values.Items[ j ] );
//    AddValue( variable_value, nil, variable^.name );
    AddValue( variable_value, node_variable, '' );
  end;
end;

function Tdock_variables_list.AddVariable( variable:PVariable; given_variable_type:TDIRVarType ):PVirtualNode;
var
  node_variable : PVirtualNode;
  data_variable : PVSTVariableNodeData;
begin
  node_variable            := dock_variables_list.variable_tree.AddChild( nil );
  data_variable            := dock_variables_list.variable_tree.GetNodeData( node_variable );
  data_variable^.text      := variable^.name;
  data_variable^.variable  := variable;
  data_variable^.highlight := false;
  data_variable^.monitor   := false;
  variable.var_type        := given_variable_type;
  result := node_variable;
end;

procedure SelectVariables();
begin

end;

procedure Tdock_variables_list.VariablesList_FeelForObject();
var
 i,j,z                    : Integer;
 varsCount                : integer;
 node_variable            : PVirtualNode;
 data_variable            : PVSTVariableNodeData;
 node_value               : PVirtualNode;
 data_value               : PVSTVariableNodeData;
  environmentVariableTable: TVariablesTable;
 localVariableTable       : TVariablesTable;
 variable_name            : string;
 variable                 : PVariable;
 variable_value           : PVariableValue;
 Stmt                     : TDISQLite3Statement;
begin

  try
      if Assigned( isbl_debugger.current_node_data ) then
      begin
        try
          dock_variables_list.variable_tree.FocusedNode := nil;
          dock_variables_list.variable_tree.Clear;
      except ON E:Exception do DebugMessageAndShow( e.Message ); end;

      localVariableTable := PVSTDebugObject( isbl_debugger.current_node_data )^.variable_table;
      environmentVariableTable := PVSTDebugObject( isbl_debugger.current_node_data )^.enviroment_variables;

      //цикл по всем переменным-------------------------------------------------
      varsCount := localVariableTable.VariablesCount;
      for  i := 0 to varsCount -1 do
      begin
        variable := localVariableTable.GetVariableByIndex( i );
        AddVariableFull( variable, script_variable_type );
      end;
      //------------------------------------------------------------------------

      //цикл по всем переменным-------------------------------------------------
      varsCount := environmentVariableTable.VariablesCount;
      for  i := 0 to varsCount -1 do
      begin
        variable := environmentVariableTable.GetVariableByIndex( i );
        AddVariableFull( variable, global_variable_type );
      end;
      //------------------------------------------------------------------------

    end;

  ApplyVirtualVisibility();
  except ON E:Exception do  DebugMessageAndShow( e.Message ); end;
end;


end.