import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../riverpod_forms.dart';

final class IsRequired {}

FormValueValidator<Object, IsRequired> makeIsRequiredValidator() =>
    (Ref ref, Object? value) {
      if (value == null || (value is String && value.isEmpty)) {
        return AsyncValue.data(IsRequired());
      }
      return AsyncValue.data(null);
    };
