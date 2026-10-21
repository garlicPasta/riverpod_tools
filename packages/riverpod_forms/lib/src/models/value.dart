sealed class Value<T> {}

final class SyncValue<T>(final T value) extends Value<T> {}

final class FutureValue<T>(final Future<T> value) extends Value<T> {}

