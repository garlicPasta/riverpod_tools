import 'package:material_ui/material_ui.dart';
import 'package:riverpod_forms/src/models/riverpod_form.dart';
import 'package:riverpod_forms/src/models/validation_result.dart';
import 'package:riverpod_forms/src/widgets/riverpod_form_field_builder.dart';

class RiverpodFormDateRangePicker<E> extends StatelessWidget {
  final SingleFormValue<DateTimeRange, E> valueProxy;
  final String Function(E)? errorMapping;
  final InputDecoration? decoration;
  final DateTime? firstDate;
  final DateTime? lastDate;

  /// Formats the selected range. Defaults to the localized compact dates.
  final String Function(BuildContext context, DateTimeRange range)? formatter;

  const RiverpodFormDateRangePicker({
    super.key,
    required this.valueProxy,
    this.errorMapping,
    this.decoration,
    this.firstDate,
    this.lastDate,
    this.formatter,
  });

  @override
  Widget build(BuildContext context) =>
      RiverpodFormFieldBuilder<DateTimeRange, E>(
        valueProxy: valueProxy,
        builder: (context, state, setValue) => _RiverpodDateRange<E>(
          state: state,
          setValue: setValue,
          errorMapping: errorMapping,
          decoration: decoration,
          firstDate: firstDate ?? DateTime(2000),
          lastDate: lastDate ?? DateTime(2100),
          formatter: formatter,
        ),
      );
}

class _RiverpodDateRange<E> extends RiverpodFormFieldHandler<DateTimeRange, E> {
  final String Function(E)? errorMapping;
  final InputDecoration? decoration;
  final DateTime firstDate;
  final DateTime lastDate;
  final String Function(BuildContext context, DateTimeRange range)? formatter;

  const _RiverpodDateRange({
    required super.state,
    required super.setValue,
    required this.firstDate,
    required this.lastDate,
    this.errorMapping,
    this.decoration,
    this.formatter,
  });

  @override
  State<StatefulWidget> createState() => _RiverpodDateRangeState<E>();
}

class _RiverpodDateRangeState<E> extends State<_RiverpodDateRange<E>> {
  bool get _isEnabled => widget.state.isEnabled && !widget.state.isInitializing;

  String _format(BuildContext context, DateTimeRange range) {
    final custom = widget.formatter;
    if (custom != null) return custom(context, range);
    final l10n = MaterialLocalizations.of(context);
    return '${l10n.formatCompactDate(range.start)} – '
        '${l10n.formatCompactDate(range.end)}';
  }

  String? get _errorText {
    if (!widget.state.isDirty) return null;
    return switch (widget.state.error) {
      ValidationFailed<E>(:final failure) => switch (failure) {
        ValidationFailure<E>(:final error) =>
          widget.errorMapping?.call(error) ?? '',
        ValidationException<E>() => 'Validation failed',
      },
      _ => null,
    };
  }

  Future<void> _pick() async {
    final current = widget.state.value;
    final picked = await showDateRangePicker(
      context: context,
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
      initialDateRange: current,
    );
    if (picked != null) widget.setValue(picked);
  }

  @override
  Widget build(BuildContext context) {
    final value = widget.state.value;
    return InkWell(
      onTap: _isEnabled ? _pick : null,
      child: InputDecorator(
        decoration: (widget.decoration ?? const InputDecoration()).copyWith(
          enabled: _isEnabled,
          errorText: _errorText,
          suffixIcon: const Icon(Icons.date_range),
        ),
        isEmpty: value == null,
        child: value == null ? null : Text(_format(context, value)),
      ),
    );
  }
}
