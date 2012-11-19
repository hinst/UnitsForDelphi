unit UPaintEx;

interface

uses
  Graphics,

  JclStacks,
  JclSortedMaps;

procedure PushPen(const aSelf: pointer; const aPen: TPen);

implementation

var
  GlobalPenOwners: TJclPtrPtrSortedMap;

procedure EnsureGlobalPenOwnersCreated;
begin
  if GlobalPenOwners = nil then
    GlobalPenOwners := TJclPtrPtrSortedMap.Create(0);
end;

procedure PushPen(const aSelf: pointer; const aPen: TPen);
var
  stack: TJclPtrStack;
begin
  EnsureGlobalPenOwnersCreated;
  if not GlobalPenOwners.ContainsKey(aSelf) then
    GlobalPenOwners.PutValue(aSelf, TJclPtrStack.Create(0));
  stack := TJclPtrStack(GlobalPenOwners.GetValue(aSelf));
  stack.Push(aPen);
end;


end.
