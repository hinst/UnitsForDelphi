unit UAdditionalTypes;

interface

type
  TVariableType = class
  public const
    Unknown = 0;
    Field = 1;
    Argument = 2;
    Local = 3;
    Global = 4;
  public
    class function ToText(const aType: integer): string;
  end;

implementation

{ TVariableType }

class function TVariableType.ToText(const aType: integer): string;
begin
  case aType of
    Unknown: result := 'Unknown';
    Field: result := 'Field';
    Argument: result := 'Argument';
    Local: result := 'Local';
    Global: result := 'Global';
  else
    result := 'Erroneous'; 
  end;
end;

end.
