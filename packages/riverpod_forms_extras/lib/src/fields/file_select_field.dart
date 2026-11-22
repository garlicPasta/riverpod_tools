import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_forms/riverpod_forms.dart';
import 'package:riverpod_forms_extras/src/models/picked_file.dart';

typedef FilePickField<ERROR> = MultiFormValue<PickedFile, ERROR>;

MultiFormValue<PickedFile, ERROR> makeFilePickField<ERROR>({
  Validator<List<PickedFile>, ERROR>? validator,
  FutureOr<List<PickedFile>>? initialValue,
  bool Function(Ref ref)? isEnabled,
  bool Function(Ref ref)? isVisible,
}) => MultiFormValue<PickedFile, ERROR>(
  validator: validator,
  initial: initialValue,
  isEnabled: isEnabled,
  isVisible: isVisible,
);
