unit UMath;

interface

function ApproachSingle(var aMoveThis: single; const aMoveHere, aDelta: single): boolean;

function RandomInteger(const aMin, aMax: integer): integer;

function GetBit(const aByte: byte; const aIndex: byte): boolean;

function SetBit(var aByte: byte; const aIndex: byte; const aValue: boolean): boolean;


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

end.
