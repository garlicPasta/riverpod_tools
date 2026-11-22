import 'package:file_picker/file_picker.dart';
import 'package:riverpod_forms_extras/src/models/picked_file.dart';

class FileManager {
  static Future<PickedFile?> pickFile() async {
    final result = await FilePicker.pickFile();
    if (result == null) return null;
    return PickedFile(result);
  }
}
