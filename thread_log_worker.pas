unit thread_log_worker;

interface

uses
  Classes, VirtualTrees, SysUtils;

type
  log_worker = class(TThread)
  private
    { Private declarations }
  protected
    procedure Execute; override;
    procedure AddNodeToTree();
    procedure RefreshLogTree();
  end;

type
  PVSTLog = ^TVSTLog;
  TVSTLog = record
    full_string:string;
    time : string;
    date : string;
    user : string;
    code : string;
    text : string;
    system : string;
    callstack : string;
  end;

var
  node : PVirtualNode;
  data : PVSTLog;

implementation

{ 
  Important: Methods and properties of objects in visual components can only be
  used in a method called using Synchronize, for example,

      Synchronize(UpdateCaption);  

  and UpdateCaption could look like,

    procedure log_worker.UpdateCaption;
    begin
      Form1.Caption := 'Updated in a thread';
    end; 
    
    or 
    
    Synchronize( 
      procedure 
      begin
        Form1.Caption := 'Updated in thread via an anonymous method' 
      end
      )
    );
    
  where an anonymous method is passed.

  Similarly, the developer can call the Queue method with similar parameters as 
  above, instead passing another TThread class as the first parameter, putting
  the calling thread in a queue with the other thread.
    
}

{ log_worker }
uses dock_log_frm, routine_debug, routine_strings;

procedure log_worker.Execute;
var
  line : string;
  param : string;
  text_and_callstack : string;
  line_count:integer;
  last_time : TTime;
begin
try
  if FileExists( sbrte_path ) then
  begin
    try
      line_count := 0;
      Reset(my_sbrtelog_file);
      while not eof(my_sbrtelog_file) do
      begin
        Readln(my_sbrtelog_file, Line);
        line_count := line_count + 1;
      end;
    except
    on E : Exception do
      begin
        DebugMessage('log_worker.Execute: Необработанное исключение. Код(1) ' + e.Message );
        ShowDebug();
      end;
    end;

    if last_log_line <> -1 then    
    if line_count > last_log_line then
    begin
      Synchronize( AddNodeToTree );
      data.date           := SubString( line, #9, 1 );
      data.time           := SubString( line, #9, 2 );
      data.system         := SubString( line, #9, 4 );
      data.user           := SubString( line, #9, 5 );
      data.code           := SubString( line, #9, 7 );
      text_and_callstack  := SubString( line, #9, 8 );
      data.text           := SubString( text_and_callstack, '<-', 1 );
      data.callstack      := SubString( text_and_callstack,  data.text, 2 );
      Synchronize( RefreshLogTree );
    end;

    last_log_line := line_count;
    CloseFile( my_sbrtelog_file );
  end;

except
    on E : Exception do
    begin
      CloseFile( my_sbrtelog_file );
      DebugMessage(' Tdock_log.ToolButton1Click: Необработанное исключение. ' + e.Message );
      ShowDebug();
    end;
end;

end;

procedure log_worker.AddNodeToTree();
begin
  node := dock_log.log_tree.AddChild( nil );
  data := dock_log.log_tree.GetNodeData( node );
end;

procedure log_worker.RefreshLogTree();
begin
  dock_log.log_tree.Selected[ node ] := True;
  dock_log.log_tree.Refresh;
end;


end.
