program TestAdvancedByte;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  
  UAdvancedByte,
  ExceptionTracer;


procedure Test;
var
  b: TByte;
begin
  b := TByte.Create(1);
  WriteLN(b.ToText);
  WriteLN(b.ToString);
  b.Free;
end;

begin
  try
    Test;
  except
    on E:Exception do
      Writeln(GetExceptionInfo(e));
  end;
  ReadLN;
end.
