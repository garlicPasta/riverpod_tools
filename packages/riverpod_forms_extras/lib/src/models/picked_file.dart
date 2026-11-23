import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';

class PickedFile extends Equatable {
  final String name;
  final String path;
  final PlatformFile? file;

  Future<int?> size() async => file?.length();

  PickedFile.platform(this.file) : name = file?.name ?? '', path = file?.path ?? '';
  PickedFile.placeholder(this.name) : file = null, path = '';

  @override
  List<Object?> get props => [name, path];
}
