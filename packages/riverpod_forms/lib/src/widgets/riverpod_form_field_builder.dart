import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_forms/src/models/riverpod_form.dart';
import 'package:riverpod_forms/src/models/riverpod_form_value_state.dart';

typedef RiverpodFormFieldBuilderCallback<VALUE, ERROR> = Widget Function(
  BuildContext context,
  FormMultiValueState<VALUE, ERROR> state,
  void Function(VALUE? value) setValue,
);

class RiverpodFormFieldBuilder<VAlUE, ERROR> extends ConsumerWidget {
  final FormValueProxy<VAlUE, ERROR, FormMultiValueState<VAlUE, ERROR>>
  valueProxy;

  final Widget Function(
    BuildContext context,
    FormMultiValueState<VAlUE, ERROR> state,
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
    FormMultiValueState<VAlUE, ERROR> state = valueProxy.watchW(ref);
    return builder(context, state, valueProxy.setValue);
  }
}

abstract class RiverpodFormFieldHandler<VALUE, ERROR> extends StatefulWidget {
  final FormMultiValueState<VALUE, ERROR> state;
  final void Function(VALUE) setValue;

  const RiverpodFormFieldHandler({
    super.key,
    required this.state,
    required this.setValue,
  });
}
