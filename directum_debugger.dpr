program directum_debugger;

uses
  FastMM4 in 'FastMM4.pas',
  ExceptionLog,
  Forms,
  Windows,
  SysUtils,
  IniFiles,
  ComServ,
  isbl_debugger_frm in 'isbl_debugger_frm.pas' {isbl_debugger},
  connection_options in 'connection_options.pas' {connection_options_form},
  routine_strings in 'routine_strings.pas',
  routine_api in 'routine_api.pas',
  routine_directum_specific in 'routine_directum_specific.pas',
  debug_form in 'debug_form.pas' {debug_window},
  IPCThrd in 'IPCThrd.pas',
  uProcessMemMgr in 'uProcessMemMgr.pas',
  options_frm in 'options_frm.pas' {options_form},
  routine_db in 'routine_db.pas',
  routine_debug in 'routine_debug.pas',
  progress_bar_unit in 'progress_bar_unit.pas' {progress_bar_form},
  compare_unit in 'compare_unit.pas' {compare_form},
  msi_unit in 'msi_unit.pas' {msi_form},
  text_unit in 'text_unit.pas' {text_form},
  virtual_tree_routine in 'virtual_tree_routine.pas',
  debugger in 'debugger.pas' {Debugger: CoClass},
  dock_callstack_frm in 'dock_callstack_frm.pas' {dock_isbl_callstack},
  dock_ignore_list in 'dock_ignore_list.pas' {dock_isbl_ignorelist},
  dock_breaks in 'dock_breaks.pas' {dock_steps_form},
  dock_isbl_tree_unit in 'dock_isbl_tree_unit.pas' {dock_isbl_tree},
  variable_table_unit in 'variable_table_unit.pas',
  main in 'main.pas' {window},
  scripts_frm in 'scripts_frm.pas' {dock_scripts},
  dock_log_frm in 'dock_log_frm.pas' {dock_log},
  thread_log_worker in 'thread_log_worker.pas',
  assistant_options_frm in 'assistant_options_frm.pas' {dock_assistant_options},
  log_message_frm in 'log_message_frm.pas' {log_message_form},
  debug_worker_thread in 'debug_worker_thread.pas',
  frm_nonvisual in 'frm_nonvisual.pas' {nonvisual},
  directum_metadata in 'directum_metadata.pas',
  dock_variables_list_frm in 'dock_variables_list_frm.pas' {dock_variables_list},
  directum_debugger_TLB in 'directum_debugger_TLB.pas',
  frm_about in 'frm_about.pas' {form_about},
  ThreadForScan in 'ThreadForScan.pas',
  trace in 'trace.pas',
  dlg_goto in 'dlg_goto.pas' {dialog_goto},
  routine_synedit in '..\directum_common\routine_synedit.pas',
  isbl_syntax_high in '..\directum_common\isbl_syntax_high.pas';

{$R *.TLB}

{$R *.res}

procedure OnShutdown();
begin
  isbl_debugger.OnShutdown;
end;

procedure RegServer();
begin
  if paramstr( 1 ) = '/regserver' then
    ComServer.UpdateRegistry( true );
  exit();

end;

procedure OnRun();
begin
  connection_options_form.OnRun;
  isbl_debugger.OnRun;
  dock_variables_list.OnRun();
  dock_isbl_tree.OnRun();
  window.OnRun;

  process_file_name := ExtractFileName( paramstr(0) );
  work_dir          := ExtractFileDir( paramstr(0) );
  configuration     := TINIFile.Create( work_dir + '\' + process_file_name + '.ini' );

//  window.sSkinManager.Active := true;
end;

begin
  RegServer();
  Application.Initialize;
  Application.Title := 'Волшебный отладчик DIRECTUM';
  Application.CreateForm(Tisbl_debugger, isbl_debugger);
  Application.CreateForm(Twindow, window);
  Application.CreateForm(Tdock_isbl_tree, dock_isbl_tree);
  Application.CreateForm(Tdock_steps_form, dock_steps_form);
  Application.CreateForm(Tdock_isbl_ignorelist, dock_isbl_ignorelist);
  Application.CreateForm(Tdock_isbl_callstack, dock_isbl_callstack);
  Application.CreateForm(Tconnection_options_form, connection_options_form);
  Application.CreateForm(Tdebug_window, debug_window);
  Application.CreateForm(Toptions_form, options_form);
  Application.CreateForm(Tprogress_bar_form, progress_bar_form);
  Application.CreateForm(Tcompare_form, compare_form);
  Application.CreateForm(Tmsi_form, msi_form);
  Application.CreateForm(Ttext_form, text_form);
  Application.CreateForm(Tdock_scripts, dock_scripts);
  Application.CreateForm(Tdock_log, dock_log);
  Application.CreateForm(Tdock_assistant_options, dock_assistant_options);
  Application.CreateForm(Tlog_message_form, log_message_form);
  Application.CreateForm(Tnonvisual, nonvisual);
  Application.CreateForm(Tdock_variables_list, dock_variables_list);
  Application.CreateForm(Tform_about, form_about);
  Application.CreateForm(Tdialog_goto, dialog_goto);
  //Уже после создания всех форм


  OnRun();

  //Рантайм
  Application.Run;
  OnShutdown();
  //После смерти приложения
  //...
end.
