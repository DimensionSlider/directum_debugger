unit isbl_debugger_frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, SynEdit, ComCtrls, ToolWin, sToolBar, VirtualTrees, Menus,
  ExtCtrls, sEdit, sLabel, sPanel, Elastic, DockPanel, SynEditHighlighter, 
  isbl_syntax_high, SynHighlighterPas, JvDockTree, JvDockControlForm, JvDockVIDStyle, 
  JvDockVSNetStyle, JvComponentBase, ImgList, Registry, routine_debug, JvExComCtrls, 
  JvToolBar, JvMenus, sStatusBar, psAPI, PlatformDefaultStyleActnCtrls, ActnList,
  ActnMan, RibbonLunaStyleActnCtrls, Ribbon, ActnCtrls, 
  RibbonObsidianStyleActnCtrls, SynEditMiscClasses, SynEditSearch, sButton, AdvMenus, 
  MarqueeProgressBar, JvStatusBar, ShellApi, Clipbrd, DISQLite3Database, DISystemCompat,
  sGroupBox, JCLDebug, AdvToolBar,

  sqlExpr, SynCompletionProposal, SynEditKeyCmds;

type
  Tisbl_debugger = class(TForm)
    MainMenu                : TAdvMainMenu;
    N3                      : TMenuItem;
    editor_panel            : TDockPanel;
    isbl_text               : TSynEdit;
    panel_title             : TsPanel;
    script_name             : TsLabel;
    N1                      : TMenuItem;
    N5                      : TMenuItem;
    menu_tree               : TMenuItem;
    menu_variables          : TMenuItem;
    BigImagesList           : TImageList;
    ImageList               : TImageList;
    N8                      : TMenuItem;
    menu_step               : TMenuItem;
    menu_breakpoint         : TMenuItem;
    menu_to_cursor          : TMenuItem;
    menu_run                : TMenuItem;
    menu_lastline_thisscript: TMenuItem;
    menu_lastscript         : TMenuItem;
    last_lastline_lastscript: TMenuItem;
    images_marks            : TImageList;
    menu_breaks             : TMenuItem;
    menu_messages           : TMenuItem;
    menu_stepover           : TMenuItem;
    timer_memory            : TTimer;
    N2                      : TMenuItem;
    N4                      : TMenuItem;
    N6                      : TMenuItem;
    JvDockVSNetStyle        : TJvDockVSNetStyle;
    JvDockServer            : TJvDockServer;
    ActionManager           : TActionManager;
    SynEditSearch1          : TSynEditSearch;
    search_panel            : TsPanel;
    search_text             : TsEdit;
    sButton1                : TsButton;
    AdvMenuStyler1          : TAdvMenuStyler;
    status                  : TJvStatusBar;
    MarqueeProgressBar1     : TMarqueeProgressBar;
    sToolBar2               : TsToolBar;
    ToolButton10            : TToolButton;
    ActionToolBar           : TActionToolBar;
    on_action               : TAction;
    clear_action            : TAction;
    search_action           : TAction;
    trace_action            : TAction;
    monitor_action          : TAction;
    step_action             : TAction;
    step_over_action        : TAction;
    first_action            : TAction;
    last_action             : TAction;
    ontop_action            : TAction;
    exit_action             : TAction;
    timer_hide_status       : TTimer;
    group_background_working: TsGroupBox;
    Label1                  : TsLabel;
    MarqueeProgressBar2     : TMarqueeProgressBar;
    isbl_text_popup         : TPopupMenu;
    N7                      : TMenuItem;
    ImageList1              : TImageList;
    tmp_                    : TTimer;
    action_run              : TAction;
    N10                     : TMenuItem;
    N11                     : TMenuItem;
    N12                     : TMenuItem;
    N13                     : TMenuItem;
    N14                     : TMenuItem;
    SynPasSyn1              : TSynPasSyn;
    N15                     : TMenuItem;
    N16                     : TMenuItem;
    N17                     : TMenuItem;
    A1                      : TMenuItem;
    search_tier             : TMenuItem;
    N18                     : TMenuItem;
    D1                      : TMenuItem;
    N9: TMenuItem;
    devToolbar: TJvToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    N19: TMenuItem;
    ToolButton3: TToolButton;
    ISBLPagesControl: TPageControl;
    debugSheet: TTabSheet;
    devSheet: TTabSheet;
    isbl_dev_edit: TSynEdit;
    ToolButton4: TToolButton;
    SynCompletionProposal: TSynCompletionProposal;
    SynAutoComplete: TSynAutoComplete;
    procedure isbl_textSpecialLineColors(Sender: TObject; Line: Integer;
      var Special: Boolean; var FG, BG: TColor);
    procedure FormCreate(Sender: TObject);
    procedure on_actionClick(Sender: TObject);
    procedure isbl_textClick(Sender: TObject);
    procedure step_actionClick(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure menu_breaksClick(Sender: TObject);
    procedure menu_messagesClick(Sender: TObject);
    procedure menu_treeClick(Sender: TObject);
    procedure menu_variablesClick(Sender: TObject);
    procedure isbl_textKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure menu_stepClick(Sender: TObject);
    procedure menu_runClick(Sender: TObject);
    procedure tb_testClick(Sender: TObject);
    procedure menu_lastline_thisscriptClick(Sender: TObject);
    procedure menu_lastscriptClick(Sender: TObject);
    procedure tb_extClick(Sender: TObject);
    procedure last_lastline_lastscriptClick(Sender: TObject);
    procedure isbl_textGutterClick(Sender: TObject; Button: TMouseButton; X, Y,
      Line: Integer; Mark: TSynEditMark);
    procedure tb_gotoendClick(Sender: TObject);
    procedure ontop_buttonClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure tb_step_over_buttonClick(Sender: TObject);
    procedure menu_stepoverClick(Sender: TObject);
    procedure menu_breakpointClick(Sender: TObject);
    procedure timer_memoryTimer(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure sButton1Click(Sender: TObject);
    procedure tb_firstClick(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure on_actionExecute(Sender: TObject);
    procedure clear_actionExecute(Sender: TObject);
    procedure search_actionExecute(Sender: TObject);
    procedure trace_actionExecute(Sender: TObject);
    procedure monitor_actionExecute(Sender: TObject);
    procedure step_actionExecute(Sender: TObject);
    procedure step_over_actionExecute(Sender: TObject);
    procedure first_actionExecute(Sender: TObject);
    procedure last_actionExecute(Sender: TObject);
    procedure ontop_actionExecute(Sender: TObject);
    procedure exit_actionExecute(Sender: TObject);
    procedure timer_hide_statusTimer(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure action_runExecute(Sender: TObject);
    procedure N10Click(Sender: TObject);
    procedure N12Click(Sender: TObject);
    procedure N14Click(Sender: TObject);
    procedure N13Click(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure isbl_textGutterPaint(Sender: TObject; aLine, X, Y: Integer);
    procedure editor_panelResize(Sender: TObject);
    procedure A1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure isbl_dev_editProcessCommand(Sender: TObject; var Command:
        TSynEditorCommand; var AChar: Char; Data: Pointer);
    procedure N18Click(Sender: TObject);
    procedure isbl_textKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure N19Click(Sender: TObject);
    procedure N9Click(Sender: TObject);
    procedure ISBLPagesControlChange(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
    procedure ToolButton2Click(Sender: TObject);
    procedure ToolButton3Click(Sender: TObject);
    procedure ToolButton4Click(Sender: TObject);

  protected
    procedure CreateParams(var Params: TCreateParams);override;


  private
    
    /// Добавляет новую переменную в список подсказок
    function CheckConnection: boolean;

    procedure ToggleDebuggerState;
    { Private declarations }
  public
    { Public declarations }
    last_step_line         : integer;
    last_rendered_line     : integer;
    last_interpreterID     : integer;
    last_interpreter_level : integer;
    last_object_node       : PVirtualNode;
    first_object_node      : PVirtualNode;

    line_of_interest        : integer;
    current_node_data       : Pointer;
    current_node            : PVirtualNode;
    on_off_state            : boolean;
    on_hold                 : boolean;
    stop_line               : integer;
    step_over_parentID      : integer;
    stepping_over           : Boolean;
    counter_rendered_lines  : integer;
    counter_started_scripts : integer;

    objects_list                    : TList;
    hold_this_line                  : boolean;
    display_how_debug_goes          : boolean;
    display_how_debug_goes_previous : boolean;

    // представляемся что мы отладчик
    FDebuggerMutex : THandle;

    procedure UpdateCaption();
    procedure SetCaptionLine( name, text : string );
    procedure SetLineOfInterest( line_number:integer );
    procedure SetLastRenderedLine( line_number:integer );
    procedure SaveControlsPositions();
    procedure RestoreControls();
    procedure OnRun();
    procedure OnShutdown();
    procedure SetOnHold();
    procedure SetOffHold();
    procedure WMSysCommand(var Msg: TWMSysCommand);message WM_SYSCOMMAND;

    procedure prepareProposals;

  end;

var
  isbl_debugger         : Tisbl_debugger;
  was_minimized         : boolean;
  FDatabase             : TDISQLite3Database;
  isbl_debugger_caption : TStringList;
  scriptName            : string;

implementation

uses debugger, routine_strings,
  dock_ignore_list, dock_variables_list_frm, dock_breaks, dock_callstack_frm, dock_isbl_tree_unit, variable_table_unit, main,
  scripts_frm, dock_log_frm, ComObj, ComServ, text_unit, frm_about, dlg_goto,
  connection_options, routine_synedit;

{$R *.dfm}

function IsUserAdmin : boolean;
const
  CAdminSia : TSidIdentifierAuthority = (value: (0, 0, 0, 0, 0, 5));
var sid : PSid;
    ctm : function (token: dword; sid: pointer; var isMember: bool) : bool; stdcall;
    b1  : bool;
begin
  result := false;
  ctm := GetProcAddress( LoadLibrary('advapi32.dll'), 'CheckTokenMembership' );
  if (@ctm <> nil) and AllocateAndInitializeSid(CAdminSia, 2, $20, $220, 0, 0, 0, 0, 0, 0, sid) then
  begin
    result := ctm(0, sid, b1) and b1;
    FreeSid(sid);
  end;
end;

procedure Tisbl_debugger.SetCaptionLine( name, text : string );
begin
   isbl_debugger_caption.Values[ name ] := text;
   UpdateCaption();
end;

procedure Tisbl_debugger.UpdateCaption();
var
  i:integer;
begin
  isbl_debugger.Caption := 'Отладчик ISBL ';
   for i := 0 to isbl_debugger_caption.Count - 1 do
     isbl_debugger.Caption := isbl_debugger.Caption + ' ' + SubString( isbl_debugger_caption.Strings[i], '=', 2 );
end;

function RGBToColor(R, G, B: Byte): TColor;
begin
  Result := B shl 16 or G shl 8 or R;
end;

function ComServerInstalled(ID: string): Boolean; overload;
var
  MyReg: TRegistry;
begin
  MyReg := TRegistry.Create(KEY_EXECUTE); // Read-only access
  try
    with MyReg do
    begin
      Rootkey := HKEY_CLASSES_ROOT;
      Result  := OpenKey(ID, false);
      CloseKey;
    end;
  finally
  FreeAndNil(MyReg);
  end;
end;

function ComServerInstalled(GUID: TGUID): Boolean; overload;
var
  MyObj : OleVariant;
begin
  result := False;
  try
    try
      MyObj := CreateComObject(GUID);
      if not VarIsEmpty(MyObj) then
      result := True;
    except
      result := False;
    end;
  finally
    if not VarIsEmpty(MyObj) then
    VarClear(MyObj);
  end;
end;



procedure VSNetDockForm(AForm: TForm; APanel: TJvDockVSNETPanel);
begin
  //  AForm.Width := 180;
  AForm.Top := 10000;
  //  AForm.Visible := true;
  AForm.ManualDock(APanel,nil,APanel.Align);
  APanel.ShowDockPanel(True, AForm);
end;

procedure Tisbl_debugger.SetOnHold();
begin
  isbl_debugger.on_hold    := true;
  hold_this_line           := true;
  step_action.Enabled      := true;
  menu_step.Enabled        := true;
  menu_stepover.Enabled    := true;
  trace_action.Checked     := true;
  step_over_action.Enabled := true;
  stepping_over            := false;
  step_over_parentID       := -1;
end;

procedure Tisbl_debugger.step_actionExecute(Sender: TObject);
begin
  if Assigned( isbl_debugger.current_node ) then
  begin
    dock_isbl_tree.tree.FocusedNode := dock_isbl_tree.SeekNodeByInterpreterID( isbl_debugger.last_interpreterID );
    dock_isbl_tree.tree.Selected[ dock_isbl_tree.tree.FocusedNode  ] := true;
  end;

  stop_line      := last_rendered_line;
  hold_this_line := false;
end;

procedure Tisbl_debugger.SetOffHold();
begin
  isbl_debugger.on_hold        := false;
  hold_this_line               := false;
  step_action.Enabled          := false;
  menu_step.Enabled            := false;
  menu_stepover.Enabled        := false;
  trace_action.Checked         := false;
  isbl_debugger.hold_this_line := false;
  step_over_action.Enabled     := false;
end;

procedure Tisbl_debugger.on_actionExecute(Sender: TObject);
begin
  ToggleDebuggerState;
end;

procedure Tisbl_debugger.CreateParams(var Params: TCreateParams);
 begin
  inherited;
  // Добавляем в расширенный стиль флаг WS_EX_AppWindow,
  // чтобы форма с документом имела кнопку на панели задач.
//  Params.ExStyle:=Params.ExStyle or WS_EX_AppWindow
 end;

procedure Tisbl_debugger.SaveControlsPositions();
begin
  configuration.WriteBool('debugger', trace_action.Name,   trace_action.Checked );
  configuration.WriteBool('debugger', on_action.Name,      on_action.Checked );
  configuration.WriteBool('debugger', ontop_action.Name,   ontop_action.Checked );
  configuration.WriteBool('debugger', monitor_action.Name,   monitor_action.Checked );
end;

procedure Tisbl_debugger.sButton1Click(Sender: TObject);
begin
  isbl_text.SearchEngine.Pattern := search_text.Text;
  isbl_text.SearchEngine.FindAll(search_text.Text);
end;

procedure Tisbl_debugger.search_actionExecute(Sender: TObject);
begin
  search_panel.Visible := search_action.Checked;
end;

procedure Tisbl_debugger.RestoreControls();
begin
  on_action.Checked      := configuration.ReadBool('debugger', on_action.Name, on_action.Checked );
  on_action.OnExecute(on_action);

  trace_action.Checked   := configuration.ReadBool('debugger', trace_action.Name, true );
  trace_action.OnExecute(trace_action);

  ontop_action.Checked   := configuration.ReadBool('debugger', ontop_action.Name, ontop_action.Checked );
  ontop_action.OnExecute(ontop_action);

  monitor_action.Checked := configuration.ReadBool('debugger', monitor_action.Name, monitor_action.Checked );
  monitor_action.OnExecute(monitor_action);
end;

procedure Tisbl_debugger.OnShutdown();
begin
  clear_action.Execute;
end;

{
 Примеры
  dock_variables_list.ManualDock( JvDockServer1.RightDockPanel );
  ManualConjoinDock(JvDockServer1.LeftDockPanel,   dock_steps_form, dock_isbl_tree );
  ( JvDockServer1.RightDockPanel as  TJvDockVSNETPanel ).DoHideControl( dock_scripts );

  Если при попытке сделать dock для окна вдруг выскакивает AV, значит либо не установлен на форму dockclient либо не задана его привязка
  Ширину парковочных панелей лучше задать перед парковкой. Иначе может произойти смещение вкладок скрытых панелек на внутрененню сторону.
}

procedure Tisbl_debugger.OnRun();
begin
  RestoreControls();
//  dock_isbl_tree.Visible             := true;
//  dock_variables_list.Visible        := true;
  JvDockServer.LeftDockPanel.Width   := 200;
  JvDockServer.RightDockPanel.Width  := 300;

  //Левая сторона
  ManualConjoinDock(JvDockServer.LeftDockPanel, dock_steps_form, dock_isbl_tree );
  //Правая сторона
  ManualConjoinDock(JvDockServer.RightDockPanel,  dock_log, dock_variables_list );

  //Фикс для сплиттера. Он неправильно распологался для левой панели.
  JvDockServer.LeftSplitter.Align := alRight;
  JvDockServer.LeftSplitter.Align := alLeft;

//  display_how_debug_goes := monitor_action.Checked;
end;

procedure Tisbl_debugger.FormCreate(Sender: TObject);
var
  isblHightlighter : TSynISBLSyn;
begin
  isbl_debugger_caption     := TStringList.Create;
  on_off_state              := on_action.Checked;
  isbl_debugger.on_hold     := trace_action.Checked;
  isblHightlighter          := TSynISBLSyn.Create(Self);
  isbl_text.Highlighter     := isblHightlighter;
  isbl_dev_edit.Highlighter := isblHightlighter;
  isblHightlighter.parent   := Addr(isbl_text);
  objects_list              := TList.Create;
  first_object_node         := nil;
  last_object_node          := nil;
  counter_rendered_lines    := 0;
  counter_started_scripts   := 0;
  isbl_text.Align           := alClient;
  isbl_text.BookMarkOptions.BookmarkImages := images_marks;

  // SQLite
  FDatabase := TDISQLite3Database.Create(nil);
  FDatabase.DatabaseName := 'trace.trc';

  FDebuggerMutex := CreateMutex(nil, True, 'ISB 7.0 Debugger Mutex');

  prepareProposals();

end;

procedure Tisbl_debugger.FormDestroy(Sender: TObject);
begin
  SaveControlsPositions();
end;

procedure Tisbl_debugger.FormHide(Sender: TObject);
begin
//  window.OnChildClose();
end;

procedure Tisbl_debugger.FormPaint(Sender: TObject);
begin
  if was_minimized then
  begin
    display_how_debug_goes := display_how_debug_goes_previous;
//    group_background_working.Visible := not display_how_debug_goes;
    group_background_working.Visible := False;
    was_minimized := false;
  end;
end;

procedure Tisbl_debugger.SetLineOfInterest( line_number:integer );
var
  amark : TSynEditMark;
begin
  try
    dock_variables_list.UpdateVariablesInfo( line_number );
    line_of_interest := line_number;
    if assigned( isbl_debugger.current_node_data ) then
    begin
      if PVSTDebugObject( isbl_debugger.current_node_data ).line_number = line_number then
      begin
        isbl_text.ActiveLineColor :=  RGBToColor( 255,119,144 )
      end
      else
      begin
        isbl_text.ActiveLineColor := clSkyBlue;
      end;
    end;

    if isbl_text.SelStart = isbl_text.SelEnd then // если я ничего не выделил, тогда можно. Иначе сбросит выделение.
    if isbl_text.CaretY <> line_of_interest then
      isbl_text.GotoLineAndCenter( line_of_interest );

  except ON E:Exception do DebugMessageAndShow( e.Message ); end;
end;

procedure Tisbl_debugger.SetLastRenderedLine( line_number:integer );
begin
  last_rendered_line := line_number;
  isbl_text.GotoLineAndCenter( line_number );
  isbl_text.Invalidate;
  isbl_text.Refresh;
end;


procedure Tisbl_debugger.isbl_textClick(Sender: TObject);
var
  i,j:integer;
begin
  try
    SetLineOfInterest( isbl_text.CaretY );
    dock_steps_form.LocateBreakPointForLine( isbl_text.CaretY );
    dock_variables_list.HighlightLineVariables( isbl_text.CaretY );
    dock_variables_list.ApplyVirtualVisibility();
  except
    ON E:Exception do DebugMessageAndShow( e.Message );
  end;
end;

procedure Tisbl_debugger.isbl_textGutterClick(Sender: TObject;
  Button: TMouseButton; X, Y, Line: Integer; mark: TSynEditMark);
var
  amark : TSynEditMark;
  marks : TSynEditMarks;
  data  : PVSTDebugObject;
  node  : PVirtualNode;
begin
  try
    node := dock_isbl_tree.tree.FocusedNode;
    if Assigned( node ) then
      data := dock_isbl_tree.tree.GetNodeData( node );
    if Assigned( node ) and Assigned( data )  then
    begin
      isbl_text.Marks.GetMarksForLine(Line, marks );
      if not assigned( marks[1] ) then
        data.stop_points.AddMark( line )
      else
        data.stop_points.DeleteMark( line );
    end;
  except
    ON E:Exception do DebugMessageAndShow( e.Message );
  end;
end;

procedure Tisbl_debugger.isbl_textGutterPaint(Sender: TObject; aLine, X,
  Y: Integer);
begin
  if assigned( current_node_data ) then
  begin
    if trace_action.Checked then
      if aLine = PVSTDebugObject( current_node_data ).line_number then
        images_marks.Draw( isbl_text.Canvas, 3, Y + 2, 0 );
  end;
end;

procedure Tisbl_debugger.isbl_textKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  node : PVirtualNode;
  data : PVSTVariableNodeData;
begin

  if Key = VK_F2 then
  begin
    if Length( isbl_text.SelText ) = 0 then
      exit;
    node := dock_variables_list.LocateVariableNodeByName( isbl_text.SelText );
    if Assigned( node ) then
    begin
      data := dock_variables_list.variable_tree.GetNodeData( node );
      if Assigned( data^.variable ) then
        dock_variables_list.ShowVariableCurValueInWindow( node );
      if Assigned( data^.value ) then
        dock_variables_list.ShowValueInWindow( node );
    end;

  end;
end;

procedure Tisbl_debugger.isbl_textKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if ( Key = VK_DOWN ) or ( Key = VK_UP ) then
    isbl_textClick(Sender);
end;

procedure Tisbl_debugger.isbl_textSpecialLineColors(Sender: TObject;
  Line: Integer; var Special: Boolean; var FG, BG: TColor);
var
  node            : PVirtualNode;
  debugObjectData : PVSTDebugObject;
begin

  try
    node := dock_isbl_tree.tree.FocusedNode;

    if assigned( node ) then
      debugObjectData := dock_isbl_tree.tree.GetNodeData(node)
    else
      exit();

    if ( assigned( debugObjectData ) ) and ( debugObjectData <> nil ) then
    begin
      //выполненная строка Сероватая
      if PVSTDebugObject( debugObjectData ).variable_table.steps_fast_table[ line ] = 1 then
         BG := TColor($E9E9E9);

      //последняя выполненная Красноватая
      if Line = last_step_line then
      begin
          BG:= TColor( RGBToColor( 255,119,144 ) );
      end;

      //Первая строчка пусть будет зеленоватая
      if Line = 1 then
        BG := clMoneyGreen;

//        Special := true;

    end;
  except
    ON E:Exception do DebugMessageAndShow( e.Message );
  end;

end;

procedure Tisbl_debugger.menu_runClick(Sender: TObject);
begin
  SetOffHold();
end;

procedure Tisbl_debugger.menu_lastline_thisscriptClick(Sender: TObject);
begin
  if assigned( current_node_data ) then
    isbl_text.GotoLineAndCenter(  PVSTDebugObject( current_node_data ).line_number );
end;

procedure Tisbl_debugger.menu_lastscriptClick(Sender: TObject);
var
  node : PVirtualNode;
begin
  node := dock_isbl_tree.SeekNodeByInterpreterID( last_interpreterID );
  if assigned( node ) then
  begin
    dock_isbl_tree.tree.FocusedNode := node;
    dock_isbl_tree.tree.Selected[node] := true;
  end;
end;

procedure Tisbl_debugger.last_lastline_lastscriptClick(Sender: TObject);
var
  node : PVirtualNode;
begin
  node := dock_isbl_tree.SeekNodeByInterpreterID( last_interpreterID );
  if assigned( node ) then
  begin
    dock_isbl_tree.tree.FocusedNode := node;
    dock_isbl_tree.tree.Selected[node] := true;
    isbl_text.GotoLineAndCenter(  PVSTDebugObject( current_node_data ).line_number );
    isbl_text.OnClick(isbl_text);
  end;
end;

procedure Tisbl_debugger.menu_breakpointClick(Sender: TObject);
begin
  isbl_textGutterClick( isbl_text, mbLeft, 0, 0, isbl_text.CaretY , nil );
end;

procedure Tisbl_debugger.menu_breaksClick(Sender: TObject);
begin

  if    not dock_isbl_tree.Visible
    and not dock_steps_form.Visible
  then
  begin
    dock_steps_form.Visible := true;
    dock_steps_form.ManualDock( JvDockServer.LeftDockPanel );
  end;

  if dock_isbl_tree.Visible and not dock_steps_form.Visible then
    ManualConjoinDock(JvDockServer.LeftDockPanel, dock_steps_form, dock_isbl_tree );

end;

procedure Tisbl_debugger.menu_variablesClick(Sender: TObject);
begin
  if    not dock_variables_list.Visible
    and not dock_log.Visible
  then
  begin
    dock_variables_list.Visible := true;
    dock_variables_list.ManualDock( JvDockServer.RightDockPanel );
  end;

  if not dock_variables_list.Visible and dock_log.Visible then
    ManualConjoinDock(JvDockServer.RightDockPanel, dock_log, dock_variables_list );
end;

procedure Tisbl_debugger.monitor_actionExecute(Sender: TObject);
begin
  display_how_debug_goes := ( Sender as TAction ).Checked;

  isbl_text.Visible                  := display_how_debug_goes;
  dock_variables_list.Visible        := display_how_debug_goes;
  dock_isbl_tree.Visible             := display_how_debug_goes;
  dock_steps_form.Visible            := display_how_debug_goes;
  JvDockServer.LeftDockPanel.Visible := display_how_debug_goes;
  panel_title.Visible                := display_how_debug_goes;

  search_action.Visible              := display_how_debug_goes;
  trace_action.Visible               := display_how_debug_goes;
  step_action.Visible                := display_how_debug_goes;
  step_over_action.Visible           := display_how_debug_goes;
  first_action.Visible               := display_how_debug_goes;
  last_action.Visible                := display_how_debug_goes;
  clear_action.Visible               := display_how_debug_goes;
  action_run.Visible                 := display_how_debug_goes;

  ActionToolBar.ActionClient.Items[4].Visible := display_how_debug_goes;

  if display_how_debug_goes then
  begin
    dock_isbl_tree.tree.FocusedNode  := first_object_node;
    group_background_working.Visible := false;
  end;


end;

procedure Tisbl_debugger.menu_stepClick(Sender: TObject);
begin
 step_action.Execute;
end;

procedure Tisbl_debugger.menu_stepoverClick(Sender: TObject);
begin
  step_over_action.Execute;
end;

procedure Tisbl_debugger.N10Click(Sender: TObject);
begin
  ShowDebug();
end;

procedure Tisbl_debugger.N12Click(Sender: TObject);
begin
  ShellExecute(handle, 'open', 'http://www.youtube.com/watch?v=ytvGpgbhpTM', nil, nil, SW_SHOW);
end;

procedure Tisbl_debugger.N13Click(Sender: TObject);
begin
  form_about.Show;
end;

procedure Tisbl_debugger.N14Click(Sender: TObject);
begin
  ShellExecute(handle, 'open', 'http://club.directum.ru/post/Alternativnyjj-otladchik-DIRECTUM.aspx', nil, nil, SW_SHOW);
end;

procedure Tisbl_debugger.N18Click(Sender: TObject);
begin
  dialog_goto.ShowModal();
end;

procedure Tisbl_debugger.N3Click(Sender: TObject);
begin
  {
  DIRAssistant.Visible := True;
  DIRAssistant.BringToFront;
  }
end;

procedure RunAsAdmin(const aFile: string; const aParameters: string = ''; Handle: HWND = 0);
var
  sei: TShellExecuteInfo;
begin
  FillChar(sei, SizeOf(sei), 0);

  sei.cbSize  := SizeOf(sei);
  sei.Wnd     := Handle;
  sei.fMask   := SEE_MASK_FLAG_DDEWAIT or SEE_MASK_FLAG_NO_UI;
  sei.lpVerb  := 'runas';
  sei.lpFile  := PChar(aFile);
  sei.lpParameters := PChar(aParameters);
  sei.nShow   := SW_SHOWNORMAL;

  if not ShellExecuteEx(@sei) then
    RaiseLastOSError;
end;

procedure Tisbl_debugger.N4Click(Sender: TObject);
var
  admin : boolean;
  path : string;
begin
  path  := paramstr( 0 );
  admin := IsUserAdmin();

  if admin then
    ComServer.UpdateRegistry( true )
  else
    RunAsAdmin( paramstr( 0 ), '/regserver' );

end;

procedure Tisbl_debugger.N6Click(Sender: TObject);
begin
  ComServer.UpdateRegistry( false );
end;

procedure Tisbl_debugger.N7Click(Sender: TObject);
begin
  Clipboard.AsText := isbl_text.SelText;
end;

procedure Tisbl_debugger.menu_messagesClick(Sender: TObject);
begin
  if    not dock_variables_list.Visible
    and not dock_log.Visible
  then
  begin
    dock_log.Visible := true;
    dock_log.ManualDock( JvDockServer.RightDockPanel );
  end;

  if dock_variables_list.Visible and  not dock_log.Visible then
    ManualConjoinDock(JvDockServer.RightDockPanel, dock_log, dock_variables_list );
end;

procedure Tisbl_debugger.menu_treeClick(Sender: TObject);
begin

  if    not dock_isbl_tree.Visible
    and not dock_steps_form.Visible
  then
  begin
    dock_isbl_tree.Visible := true;
    dock_isbl_tree.ManualDock( JvDockServer.LeftDockPanel );
  end;

  if not dock_isbl_tree.Visible and dock_steps_form.Visible then
    ManualConjoinDock(JvDockServer.LeftDockPanel, dock_steps_form, dock_isbl_tree );

end;

procedure Tisbl_debugger.on_actionClick(Sender: TObject);
begin
  on_off_state := on_action.Checked;
  if not on_off_state then
  begin
    trace_action.Checked         := false;
    isbl_debugger.on_hold        := trace_action.Checked;
    hold_this_line               := trace_action.Checked;
    step_action.Enabled          := trace_action.Checked;
    menu_step.Enabled            := trace_action.Checked;
  end;
{
  if not on_off_state then
    comserver.
    }
end;

procedure Tisbl_debugger.step_actionClick(Sender: TObject);
begin
  if Assigned( isbl_debugger.current_node ) then
  begin
    dock_isbl_tree.tree.FocusedNode := dock_isbl_tree.SeekNodeByInterpreterID( isbl_debugger.last_interpreterID );
    dock_isbl_tree.tree.Selected[ dock_isbl_tree.tree.FocusedNode  ] := true;
  end;

  stop_line      := last_rendered_line;
  hold_this_line := false;
end;

procedure Tisbl_debugger.trace_actionExecute(Sender: TObject);
begin
  if trace_action.Checked then
    SetOnHold()
  else
    SetOffHold();

  isbl_text.Repaint;
end;

procedure Tisbl_debugger.tb_testClick(Sender: TObject);
var
  bool : boolean;
begin
 bool := ComServerInstalled('{9337CC4E-E520-4BEA-A3D7-8F2EC229593F}');
 bool := ComServerInstalled('9337CC4E-E520-4BEA-A3D7-8F2EC229593F');
end;

procedure Tisbl_debugger.timer_hide_statusTimer(Sender: TObject);
begin
  MarqueeProgressBar1.Visible      := false;
  group_background_working.Visible := false;
  Timer_hide_status.Enabled        := false;
end;

procedure Tisbl_debugger.timer_memoryTimer(Sender: TObject);
 var
   pmc  : PPROCESS_MEMORY_COUNTERS;
   cb   : Integer;
   text : string;
   size : integer;
 begin
   cb := SizeOf(_PROCESS_MEMORY_COUNTERS);
   GetMem(pmc, cb);
   pmc^.cb := cb;

   if GetProcessMemoryInfo( GetCurrentProcess(), pmc, cb ) then
   begin
     size                  := pmc^.WorkingSetSize;
     text                  := FormatCurr( 'Память: #,# Байт', size );
     status.Panels[1].Text := text;
   end
   else
     status.Panels[1].Text := 'Unable to retrieve memory usage structure';

   FreeMem(pmc);
 end;

procedure Tisbl_debugger.tb_extClick(Sender: TObject);
begin
  SetOffHold();
  main.window.Close;
end;

procedure Tisbl_debugger.tb_firstClick(Sender: TObject);
var
  node : PVirtualNode;
  data : PVSTDebugObject;
begin
  node := first_object_node;
  if assigned( node ) then
  begin
    data  := dock_isbl_tree.tree.GetNodeData( node );
    dock_isbl_tree.tree.FocusedNode := node;
    dock_isbl_tree.tree.Selected[node] := true;
    isbl_text.GotoLineAndCenter( data.line_number );
    isbl_text.OnClick(isbl_text);
  end;
end;

procedure Tisbl_debugger.tb_gotoendClick(Sender: TObject);
begin
  last_lastline_lastscript.Click;
end;

procedure Tisbl_debugger.tb_step_over_buttonClick(Sender: TObject);
var
  node : PVirtualNode;
  data : PVSTDebugObject;
begin
  node               := dock_isbl_tree.tree.FocusedNode;
  if Assigned( node ) then
    data := dock_isbl_tree.tree.GetNodeData( node );
  if assigned( data ) then
  begin
    step_over_parentID := data.interpreterID;
    stepping_over := true;
    SetOffHold();
  end;

end;

procedure Tisbl_debugger.ontop_buttonClick(Sender: TObject);
begin
  if ( Sender as TToolButton ).Down then
  begin
    SetWindowLong(Self.Handle, GWL_HWNDPARENT, GetDesktopWindow);
    SetWindowPos(Self.Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE   or SWP_NOSIZE);
  end
  else
  begin
    SetWindowLong(Self.Handle, GWL_HWNDPARENT, main.window.Handle);
    SetWindowPos(Self.Handle, HWND_NOTOPMOST, 0, 0, 0, 0, SWP_NOMOVE   or SWP_NOSIZE);
  end;
end;

procedure Tisbl_debugger.step_over_actionExecute(Sender: TObject);
var
  node : PVirtualNode;
  data : PVSTDebugObject;
begin
  node               := dock_isbl_tree.tree.FocusedNode;
  if Assigned( node ) then
    data := dock_isbl_tree.tree.GetNodeData( node );

  if assigned( data ) then
  begin
    step_over_parentID := data.interpreterID;
    stepping_over := true;
    SetOffHold();
  end;
end;

procedure Tisbl_debugger.first_actionExecute(Sender: TObject);
var
  node : PVirtualNode;
  data : PVSTDebugObject;
begin
  node := first_object_node;
  if assigned( node ) then
  begin
    data  := dock_isbl_tree.tree.GetNodeData( node );
    dock_isbl_tree.tree.FocusedNode := node;
    dock_isbl_tree.tree.Selected[node] := true;
    isbl_text.GotoLineAndCenter( data.line_number );
    isbl_text.OnClick(isbl_text);
  end;
end;

procedure SetTopMost( handle: HWND );
begin
  SetWindowPos(  handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE   or SWP_NOSIZE);
end;

procedure SetNotTopMost( handle: HWND  );
begin
  SetWindowPos(  handle, HWND_NOTOPMOST, 0, 0, 0, 0, SWP_NOMOVE   or SWP_NOSIZE);
end;

procedure Tisbl_debugger.ontop_actionExecute(Sender: TObject);
begin
  //Установить поверх
  if ( Sender as TAction ).Checked then
  begin
    SetTopMost( Self.Handle );
//    SetTopMost( text_form.handle );
  end
  else
  //Установить обычный режим
  begin
    SetNotTopMost( Self.Handle );
//    SetNotTopMost( text_form.handle  );
  end;
end;

procedure Tisbl_debugger.editor_panelResize(Sender: TObject);
begin
  group_background_working.Left := round(editor_panel.Width/2) - round(group_background_working.Width/2);
  group_background_working.Top  := Round(editor_panel.Height/2) - round(group_background_working.Height/2);
end;

procedure Tisbl_debugger.exit_actionExecute(Sender: TObject);
begin
  SetOffHold();
  //main.window.Close;
  close;
end;

procedure Tisbl_debugger.last_actionExecute(Sender: TObject);
begin
  last_lastline_lastscript.Click;
end;

procedure Tisbl_debugger.A1Click(Sender: TObject);
begin
  window.sSkinManager.Active := not window.sSkinManager.Active;
end;

procedure Tisbl_debugger.action_runExecute(Sender: TObject);
begin
  SetOffHold();
end;

procedure Tisbl_debugger.Button1Click(Sender: TObject);
begin
  ImageList.Draw( isbl_text.Canvas, 10, 10, 2 );
end;

function Tisbl_debugger.CheckConnection: boolean;
begin
  if not connection_options_form.sqlconnection.Connected then
  begin
    connection_options_form.ShowModal();
  end;
  Result := connection_options_form.sqlconnection.Connected;
end;

procedure Tisbl_debugger.clear_actionExecute(Sender: TObject);
begin
  try
    dock_variables_list.variable_tree.Clear;
    dock_steps_form.steps_tree.Clear;
    objects_list.Clear;
    code_cache.Clear;
    dock_isbl_tree.ClearDebugHistory();

    script_name.Caption                   := 'Название обработки: пусто';
    current_node_data                     := nil;
    current_node                          := nil;
    isbl_debugger.counter_started_scripts := 0;
    isbl_debugger.counter_rendered_lines  := 0;
  except
    ON E:Exception do DebugMessageAndShow( e.Message );
  end;
end;

procedure Tisbl_debugger.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  CloseHandle(FDebuggerMutex);
end;

procedure Tisbl_debugger.isbl_dev_editProcessCommand(Sender: TObject; var
    Command: TSynEditorCommand; var AChar: Char; Data: Pointer);
var
   apoint,temppoint : TPoint;
   displayCoord     : TDisplayCoord;
   schema_tablename : string;
begin
//   if achar = '.' then
//    begin
//       schema_tablename := isbl_dev_edit.GetWordAtRowCol( isbl_dev_edit.CaretXY );
//       temppoint.y      := isbl_dev_edit.CaretY;
//       temppoint.x      := isbl_dev_edit.CaretX;
//
//       temppoint.y         := temppoint.y + 1;
//       displayCoord.Column := temppoint.Y;
//       displayCoord.Row    := temppoint.X;
//       apoint              := isbl_dev_edit.ClientToScreen( isbl_dev_edit.RowColumnToPixels( displayCoord ) );
//       SynCompletionProposal.Execute('',apoint.X, apoint.Y);
//    end;
end;

procedure Tisbl_debugger.N19Click(Sender: TObject);
begin
  connection_options_form.Show();
end;

procedure Tisbl_debugger.N9Click(Sender: TObject);
var
  ConnectionParams : string;
  результатСценария: variant;
  сообщение        : Integer;
begin
  ConnectionParams    := 'ServerName=%s;DBName=%s;UserName=%s;Password=%s';
  ConnectionParams    := Format( ConnectionParams, ['windowsxpsp3','directum','sa','openforme'] );
  directumLoginPoint  := CreateOleObject( 'SBLogon.LoginPoint' ); //  ILoginPoint
  DirectumApplication := directumLoginPoint.GetApplication( ConnectionParams ); // IApplication
  результатСценария   := DirectumApplication.ScriptFactory.ExecuteByName('лМастерская');
end;

procedure Tisbl_debugger.ISBLPagesControlChange(Sender: TObject);
begin
//  if ISBLPagesControl.ActivePage = debugSheet then
//    devToolbar.Visible := false
//  else
//    devToolbar.Visible := true;

end;

procedure Tisbl_debugger.prepareProposals;
var
  prettyString: string;
begin
  SynCompletionProposal.ItemList.Clear;
  SynCompletionProposal.InsertList.Clear;

  addNewImportantVariableProposal(SynCompletionProposal,'References');
  addNewImportantVariableProposal(SynCompletionProposal,'EDocuments');
  addNewImportantVariableProposal(SynCompletionProposal,'ServiceFactory');
  addNewImportantVariableProposal(SynCompletionProposal,'Application');
  addNewImportantVariableProposal(SynCompletionProposal,'Scripts');

  addNewVariableProposal(SynCompletionProposal,'Scripts');

end;



procedure Tisbl_debugger.ToggleDebuggerState;
begin
  on_off_state := on_action.Checked;
  if not on_off_state then
  begin
    trace_action.Checked  := False;
    isbl_debugger.on_hold := trace_action.Checked;
    hold_this_line        := trace_action.Checked;
    step_action.Enabled   := trace_action.Checked;
    menu_step.Enabled     := trace_action.Checked;
  end;

  if on_off_state then
     FDebuggerMutex := CreateMutex(nil, True, 'ISB 7.0 Debugger Mutex')
  else
     CloseHandle( FDebuggerMutex );

end;

procedure Tisbl_debugger.ToolButton1Click(Sender: TObject);
var
  результатСценария: Variant;
begin
  результатСценария   := DirectumApplication.ScriptFactory.ExecuteByName( ScriptName );
end;

procedure Tisbl_debugger.ToolButton2Click(Sender: TObject);
var
  query: TSQLQuery;
  text : string;
begin
  if CheckConnection then
  begin
    query          := connection_options_form.SQLQuery;
    query.SQL.Text := Format( 'UPDATE MBReports Set Report = ''%s'' FROM MBReports WHERE NameRpt = ''%s'' ', [isbl_dev_edit.Text,ScriptName] );
    query.ExecSQL();
  end;
end;

procedure Tisbl_debugger.ToolButton3Click(Sender: TObject);
var
  query: TSQLQuery;
  text : string;
begin
  if CheckConnection then
  begin
    query          := connection_options_form.SQLQuery;
    query.SQL.Text := Format( 'SELECT Report,Exprn FROM MBReports WHERE NameRpt = ''%s'' ', [ScriptName] );
    query.Open();
    while not query.eof do
    begin
      text := query.FieldByName('Report').AsString;
      isbl_dev_edit.Text := text;
      query.Next();
    end;
  end;
end;

procedure Tisbl_debugger.ToolButton4Click(Sender: TObject);
var
  query: TSQLQuery;
begin
  if CheckConnection then
  begin
    query          := connection_options_form.SQLQuery;
    query.SQL.Text := Format( 'SELECT Report,Exprn FROM MBReports WHERE NameRpt = ''%s'' ', [ScriptName] );
    query.Open();
    while not query.eof do
    begin
      text := query.FieldByName('Report').AsString;
      isbl_dev_edit.Text := text;
      query.Next();
    end;
  end;
end;

procedure Tisbl_debugger.WMSysCommand;
begin

  if Msg.CmdType = SC_MINIMIZE then
  begin
    display_how_debug_goes_previous := display_how_debug_goes;
    display_how_debug_goes          := false;
    was_minimized                   := true;
    Application.Minimize;
  end;

  if Msg.CmdType = SC_RESTORE then
  begin
    display_how_debug_goes           := display_how_debug_goes_previous;
    group_background_working.Visible := not display_how_debug_goes;
    was_minimized                    := false;
  end;

  inherited; // обрабатывать далее по-умолчанию
end;

initialization
 // ReportMemoryLeaksOnShutdown := True;

end.