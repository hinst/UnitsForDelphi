unit UMath;

interface

procedure ApproachSingle(var aMoveThis: single; const aMoveHere, aDelta: single);

implementation

procedure ApproachSingle(var aMoveThis: single; const aMoveHere, aDelta: single);
begin
  // BLOCK =
  if aMoveThis = aMoveHere then
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
