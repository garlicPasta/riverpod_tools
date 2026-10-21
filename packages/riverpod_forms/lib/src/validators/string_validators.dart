import 'package:riverpod_forms/src/models/validators.dart';

final class MinLength(final int length);
final class RegexMismatch(final RegExp regex);

Validator<String, MinLength> makeMinLengthValidator(int length) =>
    .sync((String? value) {
      if (value == null || value.length < length) {
        return MinLength(length);
      }
      return null;
    });

Validator<String, RegexMismatch> makeRegexValidator(RegExp regex) =>
    .sync((String? value) {
      if (value == null || !regex.hasMatch(value)) {
        return RegexMismatch(regex);
      }
      return null;
    });

final RegExp _emailRegex = RegExp(
  r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$',
);

Validator<String, RegexMismatch> makeIsValidEmailValidator() =>
    makeRegexValidator(_emailRegex);
