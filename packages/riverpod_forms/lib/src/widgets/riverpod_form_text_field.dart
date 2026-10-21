import 'package:flutter/material.dart';
import 'package:riverpod_forms/src/models/riverpod_form.dart';
import 'package:riverpod_forms/src/models/validation_result.dart';
import 'package:riverpod_forms/src/widgets/riverpod_form_field_builder.dart';

class RiverpodFormTextField<E> extends StatelessWidget {
  final FormSingleValueProxy<String, E> valueProxy;
  final String Function(E)? errorMapping;
  final InputDecoration? decoration;

  const RiverpodFormTextField({
    super.key,
    required this.valueProxy,
    this.errorMapping,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) => RiverpodFormFieldBuilder<String, E>(
    valueProxy: valueProxy,
    builder: (context, state, setValue) => _RiverpodText<E>(
      state: state,
      setValue: setValue,
      errorMapping: errorMapping,
      decoration: decoration,
    ),
  );
}

class _RiverpodText<E> extends RiverpodFormFieldHandler<String, E> {
  final String Function(E)? errorMapping;
  final InputDecoration? decoration;

  const _RiverpodText({
    super.key,
    required super.state,
    required super.setValue,
    this.errorMapping,
    this.decoration,
  });

  @override
  State<StatefulWidget> createState() => _RiverpodTextState<E>();
}

class _RiverpodTextState<E> extends State<_RiverpodText<E>> {
  late final TextEditingController controller = TextEditingController(
    text: widget.state.value,
  );

  @override
  void didUpdateWidget(covariant _RiverpodText<E> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.state.value != widget.state.value &&
        widget.state.value != null) {
      controller.value = TextEditingValue(
        text: widget.state.value!,
        selection: TextSelection.collapsed(offset: widget.state.value!.length),
        composing: TextRange.empty,
      );
    }
  }

  @override
  Widget build(BuildContext context) => TextField(
    controller: controller,
    onChanged: widget.setValue,
    decoration: (widget.decoration ?? InputDecoration()).copyWith(
      suffix: switch (widget.state.error) {
        ValidationInProgress<E>() => const CircularProgressIndicator(
          constraints: BoxConstraints.tightFor(width: 16, height: 16),
        ),
        _ => null,
      },
      errorText: widget.state.isDirty
          ? switch (widget.state.error) {
              ValidationInProgress<E>() => null,
              ValidationSuccess<E>() => null,
              ValidationFailed<E>(:final failure) => switch (failure) {
                ValidationFailure<E>(:final error) =>
                  widget.errorMapping?.call(error) ?? '',
                ValidationException<E>() => 'Validation failed',
              },
            }
          : null,
    ),
  );
}
