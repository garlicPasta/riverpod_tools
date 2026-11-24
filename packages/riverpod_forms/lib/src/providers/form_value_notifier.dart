import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_forms/riverpod_forms.dart';

abstract class FormValueNotifier<VALUE, ERROR, STATE> extends Notifier<STATE> {
  final String key;
  VALUE value;
  Value<VALUE>? initialValue;
  bool isDirty = false;
  bool validateField = false;
  final AsyncDebouncer _debouncer = AsyncDebouncer(Duration(milliseconds: 80));

  FormValueNotifier(this.key, this.value);

  void markDirty() {
    isDirty = true;
    validateField = true;
    ref.invalidateSelf();
  }

  void setValue(VALUE value) {
    _debouncer.run(() async {
      this.value = value;
      isDirty = true;
      validateField = true;
      ref.invalidateSelf();
    });
  }

  void validate() {
    validateField = true;
    ref.invalidateSelf();
  }
}
