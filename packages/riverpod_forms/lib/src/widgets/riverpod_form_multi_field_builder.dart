import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_forms/src/models/form_multiple_value_proxy.dart';
import 'package:riverpod_forms/src/models/riverpod_form_value_state.dart';

typedef RiverpodFormMultiFieldBuilderCallback<VALUE, ERROR> = Widget Function(
  BuildContext context,
  FormMultiValueState<VALUE, ERROR> state,
  void Function(List<VALUE>? value) setValue,
);

class RiverpodFormMultiFieldBuilder<VAlUE, ERROR> extends ConsumerWidget {
  final FormMultipleValueProxy<VAlUE, ERROR> valueProxy;

  final Widget Function(
    BuildContext context,
    FormMultiValueState<VAlUE, ERROR> state,
  )
  builder;

  const RiverpodFormMultiFieldBuilder({
    super.key,
    required this.valueProxy,
    required this.builder,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      builder(context, valueProxy.watchW(ref), valueProxy.setValue);
}

abstract class RiverpodFormFieldHandler<VALUE, ERROR> extends StatefulWidget {
  final FormMultiValueState<VALUE, ERROR> state;
  final void Function(List<VALUE>? value) setValue;

  const RiverpodFormFieldHandler({
    super.key,
    required this.state,
    required this.setValue,
  });
}
