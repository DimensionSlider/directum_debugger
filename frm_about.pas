unit frm_about;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, sButton, sMemo;

type
  Tform_about = class(TForm)
    btn_close: TsButton;
    Label1: TLabel;
    label_compile_date: TLabel;
    procedure btn_closeClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  form_about: Tform_about;

implementation

{$R *.dfm}



procedure Tform_about.btn_closeClick(Sender: TObject);
begin
  close;
end;

end.
