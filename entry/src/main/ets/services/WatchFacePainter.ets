import { common2D, drawing } from '@kit.ArkGraphics2D';
import { DialPalette, HandStyle, TickStyle, WatchFaceTime } from '../model/WatchFaceModel';

const DEG_TO_RAD: number = Math.PI / 180;
const FULL_CIRCLE_DEGREES: number = 360;
const MINUTE_MARKS: number = 60;

export class WatchFacePainter {
  paint(
    canvas: drawing.Canvas,
    width: number,
    height: number,
    palette: DialPalette,
    handStyle: HandStyle,
    tickStyle: TickStyle,
    time: WatchFaceTime
  ): void {
    const side: number = Math.min(width, height);
    const centerX: number = width / 2;
    const centerY: number = height / 2;
    const radius: number = side * 0.47;
    this.drawBackground(canvas, width, height);
    this.drawDial(canvas, centerX, centerY, radius, palette);
    this.drawBezel(canvas, centerX, centerY, radius, palette);
    this.drawTicks(canvas, centerX, centerY, radius, palette, tickStyle);
    this.drawHands(canvas, centerX, centerY, radius, palette, handStyle, time);
  }

  private drawBackground(canvas: drawing.Canvas, width: number, height: number): void {
    const brush: drawing.Brush = new drawing.Brush();
    brush.setAntiAlias(true);
    brush.setColor(0xFF05070A);
    canvas.attachBrush(brush);
    const rect: common2D.Rect = { left: 0, top: 0, right: width, bottom: height };
    canvas.drawRect(rect);
    canvas.detachBrush();
  }

  private drawDial(
    canvas: drawing.Canvas,
    centerX: number,
    centerY: number,
    radius: number,
    palette: DialPalette
  ): void {
    const brush: drawing.Brush = new drawing.Brush();
    brush.setAntiAlias(true);
    if (palette.useGradient === true) {
      const gradientColors: number[] =
        palette.gradientColors ?? [palette.innerColor, palette.middleColor, palette.outerColor];
      const gradientStops: number[] = palette.gradientStops ?? [0.0, 0.58, 1.0];
      const shader: drawing.ShaderEffect = drawing.ShaderEffect.createRadialGradient(
        { x: centerX, y: centerY },
        radius,
        gradientColors,
        drawing.TileMode.CLAMP,
        gradientStops,
        null
      );
      brush.setShaderEffect(shader);
      canvas.attachBrush(brush);
      canvas.drawCircle(centerX, centerY, radius);
      canvas.detachBrush();
      return;
    }

    const colors: number[] = [palette.outerColor, palette.middleColor, palette.innerColor];
    const radii: number[] = [radius, radius * 0.82, radius * 0.58];
    for (let layer: number = 0; layer < colors.length; layer++) {
      brush.setColor(colors[layer]);
      canvas.attachBrush(brush);
      canvas.drawCircle(centerX, centerY, radii[layer]);
      canvas.detachBrush();
    }
  }

  private drawBezel(
    canvas: drawing.Canvas,
    centerX: number,
    centerY: number,
    radius: number,
    palette: DialPalette
  ): void {
    const inset: number = radius * 0.97;
    const rect: common2D.Rect = {
      left: centerX - inset,
      top: centerY - inset,
      right: centerX + inset,
      bottom: centerY + inset
    };
    const roundRect: drawing.RoundRect = new drawing.RoundRect(rect, inset, inset);
    const pen: drawing.Pen = this.createPen(
      palette.bezelColor,
      5,
      drawing.CapStyle.ROUND_CAP,
      drawing.JoinStyle.ROUND_JOIN
    );
    canvas.attachPen(pen);
    canvas.drawRoundRect(roundRect);
    canvas.detachPen();
  }

  private drawTicks(
    canvas: drawing.Canvas,
    centerX: number,
    centerY: number,
    radius: number,
    palette: DialPalette,
    tickStyle: TickStyle
  ): void {
    const pen: drawing.Pen = this.createPen(
      palette.tickColor,
      3,
      drawing.CapStyle.ROUND_CAP,
      drawing.JoinStyle.ROUND_JOIN
    );
    canvas.attachPen(pen);
    for (let mark: number = 0; mark < MINUTE_MARKS; mark++) {
      const angle: number = mark * FULL_CIRCLE_DEGREES / MINUTE_MARKS - 90;
      const length: number = mark % 5 === 0 ? tickStyle.majorLength : tickStyle.minorLength;
      const width: number = mark % 5 === 0 ? 4 : 2;
      pen.setStrokeWidth(width);
      this.drawRadialLine(canvas, centerX, centerY, radius - length, radius - 4, angle);
    }
    canvas.detachPen();
  }

  private drawHands(
    canvas: drawing.Canvas,
    centerX: number,
    centerY: number,
    radius: number,
    palette: DialPalette,
    handStyle: HandStyle,
    time: WatchFaceTime
  ): void {
    const hourPen: drawing.Pen = this.createPen(
      palette.hourColor,
      handStyle.hourWidth,
      handStyle.capStyle,
      handStyle.joinStyle
    );
    const minutePen: drawing.Pen = this.createPen(
      palette.minuteColor,
      handStyle.minuteWidth,
      handStyle.capStyle,
      handStyle.joinStyle
    );
    const secondPen: drawing.Pen = this.createPen(
      palette.secondColor,
      handStyle.secondWidth,
      drawing.CapStyle.ROUND_CAP,
      handStyle.joinStyle
    );
    this.drawHand(canvas, centerX, centerY, radius * 0.44, handStyle.hourWidth, time.hourAngle, hourPen);
    this.drawHand(canvas, centerX, centerY, radius * 0.66, handStyle.minuteWidth, time.minuteAngle, minutePen);
    const secondTip = this.pointOnCircle(centerX, centerY, radius * 0.78, time.secondAngle);
    const secondPath: drawing.Path = new drawing.Path();
    secondPath.moveTo(centerX, centerY);
    secondPath.lineTo(secondTip.x, secondTip.y);
    canvas.attachPen(secondPen);
    canvas.drawPath(secondPath);
    canvas.detachPen();
    this.drawCurvedSecondTail(canvas, centerX, centerY, radius * 0.25, time.secondAngle, secondPen);
    this.drawCenterPin(canvas, centerX, centerY, radius, palette);
  }

  private drawHand(
    canvas: drawing.Canvas,
    centerX: number,
    centerY: number,
    length: number,
    halfBase: number,
    angle: number,
    pen: drawing.Pen
  ): void {
    const tip = this.pointOnCircle(centerX, centerY, length, angle);
    const leftBase = this.pointOnCircle(centerX, centerY, halfBase, angle + 90);
    const rightBase = this.pointOnCircle(centerX, centerY, halfBase, angle - 90);
    const path: drawing.Path = new drawing.Path();
    path.moveTo(leftBase.x, leftBase.y);
    path.lineTo(tip.x, tip.y);
    path.lineTo(rightBase.x, rightBase.y);
    path.close();
    canvas.attachPen(pen);
    canvas.drawPath(path);
    canvas.detachPen();
  }

  private drawCurvedSecondTail(
    canvas: drawing.Canvas,
    centerX: number,
    centerY: number,
    tailLength: number,
    secondAngle: number,
    pen: drawing.Pen
  ): void {
    canvas.save();
    canvas.rotate(secondAngle + 90, centerX, centerY);
    const bobR: number = tailLength * 0.24;
    const stemEndY: number = centerY + tailLength * 0.52;
    const path: drawing.Path = new drawing.Path();
    path.moveTo(centerX, centerY);
    path.lineTo(centerX, stemEndY);
    path.arcTo(
      centerX - bobR, stemEndY,
      centerX + bobR, centerY + tailLength,
      270, 330
    );
    canvas.attachPen(pen);
    canvas.drawPath(path);
    canvas.detachPen();
    canvas.restore();
  }

  private drawCenterPin(
    canvas: drawing.Canvas,
    centerX: number,
    centerY: number,
    radius: number,
    palette: DialPalette
  ): void {
    const brush: drawing.Brush = new drawing.Brush();
    brush.setAntiAlias(true);
    brush.setColor(palette.centerColor);
    canvas.attachBrush(brush);
    canvas.drawCircle(centerX, centerY, radius * 0.04);
    canvas.detachBrush();
  }

  private drawRadialLine(
    canvas: drawing.Canvas,
    centerX: number,
    centerY: number,
    innerRadius: number,
    outerRadius: number,
    angle: number
  ): void {
    const inner = this.pointOnCircle(centerX, centerY, innerRadius, angle);
    const outer = this.pointOnCircle(centerX, centerY, outerRadius, angle);
    const path: drawing.Path = new drawing.Path();
    path.moveTo(inner.x, inner.y);
    path.lineTo(outer.x, outer.y);
    canvas.drawPath(path);
  }

  private createPen(
    color: number,
    width: number,
    capStyle: drawing.CapStyle,
    joinStyle: drawing.JoinStyle
  ): drawing.Pen {
    const pen: drawing.Pen = new drawing.Pen();
    pen.setAntiAlias(true);
    pen.setColor(color);
    pen.setStrokeWidth(width);
    pen.setCapStyle(capStyle);
    pen.setJoinStyle(joinStyle);
    return pen;
  }

  private pointOnCircle(
    centerX: number,
    centerY: number,
    radius: number,
    angle: number
  ): common2D.Point {
    const radians: number = angle * DEG_TO_RAD;
    return {
      x: centerX + Math.cos(radians) * radius,
      y: centerY + Math.sin(radians) * radius
    };
  }
}
