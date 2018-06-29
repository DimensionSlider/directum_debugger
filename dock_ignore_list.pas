unit dock_ignore_list;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, Menus, DockPanel, ExtCtrls, JvComponentBase, 
  JvDockControlForm, sListBox, sPanel;

type
  Tdock_isbl_ignorelist = class(TForm)
    ignore_list: TsListBox;
    ignore_popup: TPopupMenu;
    N2: TMenuItem;
    Panel1: TsPanel;
    underpanel: TsPanel;
    JvDockClient1: TJvDockClient;
    N1: TMenuItem;
    N3: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure ignore_listMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure N2Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure ignore_listKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dock_isbl_ignorelist: Tdock_isbl_ignorelist;

implementation

uses dock_isbl_tree_unit, isbl_debugger_frm, main;

{$R *.dfm}

procedure Tdock_isbl_ignorelist.FormCreate(Sender: TObject);
var
  file_name:string;
begin
  file_name := work_dir + '\ignore.txt';
if FileExists(file_name) then
  ignore_list.Items.LoadFromFile( file_name );

end;

procedure Tdock_isbl_ignorelist.ignore_listKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_DELETE then N2.Click;
end;

procedure Tdock_isbl_ignorelist.ignore_listMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
 ignore_list.ItemIndex := ignore_list.ItemAtPos(Point(x,y),true);
end;

procedure Tdock_isbl_ignorelist.N1Click(Sender: TObject);
var
  i:integer;
begin
  for i:=0 to  ignore_list.Items.Count -1 do
    N2.Click;
  
end;

procedure Tdock_isbl_ignorelist.N2Click(Sender: TObject);
var
  index:integer;
begin
 ignore_list.Items.Delete( ignore_list.ItemIndex );
 index := ignore_list.ItemIndex - 1;
 if ( index > 0 ) and ( index < ignore_list.Count ) then
 ignore_list.Selected[ index ] := true;


 
 ignore_list.Items.SaveToFile( work_dir + '\ignore.txt' );
 dock_isbl_tree.ApplyVirtualVisibility( dock_isbl_tree.tree );
end;

end.