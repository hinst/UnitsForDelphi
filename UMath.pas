unit UMath;

interface

function ApproachSingle(var aMoveThis: single; const aMoveHere, aDelta: single): boolean;

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

end.
