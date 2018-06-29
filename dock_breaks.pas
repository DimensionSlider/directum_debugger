unit dock_breaks;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, VirtualTrees, ExtCtrls, ComCtrls, ToolWin, sToolBar, JvComponentBase, 
  JvDockControlForm, StdCtrls, sCheckBox, sPanel;

type
  Tdock_steps_form = class(TForm)
    Panel1: TsPanel;
    steps_tree: TVirtualStringTree;
    ToolBar2: TsToolBar;
    button_prev_brake: TToolButton;
    button_next_brake: TToolButton;
    Panel3: TsPanel;
    box_show_selected: TsCheckBox;
    JvDockClient1: TJvDockClient;
    procedure FormCreate(Sender: TObject);
    procedure steps_treeGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure steps_treeGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Kind: TVTImageKind; Column: TColumnIndex; var Ghosted: Boolean;
      var ImageIndex: Integer);
    procedure steps_treeFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex);
    procedure steps_treeFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure steps_treeDblClick(Sender: TObject);
    procedure button_next_brakeClick(Sender: TObject);
    procedure button_prev_brakeClick(Sender: TObject);
    procedure box_show_selectedClick(Sender: TObject);
    procedure steps_treeChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure LocateBreakPointForLine( line:integer );
    procedure LocateBreakPointForLineAndStep( line:integer; step:integer );
    procedure FeelBreakPoints();
    procedure VariablesList_FeelForBreakPoint( node_data:Pointer );
    procedure ApplySelectedVisibility( only_selected:boolean );
    function AddStepPoint( line:Integer; step:integer ):PVirtualNode;

  end;


var
  dock_steps_form : Tdock_steps_form;

implementation

{$R *.dfm}

uses isbl_debugger_frm, debugger, dock_variables_list_frm,
  dock_isbl_tree_unit, variable_table_unit, routine_debug;

procedure Tdock_steps_form.VariablesList_FeelForBreakPoint( node_data:Pointer );
begin

end;

procedure Tdock_steps_form.FormCreate(Sender: TObject);
begin
  steps_tree.NodeDataSize := SizeOf( TVSTStepPointObject );
end;

procedure  Tdock_steps_form.ApplySelectedVisibility( only_selected:boolean );
var
  i,j:integer;
  node : PVirtualNode;
  data : PVSTStepPointObject;
begin
  for I := 0 to steps_tree.TotalCount - 1 do
    begin
      //Подготовка шага цикла---------------------------------------------------
      if I <> 0 then
        node := steps_tree.GetNext(node)
      else
        node := steps_tree.GetFirst;
      //по умолчанию узел отображается до тех пор пока его не скроет один из механизмов ниже
      steps_tree.IsVisible[ node ] := true;
      data := steps_tree.GetNodeData( node );
      if assigned( data ) then
      begin
      //------------------------------------------------------------------------
        if ( only_selected ) and ( not data^.highlight ) then
          steps_tree.IsVisible[ node ] := false;
      end;
    end;
end;

procedure Tdock_steps_form.box_show_selectedClick(Sender: TObject);
begin
  ApplySelectedVisibility( box_show_selected.Checked );
end;

procedure Tdock_steps_form.steps_treeChange(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
begin
  ApplySelectedVisibility( box_show_selected.Checked );
end;

procedure Tdock_steps_form.steps_treeDblClick(Sender: TObject);
var
  data : PVSTStepPointObject;
begin

end;

procedure Tdock_steps_form.steps_treeFocusChanged(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex);
var
  selected_node : PVirtualNode;
  break_point_data : PVSTStepPointObject;
  i:integer;
begin
  selected_node  := dock_steps_form.steps_tree.FocusedNode;
  if Assigned( selected_node ) then
  begin
    break_point_data := dock_steps_form.steps_tree.GetNodeData( selected_node );
    if assigned( break_point_data ) then
    begin
      isbl_debugger.SetLineOfInterest( PVSTStepPointObject( break_point_data )^.line_number );
      dock_variables_list.HighlightLineVariables( PVSTStepPointObject( break_point_data )^.line_number );
      dock_variables_list.HighlightStepVariables( break_point_data^.Step );
      dock_variables_list.ApplyVirtualVisibility();
    end;
    LocateBreakPointForLineAndStep( PVSTStepPointObject( break_point_data )^.line_number, break_point_data^.step );
  end;
end;

procedure Tdock_steps_form.steps_treeFreeNode(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var
 Data: PVSTStepPointObject;
begin
  try
   Data := Sender.GetNodeData(Node);
   if Assigned(Data) then
    begin
      Finalize(Data^);
      //Dispose( Data );
      //FreeMem( Data, sizeof( TVSTBreakPointObject ) );
      data := nil;
    end;
  except
    ON e:Exception
    do
    begin
      DebugMessage('Tdock_steps_form.treeFreeNode: ошибка при попытке очистить дерево точек останова.' + e.message);
      ShowDebug;
    end;
  end;
end;

procedure Tdock_steps_form.steps_treeGetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: Integer);
var
  data: PVSTStepPointObject;
begin
  data := steps_tree.GetNodeData( node );
  if data^.highlight then
    if Column = 0 then
     ImageIndex := 44;
end;

procedure Tdock_steps_form.steps_treeGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
var
  data : PVSTStepPointObject;
begin
  try
    data := steps_tree.GetNodeData( node );
//    Celltext := 'Шаг: ' + IntToStr(data^.step) + ' Строка: ' + IntToStr(data^.line_number);
    if Column = 0 then
      Celltext := 'Шаг ' +  IntToStr(data^.step);
     if Column = 1 then
      CellText := 'Строка ' + IntToStr(data^.line_number);
  except
    ShowMessage( 'Tdock_steps_form.treeGetText: ошибка' );
    exit();
  end;
end;

procedure Tdock_steps_form.LocateBreakPointForLine( line:integer );
var
  data : PVSTStepPointObject;
  variable_data : PVSTVariableNodeData;
  node : PVirtualNode;
  i:integer;
  focused_once: boolean;
begin
focused_once := false;
//Пометить точка останова
   for I := 0 to steps_tree.TotalCount - 1 do
      begin
        try
          if I <> 0 then
            node := steps_tree.GetNext(node)
          else
            node := steps_tree.GetFirst;
            data := steps_tree.GetNodeData( node );
        except
          DebugMessage('Tdock_steps_form.LocateBreakPointForLine( line:integer ): Ошибка подготовки шага обновления массива переменных');
          exit();
        end;

          if data^.line_number = line then
          begin
             data^.highlight := true;
             if not focused_once then
               steps_tree.FocusedNode := node;
             focused_once := true;
          end
          else data^.highlight := false;

      end;
      steps_tree.Refresh;
      ApplySelectedVisibility( box_show_selected.Checked );
end;

procedure Tdock_steps_form.LocateBreakPointForLineAndStep( line:integer; step:integer );
var
  data : PVSTStepPointObject;
  variable_data : PVSTVariableNodeData;
  node : PVirtualNode;
  i:integer;
begin
//Пометить точка останова
   for I := 0 to steps_tree.TotalCount - 1 do
      begin
        try
          if I <> 0 then
            node := steps_tree.GetNext(node)
          else
            node := steps_tree.GetFirst;
            data := steps_tree.GetNodeData( node );
        except
          DebugMessage('Tdock_steps_form.LocateBreakPointForLine( line:integer ): Ошибка подготовки шага обновления массива переменных');
          exit();
        end;

        if Assigned( data ) then
        if ( data^.line_number = line ) and ( data^.step = step )   then
        begin
           data^.highlight := true;
           steps_tree.FocusedNode := node;
        end
        else data^.highlight := false;

      end;
      ApplySelectedVisibility( box_show_selected.Checked );
      steps_tree.Refresh;
end;

procedure Tdock_steps_form.button_prev_brakeClick(Sender: TObject);
var
  node : PVirtualNode;
begin
  node := steps_tree.FocusedNode;
  if Assigned( node ) then
  begin
    if Assigned( node.PrevSibling ) then
    begin
      steps_tree.FocusedNode := node.PrevSibling;
      steps_tree.Selected[ node.PrevSibling ] := true;
    end;
  end;
end;

procedure Tdock_steps_form.button_next_brakeClick(Sender: TObject);
var
  node : PVirtualNode;
begin
  node := steps_tree.FocusedNode;
  if Assigned( node ) then
  begin
    if Assigned( node.NextSibling ) then
    begin
      steps_tree.FocusedNode := node.NextSibling;
      steps_tree.Selected[ node.NextSibling ] := true;
    end;
  end;
end;

function Tdock_steps_form.AddStepPoint( line:Integer; step:integer ):PVirtualNode;
var
  break_point_node : PVirtualNode;
  data : PVSTStepPointObject;
begin
  if isbl_debugger.display_how_debug_goes then
  try
     break_point_node   := steps_tree.AddChild(nil);
     data               := steps_tree.GetNodeData( break_point_node );
     data^.line_number  := line;
     data^.step         := step;
     result             := break_point_node;
     try
      //steps_tree.Selected[ break_point_node ] := true;
     except
        DebugMessage('Tdock_steps_form.AddBreakPoint: необработанное исключение. Код ( 1 )');
        ShowDebug();
     end;
//     steps_tree.FocusedNode := break_point_node;
  except
     DebugMessage('Tdock_steps_form.AddBreakPoint: необработанное исключение. Код ( 0 )');
     ShowDebug();
  end;
end;

procedure Tdock_steps_form.FeelBreakPoints();
var
  i,step:integer;
  selected_node    : PVirtualNode;
  selected_data    : PVSTDebugObject;
  number : integer;
begin
  try
    steps_tree.Clear;
    selected_node := dock_isbl_tree.tree.FocusedNode;
    selected_data := dock_isbl_tree.tree.GetNodeData( selected_node );

    if assigned( selected_data ) then
     for i:=0 to  PVSTDebugObject( selected_data )^.variable_table.steps.Count - 1 do
     begin
       number           := StrToInt( PVSTDebugObject( selected_data )^.variable_table.steps[ i ] );
       AddStepPoint( number, i+1 );
       //rem data^.text       := PVSTDebugObject( selected_data )^.caption;
     end;

  except
    ShowMessage('Tdock_steps_form.FeelBreakPoints(): Ошибка при обновлении дерева точек останова.');
    exit();
  end;
  ApplySelectedVisibility( box_show_selected.Checked );
end;

end.