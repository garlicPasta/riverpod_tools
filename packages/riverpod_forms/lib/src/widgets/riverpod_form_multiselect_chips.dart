import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:riverpod_forms/riverpod_forms.dart';

class RiverpodFormMultiselectChips<T, E> extends StatelessWidget {
  final MultiFormValue<T, E, dynamic> valueProxy;
  final ErrorMapper<E>? errorMapping;
  final String Function(T)? labelMapping;

  const RiverpodFormMultiselectChips({
    super.key,
    required this.valueProxy,
    this.errorMapping,
    this.labelMapping,
  });

  @override
  Widget build(BuildContext context) =>
      RiverpodFormMultiFieldBuilder<T, E, dynamic>(
        valueProxy: valueProxy,
        builder: (context, state, setter) => _RiverpodChoiceChips<T, E>(
          errorMapping: errorMapping,
          labelMapping: labelMapping!,
          state: state,
          setter: setter,
        ),
      );
}

class _RiverpodChoiceChips<T, E>
    extends RiverpodFormMultiFieldHandler<T, E, dynamic> {
  final ErrorMapper<E>? errorMapping;
  final String Function(T) labelMapping;

  const _RiverpodChoiceChips({
    super.key,
    required this.labelMapping,
    this.errorMapping,
    required super.state,
    required super.setter,
  });

  @override
  State<StatefulWidget> createState() => _RiverpodChoiceChipsState<T, E>();
}

class _RiverpodChoiceChipsState<T, E>
    extends State<_RiverpodChoiceChips<T, E>> {
  @override
  void didUpdateWidget(covariant _RiverpodChoiceChips<T, E> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.state.value != widget.state.value) {}
  }

  @override
  Widget build(BuildContext context) => widget.state.options.when(
    error: (err, st) => Text('Error: $err'),
    loading: () => Center(
      child: const CircularProgressIndicator(
        constraints: BoxConstraints.tightFor(width: 16, height: 16),
      ),
    ),
    data: (values) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Wrap(
          spacing: 4,
          children: values.map((v) {
            final selected = widget.state.value.contains(v);
            return ChoiceChip(
              label: Text(widget.labelMapping(v)),
              onSelected: widget.state.isEnabled
                  ? (isSelect) {
                      final currentValue = widget.state.value;
                      if (isSelect) {
                        if (!currentValue.contains(v)) {
                          widget.setter.setValue([...currentValue, v]);
                        }
                        return;
                      }

                      widget.setter.setValue(
                        currentValue.where((item) => item != v).toList(),
                      );
                    }
                  : null,
              selected: selected,
            );
          }).toList(),
        ),
        notNull(
          widget.state.error.error,
          then: (value) => widget.state.isDirty
              ? Padding(
                  padding: const EdgeInsets.only(top: 8, left: 12, right: 12),
                  child: Text(
                    widget.errorMapping?.call(context, value) ?? '',
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
