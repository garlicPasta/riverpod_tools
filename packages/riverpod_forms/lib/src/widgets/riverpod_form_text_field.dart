import 'package:material_ui/material_ui.dart';
import 'package:riverpod_forms/riverpod_forms.dart';

class RiverpodFormTextField<ERR> extends StatelessWidget {
  final SingleFormValue<String, ERR> valueProxy;
  final ErrorMapper<ERR>? errorMapping;
  final InputDecoration? decoration;

  const RiverpodFormTextField({
    super.key,
    required this.valueProxy,
    this.errorMapping,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) => RiverpodFormFieldBuilder<String, ERR>(
    valueProxy: valueProxy,
    builder: (context, state, setValue) => _RiverpodText<ERR>(
      state: state,
      setValue: setValue,
      errorMapping: errorMapping,
      decoration: decoration,
    ),
  );
}

class _RiverpodText<E> extends RiverpodFormFieldHandler<String, E> {
  final ErrorMapper<E>? errorMapping;
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
    text: widget.state.initial.value ?? '',
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

    if (oldWidget.state.initial.value != widget.state.initial.value) {
      controller.text = widget.state.initial.value ?? '';
    }
  }

  Widget get loader => const CircularProgressIndicator(
    constraints: BoxConstraints.tightFor(width: 16, height: 16),
  );

  @override
  Widget build(BuildContext context) => TextField(
    enabled: widget.state.isEnabled && !widget.state.isInitializing,
    controller: controller,
    onChanged: widget.setValue,
    decoration: (widget.decoration ?? InputDecoration()).copyWith(
      suffix: switch (widget.state.error) {
        ValidationInProgress<E>() => loader,
        _ when widget.state.isInitializing => loader,
        _ => null,
      },
      errorText: (widget.state.isDirty)
          ? switch (widget.state.error) {
              ValidationInProgress<E>() => null,
              ValidationSuccess<E>() => null,
              ValidationFailed<E>(:final failure) => switch (failure) {
                ValidationFailure<E>(:final error) =>
                  widget.errorMapping?.call(context, error) ?? '',
                ValidationException<E>() => 'Validation failed',
              },
            }
          : null,
    ),
  );
}
