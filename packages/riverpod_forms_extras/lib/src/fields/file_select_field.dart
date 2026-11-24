import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_forms/riverpod_forms.dart';
import 'package:riverpod_forms_extras/src/models/picked_file.dart';

typedef FilePickField<ERROR, ITEM_ERROR> =
    MultiFormValue<PickedFile, ERROR, ITEM_ERROR>;

FilePickField<ERROR, ITEM_ERROR> makeFilePickField<ERROR, ITEM_ERROR>({
  Validator<List<PickedFile>, ERROR>? validator,
  Validator<PickedFile, ItemError<PickedFile, ITEM_ERROR>>? itemValidator,
  Value<List<PickedFile>>? initialValue,
  bool Function(Ref ref)? isEnabled,
  bool Function(Ref ref)? isVisible,
}) => MultiFormValue<PickedFile, ERROR, ITEM_ERROR>(
  validator: validator,
  itemValidator: itemValidator,
  initial: initialValue,
  isEnabled: isEnabled,
  isVisible: isVisible,
);
