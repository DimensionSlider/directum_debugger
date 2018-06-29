unit dock_isbl_tree_unit;

interface

uses
  ComCtrls, Windows, Messages, SysUtils, Variants, Classes, Graphics, 
  Controls, Forms, Dialogs, StdCtrls, sEdit, sLabel, ExtCtrls, sPanel, VirtualTrees, 
  Menus, Clipbrd, sToolBar, ToolWin, DockPanel, JvComponentBase, 
  JvDockControlForm, sCheckBox, jclDebug;
type
  Tdock_isbl_tree = class(TDockableForm)
    underpanel          : TsPanel;
    Panel1              : TsPanel;
    tree                : TVirtualStringTree;
    filter_panel        : TsPanel;
    filter_label        : TsLabel;
    filter_ed           : TsEdit;
    Panel3              : TsPanel;
    box_dont_show_hidden: TsCheckBox;
    ToolBar2            : TsToolBar;
    ToolButton1         : TToolButton;
    ToolButton2         : TToolButton;
    ToolButton3         : TToolButton;
    Panel2              : TsPanel;
    title_panel         : TsPanel;
    tree_PopupMenu      : TPopupMenu;
    N1                  : TMenuItem;
    N4                  : TMenuItem;
    N2                  : TMenuItem;
    N3                  : TMenuItem;
    box_tree            : TsCheckBox;
    box_finished        : TsCheckBox;
    JvDockClient1       : TJvDockClient;
    box_show_code       : TsCheckBox;
    N5                  : TMenuItem;
    panel_search        : TsPanel;
    sLabel1             : TsLabel;
    ed_search           : TsEdit;
    bar_search          : TsToolBar;
    ToolButton4         : TToolButton;
    ToolButton5         : TToolButton;
    procedure ToolButton1Click(Sender: TObject);
    procedure ToolButton2Click(Sender: TObject);
    procedure filter_edChange(Sender: TObject);
    procedure treeFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex);
    procedure treeContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure N3Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure box_dont_show_hiddenClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure treeGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Kind: TVTImageKind; Column: TColumnIndex; var Ghosted: Boolean;
      var ImageIndex: Integer);
    procedure treeGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure ToolButton3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure treeBeforeCellPaint(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      CellPaintMode: TVTCellPaintMode; CellRect: TRect; var ContentRect: TRect);
    procedure box_finishedClick(Sender: TObject);
    procedure SaveControlsPositions();
    procedure RestoreControls();
    procedure FormDestroy(Sender: TObject);
    procedure treeFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure box_treeClick(Sender: TObject);
    procedure box_show_codeClick(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure ed_searchChange(Sender: TObject);
    procedure ToolButton5Click(Sender: TObject);
    procedure ToolButton4Click(Sender: TObject);
    procedure ed_searchKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure SetTreeConstructionType( set_to_hierarchy:boolean );
    procedure ApplyVirtualVisibility( treeview:TVirtualStringTree );
    procedure HighLightSearchNodes( treeview:TVirtualStringTree );
    procedure ClearDebugHistory();
    procedure OnRun();

    function SeekNodeByInterpreterID( interpreterID:integer ):PVirtualNode;
  end;

var
  dock_isbl_tree: Tdock_isbl_tree;
  is_set_to_ierarchy_build_type : boolean;

implementation

{$R *.dfm}

uses debugger, routine_strings, isbl_debugger_frm,  dock_ignore_list,
  dock_callstack_frm, dock_variables_list_frm, dock_breaks, variable_table_unit, routine_debug, frm_nonvisual, main,  DISQLite3Database, DISystemCompat;

// trace
function SelectGetCallstackText(interpreterID:integer):string;
const
  SelectSQL = 'SELECT call_stack FROM Objects WHERE interpreterID = ? ';
var
 Stmt: TDISQLite3Statement;
 field_id : integer;
 id       : integer;
 RowCount : integer;
 state    : integer;
begin
  result := '';
  Stmt := FDatabase.Prepare16( SelectSQL );
   try
    Stmt.Bind_Int( 1, interpreterID );
    RowCount := 1;
    while Stmt.Step = 100 do
      begin
        result := Stmt.Column_Str16( 0 );
        state := 100;
      end;
  finally
    Stmt.Free;
  end;
end;

// trace
function SelectGetISBLText(interpreterID:integer):string;
const
  SelectSQL = 'SELECT text FROM Objects WHERE interpreterID = ? ';
var
 Stmt: TDISQLite3Statement;
 field_id : integer;
 id       : integer;
 RowCount : integer;
 state    : integer;
begin
  result := '';
  Stmt := FDatabase.Prepare16( SelectSQL );
   try
    Stmt.Bind_Int( 1, interpreterID );
    RowCount := 1;
    while Stmt.Step = 100 do
      begin
        result := Stmt.Column_Str16( 0 );
        state := 100;
      end;
  finally
    Stmt.Free;
  end;
end;

// trace
function SelectVariablesCount(interpreterID:integer):integer;
const
  SelectSQL = 'SELECT count(*) FROM variables vars WHERE Exists( SELECT interpreterID FROM variables_values WHERE interpreterID = 482 and variableID = vars.RowID )';
var
 Stmt: TDISQLite3Statement;
 field_id : integer;
 id       : integer;
 RowCount : integer;
 state    : integer;
begin
  result := -1;
  Stmt := FDatabase.Prepare16( SelectSQL );
   try
    Stmt.Bind_Int( 1, interpreterID );
    RowCount := 1;
    while Stmt.Step = 100 do
      begin
        result := Stmt.Column_Int( 0 );
        state := 100;
      end;
  finally
    Stmt.Free;
  end;
end;

function RGBToColor(R, G, B: Byte): TColor;
begin
  Result := B shl 16 or G shl 8 or R;
end;

function Tdock_isbl_tree.SeekNodeByInterpreterID( interpreterID:integer ):PVirtualNode;
var
  node : PVirtualNode;
  data : PVSTDebugObject;
  i    : integer;
begin
  try
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
         if data^.interpreterID = interpreterID then
         begin
            result := node;
         end;
    end;
  except
    ON E:Exception do  DebugMessageAndShow( e.Message );
  end;
end;

procedure Tdock_isbl_tree.OnRun;
begin
  RestoreControls();
end;


procedure Tdock_isbl_tree.SaveControlsPositions();
begin
  configuration.WriteBool('tree', 'box_dont_show_hidden', box_dont_show_hidden.checked );
  configuration.WriteBool('tree', 'box_tree', box_tree.checked );
  configuration.WriteBool('tree', 'box_finished', box_finished.checked );
end;

procedure Tdock_isbl_tree.RestoreControls();
begin
  box_dont_show_hidden.checked := configuration.ReadBool('tree', 'box_dont_show_hidden', box_dont_show_hidden.checked );
  box_tree.checked             := configuration.ReadBool('tree', 'box_tree', box_tree.checked );
  box_finished.checked         := configuration.ReadBool('tree', 'box_finished', box_finished.checked );
end;


procedure Tdock_isbl_tree.ToolButton1Click(Sender: TObject);
begin
  tree.FullCollapse();
end;

procedure Tdock_isbl_tree.ToolButton2Click(Sender: TObject);
begin
  tree.FullExpand();
end;

procedure Tdock_isbl_tree.box_finishedClick(Sender: TObject);
begin
 ApplyVirtualVisibility( dock_isbl_tree.tree );
end;

procedure Tdock_isbl_tree.box_show_codeClick(Sender: TObject);
begin
  tree.Repaint();
end;

procedure Tdock_isbl_tree.box_treeClick(Sender: TObject);
begin
  SetTreeConstructionType( box_tree.Checked );
end;

procedure Tdock_isbl_tree.ClearDebugHistory();
begin
  try
    tree.Clear;
    isbl_debugger.isbl_text.Clear;
    dock_isbl_callstack.stack_text.Clear;
  except
    ON E:Exception do  DebugMessageAndShow( e.Message );
  end;
end;

procedure Tdock_isbl_tree.ed_searchChange(Sender: TObject);
begin
  HighLightSearchNodes( dock_isbl_tree.tree );
end;

//Поиск узлов
procedure Tdock_isbl_tree.ed_searchKeyPress(Sender: TObject; var Key: Char);
var
  found : boolean;
  node : PVirtualNode;
  data : PVSTDebugObject;
begin
  found := false;
  if Key = #13 then
  begin

    // ВПЕРЕД
      node  := dock_isbl_tree.tree.FocusedNode;
      while Assigned( node ) do
      begin
        node:= tree.GetNext( node );
        if Assigned( node ) then
        begin
          data := tree.GetNodeData( node );
          if FindSubString( data.Caption, ed_search.Text ) then
          begin
            tree.FocusedNode := node;
            tree.Selected[ node ] := true;
            found := true;
            break;
          end;
        end;
      end;

    // НАЗАД
      if not found then
      begin
        node  := dock_isbl_tree.tree.FocusedNode;
        while Assigned( node ) do
        begin
          node:= tree.GetPrevious( node );
          if Assigned( node ) then
          begin
            data := tree.GetNodeData( node );
            if FindSubString( data.Caption, ed_search.Text ) then
            begin
              tree.FocusedNode := node;
              tree.Selected[ node ] := true;
              found := true;
              break;
            end;
          end;
        end;
      end;

  end;

end;

procedure Tdock_isbl_tree.box_dont_show_hiddenClick(Sender: TObject);
begin
  ApplyVirtualVisibility( dock_isbl_tree.tree );
end;

procedure Tdock_isbl_tree.SetTreeConstructionType( set_to_hierarchy:boolean );
var
  i,j:integer;
  new_data, object_data : PVSTDebugObject;
  new_node, parent_node : PVirtualNode;
  node     : PVirtualNode;
  next     : PVirtualNode;
  data     : PVSTVariableNodeData;
  precount : integer;
  id       : integer;
  node_count : integer;
begin
  try
   precount := tree.TotalCount;
   node_count := 0;

   // Не по иерархии - Первый цикл
//   if ( not set_to_hierarchy ) then

    for I := 0 to tree.TotalCount - 1 do
      begin
        //Подготовка шага цикла
        if I <> 0 then
          node := next
        else
          node := tree.GetFirst();
          next := tree.GetNext( node );
          if Assigned( node ) then
          begin
            object_data                  := tree.GetNodeData( node );
            if is_set_to_ierarchy_build_type then
            begin
              object_data.parent           := node.Parent;
              object_data.next_sibling     := node.NextSibling;
              object_data.previous_sibling := node.PrevSibling;
              tree.MoveTo( node, tree.RootNode, amAddChildLast, false );
              node_count := node_count + 1;
            end;
          end;
      end;

   {
   if set_to_hierarchy = false then
   begin
   node := tree.GetFirst;
    while Assigned( node ) do
    begin
      node := tree.GetNext(node);

       if Assigned( node ) then
        begin
          object_data                  := tree.GetNodeData( node );
          if is_set_to_ierarchy_build_type then
          begin
            object_data.parent           := node.Parent;
            object_data.next_sibling     := node.NextSibling;
            object_data.previous_sibling := node.PrevSibling;
            tree.MoveTo( node, tree.RootNode, amAddChildLast, false );

          end;
        end;
    end;
   end;
   }

 DebugMessage('Перемещено узлов: ' + IntTostr(node_count) + ' из ' + IntToStr( tree.TotalCount ) );



  // Второй цикл - по иерархии
  if ( set_to_hierarchy ) then
  for I := 0 to tree.TotalCount - 1 do
  begin
    //Подготовка шага цикла
    if I <> 0 then
      node := next
    else
      node := tree.GetFirst();
      next := tree.GetNext( node );
      if Assigned( node ) then
      begin
        object_data                  := tree.GetNodeData( node );
        if not is_set_to_ierarchy_build_type then
        begin
          if  object_data.parent_interpreterID <> -1 then
           parent_node := SeekNodeByInterpreterID( object_data.parent_interpreterID )
          else
           parent_node := tree.RootNode;
           tree.MoveTo( node, parent_node, amAddChildLast, false );
        end;
      end;
      tree.FullExpand();
  end;

      tree.Refresh;
      is_set_to_ierarchy_build_type := set_to_hierarchy;

  except
    ON E:Exception do  DebugMessageAndShow( e.Message );
  end;
end;

procedure Tdock_isbl_tree.filter_edChange(Sender: TObject);
begin
 ApplyVirtualVisibility( dock_isbl_tree.tree );

 if length(filter_ed.Text) > 0  then
  box_tree.Enabled := false
 else
  box_tree.Enabled := True;

  if box_tree.Enabled then
    SetTreeConstructionType( box_tree.Checked )
  else
    SetTreeConstructionType( false );

end;

procedure Tdock_isbl_tree.FormCreate(Sender: TObject);
begin
  dock_isbl_tree.tree.NodeDataSize := SizeOf( TVSTDebugObject );
  is_set_to_ierarchy_build_type := true;
end;

procedure Tdock_isbl_tree.FormDestroy(Sender: TObject);
begin
  SaveControlsPositions();
end;

procedure Tdock_isbl_tree.FormResize(Sender: TObject);
begin
  if Assigned( dock_isbl_tree ) then
  begin
    filter_ed.Width := dock_isbl_tree.Width - filter_ed.Left - 5;
    ed_search.Width := dock_isbl_tree.Width - ed_search.Left - bar_search.Width - 10;
  end;
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
      dock_isbl_ignorelist.ignore_list.Items.Add( data^.caption );
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

procedure Tdock_isbl_tree.N5Click(Sender: TObject);
var
  node : PVirtualNode;
  data : PVSTDebugObject;
begin
  node  := dock_isbl_tree.tree.FocusedNode;
  if Assigned( node ) then
  begin
    dock_isbl_tree.tree.DeleteNode( node );
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
  visibility : boolean;
begin
  for I := 0 to treeview.TotalCount - 1 do
    begin
      //Подготовка шага цикла---------------------------------------------------
      if I <> 0 then
        node := treeview.GetNext(node)
      else
        node := treeview.GetFirst;

      visibility := true;

      //по умолчанию узел отображается до тех пор пока его не скроет один из механизмов ниже
      data := treeview.GetNodeData( node );

      if assigned( data ) then
      begin

        //ОБРАБОТКА ВЫПОЛНЕНА - ФИЛЬТР ПО КРИТЕРИЮ------------------------------
        if box_finished.Checked then
          if data^.finished then
            visibility := false;
        //----------------------------------------------------------------------

        //ФИЛЬТР ПО ТЕКСТОВОМУ КРИТЕРИЮ-----------------------------------------
        if StringAssigned( dock_isbl_tree.filter_ed.text ) then
          if not FindSubString( data.caption, dock_isbl_tree.filter_ed.text ) then
//            if ( node.ChildCount = 0 ) or ( vsAllChildrenHidden in node.States ) then
              visibility := false;

        if StringAssigned( dock_isbl_tree.filter_ed.text ) then
          if FindSubString( data.caption, dock_isbl_tree.filter_ed.text ) then
          begin
            data.text_filtered := true;
          end
          else
            data.text_filtered := false;
        //----------------------------------------------------------------------

        //Прятать скрытые обработки
        {
        if treeview.IsVisible[ node ] then
          if box_dont_show_hidden.Checked then
          for j := 0 to dock_isbl_ignorelist.ignore_list.items.Count - 1 do
            if data.caption = dock_isbl_ignorelist.ignore_list.items[j] then
              dock_isbl_tree.tree.IsVisible[ node ] := false;
        }

      if visibility then
        treeview.IsVisible[ node ] := visibility
      else
      if treeview.IsVisible[ node ] then
        treeview.IsVisible[ node ] := visibility;

    end;
  end;

  //Скрыть все родительские узлы, дочерние узлы которых были скрыты------------
{
  for I := 0 to treeview.TotalCount - 1 do
  begin
    //Подготовка шага цикла
    if I <> 0 then
      node := treeview.GetNext( node )
    else
      node := treeview.GetFirst;

      if vsAllChildrenHidden in node.States then
      begin
        if treeview.IsVisible[node] then
          treeview.IsVisible[ node ] := false;
        if vsAllChildrenHidden in node.Parent.States then
        begin
          treeview.IsVisible[ node.Parent ] := false;
        end;
      end;

  end;
  }

  treeview.Repaint;

end;



procedure Tdock_isbl_tree.HighLightSearchNodes( treeview:TVirtualStringTree );
var
  i,j:integer;
  node : PVirtualNode;
  data : PVSTDebugObject;
  node_name : string;
  node_code : string;
  temp_celltext : string;
  visibility : boolean;
begin
  for I := 0 to treeview.TotalCount - 1 do
    begin
      //Подготовка шага цикла---------------------------------------------------
      if I <> 0 then
        node := treeview.GetNext(node)
      else
        node := treeview.GetFirst;

      data := treeview.GetNodeData( node );

      if assigned( data ) then
      begin
        //ФИЛЬТР ПО ТЕКСТОВОМУ КРИТЕРИЮ-----------------------------------------
        if StringAssigned( dock_isbl_tree.ed_search.text ) then
        begin
          if FindSubString( data.caption, dock_isbl_tree.ed_search.text ) then
              data.search_highlighted := true
          else
            data.search_highlighted := false;
        end
        else
          data.search_highlighted := false;
        //----------------------------------------------------------------------
      end;
    end;

  treeview.Repaint;
end;

procedure Tdock_isbl_tree.treeBeforeCellPaint(Sender: TBaseVirtualTree;
  TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  CellPaintMode: TVTCellPaintMode; CellRect: TRect; var ContentRect: TRect);
var
  data : PVSTDebugObject;
begin
  data := tree.GetNodeData( node );
  if Assigned( data ) then

  //выполненная обработка
    if ( data^.finished ) then
    begin
      TargetCanvas.Brush.Color := TColor($E9E9E9); // TColor( RGBToColor(204,212,255) );
      CellRect.Left := CellRect.Left;
      TargetCanvas.FillRect(CellRect);
    end;

    // ПОСЛЕДНИЙ
    if ( data^.interpreterID = isbl_debugger.last_interpreterID ) then
    begin
      TargetCanvas.Brush.Color := TColor( RGBToColor( 255,119,144) );
      CellRect.Left := CellRect.Left;
      TargetCanvas.FillRect(CellRect);
    end;

    // Подсвеченная текстовым поиском обработка
    if ( data^.search_highlighted ) then
    begin
      TargetCanvas.Brush.Color :=  TColor(RGBToColor( 255,124,84 ) );//255, 68, 78 )); // TColor(RGBToColor( 159, 255, 25 ));
      CellRect.Left := CellRect.Left;
      TargetCanvas.FillRect(CellRect);
      {
      TargetCanvas.RoundRect(CellRect, 5, 5);
      TargetCanvas.Rectangle( CellRect.Left, cellrect.Top, cellrect.Right, cellrect.Bottom );
      }
    end;

    // ВЫБРАННАЯ обработка
    if tree.Selected[Node] then
        begin
      TargetCanvas.Brush.Color := clSkyblue;// TColor(RGBToColor( 159, 255, 25 ));
      CellRect.Left := CellRect.Left;
      TargetCanvas.FillRect( CellRect );
//      TargetCanvas.RoundRect(CellRect, 5, 5);
//      TargetCanvas.Rectangle( CellRect.Left, cellrect.Top, cellrect.Right, cellrect.Bottom );
    end;

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
  selected_node        : PVirtualNode;
  new_break_point_node : PVirtualNode;
  data                 : PVSTDebugObject;
  step_point_data      : PVSTStepPointObject;
  string_buffer        : string;
  i                    :integer;
begin
  if isbl_debugger.display_how_debug_goes then
  try
    selected_node := dock_isbl_tree.tree.FocusedNode;
    isbl_debugger.last_step_line := -1;
    if Assigned( selected_node ) then
    begin
      try
        data := dock_isbl_tree.tree.GetNodeData( selected_node );
        if assigned( data ) then
        begin
          try
            isbl_debugger.current_node_data     := data;
            isbl_debugger.current_node          := selected_node;
        except
          ON E:Exception do  DebugMessageAndShow( e.Message );
        end;

          // ISBL TEXT
          try
            string_buffer := code_cache.GetCode( data^.code_cache_position );
//            string_buffer := SelectGetISBLText( data^.interpreterID );
          except
            ON E:Exception do  DebugMessageAndShow( e.Message );
          end;

          isbl_debugger.isbl_text.Text := string_buffer;
          try
             isbl_debugger.last_step_line := data.line_number;
          except
            ON E:Exception do  DebugMessageAndShow( e.Message );
          end;
          // --------------------------------------

          try
              isbl_debugger.script_name.Caption := data.caption;
              isbl_debugger_frm.scriptName      := SubString( data.caption, '.', 1 );
              isbl_debugger.SetCaptionLine( 'script', data.caption );
          except
            ON E:Exception do  DebugMessageAndShow( e.Message );
          end;

          // CALLSTACK TEXT
          try
            string_buffer := data^.call_stack;
//            string_buffer := SelectGetCallstackText( data^.interpreterID );
          except
            ON E:Exception do  DebugMessageAndShow( e.Message );
          end;

          try
            dock_isbl_callstack.stack_text.Text := string_buffer;
          except
            DebugMessageAndShow('Ошибка при работе с dock_isbl_callstack.stack_text.Text := string_buffer;');
          end;
          //--------------------------------------

        end;

//        try
//          data.stop_points.PlaceMarks;
//          dock_steps_form.FeelBreakPoints;
//          dock_variables_list.VariablesList_FeelForObject();
//        except
//          ON E:Exception do  DebugMessageAndShow( e.Message );
//        end;
      except
        ON E:Exception do  DebugMessageAndShow( e.Message );
      end;

    end;
  except
    ON E:Exception do  DebugMessageAndShow( e.Message );
  end;
end;

procedure Tdock_isbl_tree.treeFreeNode(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var
 Data: PVSTDebugObject;
 mem_start, mem_end : longint;
begin
//if true = false then
  try

   mem_start := GetTakenMem;
   Data      := Sender.GetNodeData(Node);
   if Assigned(Data) then
   begin
    Finalize( data );
    data.Free();
    data := nil;
   end;
   mem_end := GetTakenMem;

    if ( mem_end - mem_start ) <> 0 then
      DebugMessage( FormatCurr( 'Высвобождено: #,# Байт', mem_end - mem_start ) )
    else
    begin
      DebugMessage( 'Память не высвобождена' );
    end;

  except
    ON E:Exception do  DebugMessageAndShow( e.Message );
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

 if data.automation_type = requisite_change_event then
  ImageIndex := pic_index_event;

 if data.automation_type = script_type then
  ImageIndex := pic_index_script;

 if data.automation_type = workflow_block_event then
  ImageIndex := pic_index_block;

end;


procedure Tdock_isbl_tree.treeGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
var
  data : PVSTDebugObject;
begin
 data := dock_isbl_tree.tree.GetNodeData( node );
 if assigned( data ) then
 begin
   if box_show_code.Checked then
     CellText := data^.system_code + '.' + data^.caption
   else
     CellText := data^.caption
 end;
end;

procedure Tdock_isbl_tree.ToolButton3Click(Sender: TObject);
begin
  filter_ed.Text := '';
end;

procedure Tdock_isbl_tree.ToolButton4Click(Sender: TObject);var
  node : PVirtualNode;
  data : PVSTDebugObject;
begin
  node  := dock_isbl_tree.tree.FocusedNode;
  while Assigned( node ) do
  begin
    node:= tree.GetPrevious( node );
    if Assigned( node ) then
    begin
      data := tree.GetNodeData( node );
      if FindSubString( data.Caption, ed_search.Text ) then
      begin
        tree.FocusedNode := node;
        tree.Selected[ node ] := true;
        break;
      end;
    end;
  end;
end;

procedure Tdock_isbl_tree.ToolButton5Click(Sender: TObject);var
  node : PVirtualNode;
  data : PVSTDebugObject;
begin
  node  := dock_isbl_tree.tree.FocusedNode;
  while Assigned( node ) do
  begin
    node:= tree.GetNext( node );
    if Assigned( node ) then
    begin
      data := tree.GetNodeData( node );
      if FindSubString( data.Caption, ed_search.Text ) then
      begin
        tree.FocusedNode := node;
        tree.Selected[ node ] := true;
        break;
      end;
    end;
  end;
end;


end.