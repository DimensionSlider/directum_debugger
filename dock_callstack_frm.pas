unit dock_callstack_frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, DockPAnel, StdCtrls, SynEdit, ExtCtrls, JvComponentBase, 
  JvDockControlForm, sPanel;

type
  Tdock_isbl_callstack = class(TDockableForm)
    stack_text: TSynEdit;
    Panel1: TsPanel;
    underpanel: TsPanel;
    JvDockClient1: TJvDockClient;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dock_isbl_callstack: Tdock_isbl_callstack;

implementation
  uses isbl_debugger_frm;

{$R *.dfm}

end.