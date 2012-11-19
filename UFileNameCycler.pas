unit UFileNameCycler;

interface

uses
  Windows,
  SysUtils,
  
  UMath,  
  UTextUtilities;

function CycleFileName(const aFilePath: string; const aCount: integer;
  const aFileExtension: string): string;


implementation

function CycleFileName(const aFilePath: string; const aCount: integer;
  const aFileExtension: string): string;

var
  name, folderPath, current, next: string;
  i, cycle: integer;

  function GenerateFilePath(const aIndex: integer): string;
  begin
    result := folderPath + name + IntToZero(aIndex, cycle) + aFileExtension;
  end;

begin
  {$REGION PREPARE}
  name := ExtractFileName(aFilePath);
  folderPath := IncludeTrailingPathDelimiter( ExtractFilePath(aFilePath) );
  cycle := 0;
  while IntegerPowerOf10(cycle) < aCount do
    cycle := cycle + 1;
  {$ENDREGION}
  cycle := cycle + 1;
  current := GenerateFilePath(aCount);
  if FileExists(current) then
    DeleteFile(current);
  for i := aCount - 1 downto 0 do
  begin
    current := GenerateFilePath(i);
    if FileExists(current) then
    begin
      next := GenerateFilePath(i + 1);
      RenameFile(current, next);
    end;
  end;
  result := GenerateFilePath(0);
end;


end.
