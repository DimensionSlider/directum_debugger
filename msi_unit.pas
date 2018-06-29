unit msi_unit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, VirtualTrees, ExtCtrls, ShellApi, Menus, sEdit, sButton, sLabel, sPanel;

type
  Tmsi_form = class(TForm)
    pnl1: TsPanel;
    tree: TVirtualStringTree;
    lbl1: TsLabel;
    pnl2: TsPanel;
    pnl3: TsPanel;
    Panel1: TsPanel;
    Label1: TsLabel;
    pnl4: TsPanel;
    btn1: TsButton;
    pm1: TPopupMenu;
    edt1: TsEdit;
    Guid: TsLabel;
    edt2: TsEdit;
    lbl2: TsLabel;
    btn2: TsButton;
    procedure btn1Click(Sender: TObject);
    procedure treeGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);
    procedure btn2Click(Sender: TObject);
    procedure treeFocusChanged(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


 PPackageRecord = ^TPackageRecord;
 TPackageRecord = record
  guid:string;
  name:string;
 end;

var
  msi_form: Tmsi_form;


implementation

uses routine_strings, main;

{$R *.dfm}

procedure Tmsi_form.btn1Click(Sender: TObject);
var
  products_list:TStringList;
  data : PPackageRecord;
  node : PVirtualNode;
  guid : string;
  i:Integer;
begin
  ShellExecute( application.Handle, 'open', PWideChar( work_dir + '\getguids.vbs' ), nil, PWideChar( work_dir ), SW_SHOW );

  products_list := TStringList.Create;
  products_list.LoadFromFile(  work_dir + '\productslist.txt' );

  tree.NodeDataSize := SizeOf( TPackageRecord );

  for i := 0 to products_list.Count - 1 do
  begin
    node := tree.AddChild( nil );
    data := tree.GetNodeData( node );
    PPackageRecord( data )^.guid := SubString( products_list.Strings[ i ], '}', 1 ) + '}';
    PPackageRecord( data )^.name := SubString( products_list.Strings[ i ], '}', 2 );
    
  end;



end;

procedure Tmsi_form.treeGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var
 Data: PPackageRecord;
begin

  Data := Sender.GetNodeData( Node );
  if Assigned( Data ) then
  begin
    if Column = 0 then
      CellText := PPackageRecord( Data ).name;
    if Column = 1 then
      CellText := PPackageRecord( Data ).guid;
  end;


end;

procedure Tmsi_form.btn2Click(Sender: TObject);
begin
  Close;
end;

procedure Tmsi_form.treeFocusChanged(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex);
var
  data : PPackageRecord;
begin
  data := tree.GetNodeData( node );
  edt1.Text := PPackageRecord( data ).guid;
  edt2.Text := 'msiexec.exe /x ' + PPackageRecord( data ).guid + ' /qn';
end;

end.