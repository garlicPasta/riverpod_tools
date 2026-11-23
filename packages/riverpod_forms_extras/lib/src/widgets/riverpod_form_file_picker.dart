import 'package:material_ui/material_ui.dart';
import 'package:riverpod_forms/riverpod_forms.dart';
import 'package:riverpod_forms/src/models/form_value_state.dart';
import 'package:riverpod_forms_extras/src/fields/file_select_field.dart';
import 'package:riverpod_forms_extras/src/models/picked_file.dart';
import 'package:riverpod_forms_extras/src/utils/file_manager.dart';

typedef PickedFileBuilder<ERR> = Widget Function(
  BuildContext context,
  PickedFile file,
  VoidCallback remove,
  ItemError<PickedFile, ERR>? error,
);

class RiverpodFormFilePicker<ERR> extends StatelessWidget {
  final FilePickField<ERR> field;
  final PickedFileBuilder? fileBuilder;
  final ItemErrorMapper<PickedFile, ERR>? itemErrorMapping;
  final ErrorMapper<ERR> listErrorMapping;

  const RiverpodFormFilePicker({
    super.key,
    required this.field,
    this.itemErrorMapping,
    required this.listErrorMapping,
    this.fileBuilder,
  });

  Widget _defaultFileBuilder(
    BuildContext context,
    PickedFile file,
    VoidCallback remove,
    ItemError<PickedFile, ERR>? error,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(file.name),
        IconButton(icon: Icon(Icons.close), onPressed: remove),
        ?notNull<ItemError<PickedFile, ERR>, Widget?>(
          error,
          then: (e) => Text(itemErrorMapping?.call(context, e) ?? ''),
        ),
      ],
    );
  }

  Widget _buildFile(
    BuildContext context,
    PickedFile file,
    VoidCallback remove,
    ItemError<PickedFile, ERR>? error,
  ) {
    PickedFileBuilder<ERR> b = fileBuilder ?? _defaultFileBuilder;
    return b(context, file, remove, error);
  }

  ItemError<PickedFile, ERR>? filterItemError(PickedFile f, ERR e) {
    if (e is ListItemError<PickedFile, ERR>) {
      return e.items.firstWhere((i) => i.item == f);
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) => RiverpodFormMultiFieldBuilder(
    valueProxy: field,
    builder:
        (
          BuildContext context,
          FormMultipleValueState<PickedFile, ERR> state,
          FormListSetter<PickedFile> setter,
        ) => Column(
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    var f = await FileManager.pickFile();
                    if (f == null) return;
                    setter.addValue(f);
                  },
                  child: Text('Pick'),
                ),
                for (final file in state.value)
                  _buildFile(
                    context,
                    file,
                    () => setter.removeValue(file),
                    notNull<ERR, ItemError<PickedFile, ERR>?>(
                      state.error.error,
                      then: (e) => filterItemError(file, e),
                    ),
                  ),
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
