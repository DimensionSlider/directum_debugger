unit routine_debug;

interface
  uses Forms, JCLDebug, routine_strings;

  procedure DebugMessage( str:string );
  procedure ShowDebug();
  procedure ShowDebugNotModal();
  procedure EditText( str:string );
  procedure EditText_SetXMLHightlighter();
  procedure EditText_SetSQLHightlighter();
  procedure EditText_SetDFMHightlighter();

procedure DebugMessageAndShow(str:string);

procedure DetectTextType;

implementation

uses debug_form,text_unit, main;

procedure DebugMessage( str:string );
begin
  str := ProcByLevel( 1 ) + ': ' + str;
  debug_window.output.Lines.Add( str );
  debug_window.output.Lines.SaveToFile( work_dir + '\debug.txt' );
  Application.ProcessMessages;
end;

procedure DebugMessageAndShow(str:string);
begin
  str := ProcByLevel( 1 ) + ': ' + str;
  debug_window.output.Lines.Add( str );
  debug_window.output.Lines.SaveToFile( work_dir + '\debug.txt' );
  Application.ProcessMessages;
  ShowDebug();
end;

procedure ShowDebug();
begin
  if not debug_window.Visible then
    debug_window.ShowModal;
end;

procedure ShowDebugNotModal();
begin
 debug_window.Show;
end;

procedure DetectTextType;
begin

  if FindSubString( text_form.SynEdit.Text, 'SELECT' )  and
     FindSubString( text_form.SynEdit.Text, 'FROM' )  and
     FindSubString( text_form.SynEdit.Text, 'WHERE' )
    then
        text_form.Synedit.Highlighter :=  text_form.SynSQLSyn;

end;

procedure EditText( str:string );
begin
  text_form.SynEdit.Text := str;
  {
  text_form.Visible := true;
  text_form.BringToFront;
  }
  DetectTextType();
  text_form.ShowModal;
end;

procedure EditText_SetSQLHightlighter();
begin
  text_form.SynEdit.Highlighter := text_form.SynSQLSyn;
end;

procedure EditText_SetXMLHightlighter();
begin
  text_form.SynEdit.Highlighter := text_form.SynXMLSyn;
end;

procedure EditText_SetDFMHightlighter();
begin
  text_form.SynEdit.Highlighter := text_form.SynDfmSyn;
end;



end.
