import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_forms/models/riverpod_form.dart';

final class IsRequired {}

FormValueValidator<T, IsRequired> makeIsRequiredValidator<T>() =>
    (Ref ref, T? value) {
      if (value == null || (value is String && value.isEmpty)) {
        return AsyncValue.data(IsRequired());
      }
      return AsyncValue.data(null);
    };
