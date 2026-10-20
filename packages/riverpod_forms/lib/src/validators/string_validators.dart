import 'package:riverpod_forms/src/models/validators.dart';

final class MinLength(final int length);
final class RegexMismatch(final RegExp regex);

SyncValidator<String, MinLength> makeMinLengthValidator(int length) =>
    SyncValidator((String? value) {
      if (value == null || value.length < length) {
        return MinLength(length);
      }
      return null;
    });

SyncValidator<String, RegexMismatch> makeRegexValidator(RegExp regex) =>
    SyncValidator((String? value) {
      if (value == null || !regex.hasMatch(value)) {
        return RegexMismatch(regex);
      }
      return null;
    });

final RegExp _emailRegex = RegExp(
  r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$',
);

SyncValidator<String, RegexMismatch> makeIsValidEmailValidator() =>
    makeRegexValidator(_emailRegex);
