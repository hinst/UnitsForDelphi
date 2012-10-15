unit UAdvancedToolBar;

interface

uses
  ComCtrls;

type
  TAdvToolBar = class(TToolBar)
  private
    function GetLastButton: TToolButton;
  public
    procedure Add(const aButton: TToolButton);
    property LastButton: TToolButton read GetLastButton;
  end;


implementation

function TAdvToolBar.GetLastButton: TToolButton;
begin
  result := nil;
  if ButtonCount > 0 then
    result := Buttons[ButtonCount - 1];
end;

procedure TAdvToolBar.Add(const aButton: TToolButton);
begin
  if LastButton <> nil then
    aButton.Left := LastButton.Left + LastButton.Width;
end;

end.
