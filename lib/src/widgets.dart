import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

typedef ValueWidgetListener<T> = void Function(BuildContext context, T value);

typedef ValueWidgetWhen<T> = bool Function(T previous, T current);

class LessBuilder<T> extends StatefulWidget {
  const LessBuilder({
    Key? key,
    required this.valueListenable,
    required this.builder,
    this.initiated = false,
    required this.child,
    this.buildWhen,
  }) : super(key: key);

  final ValueListenable<T> valueListenable;
  final ValueWidgetWhen<T>? buildWhen;
  final ValueWidgetBuilder<T> builder;
  final bool initiated;
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
    if (widget.initiated) _valueChanged();
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
    final canListen = widget.buildWhen?.call(value, widget.valueListenable.value);
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
    Key? key,
    required this.valueListenable,
    required this.listener,
    this.initiated = false,
    required this.child,
    this.listenWhen,
  }) : super(key: key);

  final ValueListenable<T> valueListenable;
  final ValueWidgetListener<T> listener;
  final ValueWidgetWhen<T>? listenWhen;
  final bool initiated;
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
    if (widget.initiated) _valueChanged();
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
    final canListen = widget.listenWhen?.call(value, widget.valueListenable.value);
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
    Key? key,
    required this.valueListenable,
    this.initiated = false,
    required this.listener,
    required this.builder,
    this.listenWhen,
    this.buildWhen,
    this.child,
  }) : super(key: key);

  final ValueListenable<T> valueListenable;
  final ValueWidgetListener<T> listener;
  final ValueWidgetWhen<T>? listenWhen;
  final ValueWidgetWhen<T>? buildWhen;
  final ValueWidgetBuilder<T> builder;
  final bool initiated;

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return LessListener<T>(
      valueListenable: valueListenable,
      listenWhen: listenWhen,
      initiated: initiated,
      listener: listener,
      child: LessBuilder<T>(
        valueListenable: valueListenable,
        buildWhen: buildWhen,
        builder: builder,
        child: child,
      ),
    );
  }
}
