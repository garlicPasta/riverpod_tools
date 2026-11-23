import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:riverpod_forms/riverpod_forms.dart';
import 'package:riverpod_forms_extras/riverpod_forms_extras.dart';

class FileSize extends Equatable {
  final int size;
  const FileSize(this.size);
  const FileSize.kiloBytes(int kb) : size = kb * 1024;
  const FileSize.megaBytes(int mb) : size = mb * 1024 * 1024;

  @override
  List<Object?> get props => [size];
}

final class FileBiggerThan(final FileSize size) extends Equatable {
  @override
  List<Object?> get props => [size];
}

typedef FileError<ITEM_ERROR> = ItemError<PickedFile, ITEM_ERROR>;

final class InvalidFileEnding(PickedFile file, final String fileEnding);

SyncValidator<List<PickedFile>, InvalidFileEnding> allowedFileEndings(
  List<String> endings,
) => SyncValidator.new((List<PickedFile>? files) {
  if (files == null) return null;
  for (var f in files) {
    if (!endings.any((e) => f.name.endsWith(e)))
      return InvalidFileEnding(f, '');
  }
  return null;
});

AsyncValidator<PickedFile, FileError<FileBiggerThan>> filesSmallerThan(
  FileSize size,
) => .new(
  (file) async => notNullOr<int, ItemError<PickedFile, FileBiggerThan>?>(
    await file?.size().catchError((err) {
      log(
        'Failed to get size from file ${file.name}',
        error: err,
        stackTrace: StackTrace.current,
      );
      return null;
    }),
    then: (s) {
      log('File size: $s');
      return (s > size.size)
          ? ItemError(file!, FileBiggerThan(FileSize(s)))
          : null;
    },
    orElse: null,
  ),
);
