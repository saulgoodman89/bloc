part of 'timer_bloc.dart';

sealed class TimerEvent {
  const TimerEvent();
}

/*
    확실히 변경되지 않은 값들을 다루므로 클래스를 final로 선언하여 상속으로 인한 변경을 방지.
 */
final class TimerStarted extends TimerEvent {
  const TimerStarted({required this.duration});
  final int duration;
}

final class TimerPaused extends TimerEvent {
  const TimerPaused();
}

final class TimerResumed extends TimerEvent {
  const TimerResumed();
}

class TimerReset extends TimerEvent {
  const TimerReset();
}

class _TimerTicked extends TimerEvent {
  const _TimerTicked({required this.duration});
  final int duration;
}
