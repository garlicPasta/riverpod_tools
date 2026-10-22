import 'package:riverpod_forms/src/models/validators.dart';

final class ListIsEmpty {}

final class ListSizeLessThan(final int size);
final class ListSizeBiggerThan(final int size);

SyncValidator<List<T>, ListIsEmpty> makeListIsEmptyValidator<T>() =>
    .new((List<T>? value) {
      if (value == null || value.isEmpty) {
        return ListIsEmpty();
      }
      return null;
    });

SyncValidator<List<T>, ListSizeLessThan> sizeLessThan<T>(
  int size,
) => .new((List<T>? value) {
  if (value == null || value.length < size) {
    return ListSizeLessThan(size);
  }
  return null;
});

SyncValidator<List<T>, ListSizeBiggerThan> makeListSizeBiggerThanValidator<T>(
  int size,
) => .new((List<T>? value) {
  if (value == null || value.length > size) {
    return ListSizeBiggerThan(size);
  }
  return null;
});
