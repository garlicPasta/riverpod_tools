TResult? whenNotNull<TValue, TResult>(
  TValue? value, {
  required TResult Function(TValue value) then,
}) {
  if (value == null) {
    return null;
  }
  return then(value);
}
