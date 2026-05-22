import { drawing } from '@kit.ArkGraphics2D';

export interface DialPalette {
  id: string;
  title: string;
  useGradient?: boolean;
  gradientColors?: number[];
  gradientStops?: number[];
  outerColor: number;
  middleColor: number;
  innerColor: number;
  bezelColor: number;
  tickColor: number;
  minuteColor: number;
  hourColor: number;
  secondColor: number;
  centerColor: number;
}

export interface HandStyle {
  id: string;
  title: string;
  capStyle: drawing.CapStyle;
  joinStyle: drawing.JoinStyle;
  hourWidth: number;
  minuteWidth: number;
  secondWidth: number;
}

export interface TickStyle {
  id: string;
  title: string;
  majorLength: number;
  minorLength: number;
}

export interface WatchFaceTime {
  hourAngle: number;
  minuteAngle: number;
  secondAngle: number;
}
