import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_forms/models/riverpod_form.dart';

final class MinLength(final int length);
final class RegexMismatch(final RegExp regex);

FormValueValidator<String, MinLength> makeMinLengthValidator(int length) =>
    (Ref ref, dynamic value) {
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
