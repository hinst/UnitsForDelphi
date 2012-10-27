unit UWindowsTempFile;

interface

uses
  Windows,
  SysUtils;

function GetTempFolderPath: string;

function GetTempFilePath(const aPrefix: string): string;


implementation

function GetTempFolderPath: string;
var
  tempFolder: array[0..MAX_PATH] of char;
begin
  GetTempPath(MAX_PATH, @tempFolder);
  result := IncludeTrailingPathDelimiter( StrPas(tempFolder) );
end;

function GetTempFilePath(const aPrefix: string): string;
var
  path, name: array[0..MAX_PATH] of char;
begin
  FillChar(path, MAX_PATH, 0);
  FillChar(name, MAX_PATH, 0);
  GetTempPath(SizeOf(path), path);
  GetTempFileName(path, PAnsiChar(aPrefix), 0, name);
  result := name;
end;

end.
