unit routine_api;

interface

  uses ShellAPI, Windows, Messages, Forms, Controls, Classes, RichEdit, Menus, CommCtrl, uProcessMemMgr, SysUtils, Dialogs,

  routine_strings ;

    procedure OpenUrl(url:string);
    function GetOtherWindowMemoText(const sCaption : String) : WideString;
    function ReadComputerName:string;
    function GetWindText(window_handle: THandle): String;
    function SetWindText(window_handle: THandle): String;

    function GetSelText(handle_editor_memo: THandle): String;
    function GetWindowClassName( window_handle:THandle ):string;
    function GetStatusBarText(hStatusBarHandle: HWND; PanelNumber: Integer): string;


    procedure ShortCutToHotKey(HotKey: TShortCut; var Key : Word; var Modifiers: Uint);
    function GetOwnerWindowTitle( child_handle:THandle ):string;

const
  CNT_LAYOUT = 2; // количество известных раскладок
  ENGLISH    = $409;
  RUSSIAN    = $419;

  TKbdValue : array [ 1..CNT_LAYOUT ] of LongWord =
                ( ENGLISH,
                  RUSSIAN
                );
  TKbdDisplayNames : array [ 1..CNT_LAYOUT ] of string =
                ('English',
                 'Русский'
                );

type hex = string[8];

implementation


uses routine_debug, assistant_options_frm;



function dec2hex(value: dword): string;
const
  hexdigit = '0123456789ABCDEF';
begin
  Result := '';
  while value > 0 do
  begin
    Result := hexdigit[succ(value and $F)] + Result;
    value := value shr 4;
  end;
  if Result = '' then Result := '0';
end;            

procedure ShortCutToHotKey(HotKey: TShortCut; var Key : Word; var Modifiers: Uint);
var
  Shift: TShiftState;
begin
  ShortCutToKey(HotKey, Key, Shift);
  Modifiers := 0;
  if (ssShift in Shift) then
  Modifiers := Modifiers or MOD_SHIFT;
  if (ssAlt in Shift) then
  Modifiers := Modifiers or MOD_ALT;
  if (ssCtrl in Shift) then
  Modifiers := Modifiers or MOD_CONTROL;
end;  

//по сути просто дублирование проверки, сохранение хендла в общедоступной переменной и установка служебных флагов
{
procedure ConnectToEditor( possible_window:HWND );
var
  editor_component : HWND;
begin
  if possible_window = 0 then exit;
    
  editor_component := possible_window;
  editor_component := FindWindowEx(editor_component, 0, 'TSLSynEdit', nil);
    
  if editor_component <> 0 then
  begin
    handle_editor_window  := possible_window;
    handle_editor_memo    := editor_component;
    if handle_editor_memo <> 0 then
    begin     
      is_connected_to_editor := true;
    end
    else
    begin
      is_connected_to_editor := false;
    end;
  end;

end;
}

function GetWindowClassName( window_handle:THandle ):string;
var
    class_name: array [0..255] of char;
begin
  if isWindow( window_handle ) then
    GetClassName(
       window_handle,
       class_name,
       Pred(SizeOf(class_name))
    )
  else
  class_name := '';

  result := String( class_name );
end;

function GetOwnerWindowTitle( child_handle:THandle ):string;
var
  parent_handle : THandle;
  parent_window_title:array[0..255] of Char;
  title:string;
begin
  title := '';

  parent_handle := GetWindow( child_handle, GW_OWNER );
  if parent_handle <> 0 then
  begin
    GetWindowText(parent_handle, parent_window_title, SizeOf(parent_window_title));
    title := string( parent_window_title );
  end;
  
  result := title;

end;

//    memo1.Text := GetWindText(editor_window_handle);

function SetWindText(window_handle: THandle): String;
var
    cb : DWord;
begin
  {
    cb := memo1.Lines.Count;
    SetLength(Result, cb);
    if cb > 0 then
        SendMessage(editor_synedit_handle, WM_SETTEXT, cb+1, LParam(memo1.Text));

}        
end;

function GetWindText(window_handle: THandle): String;
var
    cb : DWord;
begin
    cb := SendMessage(window_handle, WM_GETTEXTLENGTH, 0, 0);
    SetLength(Result, cb);
    if cb > 0 then
        SendMessage(window_handle, WM_GETTEXT , cb+1, LParam(@Result[1]));

end;

Function GetOtherWindowMemoText(const sCaption : String) : WideString;
var
         hWindow : THandle;
         hChild  : THandle;

         aTemp      : array[0..5000] of Char;
         sClassName : String;
begin
         Result := '';

         hWindow := FindWindow(Nil,PChar(sCaption));

         if hWindow = 0 then begin
            ShowMessage('НЕ МОГУ найти программу');
            exit;
         end;

         hChild := GetWindow(hWindow, GW_CHILD);
         while hChild <> 0 do Begin
               if GetClassName(hChild, aTemp, SizeOf(aTemp)) > 0 then begin
                  sClassName := StrPAS(aTemp);

                  if sClassName = 'Edit' then begin
                     SendMessage(hChild,WM_GETTEXT,SizeOf(aTemp),Integer(@aTemp));

                     Result := StrPAS(aTemp);
                  end;
               end;
               hChild := GetWindow(hChild, GW_HWNDNEXT);
         end;
end;

Function GetOtherWindowText(const sCaption : String) : WideString;
var
         hWindow : THandle;
         hChild  : THandle;

         aTemp      : array[0..5000] of Char;
         sClassName : String;
begin
         Result := '';
         hWindow := FindWindow(Nil,PChar(sCaption));
         if hWindow = 0 then begin
            ShowMessage('НЕ МОГУ найти программу');
            exit;
         end;

         hChild := GetWindow(hWindow, GW_CHILD);

         while hChild <> 0 do Begin
               if GetClassName(hChild, aTemp, SizeOf(aTemp)) > 0 then begin
                  sClassName := StrPAS(aTemp);

                  if sClassName = 'Edit' then begin
                     SendMessage(hChild,WM_GETTEXT,SizeOf(aTemp),Integer(@aTemp));

                     Result := StrPAS(aTemp);
                  end;
               end;
               hChild := GetWindow(hChild, GW_HWNDNEXT);
         end;
end;


function GetStatusBarText(hStatusBarHandle: HWND; PanelNumber: Integer): string;
var
  PMM: TProcessMemMgr;
  NumberOfPanels, Len: Integer;
  PrcBuf: PChar;
  PartText: string;
begin
  if hStatusBarHandle = 0 then Exit;
  PMM := CreateProcessMemMgrForWnd(hStatusBarHandle);
  try
    NumberOfPanels := SendMessage(hStatusBarHandle, SB_GETPARTS, 0, 0);
    if PanelNumber < NumberOfPanels then
    begin
      Len := LOWORD(SendMessage(hStatusBarHandle, SB_GETTEXTLENGTH, PanelNumber, 0));
      if Len > 0 then
      begin
        PrcBuf := PMM.AllocMem(Len + 1);
        SendMessage(hStatusBarHandle, SB_GETTEXT, PanelNumber, Longint(PrcBuf));
        Result := PMM.ReadStr(PrcBuf);
        PMM.FreeMem(PrcBuf);
      end
      else
      begin
        Result := '';
      end;
    end;
  finally
    PMM.Free;
  end;
end;

function GetSelText(handle_editor_memo: THandle): String;
var
    cb : DWord;
begin                                    
 //   cb := SendMessage(editor_synedit_handle, WM_GETTEXTLENGTH, 0, 0);
//    SetLength(Result, cb);
//    if cb > 0 then
//        SendMessage(editor_synedit_handle, WM_, cb+1, LParam(@Result[1]));
end;

function NameKeyboardLayout(layout : LongWord) : string;
var
  i: integer;
begin
  Result:='';
  try
    for i:=1 to CNT_LAYOUT do
      if TKbdValue[i]=layout then Result:= TKbdDisplayNames[i];
  except
    Result:='';
  end;
end;


procedure OpenUrl(url:string);
begin
  ShellExecute(0, 'open', PChar(url), nil, nil, SW_SHOW);
end;

//получить имя компьютера
function ReadComputerName:string;
var
	i:DWORD;  
	p:PChar;       	
begin
	i:=255; 
	GetMem(p, i); 
	GetComputerName(p, i); 
	Result:=String(p); 
	FreeMem(p);  	
end;

//не используется
 procedure PostKeyExHWND(hWindow: HWnd; key: Word; const shift: TShiftState;
   specialkey: Boolean);
 {************************************************************ 
 * Procedure PostKeyEx 
 *
 * Parameters: 
 *  hWindow: target window to be send the keystroke 
 *  key    : virtual keycode of the key to send. For printable
 *           keys this is simply the ANSI code (Ord(character)). 
 *  shift  : state of the modifier keys. This is a set, so you 
 *           can set several of these keys (shift, control, alt, 
 *           mouse buttons) in tandem. The TShiftState type is 
 *           declared in the Classes Unit. 
 *  specialkey: normally this should be False. Set it to True to 
 *           specify a key on the numeric keypad, for example. 
 *           If this parameter is true, bit 24 of the lparam for
 *           the posted WM_KEY* messages will be set.
 * Description:
 *  This procedure sets up Windows key state array to correctly
 *  reflect the requested pattern of modifier keys and then posts
 *  a WM_KEYDOWN/WM_KEYUP message pair to the target window. Then
 *  Application.ProcessMessages is called to process the messages
 *  before the keyboard state is restored.
 * Error Conditions:
 *  May fail due to lack of memory for the two key state buffers.
 *  Will raise an exception in this case.
 * NOTE:
 *  Setting the keyboard state will not work across applications
 *  running in different memory spaces on Win32 unless AttachThreadInput
 *  is used to connect to the target thread first.
 *Created: 02/21/96 16:39:00 by P. Below
 ************************************************************}

 type
   TBuffers = array [0..1] of TKeyboardState;
 var
   pKeyBuffers: ^TBuffers;
   lParam: LongInt;
 begin
   (* check if the target window exists *)
   if IsWindow(hWindow) then
   begin
     (* set local variables to default values *)
     pKeyBuffers := nil;
     lParam := MakeLong(0, MapVirtualKey(key, 0));

     (* modify lparam if special key requested *)
     if specialkey then
       lParam := lParam or $1000000;

     (* allocate space for the key state buffers *)
     New(pKeyBuffers);
     try
       (* Fill buffer 1 with current state so we can later restore it.
          Null out buffer 0 to get a "no key pressed" state. *)
       GetKeyboardState(pKeyBuffers^[1]);
       FillChar(pKeyBuffers^[0], SizeOf(TKeyboardState), 0);

       (* set the requested modifier keys to "down" state in the buffer*)
       if ssShift in shift then
         pKeyBuffers^[0][VK_SHIFT] := $80;
       if ssAlt in shift then
       begin
         (* Alt needs special treatment since a bit in lparam needs also be set *)
         pKeyBuffers^[0][VK_MENU] := $80;
         lParam := lParam or $20000000;
       end;
       if ssCtrl in shift then
         pKeyBuffers^[0][VK_CONTROL] := $80;
       if ssLeft in shift then
         pKeyBuffers^[0][VK_LBUTTON] := $80;
       if ssRight in shift then
         pKeyBuffers^[0][VK_RBUTTON] := $80;
       if ssMiddle in shift then
         pKeyBuffers^[0][VK_MBUTTON] := $80;

       (* make out new key state array the active key state map *)
       SetKeyboardState(pKeyBuffers^[0]);
       (* post the key messages *)
       if ssAlt in Shift then
       begin
         PostMessage(hWindow, WM_SYSKEYDOWN, key, lParam);
         PostMessage(hWindow, WM_SYSKEYUP, key, lParam or $C0000000);
       end
       else
       begin
         PostMessage(hWindow, WM_KEYDOWN, key, lParam);
         PostMessage(hWindow, WM_KEYUP, key, lParam or $C0000000);
       end;
       (* process the messages *)
       Application.ProcessMessages;

       (* restore the old key state map *)
       SetKeyboardState(pKeyBuffers^[1]);
     finally
       (* free the memory for the key state buffers *)
       if pKeyBuffers <> nil then
         Dispose(pKeyBuffers);
     end; { If }
   end;
 end; { PostKeyEx }

end.
