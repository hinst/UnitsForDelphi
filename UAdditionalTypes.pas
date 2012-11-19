unit UAdditionalTypes;

interface

type
  TVariableType = class
  public const
    Unknown = 0;
    Field = 1;
    Prop = 2;
    Argument = 3;
    Local = 4;
    Global = 5;
  public
    class function ToText(const aType: integer): string;
  end;

function MethodsEqual(const a, b: TMethod): boolean;


implementation

class function TVariableType.ToText(const aType: integer): string;
begin
  case aType of
    Unknown: result := 'Unknown';
    Prop: result := 'Property';
    Field: result := 'Field';
    Argument: result := 'Argument';
    Local: result := 'Local';
    Global: result := 'Global';
  else
    result := 'Erroneous';
  end;
end;

function MethodsEqual(const a, b: TMethod): boolean;
begin
  result := (a.Code = b.Code) and (a.Data = b.Data);
end;


end.
