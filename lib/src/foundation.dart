import 'package:flutter/foundation.dart';

abstract class LessNotifier<T> extends ValueNotifier<T> {
  LessNotifier(super.value);

  Future<void> handle(LessEvent event) => event.execute(this);
}

abstract class LessEvent<T extends LessNotifier> {
  const LessEvent();

  Future<void> execute(T service);
}
