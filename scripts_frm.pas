unit scripts_frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, VirtualTrees, ImgList, StdCtrls, sEdit, sLabel, ExtCtrls, sPanel, ComCtrls, 
  ToolWin, sToolBar, debugger, JvComponentBase, JvDockControlForm;

type
  Tdock_scripts = class(TForm)
    scripts_tree: TVirtualStringTree;
    filter_panel: TsPanel;
    filter_label: TsLabel;
    filter_ed: TsEdit;
    ToolBar: TsToolBar;
    toolbar_refresh_metadata: TToolButton;
    BigImageList: TImageList;
    JvDockClient1: TJvDockClient;
    procedure toolbar_refresh_metadataClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure scripts_treeGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure scripts_treeGetImageIndex(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: Boolean; var ImageIndex: Integer);
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  type
  PVSTScriptInfo = ^TScriptInfo;
  TScriptInfo = record
    name : string;
    automation_type : TAutomationObjectType;
    folder : Boolean;
  end;

var
  dock_scripts: Tdock_scripts;

implementation

uses isbl_debugger_frm, frm_nonvisual;

{$R *.dfm}

procedure Tdock_scripts.FormCreate(Sender: TObject);
begin
  scripts_tree.NodeDataSize := sizeOf( TScriptInfo );
end;

procedure Tdock_scripts.FormResize(Sender: TObject);
begin
  if Assigned( dock_scripts ) then
    filter_ed.Width := dock_scripts.Width - 7;
end;

procedure Tdock_scripts.scripts_treeGetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: Integer);
var
  data: PVSTScriptInfo;
begin
  data := scripts_tree.GetNodeData( node );

  if data.automation_type = script_type then
    ImageIndex := pic_index_script;

  if data.automation_type = function_type then
    ImageIndex := pic_index_function;

  if data.automation_type = report_type then
    ImageIndex := pic_index_report;

   if data.folder then
    ImageIndex := pic_index_folder;

end;

procedure Tdock_scripts.scripts_treeGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
var
  data : PVSTScriptInfo;
begin
  data := scripts_tree.GetNodeData( node );
  if Assigned( data ) then
    celltext := data^.name;
end;

procedure Tdock_scripts.toolbar_refresh_metadataClick(Sender: TObject);
var
  node,parent : PVirtualNode;
  data : PVSTScriptInfo;
begin
{
  if db_connection.Connected then
  begin

    //Функции
    query_tool.Close;
    query_tool.SQL.Text := 'SELECT FName FROM MBFunc';
    query_tool.Open;
    scripts_tree.Clear;
     parent      := scripts_tree.AddChild(nil);
     scripts_tree.Selected[parent] := true;
     data        := scripts_tree.GetNodeData( parent );
     data.folder := true;
     data.name   := 'Функции';
    while not query_tool.Eof do
    begin
      node := scripts_tree.AddChild(parent);
      data := scripts_tree.GetNodeData( node );
      data^.name            := query_tool.Fields[0].AsString;
      data^.automation_type := function_type;
      query_tool.Next;
    end;

    //Сценарий
    query_tool.Close;
    query_tool.SQL.Text := 'SELECT NameRpt FROM MBReports WHERE TypeRpt =''Function'' ';
    query_tool.Open;
     parent      := scripts_tree.AddChild(nil);
     scripts_tree.Selected[parent] := true;
     data        := scripts_tree.GetNodeData( parent );
     data.folder := true;
     data.name   := 'Сценарии';
    while not query_tool.Eof do
    begin
      node := scripts_tree.AddChild(parent);
      data := scripts_tree.GetNodeData( node );
      data^.name            := query_tool.Fields[0].AsString;
      data^.automation_type := script_type;
      query_tool.Next;
    end;

    //Аналитические
    query_tool.Close;
    query_tool.SQL.Text := 'SELECT NameRpt FROM MBReports WHERE TypeRpt =''MBAnAccRpt'' ';
    query_tool.Open;
    parent      := scripts_tree.AddChild(nil);
    scripts_tree.Selected[parent] := true;
    data        := scripts_tree.GetNodeData( parent );
    data.folder := true;
    data.name   := 'Отчеты (аналитические)';
    while not query_tool.Eof do
    begin
      node := scripts_tree.AddChild(parent);
      data := scripts_tree.GetNodeData( node );
      data^.name            := query_tool.Fields[0].AsString;
      data^.automation_type := report_type;
      query_tool.Next;
    end;

    //Интегрированные
    query_tool.Close;
    query_tool.SQL.Text := 'SELECT NameRpt FROM MBReports WHERE TypeRpt =''MBAnalitV'' ';
    query_tool.Open;
    parent      := scripts_tree.AddChild(nil);
    scripts_tree.Selected[parent] := true;
    data        := scripts_tree.GetNodeData( parent );
    data.folder := true;
    data.name   := 'Отчеты (интегрированные)';
    while not query_tool.Eof do
    begin
      node := scripts_tree.AddChild(parent);
      data := scripts_tree.GetNodeData( node );
      data^.name            := query_tool.Fields[0].AsString;
      data^.automation_type := report_type;
      query_tool.Next;
    end;

    //Типовые маршруты
    query_tool.Close;
    query_tool.SQL.Text := 'SELECT NameAn FROM MBAnalit WHERE Vid = 3140 ';
    query_tool.Open;
    parent      := scripts_tree.AddChild(nil);
    scripts_tree.Selected[parent] := true;
    data        := scripts_tree.GetNodeData( parent );
    data.folder := true;
    data.name   := 'Типовые маршруты';
    while not query_tool.Eof do
    begin
      node := scripts_tree.AddChild(parent);
      data := scripts_tree.GetNodeData( node );
      data^.name            := query_tool.Fields[0].AsString;
      data^.automation_type := route_type ;
      query_tool.Next;
    end;


    //Справочники
    query_tool.Close;
    query_tool.SQL.Text := 'SELECT Name FROM MBVidAn';
    query_tool.Open;
    parent      := scripts_tree.AddChild(nil);
    scripts_tree.Selected[parent] := true;
    data        := scripts_tree.GetNodeData( parent );
    data.folder := true;
    data.name   := 'Справочники';
    while not query_tool.Eof do
    begin
      node := scripts_tree.AddChild(parent);
      data := scripts_tree.GetNodeData( node );
      data^.name            := query_tool.Fields[0].AsString;
      data^.automation_type := reference_event_type ;
      query_tool.Next;
    end;

    //Документы
    query_tool.Close;
    query_tool.SQL.Text := 'SELECT Name FROM MBEDocType';
    query_tool.Open;
    parent      := scripts_tree.AddChild(nil);
    scripts_tree.Selected[parent] := true;
    data        := scripts_tree.GetNodeData( parent );
    data.folder := true;
    data.name   := 'Документы';
    while not query_tool.Eof do
    begin
      node := scripts_tree.AddChild(parent);
      data := scripts_tree.GetNodeData( node );
      data^.name            := query_tool.Fields[0].AsString;
      data^.automation_type := document_event_type ;
      query_tool.Next;
    end;




  end;
  }
end;

end.