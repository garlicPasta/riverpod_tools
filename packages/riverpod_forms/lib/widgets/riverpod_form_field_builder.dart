import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_forms/models/riverpod_form.dart';

typedef RiverpodFormFieldBuilderCallback<VALUE, ERROR> = Widget Function(
  BuildContext context,
  FormSingleValueState<VALUE, ERROR> state,
  void Function(VALUE? value) setValue,
);

class RiverpodFormFieldBuilder<VAlUE, ERROR> extends ConsumerWidget {
  final FormValueProxy<VAlUE, ERROR> valueProxy;

  final Widget Function(
    BuildContext context,
    FormSingleValueState<VAlUE, ERROR> state,
    void Function(VAlUE? value) setValue,
  )
  builder;

  const RiverpodFormFieldBuilder({
    super.key,
    required this.valueProxy,
    required this.builder,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    FormSingleValueState<VAlUE, ERROR> state = valueProxy.watchW(ref);
    return builder(context, state, valueProxy.setValue);
  }
}

abstract class RiverpodFormFieldHandler<VALUE, ERROR> extends StatefulWidget {
  final FormSingleValueState<VALUE, ERROR> state;
  final void Function(VALUE) setValue;

  const RiverpodFormFieldHandler({
    super.key,
    required this.state,
    required this.setValue,
  });
}
