import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:riverpod_forms/riverpod_forms.dart';
import 'package:riverpod_forms_extras/riverpod_forms_extras.dart';

final class FileBiggerThan(final PickedFile file, final int size)
    extends Equatable {
  @override
  List<Object?> get props => [file, size];
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

AsyncValidator<List<PickedFile>, EqualList<FileBiggerThan>> filesSmallerThan(
  int size,
) => .new((files) async {
  EqualList<FileBiggerThan>? errors = await files
      ?.map(
        (f) async => (notNullOr<int, FileBiggerThan?>(
          await f.size().catchError((e) {
            log(
              'Failed to get size from file ${f.name}',
              error: e,
              stackTrace: StackTrace.current,
            );
            return null;
        }),
          then: (s) => (s > size) ? FileBiggerThan(f, s) : null,
          orElse: null,
        )),
      )
      .wait
      .then((s) => s.nonNulls.toEqualList());
  if (errors?.items.isNotEmpty ?? false) return errors;
  return null;
});
