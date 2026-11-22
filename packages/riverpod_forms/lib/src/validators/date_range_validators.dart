import 'package:material_ui/material_ui.dart' show DateTimeRange;
import 'package:riverpod_forms/src/models/validators.dart';

final class DurationShorterThan(final Duration duration);
final class DurationLongerThan(final Duration duration);
final class DateRangeDoesNotContain(final DateTimeRange range);

/// Valid when the range lasts strictly longer than [duration].
SyncValidator<DateTimeRange, DurationShorterThan> durationIsLongerThan(
  Duration duration,
) => .new((DateTimeRange? value) {
  if (value == null || value.duration <= duration) {
    return DurationShorterThan(duration);
  }
  return null;
});

/// Valid when the range lasts strictly shorter than [duration].
SyncValidator<DateTimeRange, DurationLongerThan> durationIsShorterThan(
  Duration duration,
) => .new((DateTimeRange? value) {
  if (value == null || value.duration >= duration) {
    return DurationLongerThan(duration);
  }
  return null;
});

/// Valid when the range fully covers [range], boundaries included.
SyncValidator<DateTimeRange, DateRangeDoesNotContain> dateRangeContains(
  DateTimeRange range,
) => .new((DateTimeRange? value) {
  if (value == null ||
      value.start.isAfter(range.start) ||
      value.end.isBefore(range.end)) {
    return DateRangeDoesNotContain(range);
  }
  return null;
});
