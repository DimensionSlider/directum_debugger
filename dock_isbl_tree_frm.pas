unit dock_isbl_tree_frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, ExtCtrls, VirtualTrees, DockPanel, Menus, Clipbrd, ComCtrls, ToolWin;

type
  Tdock_isbl_tree = class(TForm)
    Panel1: TsPanel;
    tree: TVirtualStringTree;
    filter_panel: TsPanel;
    filter_label: TsLabel;
    filter_ed: TsEdit;
    tree_PopupMenu: TPopupMenu;
    N1: TMenuItem;
    Panel2: TsPanel;
    Panel3: TsPanel;
    box_dont_show_hidden: TsCheckBox;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    ToolBar2: TsToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    underpanel: TsPanel;
    title_panel: TsPanel;
    procedure clear_filter_btnClick(Sender: TObject);
    procedure treeFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex);
    procedure treeGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Kind: TVTImageKind; Column: TColumnIndex; var Ghosted: Boolean;
      var ImageIndex: Integer);
    procedure treeGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure filter_edChange(Sender: TObject);
    procedure treeContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure N1Click(Sender: TObject);
    procedure box_dont_show_hiddenClick(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
    procedure ToolButton2Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure ToolButton3Click(Sender: TObject);


  private
    { Private declarations }
  public
    { Public declarations }
    procedure ApplyVirtualVisibility( treeview:TVirtualStringTree );
    procedure ClearDebugHistory();
    function SeekNodeByInterpreterID( interpreterID:integer ):PVirtualNode;
  end;

var
  dock_isbl_tree: Tdock_isbl_tree;

implementation

{$R *.dfm}

uses debugger, routine_strings, isbl_debugger_frm,  unit1, dock_ignore_list,
  dock_callstack_frm, dock_variables_list_frm, dock_breaks;

function Tdock_isbl_tree.SeekNodeByInterpreterID( interpreterID:integer ):PVirtualNode;
var
  node:PVirtualNode;
  data : PVSTDebugObject;
  i:integer;
begin
  result := nil;
  //НЕОПТИМАЛЬНО, ПЕРЕДЕЛАТЬ
  for I := 0 to dock_isbl_tree.tree.TotalCount - 1 do
  begin
    //Подготовка шага цикла
    if I <> 0 then
      node := dock_isbl_tree.tree.GetNext(node)
    else
      node := dock_isbl_tree.tree.GetFirst;
      data := dock_isbl_tree.tree.GetNodeData( node );
       if data.interpreterID = interpreterID then
       begin
          result := @node^;
       end;
  end;
end;


procedure Tdock_isbl_tree.ToolButton1Click(Sender: TObject);
begin
  tree.FullCollapse();
end;

procedure Tdock_isbl_tree.ToolButton2Click(Sender: TObject);
begin
  tree.FullExpand();
end;



procedure Tdock_isbl_tree.ToolButton3Click(Sender: TObject);
begin

end;

//туду переместить в основную форму отладчика
procedure Tdock_isbl_tree.ClearDebugHistory();
begin
  tree.Clear;
  isbl_debugger.isbl_text.Clear;
  dock_variables_list.var_list.Clear;
  dock_isbl_callstack.stack_text.Clear;
end;

procedure Tdock_isbl_tree.clear_filter_btnClick(Sender: TObject);
begin
  dock_isbl_tree.filter_ed.Text := '';
end;

procedure Tdock_isbl_tree.box_dont_show_hiddenClick(Sender: TObject);
begin
 ApplyVirtualVisibility( dock_isbl_tree.tree );
end;

procedure Tdock_isbl_tree.filter_edChange(Sender: TObject);
begin
 ApplyVirtualVisibility( dock_isbl_tree.tree );
end;


procedure Tdock_isbl_tree.FormResize(Sender: TObject);
begin
  if Assigned( dock_isbl_tree ) then
  filter_ed.Width := dock_isbl_tree.Width - 7;
end;

procedure Tdock_isbl_tree.N1Click(Sender: TObject);
var
  node : PVirtualNode;
  data : PVSTDebugObject;
begin
  node  := dock_isbl_tree.tree.FocusedNode;
  if Assigned( node ) then
  begin
    //Собираем данные. после установки фильтра ноды умрут вместе с Data
    data := dock_isbl_tree.tree.GetNodeData( node );
    if Assigned( data ) then
    begin
      dock_isbl_ignorelist.ignore_list.Items.Add( data.caption );
      dock_isbl_ignorelist.ignore_list.Items.SaveToFile( work_dir + '\ignore.txt' );
    end;
  end;
    dock_isbl_tree.ApplyVirtualVisibility( dock_isbl_tree.tree );
end;

procedure Tdock_isbl_tree.N3Click(Sender: TObject);
begin
  ClearDebugHistory();
end;

procedure Tdock_isbl_tree.N4Click(Sender: TObject);
var
  node : PVirtualNode;
  data : PVSTDebugObject;
begin
  node  := dock_isbl_tree.tree.FocusedNode;
  if Assigned( node ) then
  begin
    //Собираем данные. после установки фильтра ноды умрут вместе с Data
    data := dock_isbl_tree.tree.GetNodeData( node );
    if Assigned( data ) then
    begin
      Clipboard.AsText := SubString( data.caption, ',', 2 );
    end;
  end;

end;

procedure Tdock_isbl_tree.ApplyVirtualVisibility( treeview:TVirtualStringTree );
var
  i,j:integer;
  node : PVirtualNode;
  data : PVSTDebugObject;
  node_name : string;
  node_code : string;
  temp_celltext : string;
begin

  for I := 0 to treeview.TotalCount - 1 do
    begin
      //Подготовка шага цикла---------------------------------------------------
      if I <> 0 then
        node := treeview.GetNext(node)
      else
        node := treeview.GetFirst;

      //по умолчанию узел отображается до тех пор пока его не скроет один из механизмов ниже
      treeview.IsVisible[ node ] := true;
      data := treeview.GetNodeData( node );
      if assigned( data ) then
      begin
      //------------------------------------------------------------------------

        //ФИЛЬТР ПО ТЕКСТОВОМУ КРИТЕРИЮ-------------------------------------------
        if StringAssigned( dock_isbl_tree.filter_ed.text ) then
        begin
          if not FindSubString( data.caption, dock_isbl_tree.filter_ed.text ) then
          begin
            if node.ChildCount = 0 then
              treeview.IsVisible[ node ] := false;
          end;
        end;

        //ТУДУ проверять нужно ли пытаться дальше скрыть
        if treeview.IsVisible[ node ] then
          if box_dont_show_hidden.Checked then
          for j := 0 to dock_isbl_ignorelist.ignore_list.items.Count - 1 do
            if data.caption = dock_isbl_ignorelist.ignore_list.items[j] then
              dock_isbl_tree.tree.IsVisible[ node ] := false;
          end;

    end;
      {
    //Скрыть все родительские узлы, дочерние узлы которых были скрыты------------
        for I := 0 to treeview.TotalCount - 1 do
        begin
          //Подготовка шага цикла
          if I <> 0 then
            node := treeview.GetNext( node )
          else
            node := treeview.GetFirst;

            if vsAllChildrenHidden in node.States then
            begin
              treeview.IsVisible[ node ] := false;
              if vsAllChildrenHidden in node.Parent.States then
              begin
                treeview.IsVisible[ node.Parent ] := false;
              end;
            end;
        end;
        }

end;

procedure Tdock_isbl_tree.treeContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
var
   selected_node         : PVirtualNode;
   treeView_under        : TVirtualStringTree;
begin
   treeView_under := TVirtualStringTree(sender) ;
   selected_node  := dock_isbl_tree.tree.GetNodeAt( MousePos.X, MousePos.Y ) ;
   tree.Selected[ selected_node ] := true;

end;

procedure Tdock_isbl_tree.treeFocusChanged(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex);
var
  selected_node : PVirtualNode;
  new_break_point_node : PVirtualNode;
  data          : PVSTDebugObject;
  break_point_data : PVSTBreakPointObject;
  i:integer;
begin
  selected_node  := dock_isbl_tree.tree.FocusedNode;
  isbl_debugger.special_line := -1;
  if Assigned(  selected_node ) then
  begin
    data := dock_isbl_tree.tree.GetNodeData( selected_node );
    if assigned( data ) then
    begin
      isbl_debugger.current_node_data     := @data^;
      isbl_debugger.current_node          := @selected_node^;
      isbl_debugger.isbl_text.Text        := data.code_strings.Text;
      isbl_debugger.special_line          := data.line_number;
      isbl_debugger.script_name.Caption   := data.caption;
      dock_isbl_callstack.stack_text.Text := data.call_stack.Text;
      isbl_debugger.VariablesList_FeelForPoint( data.line_number );
    end;
  end;
end;

procedure Tdock_isbl_tree.treeGetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: Integer);
var
  data : PVSTDebugObject;
begin

 data := dock_isbl_tree.tree.GetNodeData( node );
 if data.automation_type = function_type then
  ImageIndex := pic_index_function;

 if data.automation_type = route_event_type then
  ImageIndex := pic_index_event;

 if data.automation_type = reference_event_type then
  ImageIndex := pic_index_event;

 if data.automation_type = script_type then
  ImageIndex := pic_index_script;

end;


procedure Tdock_isbl_tree.treeGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
var
  data : PVSTDebugObject;
begin
 data := dock_isbl_tree.tree.GetNodeData( node );
 if assigned( data ) then
   CellText := data.caption
end;

e