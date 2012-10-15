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
    function Refererence: integer;
    function Dereference: integer;
    procedure Assign(const aSource: TEnhancedObject); virtual; abstract;
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

function TEnhancedObject.Refererence: integer;
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

