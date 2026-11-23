import 'package:material_ui/material_ui.dart';
import 'package:riverpod_forms/riverpod_forms.dart';
import 'package:riverpod_forms/src/models/form_value_state.dart';
import 'package:riverpod_forms_extras/src/fields/file_select_field.dart';
import 'package:riverpod_forms_extras/src/models/picked_file.dart';
import 'package:riverpod_forms_extras/src/utils/file_manager.dart';

enum FilePickerButtonPosition { before, after }

typedef PickedFileBuilder<ITEM_ERR> = Widget Function(
  BuildContext context,
  PickedFile file,
  VoidCallback remove,
  ItemError<PickedFile, ITEM_ERR>? error,
);

typedef PickButtonBuilder = Widget Function(
  BuildContext context,
  VoidCallback pick,
);

class RiverpodFormFilePicker<ERROR, ITEM_ERROR> extends StatelessWidget {
  final FilePickField<ERROR, ITEM_ERROR> field;
  final PickedFileBuilder<ITEM_ERROR>? fileBuilder;
  final PickButtonBuilder? pickButtonBuilder;
  final ItemErrorMapper<PickedFile, ITEM_ERROR>? itemErrorMapping;
  final ErrorMapper<ERROR>? listErrorMapping;
  final FilePickerButtonPosition buttonPosition;

  const RiverpodFormFilePicker({
    super.key,
    required this.field,
    this.listErrorMapping,
    this.itemErrorMapping,
    this.fileBuilder,
    this.pickButtonBuilder,
    this.buttonPosition = FilePickerButtonPosition.after,
  });

  Widget _defaultFileBuilder(
    BuildContext context,
    PickedFile file,
    VoidCallback remove,
    ItemError<PickedFile, ITEM_ERROR>? error,
  ) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(file.name),
      IconButton(icon: Icon(Icons.close), onPressed: remove),
      ?notNull<ItemError<PickedFile, ITEM_ERROR>, Widget?>(
        error,
        then: (e) => Text(itemErrorMapping?.call(context, e) ?? ''),
      ),
    ],
  );

  Widget _buildFile(
    BuildContext context,
    PickedFile file,
    VoidCallback remove,
    ItemError<PickedFile, ITEM_ERROR>? error,
  ) {
    PickedFileBuilder<ITEM_ERROR> b = fileBuilder ?? _defaultFileBuilder;
    return b(context, file, remove, error);
  }

  void pickFile(FormListSetter<PickedFile> setter) async {
    var f = await FileManager.pickFile();
    if (f == null) return;
    setter.addValue(f);
  }

  Widget _buildPickButton(BuildContext context, VoidCallback pick) =>
      pickButtonBuilder?.call(context, pick) ??
      ElevatedButton(onPressed: pick, child: Text('Upload'));

  @override
  Widget build(BuildContext context) => RiverpodFormMultiFieldBuilder(
    valueProxy: field,
    builder:
        (
          BuildContext context,
          FormMultipleValueState<PickedFile, ERROR, ITEM_ERROR> state,
          FormListSetter<PickedFile> setter,
        ) => Column(
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                if (buttonPosition == FilePickerButtonPosition.before)
                  _buildPickButton(context, () => pickFile(setter)),
                for (final file in state.value)
                  _buildFile(
                    context,
                    file,
                    () => setter.removeValue(file),
                    state.itemErrors
                        .map((e) => e.error)
                        .nonNulls
                        .where((e) => e.item == file)
                        .firstOrNull,
                  ),
                if (buttonPosition == FilePickerButtonPosition.after)
                  _buildPickButton(context, () => pickFile(setter)),
              ],
            ),
            ?maybeNull2(
              state.error.error,
              listErrorMapping,
              then: (a, b) =>
                  notNull<String, Widget?>(b(context, a), then: (a) => Text(a)),
            ),
          ],
        ),
  );
}
