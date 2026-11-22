import 'package:file_picker/file_picker.dart';
import 'package:riverpod_forms_extras/src/models/picked_file.dart';

class FileManager {
  static Future<PickedFile?> pickFile({List<String>? allowedExtensions}) async {
    final result = await FilePicker.pickFile(
      allowedExtensions: allowedExtensions,
    );
    if (result == null) return null;
    return PickedFile.platform(result);
  }
}
