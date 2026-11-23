import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_forms/riverpod_forms.dart';

void main() {
  group('EqualIterable', () {
    test('is equal to another list wrapper with the same elements', () {
      final a = EqualList([1, 2, 3]);
      final b = EqualList([1, 2, 3]);

      expect(a, b);
      expect(a.hashCode, b.hashCode);
    });

    test('is not equal when elements or order differ', () {
      expect(EqualList([1, 2]), isNot(EqualList([1, 3])));
      expect(EqualList([1, 2]), isNot(EqualList([2, 1])));
      expect(EqualList([1, 2]), isNot(EqualList([1, 2, 3])));
    });

    test('compares empty lists as equal', () {
      expect(EqualList<int>([]), EqualList<int>([]));
    });

    test('compares nested value objects by value', () {
      expect(EqualList([(1, 'a')]), EqualList([(1, 'a')]));
    });

    test('toEqualList wraps any iterable by value', () {
      expect({1, 2, 3}.toEqualList(), EqualList([1, 2, 3]));
      expect([1, 2].map((e) => e * 2).toEqualList(), EqualList([2, 4]));
    });

    test('compares sets without order and lists with order', () {
      expect({1, 2}.toEqualSet(), {2, 1}.toEqualSet());
      expect([1, 2].toEqualList(), isNot([2, 1].toEqualList()));
    });

    test('does not equate a set with a list of the same elements', () {
      expect({1, 2}.toEqualSet() == [1, 2].toEqualList(), isFalse);
    });

    test('keeps the wrapped collection type', () {
      expect({1}.toEqualSet().items, isA<Set<int>>());
      expect([1].toEqualList().items, isA<List<int>>());
    });

    test('works as a validation error inside ValidationState', () {
      expect(
        ValidationFailed(ValidationFailure(EqualList(['a']))),
        ValidationFailed(ValidationFailure(EqualList(['a']))),
      );
    });
  });
}
