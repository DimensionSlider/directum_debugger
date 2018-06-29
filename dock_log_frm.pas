unit dock_log_frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, ImgList, ComCtrls, ToolWin, sToolBar, VirtualTrees, StdCtrls, sEdit, 
  routine_strings, sLabel, ExtCtrls, sPanel, JvComponentBase, JvDockControlForm, ShlObj, 
  MSXML2_TLB, ThreadForScan;

type
  Tdock_log = class(TForm)
    log_tree: TVirtualStringTree;
    sToolBar1: TsToolBar;
    refresh_info: TToolButton;
    ImageList: TImageList;
    JvDockClient1: TJvDockClient;
    filter_panel: TsPanel;
    filter_ed: TsEdit;
    small: TImageList;
    button_clean: TToolButton;
    procedure refresh_infoClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure log_treeGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure log_treeGetImageIndex(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: Boolean; var ImageIndex: Integer);
    procedure button_cleanClick(Sender: TObject);
    procedure log_treeDblClick(Sender: TObject);
    procedure ApplyVirtualVisibility();
    procedure filter_edChange(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;



var
  dock_log          : Tdock_log;
  last_log_line     : integer;
  my_sbrtelog_file  : textfile;
  sbrte_log_file_strings : TStringList;
  sbrte_path:string;

  scan_thread : TScanThread = nil;

implementation

{$R *.dfm}

uses isbl_debugger_frm, routine_debug, thread_log_worker, log_message_frm;

function GetSpecialPath(CSIDL: word): string;
var s:  string;
begin
  SetLength(s, MAX_PATH);
  if not SHGetSpecialFolderPath(0, PChar(s), CSIDL, true)
  then s := '';
  result := PChar(s);
end;

procedure Tdock_log.log_treeDblClick(Sender: TObject);
var
  node : PVirtualNode;
  data : PVSTLog;
begin
  node := log_tree.FocusedNode;
  if not Assigned( node ) then exit;
  data := log_tree.GetNodeData( node );
  log_message_form.ShowMessage( data.text, data.callstack );
end;

procedure Tdock_log.log_treeGetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: Integer);
begin
  ImageIndex := 0;
end;

procedure Tdock_log.log_treeGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
var
  data : PVSTLog;
begin
  data := log_tree.GetNodeData( node );
  CellText := data.text;
end;

procedure Tdock_log.refresh_infoClick(Sender: TObject);
var
  worker : log_worker;
begin
  worker                 := log_worker.Create(False);
  worker.Priority        := tpNormal;
  worker.FreeOnTerminate := true;
end;

function GetComputerNetName: string;
var
  buffer: array[0..255] of char;
  size: dword;
begin
  size := 256;
  if GetComputerName(buffer, size) then
    Result := buffer
  else
    Result := ''
end;

procedure Tdock_log.button_cleanClick(Sender: TObject);
begin
  log_tree.Clear;
end;


procedure Tdock_log.filter_edChange(Sender: TObject);
begin
  ApplyVirtualVisibility();
end;

procedure Tdock_log.ApplyVirtualVisibility();
var
  i,j:integer;
  node : PVirtualNode;
  data : PVSTLog;
  visible_state : boolean;
begin
  for I := 0 to log_tree.TotalCount - 1 do
    begin
      //Подготовка шага цикла---------------------------------------------------
      if I <> 0 then
        node := log_tree.GetNext(node)
      else
        node := log_tree.GetFirst;
      //по умолчанию узел отображается до тех пор пока его не скроет один из механизмов ниже
      visible_state := true;
      data := log_tree.GetNodeData( node );
      if assigned( data ) then
      begin
        //НАЗВАНИЕ ПЕРЕМЕННОЙ ФИЛЬТР ПО ТЕКСТОВОМУ КРИТЕРИЮ---------------------
        if StringAssigned( filter_ed.text ) then
          if not FindSubString( data^.text, filter_ed.text ) then
            visible_state := false;

        log_tree.IsVisible[ node ] := visible_state;
      end;
    end;

    log_tree.Refresh;
end;

procedure Tdock_log.FormCreate(Sender: TObject);
var
  coDoc             : ComsDOMDocument;
  Doc               : IXMLDOMDocument;
  nodelist          : IXMLDOMNodeList;
  node              : IXMLDomNode;

  line_count        : integer;
  line              : string;
  worker            : log_worker;
  special_path      : string;
  log_settings_path : string;
  logs_folder_path  : string;
begin
  special_path      := GetSpecialPath( CSIDL_COMMON_APPDATA ) + '\NPO Computer\IS-Builder\';
  logs_folder_path  := special_path;
  log_settings_path := special_path + 'logsettings.xml';

  if FileExists( log_settings_path ) then
  begin
    Doc              := ComsDOMDocument.Create;
    Doc.load( log_settings_path );
    nodelist         := Doc.SelectNodes( '//Settings/Setting' );
    node             := nodelist.nextNode;
    logs_folder_path := node.attributes.getNamedItem('LogPath').text;
  end;

  sbrte_path            := logs_folder_path + GetComputerNetName() + '.is-builder.sbrte.log';
  log_tree.NodeDataSize := sizeOf( TVSTLog );
  last_log_line         := -1;

  if fileexists( sbrte_path ) then
  begin
    AssignFile(  my_sbrtelog_file, sbrte_path );
    scan_thread := TScanThread.Create(False,logs_folder_path, False );
    worker                 := log_worker.Create(False);
    worker.Priority        := tpNormal;
    worker.FreeOnTerminate := true;
  end;

end;

procedure Tdock_log.FormResize(Sender: TObject);
begin
  filter_ed.Width := dock_log.Width - filter_ed.Left - 5;
end;

end.