import 'package:riverpod_forms/src/models/validators.dart';

final class IsRequired {}

SyncValidator<T, IsRequired> makeIsRequiredValidator<T>() =>
    SyncValidator((T? value) {
      if (value == null || (value is String && value.isEmpty)) {
        return IsRequired();
      }
      return null;
    });
