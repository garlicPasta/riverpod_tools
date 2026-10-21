import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_forms/src/models/form_multiple_value_proxy.dart';
import 'package:riverpod_forms/src/models/riverpod_form_value_state.dart';

typedef RiverpodFormMultiFieldBuilderCallback<VALUE, ERROR> = Widget Function(
  BuildContext context,
  FormMultipleValueState<VALUE, ERROR> state,
  void Function(List<VALUE>? value) setValue,
);

class RiverpodFormMultiFieldBuilder<VAlUE, ERROR> extends ConsumerWidget {
  final FormMultipleValueProxy<VAlUE, ERROR> valueProxy;

  final Widget Function(
    BuildContext context,
    FormMultipleValueState<VAlUE, ERROR> formValueState,
    void Function(List<VAlUE>? value) setValue,
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

abstract class RiverpodFormMultiFieldHandler<VALUE, ERROR> extends StatefulWidget {
  final FormMultipleValueState<VALUE, ERROR> state;
  final void Function(List<VALUE>? value) setValue;

  const RiverpodFormMultiFieldHandler({
    super.key,
    required this.state,
    required this.setValue,
  });
}
