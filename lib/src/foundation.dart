import 'package:flutter/foundation.dart';

class LessService<T> extends ValueNotifier<T> {
  LessService(super.value);
  void emit(T newValue) => value = newValue;
}
