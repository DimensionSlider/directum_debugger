unit dlg_goto;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  Tdialog_goto = class(TForm)
    ed_string_num: TEdit;
    Label1: TLabel;
    btnGo: TButton;
    btn_cancel: TButton;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure ed_string_numKeyPress(Sender: TObject; var Key: Char);
    procedure btnGoClick(Sender: TObject);
    procedure btn_cancelClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dialog_goto: Tdialog_goto;

implementation

uses isbl_debugger_frm;

{$R *.dfm}

procedure Tdialog_goto.btnGoClick(Sender: TObject);
var
  line_num : integer;
begin
  if Length( ed_string_num.Text) > 0 then
  begin
    line_num := StrToInt( ed_string_num.Text );
    isbl_debugger.isbl_text.GotoLineAndCenter( line_num );
    close;
  end;
end;

procedure Tdialog_goto.btn_cancelClick(Sender: TObject);
begin
  close;
end;

procedure Tdialog_goto.ed_string_numKeyPress(Sender: TObject; var Key: Char);
begin

  if Key = #27 then // VK_ESCAPE
      Close;
  if Key = #13 then // VK_ESCAPE
      btnGo.Click;

end;

procedure Tdialog_goto.FormKeyPress(Sender: TObject; var Key: Char);
begin
if Key = #27 then // VK_ESCAPE
    Close;
end;

end.
