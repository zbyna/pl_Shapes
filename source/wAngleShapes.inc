
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

//============================= TplRectangleShape ============================================

procedure TplRectangleShape.PaintShadow;
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

  if CalcPoly(Points,POLY_RECTANGLE,w,h) then begin
    OffsetPoly(Points,l+ShadowOffset,t+ShadowOffset);
    Canvas.Polygon(Points);
  end;
end;

procedure TplRectangleShape.PaintShape;
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

  if CalcPoly(Points,POLY_RECTANGLE,w,h) then begin
    OffsetPoly(Points,l,t);
    Canvas.Polygon(Points);
  end;
end;

//====================== TplParallelogramShape ===========================================
procedure TplParallelogramShape.PaintShadow;
var Points  : Array[0..4] of TPoint;
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

  if CalcPoly(Points,POLY_PARALLELOGRAM,w,h) then begin
    OffsetPoly(Points,l+ShadowOffset,t+ShadowOffset);
    Canvas.Polygon(Points);
  end;
end;

procedure TplParallelogramShape.PaintShape;
var Points  : Array[0..4] of TPoint;
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

  if CalcPoly(Points,POLY_PARALLELOGRAM,w,h) then begin
    OffsetPoly(Points,l,t);
    Canvas.Polygon(Points);
  end;
end;

//================= TplTrapezoidShape =========================================
procedure TplTrapezoidShape.PaintShadow;
var Points  : Array[0..4] of TPoint;
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

  if CalcPoly(Points,POLY_TRAPEZOID,w,h) then begin
    OffsetPoly(Points,l+ShadowOffset,t+ShadowOffset);
    Canvas.Polygon(Points);
  end;
end;

procedure TplTrapezoidShape.PaintShape;
var Points  : Array[0..4] of TPoint;
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

  if CalcPoly(Points,POLY_TRAPEZOID,w,h) then begin
    OffsetPoly(Points,l,t);
    Canvas.Polygon(Points);
  end;
end;

//======================= TplPentagonShape ========================================
procedure TplPentagonShape.PaintShadow;
var Points  : Array[0..5] of TPoint;
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

  if CalcPoly(Points,POLY_PENTAGON,w,h) then begin
    OffsetPoly(Points,l+ShadowOffset,t+ShadowOffset);
    Canvas.Polygon(Points);
  end;
end;

procedure TplPentagonShape.PaintShape;
var Points  : Array[0..5] of TPoint;
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

  if CalcPoly(Points,POLY_PENTAGON,w,h) then begin
    OffsetPoly(Points,l,t);
    Canvas.Polygon(Points);
  end;
end;

//======================== TplHexagonShape ===============================================
procedure TplHexagonShape.PaintShadow;
var Points  : Array[0..6] of TPoint;
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

  if CalcPoly(Points,POLY_HEXAGON,w,h) then begin
    OffsetPoly(Points,l+ShadowOffset,t+ShadowOffset);
    Canvas.Polygon(Points);
  end;
end;

procedure TplHexagonShape.PaintShape;
var Points  : Array[0..6] of TPoint;
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

  if CalcPoly(Points,POLY_HEXAGON,w,h) then begin
    OffsetPoly(Points,l,t);
    Canvas.Polygon(Points);
  end;
end;

//==================== TplOctagonShape ===========================================
procedure TplOctagonShape.PaintShadow;
var Points  : Array[0..8] of TPoint;
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

  if CalcPoly(Points,POLY_OCTAGON,w,h) then begin
    OffsetPoly(Points,l+ShadowOffset,t+ShadowOffset);
    Canvas.Polygon(Points);
  end;
end;

procedure TplOctagonShape.PaintShape;
var Points  : Array[0..8] of TPoint;
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

  if CalcPoly(Points,POLY_OCTAGON,w,h) then begin
    OffsetPoly(Points,l,t);
    Canvas.Polygon(Points);
  end;
end;

//================= TplStarShape =========================================
procedure TplStarShape.PaintShadow;
var Points  : Array[0..16] of TPoint;
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

  if CalcPoly(Points,POLY_STAR,w,h) then begin
    OffsetPoly(Points,l+ShadowOffset,t+ShadowOffset);
    Canvas.Polygon(Points);
  end;
end;

procedure TplStarShape.PaintShape;
var Points  : Array[0..16] of TPoint;
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

  if CalcPoly(Points,POLY_STAR,w,h) then begin
    OffsetPoly(Points,l,t);
    Canvas.Polygon(Points);
  end;
end;

//===================== TplBubbleShape =========================================
procedure TplBubbleShape.PaintShadow;
var Points  : Array[0..11] of TPoint;
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

  if CalcPoly(Points,POLY_BUBBLE,w,h) then begin
    OffsetPoly(Points,l+ShadowOffset,t+ShadowOffset);
    Canvas.Polygon(Points);
  end;
end;

procedure TplBubbleShape.PaintShape;
var Points  : Array[0..11] of TPoint;
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

  if CalcPoly(Points,POLY_BUBBLE,w,h) then begin
    OffsetPoly(Points,l,t);
    Canvas.Polygon(Points);
  end;
end;      
