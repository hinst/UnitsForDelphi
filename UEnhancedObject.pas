unit UEnhancedObject;

interface

uses
  SyncObjs,
  SysUtils;

type
  TEnhancedObject = class
  public
    constructor Create; virtual;
  protected
    fLockReferenceCount: TCriticalSection;
    fReferenceCount: integer;
  public
    property LockReferenceCount: TCriticalSection read fLockReferenceCount;
    property ReferenceCount: integer read fReferenceCount;
    function Reference: integer;
    function Dereference: integer;
      // no virtual
    function AssignReference(const aReference: TEnhancedObject): boolean; overload;
      // a := b
    class function AssignReference(var a; const b: TEnhancedObject)
      : boolean; overload;
    destructor Destroy; override;
  end;


function DereferenceAndNil(var aObject): integer;

implementation

constructor TEnhancedObject.Create;
begin
  inherited Create;
  fLockReferenceCount := TCriticalSection.Create;
  fReferenceCount := 0;
end;

function TEnhancedObject.Reference: integer;
begin
  LockReferenceCount.Enter;
  fReferenceCount := fReferenceCount + 1;
  LockReferenceCount.Leave;
  result := fReferenceCount;
end;

function TEnhancedObject.Dereference: integer;
begin
  LockReferenceCount.Enter;
  fReferenceCount := fReferenceCount - 1;
  LockReferenceCount.Leave;
  result := fReferenceCount;
  if fReferenceCount <= 0 then
    Free;
end;

function TEnhancedObject.AssignReference(const aReference: TEnhancedObject): boolean;
begin
  result := AssignReference(self, aReference);
end;

class function TEnhancedObject.AssignReference(var a;
  const b: TEnhancedObject): boolean;
begin
  if pointer(a) <> nil then
    if TObject(a) is TEnhancedObject then
      (TObject(a) as TEnhancedObject).Dereference;
  pointer(a) := b;
  if b <> nil then
    b.Reference;
  result := b <> nil;
end;

destructor TEnhancedObject.Destroy;
begin
  FreeAndNil(fLockReferenceCount);
  inherited Destroy;
end;

function DereferenceAndNil(var aObject): integer;
begin
  if pointer(aObject) = nil then
    result := -1
  else
  begin
    result := (TObject(aObject) as TEnhancedObject).Dereference;
    if result <= 0 then
      pointer(aObject) := nil;
  end;
end;

end.

