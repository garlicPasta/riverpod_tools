import 'package:flutter_riverpod/flutter_riverpod.dart';

sealed class ValidationResult<ERROR> {
  static ValidationResult<ERROR> fromAsyncValue<ERROR>(
    AsyncValue<ERROR?> asyncValue,
  ) => asyncValue.when(
    skipLoadingOnRefresh: false,
    data: (error) => error == null
        ? ValidationSuccess<ERROR>()
        : ValidationFailed<ERROR>(ValidationFailure<ERROR>(error)),
    loading: () => ValidationInProgress<ERROR>(),
    error: (err, stack) =>
        ValidationFailed<ERROR>(ValidationException<ERROR>(err, stack)),
  );

  ERROR? get error => switch (this) {
    ValidationFailed<ERROR>(:final failure) => switch (failure) {
      ValidationFailure<ERROR>(:final error) => error,
      ValidationException<ERROR>() => null,
    },
    ValidationInProgress<ERROR>() => null,
    ValidationSuccess<ERROR>() => null,
  };

  ValidationResult<T> as<T>() => switch (this) {
    ValidationInProgress<ERROR>() => ValidationInProgress<T>(),
    ValidationSuccess<ERROR>() => ValidationSuccess<T>(),
    ValidationFailed<ERROR>(:final failure) => ValidationFailed<T>(
      failure.as<T>(),
    ),
  };

  const ValidationResult();
}

final class ValidationInProgress<ERROR> extends ValidationResult<ERROR> {
  const ValidationInProgress();
}

final class ValidationSuccess<ERROR> extends ValidationResult<ERROR> {
  const ValidationSuccess();
}

final class ValidationFailed<ERROR>(final ValidationError<ERROR> failure)
    extends ValidationResult<ERROR> {}

sealed class ValidationError<ERROR> {
  ValidationError<T> as<T>() => switch (this) {
    ValidationFailure<ERROR>(:final error) => ValidationFailure<T>(error as T),
    ValidationException<ERROR>(:final exception, :final stackTrace) =>
      ValidationException<T>(exception, stackTrace),
  };
}

final class ValidationFailure<ERROR>(final ERROR error)
    extends ValidationError<ERROR> {}

final class ValidationException<ERROR>(
  final Object exception,
  final StackTrace stackTrace,
) extends ValidationError<ERROR> {}
