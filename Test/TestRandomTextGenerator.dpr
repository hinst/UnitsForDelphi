program TestRandomTextGenerator;

{$APPTYPE CONSOLE}

uses
  SysUtils,

  UTextUtilities;

var
  i: integer;
  text: string;

begin
  randomize;
  i := 0;
  while i < 30 do
  begin
    i := i + 10;
    text := IntToStr(i) + ': "' + GenerateRandomText(i) + '"';
    WriteLN(text);
  end;
end.
