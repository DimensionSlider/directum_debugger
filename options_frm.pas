unit options_frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, ExtCtrls, StdCtrls, ComCtrls, sPanel, sTreeView, sButton, VirtualTrees, 
  sEdit, acPathDialog, sLabel, JvPageList, JvNavigationPane, JvExControls, 
  JvButton, SynEdit, JvExComCtrls, JvComCtrls, SynEditHighlighter, 
  SynHighlighterXML, MSXML2_TLB, IBDatabaseINI, sCheckBox, sPageControl;

type
  Toptions_form = class(TForm)
    Panel1: TsPanel;
    Button1: TsButton;
    Button2: TsButton;
    Button3: TsButton;
//    procedure skintreeGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
//      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
//    procedure Button4Click(Sender: TObject);
//    procedure FormCreate(Sender: TObject);
//    procedure skintreeDblClick(Sender: TObject);
//    procedure CheckBox1Click(Sender: TObject);
//    procedure Button2Click(Sender: TObject);
//    procedure Button3Click(Sender: TObject);
//    procedure JvNavPanelButton2Click(Sender: TObject);
//    procedure JvNavPanelButton3Click(Sender: TObject);
//    procedure JvNavPanelButton1Click(Sender: TObject);
//    procedure Button5Click(Sender: TObject);
//    procedure Button6Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
//    procedure ListSkins(Dir:String);
  end;

type
 PVSTSkinInfo = ^TVSTSkinInfo;
  TVSTSkinInfo  = record
   name : string;
end;



var
  options_form: Toptions_form;

implementation

uses main, routine_debug, frm_nonvisual;

{$R *.dfm}

//
//procedure Toptions_form.CheckBox1Click(Sender: TObject);
//begin
////  nonvisual.skin_manager.Active := checkbox1.Checked;
//end;
//
//procedure Toptions_form.FormCreate(Sender: TObject);
//begin
//
////  skintree.NodeDataSize := SizeOf( TVSTSkinInfo );
//
//end;
//
//procedure Toptions_form.JvNavPanelButton1Click(Sender: TObject);
//begin
////  pagecontrol.ActivePage := helper_page;
//end;
//
//procedure Toptions_form.JvNavPanelButton2Click(Sender: TObject);
//begin
////  pagecontrol.ActivePage := cover_page;
//end;
//
//procedure Toptions_form.JvNavPanelButton3Click(Sender: TObject);
//begin
////  pagecontrol.ActivePage := config_page;
//end;
//
//procedure Toptions_form.ListSkins(Dir:String);
//begin
////var
////  SR:TSearchRec;
////  FindRes:Integer;
////  node : PVirtualNode;
////  data : PVSTSkinInfo;
////begin
////  FindRes:=FindFirst(Dir+'*.asz',faAnyFile,SR);
////  While FindRes = 0 do
////  begin
////    if ((SR.Attr and faDirectory)=faDirectory) and
////    ((SR.Name='.')or(SR.Name='..')) then
////    begin
////      FindRes:=FindNext(SR);
////      Continue;
////    end;
////    if ((SR.Attr and faDirectory)=faDirectory) then {если найден каталог, то}
////    begin
////      ListSkins(Dir+SR.Name+'\'); {входим в процедуру поиска с параметрами текущего каталога + каталог, что мы нашли}
////      FindRes:=FindNext(SR); {после осмотра вложенного каталога мы продолжаем поиск в этом каталоге}
////      Continue;
////    end;
////    node := skintree.AddChild(nil);
////    data := skintree.GetNodeData( node );
////    skintree.Selected[node]:=true;
////    data.name := SR.Name;
////    FindRes:=FindNext(SR);
////  end;
////  FindClose(SR);
//end;
//
//procedure Toptions_form.Button2Click(Sender: TObject);//begin
//  Close;
//end;
//
//procedure Toptions_form.Button3Click(Sender: TObject);//begin
//  close;
//end;
//
//procedure Toptions_form.Button4Click(Sender: TObject);
//begin
////   ListSkins( sk_path.text );
////  nonvisual.skin_manager.SkinDirectory := sk_path.Text;
//end;
//
//procedure Toptions_form.Button5Click(Sender: TObject);//begin////var
////  node_list : IXMLDOMNodeList;
////  breakpoints_node, breakpoint, line, node      : IXMLDOMNode;
////  new_node  : IXMLDOMNode;
////  breakpoints_element : IXMLDOMElement;
////  attribute : IXMLDOMAttribute;
////
////begin
////  node_list := xml_configuration.SelectNodes('//Settings/Breakpoints');
////  if node_list.length = 0 then
////  begin
////     node_list := xml_configuration.SelectNodes('//Settings');
////     node := node_list.NextNode;
////     new_node := xml_configuration.CreateNode(1,'Breakpoints','');
////     node.AppendChild( new_node );
////     config_editor.Text := xml_configuration.XML;
////  end;
////
////  node_list := xml_configuration.SelectNodes('//Settings/Breakpoints/Breakpoint');
////  if node_list.length = 0 then
////  begin
////     node_list        := xml_configuration.SelectNodes('//Settings/Breakpoints');
////     breakpoints_node := node_list.NextNode;
////     breakpoint       := xml_configuration.CreateNode(1,'Breakpoint','');
////     breakpoints_node.AppendChild( breakpoint );
////     attribute        := xml_configuration.createAttribute( 'Name' );
////     breakpoint.attributes.SetNamedItem(attribute);
////     attribute.Text   := '—прѕоиск';
////     line             := xml_configuration.CreateNode(1,'Lines','');
////     breakpoint.AppendChild( line );
////     config_editor.Text := xml_configuration.XML;
////  end;
//
//end;

//procedure Toptions_form.Button6Click(Sender: TObject);//begin
////  EditText( xml_configuration.XML );
////  EditText_SetXMLHightlighter();
//end;
//procedure Toptions_form.skintreeDblClick(Sender: TObject);//var
//  data : PVSTSkinInfo;
//begin
//  if Assigned( skintree.FocusedNode ) then
//  begin
//    data := skintree.GetNodeData( skintree.FocusedNode );
//    if assigned( data ) then
//    begin
////      nonvisual.Skin_Manager.SkinName := ExtractFileName(data.name);
//    end;
//  end;
//end;//procedure Toptions_form.skintreeGetText(Sender: TBaseVirtualTree;//  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
//  var CellText: string);
//var
//  data : PVSTSkinInfo;
//begin
//  data := skintree.GetNodeData( node );
//  celltext := data.name;
//end;
end.