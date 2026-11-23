import 'package:equatable/equatable.dart';

/// Wraps a collection so it is compared by its elements instead of by
/// identity.
///
/// The collection keeps its own type: lists are compared in order, sets
/// without order. Pass a materialized collection, since lazy iterables would
/// be re-evaluated on every comparison.
final class EqualIterable<T extends Iterable<Object?>> extends Equatable {
  final T items;

  const EqualIterable(this.items);

  @override
  List<Object?> get props => [items];
}

typedef EqualList<E> = EqualIterable<List<E>>;
typedef EqualSet<E> = EqualIterable<Set<E>>;

extension EqualIterableExtension<T> on Iterable<T> {
  /// Copies this iterable into an [EqualList].
  EqualList<T> toEqualList() => EqualIterable(toList());

  /// Copies this iterable into an [EqualSet].
  EqualSet<T> toEqualSet() => EqualIterable(toSet());
}
