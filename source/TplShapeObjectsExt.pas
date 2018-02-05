{**********************************************************************
 Package pl_Shapes.pkg
 This unit is part of CodeTyphon Studio (http://www.pilotlogic.com/)
***********************************************************************}

unit TplShapeObjectsExt;

{$mode delphi}{$H+}

interface

uses
  Classes, SysUtils, Controls, Graphics, TplShapeObjectsBase,BGRACanvas;

type

  { TplDrawObjectComposite }

  TplDrawObjectComposite = class(TplSolid)
  private
    xmin, ymin, xmax, ymax: integer;
    targetParent: TControl;
  protected
    procedure DrawObject(Canvas: TCanvas; IsShadow: boolean); override;
    procedure GroupDrawObjects(drawObjectComponents: array of TplDrawObject); virtual;
    procedure ExtendGroup(aDraw: TplDrawObject);
    function CheckDrawObjectGroup(drawObjectComponents: array of TplDrawObject): boolean; virtual;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: integer); override;
    procedure ChangeChildrenBounds(OldBounds, NewBounds: TRect); virtual;
    procedure ChangeChildBounds(aChild: TControl; OldBounds, NewBounds: TRect); virtual;
  public
    constructor Create(AnOwner: TComponent); override; overload;
    constructor Create(AnOwner: TComponent; drawObjectComponents: array of TplDrawObject); virtual; overload;
    destructor Destroy; override;
  end;

implementation

{ TplDrawObjectComposite }

procedure TplDrawObjectComposite.DrawObject(Canvas: TCanvas; IsShadow: boolean);
var
  iComp: integer;
  aComp: TComponent;
  aDrawComp: TplDrawObject;
begin
  //{ DONE -oTC -cExtension : draw components + overall control lines}
  //for iComp := 0 to ComponentCount-1 do
  //begin
  //  aComp := Components[ iComp];
  //  if aComp is TDrawObject then
  //  begin
  //    aDrawComp := TDrawObject(aComp);
  //    aDrawComp.DrawObject( Canvas, IsShadow);
  //  end;
  //end;
end;

procedure TplDrawObjectComposite.GroupDrawObjects(drawObjectComponents: array of TplDrawObject);
var
  iDraw: integer;
  aDraw: TplDrawObject;
begin
  if not CheckDrawObjectGroup(drawObjectComponents) then
    Exit;

  // set up the group
  Parent := targetParent as TWinControl;
  Left := xmin;
  Top := ymin;
  Width := xmax - xmin;
  Height := ymax - ymin;
  Focused := True;
  BringToFront;

  //get the individual components in
  for iDraw := low(drawObjectComponents) to high(drawObjectComponents) do
  begin
    aDraw := drawObjectComponents[iDraw];
    //aDraw.Parent := self;
    aDraw.Owner.RemoveComponent(aDraw);
    Self.InsertComponent(aDraw);

    //aDraw.CanMove := false;
    aDraw.Focused := False;
    aDraw.CanFocus := False;

    // Need to control the events and send them to the object.
    { TODO -oTC -cExtension : Add the events here on components }
  end;

  //Redraw self
  CalcMargin;
  BtnPoints[0] := Point(Margin, Margin);
  BtnPoints[1] := Point(Width - Margin, Height - Margin);
  ResizeNeeded;
end;

procedure TplDrawObjectComposite.ExtendGroup(aDraw: TplDrawObject);
var
  x1, y1, x2, y2: integer;
begin
  x1 := aDraw.left;
  y1 := aDraw.top;
  x2 := x1 + aDraw.Width;
  y2 := y1 + aDraw.Height;

  if (x1 < xmin) then
    xmin := x1;
  if (y1 < ymin) then
    ymin := y1;
  if (x2 > xmax) then
    xmax := x2;
  if (y2 > ymax) then
    ymax := y2;
end;

function TplDrawObjectComposite.CheckDrawObjectGroup(drawObjectComponents: array of TplDrawObject): boolean;
var
  iDraw: integer;
  aDraw: TplDrawObject;
begin
  Result := False;
  xmin := 10000;
  ymin := 10000;
  xmax := 0;
  ymax := 0;
  targetParent := drawObjectComponents[low(drawObjectComponents)].Parent;
  for iDraw := low(drawObjectComponents) to high(drawObjectComponents) do
  begin
    aDraw := drawObjectComponents[iDraw];
    if aDraw.Parent <> targetParent then
      exit;
    ExtendGroup(aDraw);
  end;
  Result := True;
end;

procedure TplDrawObjectComposite.SetBounds(ALeft, ATop, AWidth, AHeight: integer);
var
  OldBounds, NewBounds: TRect;
begin
  OldBounds := Bounds(Left, Top, Width, Height);
  NewBounds := Bounds(ALeft, ATop, AWidth, AHeight);

  inherited SetBounds(ALeft, ATop, AWidth, AHeight);

  ChangeChildrenBounds(OldBounds, NewBounds);
end;

procedure TplDrawObjectComposite.ChangeChildrenBounds(OldBounds, NewBounds: TRect);
var
  iChild: integer;
  aChild: TComponent;
  aChildControl: TControl;
begin
  for iChild := 0 to ComponentCount - 1 do
  begin
    aChild := Components[iChild];
    if aChild is TControl then
    begin
      aChildControl := TControl(aChild);
      ChangeChildBounds(aChildControl, OldBounds, NewBounds);
    end;
  end;
end;

procedure TplDrawObjectComposite.ChangeChildBounds(aChild: TControl; OldBounds, NewBounds: TRect);
var
  NewLeft, NewTop, NewWidth, NewHeight: integer;
  dx, dy: integer;
  rx, ry: real;
begin
  dx := NewBounds.Left - OldBounds.Left;
  dy := NewBounds.Top - OldBounds.Top;
  rx := (NewBounds.Right - NewBounds.Left) / (OldBounds.Right - OldBounds.Left);
  ry := (NewBounds.Bottom - NewBounds.Top) / (OldBounds.Bottom - OldBounds.Top);

  NewLeft := round((aChild.Left - OldBounds.Left) * rx) + NewBounds.Left;
  NewTop := round((aChild.Top - OldBounds.Top) * ry) + NewBounds.Top;
  NewWidth := round(aChild.Width * rx);
  NewHeight := round(aChild.Height * ry);
  aChild.SetBounds(NewLeft, NewTop, NewWidth, NewHeight);
end;

constructor TplDrawObjectComposite.Create(AnOwner: TComponent);
begin
  inherited Create(AnOwner);
end;

constructor TplDrawObjectComposite.Create(AnOwner: TComponent; drawObjectComponents: array of TplDrawObject);
begin
  Create(anOwner);
  GroupDrawObjects(drawObjectComponents);
end;

destructor TplDrawObjectComposite.Destroy;
begin
  inherited Destroy;
end;

end.




