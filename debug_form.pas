unit debug_form;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, ExtCtrls, ShellApi, sMemo, sButton, sPanel, Clipbrd, ComCtrls, 
  ToolWin, sToolBar, ImgList;

type
  Tdebug_window = class(TForm)
    output     : TsMemo;
    ToolBar    : TsToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ImageList  : TImageList;
    ToolButton5: TToolButton;
    procedure Button1Click(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure sButton2Click(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
    procedure ToolButton2Click(Sender: TObject);
    procedure ToolButton3Click(Sender: TObject);
    procedure ToolButton4Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ToolButton5Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  debug_window: Tdebug_window;

implementation

  uses main, isbl_debugger_frm;

{$R *.dfm}

procedure Tdebug_window.Button1Click(Sender: TObject);
begin
  output.Clear;
end;

procedure Tdebug_window.FormCreate(Sender: TObject);
begin
    SetWindowLong(Self.Handle, GWL_HWNDPARENT, GetDesktopWindow);
    SetWindowPos(Self.Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE   or SWP_NOSIZE);
end;

procedure Tdebug_window.sButton2Click(Sender: TObject);
begin
  Clipboard.AsText := output.Text;
end;

procedure Tdebug_window.ToolButton1Click(Sender: TObject);
begin
  Application.Terminate();
  Application.ProcessMessages();
  isbl_debugger.Close;
end;

procedure Tdebug_window.ToolButton2Click(Sender: TObject);
begin
  Clipboard.AsText := output.Text;
end;

procedure Tdebug_window.ToolButton3Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', PChar( ExtractFilePath(paramstr(0) )), nil, PChar( ExtractFilePath(paramstr(0) )), SW_SHOWNORMAL);
end;

procedure Tdebug_window.ToolButton4Click(Sender: TObject);
begin
  output.Clear;
end;

procedure Tdebug_window.ToolButton5Click(Sender: TObject);
begin
  Close;
end;

procedure Tdebug_window.btn1Click(Sender: TObject);
begin
  window.close;
end;

end.