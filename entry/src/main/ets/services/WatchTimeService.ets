import { WatchFaceTime } from '../model/WatchFaceModel';

export function createWatchFaceTime(timestamp: number): WatchFaceTime {
  const now: Date = new Date(timestamp);
  const seconds: number = now.getSeconds();
  const minutes: number = now.getMinutes();
  const hours: number = now.getHours() % 12;
  const secondAngle: number = seconds * 6 - 90;
  const minuteAngle: number = (minutes + seconds / 60) * 6 - 90;
  const hourAngle: number = (hours + minutes / 60) * 30 - 90;

  return {
    hourAngle: hourAngle,
    minuteAngle: minuteAngle,
    secondAngle: secondAngle
  };
}
