unit UAdditionalExceptions;

interface

uses
  SysUtils,
  UAdditionalTypes;

type
  EUnassigned = class(Exception)
  public
    constructor Create(const aVariableType: integer; const aVariableName: string);
  private
    fVariableType: integer;
    fVariableName: string;
    procedure UpdateMessage;
  public
    property VariableType: integer read fVariableType;
  end;

procedure AssertAssigned(const aPointer: pointer; const aVariableName: string;
  const aVariableType: integer);

implementation

constructor EUnassigned.Create(const aVariableType: integer; const aVariableName: string);
begin
  inherited Create(aVariableName);
  fVariableType := aVariableType;
  fVariableName := aVariableName;
end;

procedure AssertAssigned(const aPointer: pointer; const aVariableName: string;
  const aVariableType: integer);
begin
  if not Assigned(aPointer) then
    raise EUnassigned.Create(aVariableType, aVariableName);
end;

procedure EUnassigned.UpdateMessage;
begin

end;

end.
