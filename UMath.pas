unit UMath;

interface

  // result = equal
function ApproachSingle(var aMoveThis: single; const aMoveHere, aDelta: single): boolean;

  // result = equal
function ApproachInteger(var aMoveThis: integer; const aMoveHere, aDelta: integer): boolean;

function RandomInteger(const aMin, aMax: integer): integer;

function GetBit(const aByte: byte; const aIndex: byte): boolean;

function SetBit(var aByte: byte; const aIndex: byte; const aValue: boolean): boolean;

function IntegerPowerOf10(const aPower: byte): integer;

function RandomDeviateInteger(const aInput: integer; const aBy: single): integer;


implementation

function ApproachSingle(var aMoveThis: single; const aMoveHere, aDelta: single): boolean;
begin
  result := aMoveThis = aMoveHere;
  // BLOCK =
  if result then
    exit;

  // BLOCK . < x
  if aMoveThis < aMoveHere then
  begin
    aMoveThis := aMoveThis + aDelta;
    if aMoveHere < aMoveThis then
      aMoveThis := aMoveHere;
  end;

  // BLOCK x < .
  if aMoveHere < aMoveThis then
  begin
    aMoveThis := aMoveThis - aDelta;
    if aMoveThis < aMoveHere then
      aMoveThis := aMoveHere;
  end;

end;

function ApproachInteger(var aMoveThis: integer; const aMoveHere, aDelta: integer): boolean;
begin
  result := aMoveThis = aMoveHere;
  // BLOCK =
  if result then
    exit;

  // BLOCK . < x
  if aMoveThis < aMoveHere then
  begin
    aMoveThis := aMoveThis + aDelta;
    if aMoveHere < aMoveThis then
      aMoveThis := aMoveHere;
  end;

  // BLOCK x < .
  if aMoveHere < aMoveThis then
  begin
    aMoveThis := aMoveThis - aDelta;
    if aMoveThis < aMoveHere then
      aMoveThis := aMoveHere;
  end;
end;

function RandomInteger(const aMin, aMax: integer): integer;
begin
  result := random(aMax - aMin + 1) + aMin;
end;

function GetBit(const aByte: byte; const aIndex: byte): boolean;
var
  mask: byte;
begin
  mask := 1 shl aIndex;
  result := (aByte and mask) <> 0;
end;

function SetBit(var aByte: byte; const aIndex: byte; const aValue: boolean): boolean;
var
  mask: byte;
begin
  result := aIndex < 8;
  if not result then
    exit;
  mask := 1 shl aIndex;
  case aValue of
    true:
      aByte := aByte or mask;
    false:
      aByte := aByte and not mask;
  end;
end;

function IntegerPowerOf10(const aPower: byte): integer;
var
  i: byte;
begin
  result := 1;
  for i := 1 to aPower do
    result := result * 10;
end;

function RandomDeviateInteger(const aInput: integer; const aBy: single): integer;
var
  by: integer;
begin
  by := round(aInput * aBy);
  result := aInput + RandomInteger(-by, by);
end;

end.
