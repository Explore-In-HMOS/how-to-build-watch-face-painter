import { WatchFaceCanvas } from '../components/WatchFaceCanvas';

@Entry
@Component
struct Index {
  build() {
    Column() {
      WatchFaceCanvas()
        .width('100%')
        .height('100%');
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#05070A');
  }
}
