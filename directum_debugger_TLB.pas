unit directum_debugger_TLB;

// ************************************************************************ //
// WARNING
// -------
// The types declared in this file were generated from data read from a
// Type Library. If this type library is explicitly or indirectly (via
// another type library referring to this type library) re-imported, or the
// 'Refresh' command of the Type Library Editor activated while editing the
// Type Library, the contents of this file will be regenerated and all
// manual modifications will be lost.
// ************************************************************************ //

// $Rev: 31855 $
// File generated on 20.07.2012 16:47:41 from Type Library described below.

// ************************************************************************  //
// Type Lib: C:\Documents and Settings\Разработчик\Рабочий стол\directum_debugger\directum_debugger (1)
// LIBID: {65B57E38-A336-41BC-92A8-BC376497EDF0}
// LCID: 0
// Helpfile:
// HelpString:
// DepndLst:
//   (1) v2.0 stdole, (C:\WINDOWS\system32\stdole2.tlb)
//   (2) v4.0 StdVCL, (stdvcl40.tlb)
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers.
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
{$ALIGN 4}
interface

uses Windows, ActiveX, Classes, Graphics, OleServer, StdVCL, Variants;


// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:
//   Type Libraries     : LIBID_xxxx
//   CoClasses          : CLASS_xxxx
//   DISPInterfaces     : DIID_xxxx
//   Non-DISP interfaces: IID_xxxx
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  directum_debuggerMajorVersion = 1;
  directum_debuggerMinorVersion = 0;

  LIBID_directum_debugger: TGUID = '{65B57E38-A336-41BC-92A8-BC376497EDF0}';

  IID_IDebugger: TGUID = '{B9EB683D-FEA3-4219-8E6D-99AA22B4D84E}';
  CLASS_Debugger: TGUID = '{9337CC4E-E520-4BEA-A3D7-8F2EC229593F}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary
// *********************************************************************//
  IDebugger = interface;
  IDebuggerDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library
// (NOTE: Here we map each CoClass to its Default Interface)
// *********************************************************************//
  Debugger = IDebugger;


// *********************************************************************//
// Interface: IDebugger
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B9EB683D-FEA3-4219-8E6D-99AA22B4D84E}
// *********************************************************************//
  IDebugger = interface(IDispatch)
    ['{B9EB683D-FEA3-4219-8E6D-99AA22B4D84E}']
    procedure StartDebug(InterpreterID: Integer; const ProgramCaption: WideString;
                         const Text: WideString; const CallStack: WideString); safecall;
    procedure FinishDebug(InterpreterID: Integer); safecall;
    procedure GotoLine(InterpreterID: Integer; LineNumber: Integer; Variables: OleVariant;
                       EnvironmentVariables: OleVariant); safecall;
    procedure Ping; safecall;
  end;

// *********************************************************************//
// DispIntf:  IDebuggerDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B9EB683D-FEA3-4219-8E6D-99AA22B4D84E}
// *********************************************************************//
  IDebuggerDisp = dispinterface
    ['{B9EB683D-FEA3-4219-8E6D-99AA22B4D84E}']
    procedure StartDebug(InterpreterID: Integer; const ProgramCaption: WideString;
                         const Text: WideString; const CallStack: WideString); dispid 201;
    procedure FinishDebug(InterpreterID: Integer); dispid 202;
    procedure GotoLine(InterpreterID: Integer; LineNumber: Integer; Variables: OleVariant;
                       EnvironmentVariables: OleVariant); dispid 203;
    procedure Ping; dispid 204;
  end;

// *********************************************************************//
// The Class CoDebugger provides a Create and CreateRemote method to
// create instances of the default interface IDebugger exposed by
// the CoClass Debugger. The functions are intended to be used by
// clients wishing to automate the CoClass objects exposed by the
// server of this typelibrary.
// *********************************************************************//
  CoDebugger = class
    class function Create: IDebugger;
    class function CreateRemote(const MachineName: string): IDebugger;
  end;

implementation

uses ComObj;

class function CoDebugger.Create: IDebugger;
begin
  Result := CreateComObject(CLASS_Debugger) as IDebugger;
end;

class function CoDebugger.CreateRemote(const MachineName: string): IDebugger;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Debugger) as IDebugger;
end;

end.

