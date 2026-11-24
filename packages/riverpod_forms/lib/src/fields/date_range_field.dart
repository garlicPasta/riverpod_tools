import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:riverpod_forms/riverpod_forms.dart';

SingleFormValue<DateTimeRange, ERROR> makeDateRangeField<ERROR>({
  Validator<DateTimeRange, ERROR>? validator,
  Value<DateTimeRange?> initialValue = const Value.sync(null),
  bool Function(Ref ref)? isEnabled,
  bool Function(Ref ref)? isVisible,
}) => SingleFormValue<DateTimeRange, ERROR>(
  validator: validator,
  initial: initialValue,
  isEnabled: isEnabled,
  isVisible: isVisible,
);
