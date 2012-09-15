unit ExceptionTracer;

{$DEFINE USE_MAD_EXCEPT}
{ $DEFINE INCLUDE_THREAD_STACK_TRACE} // takes effect only when USE_MAD_EXCEPT defined
{ $DEFINE USE_NICE_EXCEPTIONS}


interface

uses
  SysUtils
  {$IFDEF USE_MAD_EXCEPT}
  , madStackTrace
  , madExcept
  {$ENDIF}
  {$IFDEF USE_NICE_EXCEPTIONS}
  , NiceExceptions
  {$ENDIF}
  ;

function GetExceptionInfo(const e: Exception): string;

implementation

function GetExceptionInfo(const e: Exception): string;
begin
  {$IFNDEF USE_NICE_EXCEPTIONS}
    result := 'Exception: ' + e.ClassName;
    result := result + sLineBreak + '  "' + e.Message + '"';
  {$ENDIF}

  {$IFDEF USE_MAD_EXCEPT}
    result := result + sLineBreak + '~~~Crash stack trace:~~~' + sLineBreak + GetCrashStackTrace;
    {$IFDEF INCLUDE_THREAD_STACK_TRACE}
      result := result + sLineBreak + '~~~Thread stack trace:~~~' + sLineBreak + GetThreadStackTrace;
    {$ENDIF}
  {$ENDIF}
  
  {$IFDEF USE_NICE_EXCEPTIONS}
    result := GetFullExceptionInfo(e);
  {$ENDIF}
end;

end.
