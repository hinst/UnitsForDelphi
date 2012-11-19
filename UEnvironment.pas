unit UEnvironment;

interface

uses
  SysUtils;

function GetExecutableFolderPath: string;

implementation

function GetExecutableFolderPath: string;
begin
  result := ExtractFilePath(ParamStr(0));
end;

end.
