unit frm_nonvisual;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, ImgList, sSkinManager;

type
  Tnonvisual = class(TForm)
    ImageList: TImageList;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  nonvisual: Tnonvisual;

const
  pic_index_reference            = 2;
  pic_index_module               = 5;
  pic_index_ref_requisite        = 11;
  pic_index_autoset_column_width = 12;
  pic_index_edoc_requisite       = 13;
  pic_index_edoc_custom          = 15;
  pic_index_folder               = 32;
  pic_index_view                 = 33;
  pic_index_pagecontrol          = 34;
  pic_index_tabsheet             = 35;
  pic_index_group                = 36;
  pic_index_script               = 37;
  pic_index_event                = 46;
  pic_index_function             = 47;
  pic_index_report_tool          = 114;
  pic_index_report               = 115;
  pic_index_block                = 122;


implementation

{$R *.dfm}

end.