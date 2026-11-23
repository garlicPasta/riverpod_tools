import 'package:material_ui/material_ui.dart';
import 'package:riverpod_forms/riverpod_forms.dart';
import 'package:riverpod_forms/src/models/form_value_state.dart';
import 'package:riverpod_forms_extras/src/fields/file_select_field.dart';
import 'package:riverpod_forms_extras/src/models/picked_file.dart';
import 'package:riverpod_forms_extras/src/utils/file_manager.dart';

typedef PickedFileBuilder = Widget Function(
  BuildContext context,
  PickedFile file,
  VoidCallback remove,
);

class RiverpodFormFilePicker<ERR, ITEM_ERR> extends StatelessWidget {
  final FilePickField<ERR, ITEM_ERR> field;

  final PickedFileBuilder? fileBuilder;

  const RiverpodFormFilePicker({
    super.key,
    required this.field,
    this.fileBuilder,
  });

  static Widget _defaultFileBuilder(
    BuildContext context,
    PickedFile file,
    VoidCallback remove,
  ) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(file.name),
      IconButton(icon: Icon(Icons.close), onPressed: remove),
    ],
  );

  @override
  Widget build(BuildContext context) => RiverpodFormMultiFieldBuilder(
    valueProxy: field,
    builder:
        (
          context,
          FormMultipleValueState<PickedFile, ERR, ITEM_ERR> state,
          FormListSetter<PickedFile> setter,
        ) => Wrap(
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
            for (final f in state.value)
              (fileBuilder ?? _defaultFileBuilder)(
                context,
                f,
                () => setter.removeValue(f),
              ),
          ],
        ),
  );
}
