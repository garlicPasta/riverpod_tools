import 'package:material_ui/material_ui.dart';
import 'package:riverpod_forms/riverpod_forms.dart';
import 'package:riverpod_forms/src/models/form_value_state.dart';
import 'package:riverpod_forms_extras/src/fields/file_select_field.dart';
import 'package:riverpod_forms_extras/src/models/picked_file.dart';
import 'package:riverpod_forms_extras/src/utils/file_manager.dart';

class FilePicker<ERR> extends StatelessWidget {
  final FilePickField<ERR> field;
  const FilePicker({super.key, required this.field});

  @override
  Widget build(BuildContext context) => RiverpodFormMultiFieldBuilder(
    valueProxy: field,
    builder:
        (
          context,
          FormMultipleValuesState<PickedFile, ERR> state,
          FormListSetter<PickedFile> setter,
        ) {
          return Wrap(
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
                Row(
                  children: [
                    Text(f.path.name),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => setter.removeValue(f),
                    ),
                  ],
                ),
            ],
          );
        },
  );
}
