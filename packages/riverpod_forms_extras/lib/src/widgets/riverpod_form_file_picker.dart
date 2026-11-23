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
  ERR? error,
);

class RiverpodFormFilePicker<ERR> extends StatelessWidget {
  final FilePickField<ERR> field;

  final PickedFileBuilder? fileBuilder;
  final ErrorMapper<ERR>? errorMapping;

  const RiverpodFormFilePicker({
    super.key,
    required this.field,
    this.errorMapping,
    this.fileBuilder,
  });

  Widget _defaultFileBuilder(
    BuildContext context,
    PickedFile file,
    VoidCallback remove,
    ERR? error,
  ) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(file.name),
      IconButton(icon: Icon(Icons.close), onPressed: remove),
      Text(
        notNullOr(
          error,
          then: (error) => errorMapping?.call(context, error) ?? '',
          orElse: '',
        ),
      ),
    ],
  );

  Widget _buildFile(
    BuildContext context,
    PickedFile file,
    VoidCallback remove,
    ERR? error,
  ) {
    PickedFileBuilder<ERR> b = fileBuilder ?? _defaultFileBuilder;
    return b(context, file, remove, error);
  }

  @override
  Widget build(BuildContext context) => RiverpodFormMultiFieldBuilder(
    valueProxy: field,
    builder:
        (
          BuildContext context,
          FormMultipleValuesState<PickedFile, ERR> state,
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
                for (final f in state.value)
                  _buildFile(
                    context,
                    f,
                    () => setter.removeValue(f),
                    state.error.error,
                  ),
              ],
            ),
            ?whenNull(
              state.error.error,
              then: (e) => Text(errorMapping?.call(context, e) ?? ''),
            ),
          ],
        ),
  );
}
