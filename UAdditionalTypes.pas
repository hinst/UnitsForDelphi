unit UAdditionalTypes;

interface

type
  TVariableType = class
  public const
    Field = 0;
    Argument = 1;
    Local = 2;
    Global = 3;
  public
    class function ToString(const aType: integer): string;
  end;

implementation

{ TVariableType }

class function TVariableType.ToString(const aType: integer): string;
begin
  case aType of
    Field: result := 'Field';
    Argument: result := 'Argument';
    Local: result := 'Local';
    Global: result := 'Global';
  end;
end;

end.
