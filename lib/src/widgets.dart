import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

typedef ValueWidgetListener<T> = void Function(BuildContext context, T value);

typedef ValueWidgetWhen<T> = bool Function(T previous, T current);

class LessBuilder<T> extends StatefulWidget {
  const LessBuilder({
    super.key,
    required this.valueListenable,
    this.fireImmediately = false,
    required this.builder,
    this.canBuild,
    this.child,
  });

  final ValueListenable<T> valueListenable;
  final ValueWidgetBuilder<T> builder;
  final ValueWidgetWhen<T>? canBuild;
  final bool fireImmediately;
  final Widget? child;

  @override
  State<StatefulWidget> createState() => _LessBuilderState<T>();
}

class _LessBuilderState<T> extends State<LessBuilder<T>> {
  late T value;

  @override
  void initState() {
    super.initState();
    value = widget.valueListenable.value;
    if (widget.fireImmediately) _valueChanged();
    widget.valueListenable.addListener(_valueChanged);
  }

  @override
  void didUpdateWidget(LessBuilder<T> oldWidget) {
    if (oldWidget.valueListenable != widget.valueListenable) {
      oldWidget.valueListenable.removeListener(_valueChanged);
      value = widget.valueListenable.value;
      widget.valueListenable.addListener(_valueChanged);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    widget.valueListenable.removeListener(_valueChanged);
    super.dispose();
  }

  bool _canListen() {
    final canListen = widget.canBuild?.call(value, widget.valueListenable.value);
    return canListen == null || canListen;
  }

  void _valueChanged() {
    if (_canListen()) setState(() => value = widget.valueListenable.value);
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, value, widget.child);
}

class LessListener<T> extends StatefulWidget {
  const LessListener({
    super.key,
    required this.valueListenable,
    this.fireImmediately = false,
    required this.listener,
    required this.child,
    this.canListen,
  });

  final ValueListenable<T> valueListenable;
  final ValueWidgetListener<T> listener;
  final ValueWidgetWhen<T>? canListen;
  final bool fireImmediately;
  final Widget child;

  @override
  State<StatefulWidget> createState() => _LessListenerState<T>();
}

class _LessListenerState<T> extends State<LessListener<T>> {
  late T value;

  @override
  void initState() {
    super.initState();
    value = widget.valueListenable.value;
    if (widget.fireImmediately) _valueChanged();
    widget.valueListenable.addListener(_valueChanged);
  }

  @override
  void didUpdateWidget(LessListener<T> oldWidget) {
    if (oldWidget.valueListenable != widget.valueListenable) {
      oldWidget.valueListenable.removeListener(_valueChanged);
      value = widget.valueListenable.value;
      widget.valueListenable.addListener(_valueChanged);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    widget.valueListenable.removeListener(_valueChanged);
    super.dispose();
  }

  bool _canListen() {
    final canListen = widget.canListen?.call(value, widget.valueListenable.value);
    return canListen == null || canListen;
  }

  void _valueChanged() {
    if (_canListen()) widget.listener(context, value);
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

class LessConsumer<T> extends StatelessWidget {
  const LessConsumer({
    super.key,
    required this.valueListenable,
    this.fireImmediately = false,
    required this.listener,
    required this.builder,
    this.canListen,
    this.canBuild,
    this.child,
  });

  final ValueListenable<T> valueListenable;
  final ValueWidgetListener<T> listener;
  final ValueWidgetWhen<T>? canListen;
  final ValueWidgetWhen<T>? canBuild;
  final ValueWidgetBuilder<T> builder;
  final bool fireImmediately;

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return LessListener<T>(
      valueListenable: valueListenable,
      canListen: canListen,
      fireImmediately: fireImmediately,
      listener: listener,
      child: LessBuilder<T>(
        valueListenable: valueListenable,
        canBuild: canBuild,
        builder: builder,
        child: child,
      ),
    );
  }
}
