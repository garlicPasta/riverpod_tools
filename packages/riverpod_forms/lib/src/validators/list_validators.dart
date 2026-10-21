import 'package:riverpod_forms/src/models/validators.dart';

final class ListIsEmpty {}

final class ListSizeLessThan(final int size);
final class ListSizeBiggerThan(final int size);

Validator<List<T>, ListIsEmpty> makeListIsEmptyValidator<T>() =>
    .sync((List<T>? value) {
      if (value == null || value.isEmpty) {
        return ListIsEmpty();
      }
      return null;
    });

Validator<List<T>, ListSizeLessThan> makeListSizeLessThanValidator<T>(
  int size,
) => .sync((List<T>? value) {
  if (value == null || value.length < size) {
    return ListSizeLessThan(size);
  }
  return null;
});

Validator<List<T>, ListSizeBiggerThan> makeListSizeBiggerThanValidator<T>(
  int size,
) => .sync((List<T>? value) {
  if (value == null || value.length > size) {
    return ListSizeBiggerThan(size);
  }
  return null;
});
