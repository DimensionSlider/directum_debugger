unit assistant_options_frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, JvComponentBase, JvDockControlForm, ComCtrls, StdCtrls, sRadioButton, 
  sGroupBox, sLabel, ExtCtrls, sPanel, Menus, sbutton;

type
  Tdock_assistant_options = class(TForm)
    tool_panel: TsPanel;
    Label1: TsLabel;
    group_1: TsGroupBox;
    preproc_mode_rbtn: TsRadioButton;
    name_mode_rbtn: TsRadioButton;
    full_bdfield_rbtn: TsRadioButton;
    preproc_mode_short_rbtn: TsRadioButton;
    bdfield_rbtn: TsRadioButton;
    Button1: TsButton;
    group_2: TsGroupBox;
    quotes_mode_rbtn: TsRadioButton;
    double_quotes_mode_rbtn: TsRadioButton;
    noquotes_mode_rbtn: TsRadioButton;
    HotKey1: THotKey;
    JvDockClient1: TJvDockClient;
    procedure FormResize(Sender: TObject);
    procedure HotKey1Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dock_assistant_options: Tdock_assistant_options;

implementation

uses routine_api, main;

{$R *.dfm}

procedure Tdock_assistant_options.FormResize(Sender: TObject);
begin
  group_1.Width := group_1.Parent.Width - 25;
  group_2.Width := group_2.Parent.Width - 25;
end;

procedure Tdock_assistant_options.HotKey1Change(Sender: TObject);
var
  Key : Word;
  Modifiers: UINT;
  text_shortcut:string;
begin
  UnregisterHotKey( Handle, global_hotkey_id);
  GlobalDeleteAtom( global_hotkey_id );
  ShortCutToHotKey(HotKey1.HotKey, Key, Modifiers);
  global_hotkey_id := GlobalAddAtom( 'dir_assistant_hotkey' );
  RegisterHotKey( Handle , global_hotkey_id, Modifiers, Key );

  text_shortcut := ShortCutToText( HotKey1.HotKey );
  configuration.WriteString( 'user','hotkey', text_shortcut );
end;

end.