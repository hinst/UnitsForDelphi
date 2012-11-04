unit UAdvancedByte;

interface

uses
  SysUtils,
  UMath,
  UTextUtilities,
  UAdditionalExceptions;

type
  TByte = class
  public
    constructor Create(const aValue: byte);
  protected
    fValue: byte;
    function AccessTheValue: PByte;
    function GetBit(const aIndex: integer): boolean;
    procedure SetBit(const aIndex: integer; const aBit: boolean);
    function GetBitName(const aIndex: integer): string; virtual;
    function GetBitAsChar(const aIndex: integer): char;
    procedure AssertBitIndex(const aIndex: integer); virtual;
    function GetCountOfBits: integer; virtual;
    function GetCountOfEnabled: integer;
  public
    property Value: byte read fValue write fValue;
    property AccessValue: PByte read AccessTheValue;
    property Bits[const aIndex: integer]: boolean read GetBit write SetBit;
    property BitNames[const aIndex: integer]: string read GetBitName;
    property BitAsChar[const aIndex: integer]: char read GetBitAsChar;
    property CountOfBits: integer read GetCountOfBits;
    property CountOfEnabled: integer read GetCountOfEnabled;
    function ToText: string;
    function ToString: string;
  end;


implementation

constructor TByte.Create(const aValue: byte);
begin
  inherited Create;
  fValue := aValue;
end;

function TByte.AccessTheValue: PByte;
begin
  result := @fValue;
end;

function TByte.GetBit(const aIndex: integer): boolean;
begin
  result := UMath.GetBit(fValue, aIndex);
end;

procedure TByte.SetBit(const aIndex: integer; const aBit: boolean);
begin
  UMath.SetBit(fValue, aIndex, aBit);
end;

function TByte.ToString: string;
var
  i: integer;
begin
  result := '';
  for i := 0 to CountOfBits - 1 do
    result := BitAsChar[i] + result;
end;

function TByte.ToText: string;
const
  Separator = '+';
  No = 'no bits enabled';
var
  i: integer;
begin
  result := '';
  for i := 0 to CountOfBits - 1 do
    if Bits[i] then
      result := result + Separator + BitNames[i];
  if result = '' then
    result := No;
end;

function TByte.GetBitName(const aIndex: integer): string;
begin
  result := IntToStr(aIndex);
end;

function TByte.GetBitAsChar(const aIndex: integer): char;
begin
  if Bits[aIndex] then
    result := '1'
  else
    result := '0';
end;

procedure TByte.AssertBitIndex(const aIndex: integer);
begin
  AssertIndex(0, aIndex, CountOfBits - 1);
end;

function TByte.GetCountOfBits: integer;
begin
  result := 8;
end;

function TByte.GetCountOfEnabled: integer;
var
  i: integer;
begin
  result := 0;
  for i := 0 to CountOfBits - 1 do
    if Bits[i] then
      result := result + 1;
end;

end.
