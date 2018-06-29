unit text_unit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, SynEdit, StdCtrls, ExtCtrls, Clipbrd, SynHighlighterSQL, 
  SynEditHighlighter, SynHighlighterXML, ExtDlgs, OmniXML, OmniXMLUtils, SynHighlighterDfm, 
  sButton, sPanel, ComCtrls, ToolWin, sToolBar, ImgList, ActnMan, ActnCtrls, Ribbon, 
  ActnList, RibbonLunaStyleActnCtrls, PlatformDefaultStyleActnCtrls, ActnMenus,
  SynHighlighterPHP, Menus;

type
  Ttext_form = class(TForm)
    SynEdit: TSynEdit;
    SynXMLSyn: TSynXMLSyn;
    SynSQLSyn: TSynSQLSyn;
    save_text_file_dialog: TSaveTextFileDialog;
    SynDfmSyn: TSynDfmSyn;
    ImageList: TImageList;
    ActionManager: TActionManager;
    Action1: TAction;
    Action2: TAction;
    Action3: TAction;
    Action4: TAction;
    Action5: TAction;
    Action6: TAction;
    Action7: TAction;
    Action8: TAction;
    Action9: TAction;
    ActionMainMenuBar1: TActionMainMenuBar;
    Action10: TAction;
    SynPHPSyn: TSynPHPSyn;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    procedure btn2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure toolbar_clearClick(Sender: TObject);
    procedure on_hold_buttonClick(Sender: TObject);
    procedure toolbar_stepClick(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
    procedure ToolButton2Click(Sender: TObject);
    procedure ToolButton3Click(Sender: TObject);
    procedure ToolButton5Click(Sender: TObject);
    procedure ToolButton4Click(Sender: TObject);
    procedure Action2Execute(Sender: TObject);
    procedure Action1Execute(Sender: TObject);
    procedure Action3Execute(Sender: TObject);
    procedure Action4Execute(Sender: TObject);
    procedure Action5Execute(Sender: TObject);
    procedure Action6Execute(Sender: TObject);
    procedure Action7Execute(Sender: TObject);
    procedure Action8Execute(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure SynEditKeyPress(Sender: TObject; var Key: Char);
    procedure Action10Execute(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  function FormatXML(szOriginal : string; nIndentDepth : Integer = 2;
bHighlightCloseTag : boolean = false) : string;

var
  text_form: Ttext_form;

implementation


{$R *.dfm}

function IndentXML(const xml: string): string;
var
  xmlDoc: IXMLDocument;
begin
  Result := '';
  xmlDoc := CreateXMLDoc;
  if not XMLLoadFromAnsiString(xmlDoc, xml) then
    Exit;
  Result := XMLSaveToAnsiString(xmlDoc, ofIndent);
end;

procedure Ttext_form.Action10Execute(Sender: TObject);
begin
  Synedit.Highlighter := SynPHPSyn;
end;

procedure Ttext_form.Action1Execute(Sender: TObject);
begin
  Clipboard.AsText := Synedit.Lines.Text;
end;

procedure Ttext_form.Action2Execute(Sender: TObject);
begin
  Synedit.WordWrap := true;
end;

procedure Ttext_form.Action3Execute(Sender: TObject);
begin
  Synedit.WordWrap := false;
end;

procedure Ttext_form.Action4Execute(Sender: TObject);
begin
  if save_text_file_dialog.Execute then
    Synedit.Lines.SaveToFile( save_text_file_dialog.FileName );
end;

procedure Ttext_form.Action5Execute(Sender: TObject);
begin
  Synedit.Highlighter := SynSQLSyn;

end;

procedure Ttext_form.Action6Execute(Sender: TObject);
begin
  Synedit.Highlighter := SynXMLSyn;

end;

procedure Ttext_form.Action7Execute(Sender: TObject);
begin
 Synedit.Text := IndentXML(  Synedit.Text );
end;

procedure Ttext_form.Action8Execute(Sender: TObject);
begin
  close;
end;

procedure Ttext_form.btn2Click(Sender: TObject);
begin
  Clipboard.AsText := Synedit.Lines.Text;
end;

procedure Ttext_form.Button1Click(Sender: TObject);
begin
Synedit.WordWrap := true;
end;

procedure Ttext_form.Button2Click(Sender: TObject);
begin
Synedit.WordWrap := false;
end;

procedure Ttext_form.Button3Click(Sender: TObject);
function PadLine(const Count: Integer): string;
var
I: Integer;
begin
SetLength(Result, Count);
for I:= 1 to Count do
Result[I]:= ' ';
end;
var
S: string;
P: PChar;
NewLine: string;
Level: Integer;
begin
S:= Synedit.Lines.Text;
Synedit.Lines.Clear;
P:= PChar(S);
NewLine:= '';
Level:= 0;
while P^ <>#0 do
begin
case P^ of
'<': begin
if NewLine <>'' then
Synedit.Lines.Add(NewLine);
if PChar(P+1)^ = '/' then
begin
NewLine:= PadLine((Level-1) * 2) + P^;
Dec(Level);
end
else
begin
Inc(Level);
NewLine:= PadLine((Level-1) * 2) + P^;
end;
end;
'>': begin
NewLine:= NewLine + P^;
Synedit.Lines.Add(NewLine);
NewLine:= '';
if PChar(P+1)^ = #0 then
Break;
if PChar(P-1)^ ='/' then
Dec(Level);
end;
else
if NewLine = '' then
NewLine:= PadLine(Level * 2);
NewLine:= NewLine + P^;
end;
Inc(P);
end;
if NewLine <>'' then
Synedit.Lines.Add(NewLine);
end;

procedure Ttext_form.Button4Click(Sender: TObject);
begin
  if save_text_file_dialog.Execute then
    Synedit.Lines.SaveToFile( save_text_file_dialog.FileName );
end;

procedure Ttext_form.Button5Click(Sender: TObject);
begin
// SynEdit1.Text := FormatXML( SynEdit1.Text, 10, false);
 Synedit.Text := IndentXML(  Synedit.Text );
end;

procedure Ttext_form.FormCreate(Sender: TObject);
begin
  save_text_file_dialog.InitialDir := ExtractFilePath( paramstr(0) );
end;

procedure Ttext_form.FormKeyPress(Sender: TObject; var Key: Char);
begin
if Key = #27 then // VK_ESCAPE
    Close;
end;

procedure Ttext_form.N1Click(Sender: TObject);
begin
  SynEdit.CopyToClipboard;
end;

procedure Ttext_form.N2Click(Sender: TObject);
begin
  SynEdit.CutToClipboard;
end;

procedure Ttext_form.N3Click(Sender: TObject);
begin
  SynEdit.PasteFromClipboard;
end;

procedure Ttext_form.on_hold_buttonClick(Sender: TObject);
begin
Synedit.WordWrap := true;
end;

procedure Ttext_form.SynEditKeyPress(Sender: TObject; var Key: Char);
begin
if Key = #27 then // VK_ESCAPE
    Close;
end;

procedure Ttext_form.toolbar_clearClick(Sender: TObject);
begin
  Clipboard.AsText := Synedit.Lines.Text;
end;

procedure Ttext_form.toolbar_stepClick(Sender: TObject);
begin
Synedit.WordWrap := false;
end;

procedure Ttext_form.ToolButton1Click(Sender: TObject);
begin
  if save_text_file_dialog.Execute then
    Synedit.Lines.SaveToFile( save_text_file_dialog.FileName );
end;

procedure Ttext_form.ToolButton2Click(Sender: TObject);
begin
 Synedit.Text := IndentXML(  Synedit.Text );
end;

procedure Ttext_form.ToolButton3Click(Sender: TObject);
begin
  close;
end;

procedure Ttext_form.ToolButton4Click(Sender: TObject);
begin
  Synedit.Highlighter := SynSQLSyn;
end;

procedure Ttext_form.ToolButton5Click(Sender: TObject);
begin
  Synedit.Highlighter := SynXMLSyn;
end;

function FormatXML(szOriginal : string; nIndentDepth : Integer;
bHighlightCloseTag : boolean) : string;
var
bDoIndent : boolean;
szCheckTag : string;
bTagBuilding : boolean;
szCurrentTag : string;
cNextChar : char;
bQuoteActive : boolean;
cChar : char;
bCheckIndent : boolean;
bTagActive : boolean;
nStringLoop : Integer;
nIndent : Integer;
procedure OutputIndent;
var
nIndentLoop : Integer;
begin
result := result + #13#10;
if nIndent < 0 then
begin
nIndent := 0; // fix negative indents due to bad
//XML
// result := result + '[NEGINDENT]';
end;
for nIndentLoop := 0 to nIndent do
begin
result := result + ' ';
end;
end;
begin
bTagBuilding := False;
bQuoteActive := False;
bTagActive := False;
result := '';
nIndent := 0;
bCheckIndent := False;
szCurrentTag := '';
for nStringLoop := 1 to Length(szOriginal) do
begin
cChar := szOriginal[nStringLoop];
if nStringLoop < Length(szOriginal) then
begin
cNextChar := szOriginal[nStringLoop + 1];
end
else
begin
cNextChar := ' '; // safe char
end;
case cChar of //
'<':
begin
bDoIndent := False;
bTagActive := True;
if cNextChar = '/' then
begin
Dec(nIndent, nIndentDepth);
bTagBuilding := False;
bCheckIndent := False;
szCheckTag := Copy(szOriginal,
nStringLoop + 2, Length(szCurrentTag));
if szCheckTag <>szCurrentTag then
bDoIndent := True;
end
else
begin
bTagBuilding := True;
szCurrentTag := '';
bCheckIndent := True;
if not bHighlightCloseTag then
bDoIndent := True;
end;
if bHighlightCloseTag then
bDoIndent := True;
if bDoIndent then
OutputIndent;
result := result + '<';
end;
'>':
begin
bTagActive := False;
bTagBuilding := False;
result := result + '>';
if bCheckIndent then
Inc(nIndent, nIndentDepth);
{$IFDEF Codesite}
// CodeSite.Send('CurrentTag="' +
szCurrentTag + '"');
{$ENDIF}
end;
'"':
begin
result := result + cChar;
if bTagActive then
bQuoteActive := not bQuoteActive;
end;
'/':
begin
if (bTagActive) and (not bQuoteActive)
then
begin
if bCheckIndent then
begin
if cNextChar = '>' then
Dec(nIndent,
nIndentDepth);
end;
end;
result := result + '/';
end;
else
begin
if bTagBuilding then
begin
if cChar <>' ' then
begin
szCurrentTag :=
szCurrentTag + cChar;
end
else
begin
bTagBuilding := False;
end;
end;
result := result + cChar;
end;
end; // case
end;
end;

end.