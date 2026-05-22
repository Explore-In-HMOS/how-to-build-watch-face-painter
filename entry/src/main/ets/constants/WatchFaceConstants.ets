import { drawing } from '@kit.ArkGraphics2D';
import { DialPalette, HandStyle, TickStyle } from '../model/WatchFaceModel';

export const WATCH_FACE_TITLE: string = 'Watch Face Painter';

export const DIAL_PALETTES: DialPalette[] = [
  {
    id: 'aurora',
    title: 'Aurora',
    useGradient: true,
    gradientColors: [0xFF43D5B0, 0xFF36BCA5, 0xFF1D7770, 0xFF104047, 0xFF0A111F],
    gradientStops: [0.0, 0.28, 0.52, 0.74, 1.0],
    outerColor: 0xFF0A111F,
    middleColor: 0xFF104047,
    innerColor: 0xFF43D5B0,
    bezelColor: 0xFFE8F7FF,
    tickColor: 0xFFE6FFF7,
    minuteColor: 0xFFFFFFFF,
    hourColor: 0xFFF5D36D,
    secondColor: 0xFFFF6D7A,
    centerColor: 0xFFFFFFFF
  },
  {
    id: 'ember',
    title: 'Ember',
    outerColor: 0xFF101014,
    middleColor: 0xFF6E2334,
    innerColor: 0xFFF0A15C,
    bezelColor: 0xFFFFE8C8,
    tickColor: 0xFFFFF2DD,
    minuteColor: 0xFFFFFFFF,
    hourColor: 0xFFFFCF75,
    secondColor: 0xFF49D8FF,
    centerColor: 0xFFFFF2DD
  },
  {
    id: 'mono',
    title: 'Mono',
    outerColor: 0xFF101418,
    middleColor: 0xFF313B45,
    innerColor: 0xFFCCD8E2,
    bezelColor: 0xFFF8FAFC,
    tickColor: 0xFFF8FAFC,
    minuteColor: 0xFFFFFFFF,
    hourColor: 0xFFD7E0EA,
    secondColor: 0xFFFF4D4D,
    centerColor: 0xFFFFFFFF
  }
];

export const HAND_STYLES: HandStyle[] = [
  {
    id: 'round',
    title: 'Round',
    capStyle: drawing.CapStyle.ROUND_CAP,
    joinStyle: drawing.JoinStyle.ROUND_JOIN,
    hourWidth: 9,
    minuteWidth: 6,
    secondWidth: 3
  },
  {
    id: 'square',
    title: 'Square',
    capStyle: drawing.CapStyle.SQUARE_CAP,
    joinStyle: drawing.JoinStyle.BEVEL_JOIN,
    hourWidth: 8,
    minuteWidth: 5,
    secondWidth: 2
  },
  {
    id: 'flat',
    title: 'Flat',
    capStyle: drawing.CapStyle.FLAT_CAP,
    joinStyle: drawing.JoinStyle.MITER_JOIN,
    hourWidth: 10,
    minuteWidth: 4,
    secondWidth: 2
  }
];

export const TICK_STYLES: TickStyle[] = [
  {
    id: 'classic',
    title: 'Classic',
    majorLength: 18,
    minorLength: 9
  },
  {
    id: 'bold',
    title: 'Bold',
    majorLength: 24,
    minorLength: 12
  },
  {
    id: 'minimal',
    title: 'Minimal',
    majorLength: 14,
    minorLength: 6
  }
];
