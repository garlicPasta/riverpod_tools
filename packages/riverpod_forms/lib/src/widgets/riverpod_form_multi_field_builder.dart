import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_forms/src/models/form_multiple_value.dart';
import 'package:riverpod_forms/src/models/form_value_state.dart';

class FormListSetter<VALUE>(
  final void Function(List<VALUE> value) setValue,
  final void Function(VALUE value) addValue,
  final void Function(VALUE value) removeValue,
  final void Function() clear,
);

class RiverpodFormMultiFieldBuilder<VALUE, ERROR> extends ConsumerWidget {
  final MultiFormValue<VALUE, ERROR> valueProxy;

  final Widget Function(
    BuildContext context,
    FormMultipleValueState<VALUE, ERROR> formValueState,
    FormListSetter<VALUE> setter,
  )
  builder;

  const RiverpodFormMultiFieldBuilder({
    super.key,
    required this.valueProxy,
    required this.builder,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = valueProxy.watchW(ref);
    if (!state.isVisible) {
      return const SizedBox.shrink();
    }
    return builder(
      context,
      state,
      FormListSetter(
        valueProxy.setValue,
        valueProxy.addValue,
        valueProxy.removeValue,
        valueProxy.clear,
      ),
    );
  }
}

abstract class RiverpodFormMultiFieldHandler<VALUE, ERROR>
    extends StatefulWidget {
  final FormMultipleValueState<VALUE, ERROR> state;
  final FormListSetter<VALUE> setter;

  const RiverpodFormMultiFieldHandler({
    super.key,
    required this.state,
    required this.setter,
  });
}
