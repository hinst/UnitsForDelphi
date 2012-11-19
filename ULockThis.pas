unit ULockThis;

interface

uses
  SysUtils,
  SyncObjs,
  JclSortedMaps;

procedure LockPointer(const aPointer: pointer); 

function UnlockPointer(const aPointer: pointer): boolean;

implementation

var
  globalLocks: TJclPtrPtrSortedMap;
  lockGlobalLocks: TCriticalSection;

procedure LockPointer(const aPointer: pointer);
begin
  if aPointer = nil then
    exit;
  if not globalLocks.ContainsKey(aPointer) then
    globalLocks.PutValue(aPointer, TCriticalSection.Create);
  TCriticalSection(globalLocks.GetValue(aPointer)).Enter;
end;

function UnlockPointer(const aPointer: pointer): boolean;
begin
  if aPointer = nil then
  begin
    result := false;
    exit;
  end;
  result := globalLocks.ContainsKey(aPointer);
  if result then
    TCriticalSection(globalLocks.GetValue(aPointer)).Leave;
end;

procedure ReleaseGlobalLocks;
begin
  while globalLocks.Size > 0 do
    TCriticalSection(
      globalLocks.Extract(
        globalLocks.FirstKey
      )
    ).Free;
  FreeAndNil(globalLocks);
end;

initialization
  lockGlobalLocks := TCriticalSection.Create;
  globalLocks := TJclPtrPtrSortedMap.Create(0);
finalization
  ReleaseGlobalLocks;
  FreeAndNil(lockGlobalLocks);
end.
