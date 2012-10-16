unit UWindowsOverlappedEvent;

interface

uses
  Windows,
  SysUtils,
  Types;

type
  EWaitWindowsOverlappedEvent = class(Exception)
  public
    constructor Create(const aTime: DWORD);
  protected
    fTime: DWORD;
    procedure CreateThis;
  public
    property Time: DWORD read fTime;
  end;

  TWindowsOverlappedEvent = class
  public
    constructor Create;
  public type
    EAbandoned = class(EWaitWindowsOverlappedEvent);
    ETimeOut = class(EWaitWindowsOverlappedEvent);
    EFailed = class(EWaitWindowsOverlappedEvent);
  private
    fOverlapped: TOverlapped;
    function AccessOverlapped: POverlapped;
    function GetEvent: THandle;
    procedure CreateThis;
    procedure CloseEvent;
    procedure DestroyThis;
  public
    property Event: THandle read GetEvent;
    property Overlapped: POverlapped read AccessOverlapped;
    function Wait(const aTime: DWORD): boolean;
    destructor Destroy; override;
  end;


implementation

constructor EWaitWindowsOverlappedEvent.Create(const aTime: DWORD);
begin
  inherited Create('');
  fTime := aTime;
  CreateThis;
end;

procedure EWaitWindowsOverlappedEvent.CreateThis;
begin
  Message := 'Time: ' + IntToStr(Time);
end;

constructor TWindowsOverlappedEvent.Create;
begin
  inherited Create;
  CreateThis;
end;

function TWindowsOverlappedEvent.AccessOverlapped: POverlapped;
begin
  result := @fOverlapped;
end;

procedure TWindowsOverlappedEvent.CreateThis;
begin
  fOverlapped.hEvent := CreateEvent(nil, false, false, nil);
end;

procedure TWindowsOverlappedEvent.CloseEvent;
begin
  if Event > 0 then
  begin
    CloseHandle(Event);
    fOverlapped.hEvent := 0;
  end;
end;

function TWindowsOverlappedEvent.GetEvent: THandle;
begin
  result := fOverlapped.hEvent;
end;

procedure TWindowsOverlappedEvent.DestroyThis;
begin
  CloseEvent;
end;

function TWindowsOverlappedEvent.Wait(const aTime: DWORD): boolean;
var
  waitResult: DWORD;
begin
  result := false;
  Assert(Event > 0);
  waitResult := WaitForSingleObject(Event, aTime);
  if waitResult = WAIT_ABANDONED then
    raise EAbandoned.Create(aTime);
  if waitResult = WAIT_FAILED then
    raise EFailed.Create(aTime);
  result := waitResult = WAIT_OBJECT_0;
end;

destructor TWindowsOverlappedEvent.Destroy;
begin
  CloseHandle(Event);
  Overlapped^.hEvent := 0;
  DestroyThis;
  inherited Destroy;
end;


end.
