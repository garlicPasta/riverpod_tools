import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:riverpod_forms/riverpod_forms.dart';
import 'package:riverpod_forms_extras/riverpod_forms_extras.dart';

final class FileBiggerThan(final int size) extends Equatable {
  @override
  List<Object?> get props => [size];
}

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

AsyncValidator<List<PickedFile>, ListItemError<PickedFile, FileBiggerThan>>
filesSmallerThan(int size) => .new((files) async {
  EqualList<ItemError<PickedFile, FileBiggerThan>>? errors = await files
      ?.map(
        (f) async => (notNullOr<int, ItemError<PickedFile, FileBiggerThan>?>(
          await f.size().catchError((err) {
            log(
              'Failed to get size from file ${f.name}',
              error: err,
              stackTrace: StackTrace.current,
            );
            return null;
          }),
          then: (s) => (s > size) ? ItemError(f, FileBiggerThan(s)) : null,
          orElse: null,
        )),
      )
      .wait
      .then((s) => s.nonNulls.toEqualList());
  if (errors?.items.isNotEmpty ?? false) return errors;
  return null;
});
