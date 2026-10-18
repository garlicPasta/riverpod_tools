import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../riverpod_forms.dart';

final class MinLength(final int length);
final class RegexMismatch(final RegExp regex);

FormValueValidator<String, MinLength> makeMinLengthValidator(int length) =>
    (Ref ref, String? value) {
      if (value is String && value.length < length) {
        return AsyncValue.data(MinLength(length));
      }
      return AsyncValue.data(null);
    };

FormValueValidator<String, RegexMismatch> makeRegexValidator(RegExp regex) =>
    (Ref ref, String? value) {
      if (value != null && !regex.hasMatch(value)) {
        return AsyncValue.data(RegexMismatch(regex));
      }
      return AsyncValue.data(null);
    };

final RegExp _emailRegex = RegExp(
  r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$',
);

FormValueValidator<String, RegexMismatch> makeIsValidEmailValidator() =>
    makeRegexValidator(_emailRegex);