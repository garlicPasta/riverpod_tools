import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_forms/riverpod_forms.dart';
import 'package:riverpod_forms/src/widgets/riverpod_form_multi_field_builder.dart';

class RiverpodFormMultiselectChips<T, E> extends StatelessWidget {
  final MultiFormValue<T, E> valueProxy;
  final String Function(E)? errorMapping;
  final String Function(T)? labelMapping;

  const RiverpodFormMultiselectChips({
    super.key,
    required this.valueProxy,
    this.errorMapping,
    this.labelMapping,
  });

  @override
  Widget build(BuildContext context) => RiverpodFormMultiFieldBuilder<T, E>(
    valueProxy: valueProxy,
    builder: (context, state, setValue) => _RiverpodChoiceChips<T, E>(
      errorMapping: errorMapping,
      labelMapping: labelMapping!,
      state: state,
      setValue: setValue,
    ),
  );
}

class _RiverpodChoiceChips<T, E> extends RiverpodFormMultiFieldHandler<T, E> {
  final String Function(E)? errorMapping;
  final String Function(T) labelMapping;

  const _RiverpodChoiceChips({
    super.key,
    required this.labelMapping,
    this.errorMapping,
    required super.state,
    required super.setValue,
  });

  @override
  State<StatefulWidget> createState() => _RiverpodChoiceChipsState<T, E>();
}

class _RiverpodChoiceChipsState<T, E>
    extends State<_RiverpodChoiceChips<T, E>> {
  @override
  void didUpdateWidget(covariant _RiverpodChoiceChips<T, E> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.state.value != widget.state.value &&
        widget.state.value != null) {}
  }

  @override
  Widget build(BuildContext context) => widget.state.values.when(
    error: (err, st) => Text('Error: $err'),
    loading: () => CircularProgressIndicator(),
    data: (values) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Wrap(
          spacing: 4,
          children: values.map((v) {
            final selected = widget.state.value?.contains(v) ?? false;
            return ChoiceChip(
              label: Text(widget.labelMapping(v)),
              onSelected: widget.state.isEnabled
                  ? (isSelect) {
                      final currentValue = widget.state.value ?? <T>[];
                      if (isSelect) {
                        if (!currentValue.contains(v)) {
                          widget.setValue([...currentValue, v]);
                        }
                        return;
                      }

                      widget.setValue(
                        currentValue.where((item) => item != v).toList(),
                      );
                    }
                  : null,
              selected: selected,
            );
          }).toList(),
        ),
        whenNull(
          widget.state.error.error,
          then: (value) => widget.state.isDirty
              ? Padding(
                  padding: const EdgeInsets.only(top: 8, left: 12, right: 12),
                  child: Text(
                    widget.errorMapping?.call(value) ?? '',
                    style:
                        Theme.of(context).inputDecorationTheme.errorStyle ??
                        TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                )
              : null,
        ),
      ].nonNulls.toList(),
    ),
  );
}
