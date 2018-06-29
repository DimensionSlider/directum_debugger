// Replace __TYPE__ to necessary type...

unit TypeTemplate;

interface

uses
  ArrayV;

const
  IID_I__TYPE__Array = '{2CF25991-6057-4E42-A7A3-0624EF019DFB}';
  ext__TYPE__ = $00080000 or varPointer;

type
  T__TYPE__ = Pointer; // ...and remove this line

  T__TYPE__Data = packed record
    VExtType: LongWord;
    Reserved: LongWord;
    V__TYPE__: T__TYPE__;
    Dummy: LongWord;
  end;

  T__TYPE__Array = class;

  I__TYPE__Array = interface(IAbstractArray)
    ['{2CF25991-6057-4E42-A7A3-0624EF019DFB}']
    function GetCurrentValue: T__TYPE__;
    function GetInstance: T__TYPE__Array;
    function GetItem(Key: Variant): T__TYPE__;
    function GetValue(Index: Integer): T__TYPE__;
    procedure SetItem(Key: Variant; const Value: T__TYPE__);
  //
    function FindValue(const Value: T__TYPE__; var Index: Integer): Boolean;
    property CurrentValue: T__TYPE__ read GetCurrentValue;
    property Instance: T__TYPE__Array read GetInstance;
    property Item[Key: Variant]: T__TYPE__ read GetItem write SetItem; default;
    property Value[Index: Integer]: T__TYPE__ read GetValue;
  end;

  T__TYPE__Array = class(TVariantArray, I__TYPE__Array)
  private
    function GetCurrentValue: T__TYPE__;
    function GetInstance: T__TYPE__Array;
    function GetItem(Key: Variant): T__TYPE__;
    function GetValue(Index: Integer): T__TYPE__;
    procedure SetItem(Key: Variant; const Value: T__TYPE__);
  public
    function FindValue(const Value: T__TYPE__; var Index: Integer): Boolean;
    property CurrentValue: T__TYPE__ read GetCurrentValue;
    property Instance: T__TYPE__Array read GetInstance;
    property Item[Key: Variant]: T__TYPE__ read GetItem write SetItem; default;
    property Value[Index: Integer]: T__TYPE__ read GetValue;
  end;

function Create__TYPE__Array: T__TYPE__Array; overload;
function Create__TYPE__Array(CustomCompare: TVariantCompare): T__TYPE__Array; overload;

implementation

function Create__TYPE__Array: T__TYPE__Array;
begin
  Result := T__TYPE__Array.Create;
end;

function Create__TYPE__Array(CustomCompare: TVariantCompare): T__TYPE__Array;
begin
  Result := T__TYPE__Array.Create(CustomCompare);
end;

{ T__TYPE__Array }

function T__TYPE__Array.FindValue(const Value: T__TYPE__;
  var Index: Integer): Boolean;
var
  V: Variant;
begin
  T__TYPE__Data(V).VExtType := ext__TYPE__;
  T__TYPE__Data(V).V__TYPE__ := Value;
  Result := inherited FindValue(V, Index);
end;

function T__TYPE__Array.GetCurrentValue: T__TYPE__;
var
  V: Variant;
begin
  V := inherited GetCurrentValue;
  Result := T__TYPE__Data(V).V__TYPE__;
end;

function T__TYPE__Array.GetInstance: T__TYPE__Array;
begin
  Result := Self;
end;

function T__TYPE__Array.GetItem(Key: Variant): T__TYPE__;
var
  V: Variant;
begin
  V := inherited GetItem(Key);
  Result := T__TYPE__Data(V).V__TYPE__;
end;

function T__TYPE__Array.GetValue(Index: Integer): T__TYPE__;
var
  V: Variant;
begin
  V := inherited GetValue(Index);
  Result := T__TYPE__Data(V).V__TYPE__;
end;

procedure T__TYPE__Array.SetItem(Key: Variant; const Value: T__TYPE__);
var
  V: Variant;
begin
  T__TYPE__Data(V).VExtType := ext__TYPE__;
  T__TYPE__Data(V).V__TYPE__ := Value;
  inherited SetItem(Key, V);
end;

end.

