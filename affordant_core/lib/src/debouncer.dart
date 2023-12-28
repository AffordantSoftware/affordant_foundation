import 'dart:async';

abstract interface class Debouncer {
  const Debouncer();

  factory Debouncer.duration(
    Duration duration,
  ) = TimerDebouncer;

  void debounce(void Function() delegate);
  FutureOr<void> dispose();
}

class TimerDebouncer implements Debouncer {
  TimerDebouncer(this.duration);

  final Duration duration;
  Timer? _timer;
  // U Function()? _delegate;

  @override
  void debounce(void Function() delegate) {
    _timer?.cancel();
    _timer = Timer(duration, delegate);
  }

  @override
  void dispose() {
    _timer?.cancel();
  }
}
