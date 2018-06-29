unit connection_options;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, ExtCtrls, StdCtrls, routine_strings, xmldom, XMLIntf, msxmldom, XMLDoc, 
  sButton, sCheckBox, sEdit, sLabel, sGroupBox, IdBaseComponent, IdComponent, 
  IdRawBase, IdRawClient, IdIcmpClient, dxBevel, Menus, JvMenus, JvExControls, 
  JvSpeedButton, Mask, AdvDropDown, AdvCustomGridDropDown, AdvGridDropDown, DB,
  SqlExpr, ComObj, FMTBcd, DBXMSSQL;

type
  Tconnection_options_form = class(TForm)
    XMLDocument: TXMLDocument;
    connect_btn: TsButton;
    Button1: TsButton;
    IdIcmpClient1: TIdIcmpClient;
    CheckBox1: TsCheckBox;
    cmb_remember_password: TsCheckBox;
    autologon_box: TsCheckBox;
    label_connected: TsLabel;
    login_edit: TsEdit;
    db_edit: TsEdit;
    pc_edit: TsEdit;
    dxBevel1: TdxBevel;
    Image1: TImage;
    JvSpeedButton1: TJvSpeedButton;
    local_config_popup: TJvPopupMenu;
    SQLConnection: TSQLConnection;
    SQLQuery: TSQLQuery;
    pass_edit: TsEdit;
    db_params_delphi7: TMemo;
    procedure connect_btnClick(Sender: TObject);
    procedure pass_editKeyPress(Sender: TObject; var Key: Char);
    procedure db_editKeyPress(Sender: TObject; var Key: Char);
    procedure pc_editKeyPress(Sender: TObject; var Key: Char);
    procedure login_editKeyPress(Sender: TObject; var Key: Char);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure autologon_boxClick(Sender: TObject);
    procedure cmb_remember_passwordClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SelectConfigDatabase( Sender:TObject );

  private
    procedure ConnectToDirectumApplication;
    { Private declarations }
  public
      procedure OnRun();
      procedure ConnectToDB();
    { Public declarations }
  end;

var
  connection_options_form: Tconnection_options_form;
  servers:TStringList;

implementation

{$R *.dfm}

uses main;

function IPExists(IPAddr: String): Bool;
var
  I: TIdIcmpClient;
  Rec: Integer;
begin
  Result:= False;
  I:= TIdIcmpClient.Create(nil);
  try
    I.Host:= IPAddr;
    I.Ping();
    Sleep(2000);
    Rec:= I.ReplyStatus.BytesReceived;
    if Rec > 0 then Result:= True else Result:= False;
  finally
    I.Free;
  end;
end;

procedure Tconnection_options_form.SelectConfigDatabase( Sender:TObject );
begin
 pc_edit.Text := TRIM( SubString( ( Sender as TMenuItem ).Caption, 'на', 2 ) );
 db_edit.Text := SubString( ( Sender as TMenuItem ).Caption, 'на', 1 );
 db_edit.Text := TRIM(db_edit.Text);
 db_edit.Text := Replace( db_edit.Text, '&', '')
end;

procedure Tconnection_options_form.OnRun();
var
    i              : integer;
    Settings       : IXMLNode;
    Configurations : IXMLNode;
    SettingGroup   : IXMLNode;
    menu_item      : TMenuItem;
begin

  login_edit.Text               := configuration.ReadString('auth',       'login',login_edit.Text);
  pass_edit.Text                := configuration.ReadString('auth',       'pass', pass_edit.Text);
  pc_edit.Text                  := configuration.ReadString('connection', 'pc',   pc_edit.Text );
  db_edit.Text                  := configuration.ReadString('connection', 'db',   db_edit.Text );
  cmb_remember_password.Checked := configuration.ReadBool('auth', 'remember_me',  cmb_remember_password.checked );
  autologon_box.Checked         := configuration.ReadBool('auth', 'auto_connect', autologon_box.checked );

  //Заполнить выбор базы данных возможными вариантами---------------------------
  if FileExists( path_to_configurations_xml ) then
  begin
    XMLDocument.FileName := path_to_configurations_xml;
    XMLDocument.LoadFromFile( path_to_configurations_xml );
    Settings        := XMLDocument.ChildNodes.Get(1);
    Configurations  := Settings.ChildNodes.Get(0);
    servers.Clear;
    for i:=0 to Configurations.ChildNodes.COunt - 1 do
    begin
      SettingGroup := Configurations.ChildNodes.Get( i );
      servers.Add( SettingGroup.AttributeNodes['Server'].Text );
      menu_item := TMenuItem.Create( local_config_popup );
      menu_item.Caption := SettingGroup.AttributeNodes['Database'].Text + '   на   ' + SettingGroup.AttributeNodes['Server'].Text;
      menu_item.OnClick := SelectConfigDatabase;
      local_config_popup.Items.Add( menu_item );

    end;
  end;
  //----------------------------------------------------------------------------

  if autologon_box.Checked then
  begin
    IdIcmpClient1.Host := pc_edit.Text;
    IdIcmpClient1.Ping();
    if idICMPClient1.ReplyStatus.BytesReceived <> 0 then    
      connect_btn.Click;
  end;


end;

procedure Tconnection_options_form.ConnectToDB();
var
  connection_string:string;
begin

  if StringAssigned( login_edit.Text ) and StringAssigned( db_edit.Text ) and StringAssigned( pc_edit.Text ) then
  begin
    configuration.WriteString('auth',       'login',login_edit.Text);
    
    if cmb_remember_password.Checked then
      configuration.WriteString('auth',       'pass', pass_edit.Text)
    else
      configuration.WriteString('auth',       'pass', '' );

    configuration.WriteString('connection', 'pc',         pc_edit.Text );
    configuration.WriteString('connection', 'db',         db_edit.Text );
    configuration.WriteString('host',       'station',    current_computer_name );

    sqlconnection.Connected := false;
    sqlconnection.Params.Clear;
    sqlconnection.Params.AddStrings( db_params_delphi7.Lines );
    sqlconnection.Params.ValueFromIndex[ sqlconnection.Params.IndexOfName('DataBase') ]   := db_edit.Text;
    sqlconnection.Params.ValueFromIndex[ sqlconnection.Params.IndexOfName('User_Name') ]  := login_edit.Text;
    sqlconnection.Params.ValueFromIndex[ sqlconnection.Params.IndexOfName('Password') ]   := pass_edit.Text;
    sqlconnection.Params.ValueFromIndex[ sqlconnection.Params.IndexOfName('HostName') ]   := pc_edit.Text;

    try
      configuration.WriteString('auth','last_time_connect_attempt','1');
      sqlconnection.Connected := true;

    except
      on E : Exception do
      begin
        sqlconnection.connected := false;
        configuration.WriteString('auth','last_time_connect_attempt','0');
        ShowMessage( E.Message );
      end;
    end;

  end;

end;

procedure Tconnection_options_form.connect_btnClick(Sender: TObject);
var
  ConnectionParams : string;
begin

  if StringAssigned( login_edit.Text ) and
     StringAssigned( db_edit.Text )    and
     StringAssigned( pc_edit.Text ) then
  begin
    ConnectToDB();
    if sqlconnection.Connected then
    begin
      label_connected.Caption := 'Состояние: подключены';
      ConnectToDirectumApplication();
      Close();
    end
  end
  else
    ShowMessage('Заполнены не все поля авторизации');

end;

procedure Tconnection_options_form.pass_editKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then connect_btn.Click;
end;

procedure Tconnection_options_form.db_editKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then login_edit.SetFocus;
end;

procedure Tconnection_options_form.pc_editKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then db_edit.SetFocus;
end;

procedure Tconnection_options_form.login_editKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then pass_edit.SetFocus;
end;

procedure Tconnection_options_form.autologon_boxClick(Sender: TObject);
begin
  configuration.WriteBool('auth', 'auto_connect',  autologon_box.Checked );
end;

procedure Tconnection_options_form.Button1Click(Sender: TObject);
begin
  close;
end;

procedure Tconnection_options_form.cmb_remember_passwordClick(Sender: TObject);
begin
  configuration.WriteBool('auth', 'remember_me',  cmb_remember_password.Checked );
end;

procedure Tconnection_options_form.ConnectToDirectumApplication;
var
  ConnectionParams: string;
begin
  ConnectionParams    := 'ServerName=%s;DBName=%s;UserName=%s;Password=%s';
  ConnectionParams    := Format( ConnectionParams, [ pc_edit.Text,db_edit.Text,login_edit.Text,pass_edit.Text] );
  directumLoginPoint  := CreateOleObject( 'SBLogon.LoginPoint' ); //  ILoginPoint
  DirectumApplication := directumLoginPoint.GetApplication( ConnectionParams ); // IApplication;
end;

procedure Tconnection_options_form.FormCreate(Sender: TObject);
begin
  servers := TStringList.Create();
  sqlconnection.LibraryName := 'dbxmss.dll';
  sqlconnection.VendorLib   := 'sqlncli10.dll';
end;

procedure Tconnection_options_form.FormShow(Sender: TObject);begin
{  if sqlconnection.Connected then label_connected.Caption := 'Состояние: подключены'
  else  label_connected.Caption := 'Состояние: не подключены';}
end;

end.