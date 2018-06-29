unit progress_bar_unit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, ComCtrls, StdCtrls, acProgressBar, sLabel;

type
  Tprogress_bar_form = class(TForm)
    progress: TsProgressBar;
    title: TsLabel;
    detail_text: TsLabel;
    ammount_done: TsLabel;
  private
    { Private declarations }
  public
    { Public declarations }
    text    : string;
    ammount : Integer;
    procedure SetAmmount( number:integer );
    procedure SetTitle( title_text:string );
    procedure Next();
    procedure Show();
    procedure Hide();
    
  end;

var
  progress_bar_form: Tprogress_bar_form;

implementation

{$R *.dfm}

procedure Tprogress_bar_form.SetAmmount( number:integer );
begin
  progress.position := 0;
  progress.Max := number;
end;

procedure Tprogress_bar_form.Next();
begin
  progress.position := progress.position + 1;
  ammount_done.Caption := Format('%s из %s', [ IntToStr(progress.Position), IntToStr( progress.Max) ] );
  Application.ProcessMessages;
end;

procedure Tprogress_bar_form.Show();
begin
  Self.Visible := true;
end;

procedure Tprogress_bar_form.Hide();
begin
  Self.Visible := false;
end;

procedure Tprogress_bar_form.SetTitle( title_text:string );
begin
  title.Caption := title_text;
end;


end.