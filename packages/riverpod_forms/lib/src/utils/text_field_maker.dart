import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_forms/riverpod_forms.dart';

SingleFormValue<String, ERROR> makeTextField<ERROR>({
  Validator<String, ERROR>? validator,
  String? initialValue,
  bool Function(Ref ref)? isEnabled,
  bool Function(Ref ref)? isVisible,
}) => SingleFormValue<String, ERROR>(
  validator: validator,
  initial: initialValue ?? '',
  isEnabled: isEnabled,
  isVisible: isVisible,
);
