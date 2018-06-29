unit compare_unit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, VirtualTrees, sButton, sEdit, sLabel;

type
  Tcompare_form = class(TForm)
    VirtualStringTree: TVirtualStringTree;
    Edit1: TsEdit;
    Edit2: TsEdit;
    Label1: TsLabel;
    Label2: TsLabel;
    Label3: TsLabel;
    Button1: TsButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  compare_form: Tcompare_form;

implementation

{$R *.dfm}

end.