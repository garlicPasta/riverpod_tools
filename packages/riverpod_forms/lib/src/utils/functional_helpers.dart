TResult? whenNull<TValue, TResult>(
  TValue? value, {
  required TResult Function(TValue value) then,
}) {
  if (value == null) {
    return null;
  }
  return then(value);
}

TResult notNullOr<TValue, TResult>(
  TValue? value, {
  required TResult Function(TValue value) then,
  required TResult orElse,
}) {
  if (value == null) {
    return orElse;
  }
  return then(value);
}
