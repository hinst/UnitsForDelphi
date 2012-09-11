unit UCustomThread;

interface

uses
  Classes;

type
  TCustomThread = class;     

  TCustomThreadExecuteEvent = procedure(const aThread: TCustomThread) of object;

  TCustomThread = class(TThread)
  public
    constructor Create(const aOnExecute: TCustomThreadExecuteEvent); reintroduce;
  private
    fOnExecute: TCustomThreadExecuteEvent;
  protected
    procedure Execute; override;
  public
    property OnExecute: TCustomThreadExecuteEvent read fOnExecute;
    destructor Destroy; override;
  end;

implementation

constructor TCustomThread.Create(const aOnExecute: TCustomThreadExecuteEvent);
begin
  inherited Create(true);
  fOnExecute := aOnExecute;
end;

destructor TCustomThread.Destroy;
begin
  inherited;
end;

procedure TCustomThread.Execute;
begin
  if @OnExecute = nil then exit;
  OnExecute(self);
  inherited;
end;

end.
