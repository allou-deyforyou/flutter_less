import 'package:flutter/foundation.dart';

class LessNotifier<T> extends ValueNotifier<T> {
  LessNotifier(super.value);
  Future<void> handle(LessEvent<T> event) => event.execute(this);
}

abstract class LessEvent<T> {
  const LessEvent();
  @protected
  Future<void> execute(LessNotifier<T> notifier);
}
