unit UCustomThread;

interface

uses
  SysUtils, Classes;

type
  TCustomThread = class;

  TCustomThreadExecuteEvent = procedure(const aThread: TCustomThread) of object;
  TCustomThreadExceptionEvent = procedure(const aThread: TCustomThread;
    const aException: Exception) of object;

  TCustomThread = class(TThread)
  public
    constructor Create; virtual;
  public type
    EDontTerminate = class(Exception);
  private
    fOnExecute: TCustomThreadExecuteEvent;
    fOnException: TCustomThreadExceptionEvent;
    fStop: boolean;
  protected
    procedure Execute; override;
  public
    property OnExecute: TCustomThreadExecuteEvent read fOnExecute write fOnExecute;
    property OnException: TCustomThreadExceptionEvent read fOnException write fOnException;
    property Stop: boolean read fStop write fStop;
    procedure Terminate;
    destructor Destroy; override;
  end;

implementation

constructor TCustomThread.Create;
begin
  inherited Create(true);
  OnExecute := nil;
  OnException := nil;
  Stop := false;
end;

procedure TCustomThread.Execute;
begin
  if @OnExecute = nil then exit;
  try
    OnExecute(self);
  except
    on e: Exception do
    begin
      if @OnException <> nil then
        OnException(self, e);
    end;
  end;
end;

procedure TCustomThread.Terminate;
begin
  raise EDontTerminate.Create('Use Stop := true instead');
end;

destructor TCustomThread.Destroy;
begin
  inherited Destroy;
end;

end.
