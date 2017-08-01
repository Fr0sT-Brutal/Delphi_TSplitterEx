// Extended version of TSplitter that has clickable area and able to toggle visibility
// of linked control
// (c) Fr0sT

unit SplitterEx;

interface

uses Windows, Messages, Graphics, Classes, Controls, ExtCtrls;

type
  TSplitterEx = class(ExtCtrls.TSplitter)
  private
    // fields to init
    FImages: array[Boolean] of TImage;
    FHotColor: TColor;
    FToggleControl: TControl;       // linked control that will be toggled on splitter click
    FDenyDrag: Boolean;             // if True, splitter will ignore mouse dragging (for case when FToggleControl.Align is alClient)
    // runtime props
    FClickArea: TRect;              // coords of button image on the splitter
    FSaveControlSize: Integer;      // previous dimension (Height/Width) of linked control
    FSaveControlPos: Integer;       // previous position (Left/Top) of linked control | to reset align order
    FSavePos: Integer;              // previous position (Left/Top) of splitter       |
    FMouseOverClickArea: Boolean;
    FSaveCursor: TCursor;           // copy of Cursor property
    FSaveColor: TColor;             // copy of Color property
    FControlHidden: Boolean;        // current state of linked control
    // internal methods
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
  public
    // overrides
    procedure Paint; override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure StopSizing; override;
    procedure Click; override;
    // new handlers
    procedure MouseEnter; virtual;
    procedure MouseLeave; virtual;
    // new methods
    procedure Toggle;
    procedure SetImages(ImageShown: TImage; ImageHidden: TImage = nil);

    property HotColor: TColor read FHotColor write FHotColor;
    property ToggleControl: TControl read FToggleControl write FToggleControl;
    property DenyDrag: Boolean read FDenyDrag write FDenyDrag;
  end;

implementation

function Max(const A, B: Integer): Integer;
begin
  if A > B
    then Result := A
    else Result := B;
end;

type
  TOrientation = (oVert, oHorz);

function GetCtrlSize(Orient: TOrientation; Control: TControl): Integer;
begin
  case Orient of
    oVert: Result := Control.Width;
    oHorz: Result := Control.Height;
    else raise TObject.Create;
  end;
end;

procedure SetCtrlSize(Orient: TOrientation; Control: TControl; Size: Integer);
begin
  case Orient of
    oVert: Control.Width := Size;
    oHorz: Control.Height := Size;
  end;
end;

function GetCtrlPos(Orient: TOrientation; Control: TControl): Integer;
begin
  case Orient of
    oVert: Result := Control.Left;
    oHorz: Result := Control.Top;
    else raise TObject.Create;
  end;
end;

procedure SetCtrlPos(Orient: TOrientation; Control: TControl; Pos: Integer);
begin
  case Orient of
    oVert: Control.Left := Pos;
    oHorz: Control.Top := Pos;
  end;
end;

{ TSplitter }

procedure TSplitterEx.Toggle;
var
  Orient: TOrientation;
  CurrSize: Integer;
begin
  // Determine orientation (copy from VCL)
  if Align in [alBottom, alTop] then
    Orient := oHorz
  else
    Orient := oVert;

  // Control is hidden:
  //   Set size
  //   Set positions of splitter and control to revert align order (!)
  if FControlHidden then
  begin
    // New size
    CurrSize := Max(FSaveControlSize, MinSize);
    if FToggleControl.Align = alClient then
      SetCtrlSize(Orient, Parent, GetCtrlSize(Orient, Parent) + CurrSize)
    else
      SetCtrlSize(Orient, FToggleControl, CurrSize);
    SetCtrlPos(Orient, Self, FSavePos);
    SetCtrlPos(Orient, FToggleControl, FSaveControlPos);
  end
  else
  // Control is visible:
  //   Save control size
  //   Save control and splitter positions
  //   Set control size to 0
  begin
    FSaveControlSize := GetCtrlSize(Orient, FToggleControl);
    FSaveControlPos := GetCtrlPos(Orient, FToggleControl);
    FSavePos := GetCtrlPos(Orient, Self);
    if FToggleControl.Align = alClient then
      SetCtrlSize(Orient, Parent, GetCtrlSize(Orient, Parent) - FSaveControlSize)
    else
      SetCtrlSize(Orient, FToggleControl, 0);
  end;
  FControlHidden := not FControlHidden;
  // Refresh, call OnMoved
  StopSizing;
end;

// Call Toggle if needed
procedure TSplitterEx.Click;
begin
  if FMouseOverClickArea then
    Toggle;
end;

procedure TSplitterEx.CMMouseEnter(var Message: TMessage);
begin
  MouseEnter;
  // inherited from TControl
  if Parent <> nil then
    Parent.Perform(CM_MOUSEENTER, 0, Longint(Self));
end;

procedure TSplitterEx.CMMouseLeave(var Message: TMessage);
begin
  MouseLeave;
  // inherited from TControl
  if Parent <> nil then
    Parent.Perform(CM_MOUSELEAVE, 0, Longint(Self));
end;

// Draw splitter with hot color
procedure TSplitterEx.MouseEnter;
begin
  FSaveColor := Color;
  Color := HotColor;
end;

// Draw splitter with default color
procedure TSplitterEx.MouseLeave;
begin
  Color := FSaveColor;
end;

// Show hand cursor if mouse is over an image
procedure TSplitterEx.MouseMove(Shift: TShiftState; X, Y: Integer);
var MouseOverClickArea: Boolean;
begin
  inherited;
  MouseOverClickArea := PtInRect(FClickArea, Point(X, Y));
  // No status change 
  if FMouseOverClickArea = MouseOverClickArea then
    Exit;
  // Entering click area
  if not FMouseOverClickArea and MouseOverClickArea then
  begin
    FSaveCursor := Cursor;
    Cursor := crHandPoint;
  end
  else
  // Leaving click area
  if FMouseOverClickArea and not MouseOverClickArea then
    Cursor := FSaveCursor;

  FMouseOverClickArea := MouseOverClickArea;
end;

// Do not call inherited if mouse is over click area or dragging is denied
procedure TSplitterEx.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if not FMouseOverClickArea and not FDenyDrag then
    inherited;
end;

// Draw click image
procedure TSplitterEx.Paint;
begin
  inherited;
  if FImages[FControlHidden] <> nil then
    Canvas.Draw(FClickArea.Left, FClickArea.Top, FImages[FControlHidden].Picture.Graphic);
end;

// Init click image and calc click area from image's dimensions
//   ImageShown - image to draw when control is shown
//   ImageHidden - image to draw when control is hidden. If nil, ImageShown will be used.
// ! No image size checks is performed !
procedure TSplitterEx.SetImages(ImageShown: TImage; ImageHidden: TImage);
begin
  FImages[False] := ImageShown;
  FImages[True] := ImageHidden;
  if FImages[True] = nil then
    FImages[True] := FImages[False];
  FClickArea.Left := (ClientWidth - ImageShown.Width) div 2;
  FClickArea.Top := (ClientHeight - ImageShown.Height) div 2;
  FClickArea.Right := FClickArea.Left + ImageShown.Width;
  FClickArea.Bottom := FClickArea.Top + ImageShown.Height;
end;

// Re-determine FControlHidden flag (otherwise it could be missed by dragging from hidden state)
procedure TSplitterEx.StopSizing;
var Orient: TOrientation;
begin
  inherited;

  // Determine orientation (copy from VCL)
  if Align in [alBottom, alTop] then
    Orient := oHorz
  else
    Orient := oVert;

  FControlHidden := (GetCtrlSize(Orient, FToggleControl) = 0);
end;

end.
