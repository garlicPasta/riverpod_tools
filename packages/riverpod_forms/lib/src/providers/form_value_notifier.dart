import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_forms/riverpod_forms.dart';
import 'package:riverpod_forms/src/extension/future_or_extension.dart';

abstract class FormValueNotifier<VALUE, ERROR, STATE> extends Notifier<STATE> {
  final String key;
  VALUE value;
  bool isDirty = false;
  bool isInitializing = true;
  bool initializationFailed = false;
  bool validateField = false;
  final AsyncDebouncer _debouncer = AsyncDebouncer(Duration(milliseconds: 80));

  FormValueNotifier(this.key, FutureOr<VALUE> initial, this.value) {
    initial.handle(
      whenValue: (v) {
        isInitializing = false;
        value = v;
      },
      whenFuture: (f) {
        f
            .then((v) {
              isInitializing = false;
              value = v;
            })
            .catchError((e) {
              initializationFailed = true;
            })
            .then((_) {
              ref.invalidateSelf();
            });
      },
    );
  }

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
