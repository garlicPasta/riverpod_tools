import 'package:file_picker/file_picker.dart';

class PickedFile {
  final String name;
  final PlatformFile? path;

  PickedFile.platform(this.path) : name = path?.name ?? '';
  PickedFile.placeholder(this.name) : path = null;
}
