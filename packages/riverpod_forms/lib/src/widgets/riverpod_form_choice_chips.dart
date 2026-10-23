import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_forms/src/models/riverpod_form.dart';
import 'package:riverpod_forms/src/utils/functional_helpers.dart';
import 'package:riverpod_forms/src/widgets/riverpod_form_field_builder.dart';

class RiverpodFormChoiceChips<VALUE, E> extends StatelessWidget {
  final SingleFormValue<VALUE, E> valueProxy;
  final String Function(E)? errorMapping;
  final String Function(VALUE)? labelMapping;

  const RiverpodFormChoiceChips({
    super.key,
    required this.valueProxy,
    this.errorMapping,
    this.labelMapping,
  });

  @override
  Widget build(BuildContext context) => RiverpodFormFieldBuilder<VALUE, E>(
    valueProxy: valueProxy,
    builder: (context, state, setValue) => _RiverpodChoiceChips<VALUE, E>(
      state: state,
      setValue: setValue,
      errorMapping: errorMapping,
      labelMapping: labelMapping!,
    ),
  );
}

class _RiverpodChoiceChips<VALUE, E>
    extends RiverpodFormFieldHandler<VALUE, E> {
  final String Function(E)? errorMapping;
  final String Function(VALUE) labelMapping;

  const _RiverpodChoiceChips({
    super.key,
    required super.state,
    required super.setValue,
    required this.labelMapping,
    this.errorMapping,
  });

  @override
  State<StatefulWidget> createState() => _RiverpodChoiceChipsState<VALUE, E>();
}

class _RiverpodChoiceChipsState<VALUE, E>
    extends State<_RiverpodChoiceChips<VALUE, E>> {
  @override
  void didUpdateWidget(covariant _RiverpodChoiceChips<VALUE, E> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.state.value != widget.state.value &&
        widget.state.value != null) {}
  }

  @override
  Widget build(BuildContext context) => widget.state.values!.when(
    error: (err, st) => Text('Error: $err'),
    loading: () => CircularProgressIndicator(),
    data: (values) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Wrap(
          spacing: 4,
          children: values.map((v) {
            final selected = widget.state.value == v;
            return ChoiceChip(
              label: Text(widget.labelMapping(v)),
              onSelected: (isSelect) {
                if (isSelect) {
                  widget.setValue(v);
                }
              },
              selected: selected,
            );
          }).toList(),
        ),
        whenNull(
          widget.state.error?.error,
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
