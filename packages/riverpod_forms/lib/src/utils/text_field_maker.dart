import 'package:riverpod_forms/riverpod_forms.dart';

SingleFormValue<String, ERROR> makeTextField<ERROR>({
  Validator<String, ERROR>? validator,
  String? initialValue,
}) => SingleFormValue<String, ERROR>(
  validator: validator,
  initial: initialValue ?? '',
);
