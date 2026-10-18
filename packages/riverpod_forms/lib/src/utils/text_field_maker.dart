import 'package:riverpod_forms/riverpod_forms.dart';

FormSingleValueProxy<String, ERROR> makeTextField<ERROR>({
  FormValueValidator<String, ERROR>? validator,
  String? initialValue,
}) => FormSingleValueProxy<String, ERROR>(
  validator: validator,
  initial: initialValue,
);
