unit ThreadForScan;

interface

uses
  Classes, Windows, SysUtils, idGlobal, thread_log_worker;

type
  TScanThread = class(TThread)
  private
  
    Dir : string;
    SubDirs : Boolean;
    EventLog : string;
    procedure AddEvent;
  protected
    procedure Execute; override;

  public
    constructor Create(CreateSuspended : Boolean; const _Dir : string; _SubDirs : Boolean);
  end;

implementation

constructor TScanThread.Create;
begin
  inherited Create(CreateSuspended);
  Dir := _Dir;
  SubDirs := _SubDirs;
end;

procedure TScanThread.AddEvent;
begin
//  Log.Log( eventlog );
end;

procedure TScanThread.Execute;
type
  FILE_NOTIFY_INFORMATION = record
    NextEntryOffset: DWORD;
    Action: DWORD;
    FileNameLength: DWORD;
    FileName: array [0..0] of WCHAR;
  end;
var
  hDir     : THandle;
  Buf      : pointer;
  Returned : DWORD;
  BufSize  : dword;
  adr      : DWORD;
  file_notify_changes      : ^FILE_NOTIFY_INFORMATION absolute adr;
  s        : string;
  ws       : WideString;
  ext      : string;
  worker : log_worker;

const
  wcs = SizeOf( WideChar ); // = 2
  FILE_LIST_DIRECTORY       = ( $0001 ); // directory

begin
  hDir := CreateFile( PChar( Dir ),
                     FILE_LIST_DIRECTORY,
                     FILE_SHARE_READ or FILE_SHARE_DELETE,
                     nil,
                     OPEN_EXISTING,
                     FILE_FLAG_BACKUP_SEMANTICS,
                     0 );

  if hDir = INVALID_HANDLE_VALUE then
    Exit;

  BufSize := 16*1024*1024; // 16 метров - так навсякий пожарный :)

  GetMem(Buf, BufSize);

  repeat

    if ReadDirectoryChangesW( hDir, Buf, BufSize, SubDirs,
       FILE_NOTIFY_CHANGE_FILE_NAME or
       FILE_NOTIFY_CHANGE_DIR_NAME or
       FILE_NOTIFY_CHANGE_ATTRIBUTES or
       FILE_NOTIFY_CHANGE_SIZE or
       FILE_NOTIFY_CHANGE_LAST_WRITE or
       FILE_NOTIFY_CHANGE_LAST_ACCESS or
       FILE_NOTIFY_CHANGE_CREATION or
       FILE_NOTIFY_CHANGE_SECURITY, @Returned, nil, nil) then
    begin
      Adr := Cardinal(Buf);
      while Adr < (Cardinal(Buf) + Returned) do
      begin

        case file_notify_changes^.Action of
          FILE_ACTION_ADDED            : s := 'Добавлен';
          FILE_ACTION_REMOVED          : s := 'Удален';
          FILE_ACTION_MODIFIED         : s := 'Изменен';
          FILE_ACTION_RENAMED_OLD_NAME : s := 'Переименован ИЗ';
          FILE_ACTION_RENAMED_NEW_NAME : s := 'Переименован В';
          else s := '0x' + IntToHex( file_notify_changes^.Action, 8 );
        end;

        if ( file_notify_changes^.Action = FILE_ACTION_ADDED ) or ( file_notify_changes^.Action = FILE_ACTION_MODIFIED ) then
        begin
          SetLength( ws, file_notify_changes^.FileNameLength div wcs );
          Move( file_notify_changes^.FileName, ws[1], file_notify_changes^.FileNameLength );
          EventLog := s + ' "' + ws + '"';
          //Log.Log( EventLog );
          ext := ExtractFileExt( ws );
          {
          if ext = the_extension then
          begin
            source_file := PWideChar( source_folder + ws );
            dest_file   := PWideChar( dest_folder + ws );
            CaptureMonitor.MoveEvent();
          end;
          }
          worker := log_worker.Create(False);
          worker.Priority := tpNormal;
          worker.FreeOnTerminate := true;
        end;
        {AddEvent();}
        Inc(adr, file_notify_changes^.FileNameLength - wcs + SizeOf(file_notify_changes^));
      end;
    end;
  until
    False;

  CloseHandle( hDir );
  FreeMem( Buf );

end;

end.
