import 'package:riverpod_forms/src/models/validators.dart';

final class ListIsEmpty {}

final class ListLengthLessThan(final int size);
final class ListLengthBiggerThan(final int size);

SyncValidator<List<T>, ListIsEmpty> listNotEmpty<T>() => .new((List<T>? value) {
  if (value == null || value.isEmpty) {
    return ListIsEmpty();
  }
  return null;
});

SyncValidator<List<T>, ListLengthLessThan> listLengthBiggerThan<T>(int size) =>
    .new((List<T>? value) {
      if (value == null || value.length < size) {
        return ListLengthLessThan(size);
      }
      return null;
    });

SyncValidator<List<T>, ListLengthBiggerThan> listLengthSmallerThan<T>(
  int size,
) => .new((List<T>? value) {
  if (value == null || value.length > size) {
    return ListLengthBiggerThan(size);
  }
  return null;
});
