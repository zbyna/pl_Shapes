

//============================= TplTriangleShape ============================================

procedure TplTriangleShape.PaintShadow;
var Points  : Array[0..3] of TPoint;
    l,t,w,h : Integer;
begin
  inherited PaintShadow;

  { Calc the new coordinates for the current width and height }
  l := Pen.Width div 2;
  t := l;
  w := Width-ShadowOffset-1-Pen.Width;
  h := Height-ShadowOffset-1-Pen.Width;

  if Pen.Width = 0 then begin
    Dec(w);
    Dec(h);
  end;

  if CalcPoly(Points,POLY_TRIANGLE,w,h) then begin
    OffsetPoly(Points,l+ShadowOffset,t+ShadowOffset);
    Canvas.Polygon(Points);
  end;
end;

procedure TplTriangleShape.PaintShape;
var Points  : Array[0..3] of TPoint;
    l,t,w,h : Integer;
begin
  inherited PaintShape;

  { Calc the new coordinates for the current width and height }
  l := Pen.Width div 2;
  t := l;
  w := Width-ShadowOffset-1-Pen.Width;
  h := Height-ShadowOffset-1-Pen.Width;

  if not Shadow then begin
    Inc(w,ShadowOffset);
    Inc(h,ShadowOffset);
  end;

  if Pen.Width = 0 then begin
    Dec(w);
    Dec(h);
  end;

  if CalcPoly(Points,POLY_TRIANGLE,w,h) then begin
    OffsetPoly(Points,l,t);
    Canvas.Polygon(Points);
  end;
end;

//============================= TplTriangleShapeR ============================================

procedure TplTriangleShapeR.PaintShadow;
var Points  : Array[0..3] of TPoint;
    l,t,w,h : Integer;
begin
  inherited PaintShadow;

  { Calc the new coordinates for the current width and height }
  l := Pen.Width div 2;
  t := l;
  w := Width-ShadowOffset-1-Pen.Width;
  h := Height-ShadowOffset-1-Pen.Width;

  if Pen.Width = 0 then begin
    Dec(w);
    Dec(h);
  end;

  if CalcPoly(Points,POLY_TRIANGLE_R,w,h) then begin
    OffsetPoly(Points,l+ShadowOffset,t+ShadowOffset);
    Canvas.Polygon(Points);
  end;
end;

procedure TplTriangleShapeR.PaintShape;
var Points  : Array[0..3] of TPoint;
    l,t,w,h : Integer;
begin
  inherited PaintShape;

  { Calc the new coordinates for the current width and height }
  l := Pen.Width div 2;
  t := l;
  w := Width-ShadowOffset-1-Pen.Width;
  h := Height-ShadowOffset-1-Pen.Width;

  if not Shadow then begin
    Inc(w,ShadowOffset);
    Inc(h,ShadowOffset);
  end;

  if Pen.Width = 0 then begin
    Dec(w);
    Dec(h);
  end;

  if CalcPoly(Points,POLY_TRIANGLE_R,w,h) then begin
    OffsetPoly(Points,l,t);
    Canvas.Polygon(Points);
  end;
end;


//============================= TplTriangleShapeD ============================================

procedure TplTriangleShapeD.PaintShadow;
var Points  : Array[0..3] of TPoint;
    l,t,w,h : Integer;
begin
  inherited PaintShadow;

  { Calc the new coordinates for the current width and height }
  l := Pen.Width div 2;
  t := l;
  w := Width-ShadowOffset-1-Pen.Width;
  h := Height-ShadowOffset-1-Pen.Width;

  if Pen.Width = 0 then begin
    Dec(w);
    Dec(h);
  end;

  if CalcPoly(Points,POLY_TRIANGLE_D,w,h) then begin
    OffsetPoly(Points,l+ShadowOffset,t+ShadowOffset);
    Canvas.Polygon(Points);
  end;
end;

procedure TplTriangleShapeD.PaintShape;
var Points  : Array[0..3] of TPoint;
    l,t,w,h : Integer;
begin
  inherited PaintShape;

  { Calc the new coordinates for the current width and height }
  l := Pen.Width div 2;
  t := l;
  w := Width-ShadowOffset-1-Pen.Width;
  h := Height-ShadowOffset-1-Pen.Width;

  if not Shadow then begin
    Inc(w,ShadowOffset);
    Inc(h,ShadowOffset);
  end;

  if Pen.Width = 0 then begin
    Dec(w);
    Dec(h);
  end;

  if CalcPoly(Points,POLY_TRIANGLE_D,w,h) then begin
    OffsetPoly(Points,l,t);
    Canvas.Polygon(Points);
  end;
end;


//============================= TplTriangleShapeL ============================================

procedure TplTriangleShapeL.PaintShadow;
var Points  : Array[0..3] of TPoint;
    l,t,w,h : Integer;
begin
  inherited PaintShadow;

  { Calc the new coordinates for the current width and height }
  l := Pen.Width div 2;
  t := l;
  w := Width-ShadowOffset-1-Pen.Width;
  h := Height-ShadowOffset-1-Pen.Width;

  if Pen.Width = 0 then begin
    Dec(w);
    Dec(h);
  end;

  if CalcPoly(Points,POLY_TRIANGLE_L,w,h) then begin
    OffsetPoly(Points,l+ShadowOffset,t+ShadowOffset);
    Canvas.Polygon(Points);
  end;
end;

procedure TplTriangleShapeL.PaintShape;
var Points  : Array[0..3] of TPoint;
    l,t,w,h : Integer;
begin
  inherited PaintShape;

  { Calc the new coordinates for the current width and height }
  l := Pen.Width div 2;
  t := l;
  w := Width-ShadowOffset-1-Pen.Width;
  h := Height-ShadowOffset-1-Pen.Width;

  if not Shadow then begin
    Inc(w,ShadowOffset);
    Inc(h,ShadowOffset);
  end;

  if Pen.Width = 0 then begin
    Dec(w);
    Dec(h);
  end;

  if CalcPoly(Points,POLY_TRIANGLE_L,w,h) then begin
    OffsetPoly(Points,l,t);
    Canvas.Polygon(Points);
  end;
end;
