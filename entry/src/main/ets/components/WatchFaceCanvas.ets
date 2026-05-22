import display from '@ohos.display';
import { CircleShape } from '@kit.ArkUI';
import {
  DIAL_PALETTES,
  HAND_STYLES,
  TICK_STYLES
} from '../constants/WatchFaceConstants';
import { DialPalette, HandStyle, TickStyle, WatchFaceTime } from '../model/WatchFaceModel';
import { WatchFacePainter } from '../services/WatchFacePainter';
import { createWatchFaceTime } from '../services/WatchTimeService';

@Component
export struct WatchFaceCanvas {
  private themeIndex: number = 0;
  private time: WatchFaceTime = createWatchFaceTime(Date.now());
  private readonly renderingContext: DrawingRenderingContext = new DrawingRenderingContext();
  private readonly painter: WatchFacePainter = new WatchFacePainter();
  private timerId: number = 0;
  private canvasPx: number = 0;

  aboutToAppear(): void {
    try {
      const d = display.getDefaultDisplaySync();
      this.canvasPx = Math.min(d.width, d.height);
    } catch (error) {
      this.canvasPx = 0;
    }
    this.refreshTime();
    this.timerId = setInterval(() => {
      this.refreshTime();
    }, 1000);
  }

  aboutToDisappear(): void {
    if (this.timerId !== 0) {
      clearInterval(this.timerId);
      this.timerId = 0;
    }
  }

  build() {
    Column() {
      Canvas(this.renderingContext)
        .width('100%')
        .height('100%')
        .clipShape(new CircleShape({ width: '100%', height: '100%' }))
        .onReady(() => {
          this.paintFace();
        })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#05070A')
    .onClick(() => {
      this.themeIndex = (this.themeIndex + 1) % DIAL_PALETTES.length;
      this.paintFace();
    })
  }

  private refreshTime(): void {
    this.time = createWatchFaceTime(Date.now());
    this.paintFace();
  }

  private paintFace(): void {
    const size: number = this.canvasPx > 0 ? this.canvasPx : this.renderingContext.size.width;
    if (size <= 0) {
      return;
    }
    const canvas = this.renderingContext.canvas;
    if (!canvas) {
      return;
    }
    this.painter.paint(
      canvas,
      size,
      size,
      this.currentPalette(),
      this.currentHandStyle(),
      this.currentTickStyle(),
      this.time
    );
    this.renderingContext.invalidate();
  }

  private currentPalette(): DialPalette {
    return DIAL_PALETTES[this.themeIndex];
  }

  private currentHandStyle(): HandStyle {
    return HAND_STYLES[this.themeIndex];
  }

  private currentTickStyle(): TickStyle {
    return TICK_STYLES[this.themeIndex];
  }
}
