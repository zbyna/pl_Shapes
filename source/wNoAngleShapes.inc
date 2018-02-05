
//======================================= TplRectShape =============================================
procedure TplRectShape.PaintShadow;
var rl,rt,rw,rh : Integer;
begin
  inherited PaintShadow;

  if Shadow then begin
    { Calc width and height of the shadow rectangle }
    rl := Pen.Width div 2+ShadowOffset;
    rt := Pen.Width div 2+ShadowOffset;

    rw := Width-ShadowOffset-Pen.Width+1;
    rh := Height-ShadowOffset-Pen.Width+1;

    if Pen.Width = 0 then begin
      Dec(rw);
      Dec(rh);
    end;

    { Draw the shadow rectangle }
    Canvas.Rectangle(rl,rt,rl+rw,rt+rh);
  end;
end;

procedure TplRectShape.PaintShape;
var rl,rt,rw,rh : Integer;
begin
  inherited PaintShape;

  { Calc the width and height of the rectangle }
  rl := Pen.Width div 2;
  rt := Pen.Width div 2;

  rw := Width-ShadowOffset-Pen.Width+1;
  rh := Height-ShadowOffset-Pen.Width+1;

  if not Shadow then begin
    Inc(rw,ShadowOffset);
    Inc(rh,ShadowOffset);
  end;

  if Pen.Width = 0 then begin
    Dec(rw);
    Dec(rh);
  end;

  { Paint the rectangle }
  Canvas.Rectangle(rl,rt,rl+rw,rt+rh);
end;

//=================================== TplRoundRectShape ============================================
procedure TplRoundRectShape.PaintShadow;
var rl,rt,rw,rh,r : Integer;
begin
  inherited PaintShadow;

  if Shadow then begin
    { Calc width and height of the shadow rectangle }
    rl := Pen.Width div 2+ShadowOffset;
    rt := Pen.Width div 2+ShadowOffset;

    rw := Width-ShadowOffset-Pen.Width+1;
    rh := Height-ShadowOffset-Pen.Width+1;

    if Pen.Width = 0 then begin
      Dec(rw);
      Dec(rh);
    end;

    if rw < rh then r := rw else r := rh;

    { Draw the shadow rectangle }
    Canvas.RoundRect(rl,rt,rl+rw,rt+rh,r div 4,r div 4);
  end;
end;

procedure TplRoundRectShape.PaintShape;
var rl,rt,rw,rh,r : Integer;
begin
  inherited PaintShape;

  { Calc the width and height of the rectangle }
  rl := Pen.Width div 2;
  rt := Pen.Width div 2;

  rw := Width-ShadowOffset-Pen.Width+1;
  rh := Height-ShadowOffset-Pen.Width+1;

  if not Shadow then begin
    Inc(rw,ShadowOffset);
    Inc(rh,ShadowOffset);
  end;

  if Pen.Width = 0 then begin
    Dec(rw);
    Dec(rh);
  end;

  if rw < rh then r := rw else r := rh;

  { Paint the rectangle }
  Canvas.RoundRect(rl,rt,rl+rw,rt+rh,r div 4,r div 4);
end;

//=========================== TplSquareShape ===============================================
procedure TplSquareShape.PaintShadow;
var rl,rt,rw,rh : Integer;
begin
  inherited PaintShadow;

  if Shadow then begin
    { Calc width and height of the shadow square }
    rl := Pen.Width div 2+ShadowOffset;
    rt := Pen.Width div 2+ShadowOffset;

    rw := Width-ShadowOffset-Pen.Width+1;
    rh := Height-ShadowOffset-Pen.Width+1;

    if Pen.Width = 0 then begin
      Dec(rw);
      Dec(rh);
    end;

    if rw > rh then
      rw := rh
    else
      rh := rw;

    { Draw the shadow square }
    Canvas.Rectangle(rl,rt,rl+rw,rt+rh);
  end;
end;

procedure TplSquareShape.PaintShape;
var rl,rt,rw,rh: Integer;
begin
  inherited PaintShape;

  { Calc the width and height of the square }
  rl := Pen.Width div 2;
  rt := Pen.Width div 2;

  rw := Width-ShadowOffset-Pen.Width+1;
  rh := Height-ShadowOffset-Pen.Width+1;

  if not Shadow then begin
    Inc(rw,ShadowOffset);
    Inc(rh,ShadowOffset);
  end;

  if Pen.Width = 0 then begin
    Dec(rw);
    Dec(rh);
  end;

  if rw > rh then
    rw := rh
  else
    rh := rw;

  { Paint the square }
  Canvas.Rectangle(rl,rt,rl+rw,rt+rh);
end;

//===================== TplRoundSquareShape ================================================
procedure TplRoundSquareShape.PaintShadow;
var rl,rt,rw,rh,r : Integer;
begin
  inherited PaintShadow;

  if Shadow then begin
    { Calc width and height of the shadow square }
    rl := Pen.Width div 2+ShadowOffset;
    rt := Pen.Width div 2+ShadowOffset;

    rw := Width-ShadowOffset-Pen.Width+1;
    rh := Height-ShadowOffset-Pen.Width+1;

    if Pen.Width = 0 then begin
      Dec(rw);
      Dec(rh);
    end;

    if rw > rh then begin
      rw := rh;
      r  := rh;
    end else begin
      rh := rw;
      r := rw;
    end;

    { Draw the shadow square }
    Canvas.RoundRect(rl,rt,rl+rw,rt+rh,r div 4,r div 4);
  end;
end;

procedure TplRoundSquareShape.PaintShape;
var rl,rt,rw,rh,r : Integer;
begin
  inherited PaintShape;

  { Calc the width and height of the square }
  rl := Pen.Width div 2;
  rt := Pen.Width div 2;

  rw := Width-ShadowOffset-Pen.Width+1;
  rh := Height-ShadowOffset-Pen.Width+1;

  if not Shadow then begin
    Inc(rw,ShadowOffset);
    Inc(rh,ShadowOffset);
  end;

  if Pen.Width = 0 then begin
    Dec(rw);
    Dec(rh);
  end;

  if rw > rh then begin
    rw := rh;
    r  := rh;
  end else begin
    rh := rw;
    r := rw;
  end;

  { Paint the square }
  Canvas.RoundRect(rl,rt,rl+rw,rt+rh,r div 4,r div 4);
end;

//===================== TplEllipseShape ========================================
procedure TplEllipseShape.PaintShadow;
var rl,rt,rw,rh : Integer;
begin
  inherited PaintShadow;

  if Shadow then begin
    { Calc width and height of the shadow ellipse }
    rl := Pen.Width div 2+ShadowOffset;
    rt := Pen.Width div 2+ShadowOffset;

    rw := Width-ShadowOffset-Pen.Width+1;
    rh := Height-ShadowOffset-Pen.Width+1;

    if Pen.Width = 0 then begin
      Dec(rw);
      Dec(rh);
    end;

    { Draw the shadow ellipse }
    Canvas.Ellipse(rl,rt,rl+rw,rt+rh);
  end;
end;

procedure TplEllipseShape.PaintShape;
var rl,rt,rw,rh : Integer;
begin
  inherited PaintShape;

  { Calc the width and height of the ellipse }
  rl := Pen.Width div 2;
  rt := Pen.Width div 2;

  rw := Width-ShadowOffset-Pen.Width+1;
  rh := Height-ShadowOffset-Pen.Width+1;

  if not Shadow then begin
    Inc(rw,ShadowOffset);
    Inc(rh,ShadowOffset);
  end;

  if Pen.Width = 0 then begin
    Dec(rw);
    Dec(rh);
  end;

  { Paint the ellipse }
  Canvas.Ellipse(rl,rt,rl+rw,rt+rh);
end;

//=========================== TplCircleShape =========================================
procedure TplCircleShape.PaintShadow;
var rl,rt,rw,rh : Integer;
begin
  inherited PaintShadow;

  if Shadow then begin
    { Calc width and height of the shadow Circle }
    rl := Pen.Width div 2+ShadowOffset;
    rt := Pen.Width div 2+ShadowOffset;

    rw := Width-ShadowOffset-Pen.Width+1;
    rh := Height-ShadowOffset-Pen.Width+1;

    if Pen.Width = 0 then begin
      Dec(rw);
      Dec(rh);
    end;

    if rw > rh then
      rw := rh
    else
      rh := rw;

    { Draw the shadow Circle }
    Canvas.Ellipse(rl,rt,rl+rw,rt+rh);
  end;
end;

procedure TplCircleShape.PaintShape;
var rl,rt,rw,rh: Integer;
begin
  inherited PaintShape;

  { Calc the width and height of the Circle }
  rl := Pen.Width div 2;
  rt := Pen.Width div 2;

  rw := Width-ShadowOffset-Pen.Width+1;
  rh := Height-ShadowOffset-Pen.Width+1;

  if not Shadow then begin
    Inc(rw,ShadowOffset);
    Inc(rh,ShadowOffset);
  end;

  if Pen.Width = 0 then begin
    Dec(rw);
    Dec(rh);
  end;

  if rw > rh then
    rw := rh
  else
    rh := rw;

  { Paint the Circle }
  Canvas.Ellipse(rl,rt,rl+rw,rt+rh);
end;
                            