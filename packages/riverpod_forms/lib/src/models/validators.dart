import 'package:async_value_tools/async_value_tools.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_forms/riverpod_forms.dart';
import 'package:riverpod_forms/src/providers/as_future_provider.dart';

typedef ValueValidator<VALUE, ERROR> = AsyncValue<ERROR?> Function(
  Ref ref,
  VALUE? value,
);

sealed class Validator<T, ERROR> {
  const Validator._();

  factory Validator.sync(ERROR? Function(T? value) validate) =>
      SyncValidator<T, ERROR>(validate);

  factory Validator.async(Future<ERROR?> Function(T value) validate) =>
      AsyncValidator<T, ERROR>(validate);

  factory Validator.riverpod(
    AsyncValue<ERROR?> Function(Ref ref, T? value) validate,
  ) => RiverpodValidator<T, ERROR>(validate);

  ValueValidator<T, ERROR> get normalize;

  static Validator<T, CombinedValidatorResult2<T, E0, E1>> combined2<T, E0, E1>(
    Validator<T, E0> v0,
    Validator<T, E1> v1,
  ) => makeCombinedValidator2<T, E0, E1>(v0, v1);

  static Validator<T, CombinedValidatorResult3<T, E0, E1, E2>>
  combined3<T, E0, E1, E2>(
    Validator<T, E0> v0,
    Validator<T, E1> v1,
    Validator<T, E2> v2,
  ) => makeCombinedValidator3<T, E0, E1, E2>(v0, v1, v2);
}

Validator<T, CombinedValidatorResult2<T, E0, E1>>
makeCombinedValidator2<T, E0, E1>(Validator<T, E0> v0, Validator<T, E1> v1) =>
    CombinedValidator2<T, E0, E1>(v0, v1);

Validator<T, CombinedValidatorResult3<T, E0, E1, E2>>
makeCombinedValidator3<T, E0, E1, E2>(
  Validator<T, E0> v0,
  Validator<T, E1> v1,
  Validator<T, E2> v2,
) => CombinedValidator3<T, E0, E1, E2>(v0, v1, v2);

final class SyncValidator<T, ERROR> extends Validator<T, ERROR> {
  final ERROR? Function(T? value) validate;

  const SyncValidator(this.validate) : super._();

  @override
  ValueValidator<T, ERROR> get normalize =>
      (_, val) => AsyncData<ERROR?>(validate(val));
}

final class AsyncValidator<T, ERROR> extends Validator<T, ERROR> {
  final Future<ERROR?> Function(T value) validate;

  const AsyncValidator(this.validate) : super._();

  @override
  ValueValidator<T, ERROR> get normalize =>
      (ref, value) => value == null
      ? AsyncData(null)
      : ref.watch(futureToAsyncDataProvider(validate(value))).as<ERROR?>();
}

final class RiverpodValidator<T, ERROR> extends Validator<T, ERROR> {
  final AsyncValue<ERROR?> Function(Ref ref, T? value) validate;

  const RiverpodValidator(this.validate) : super._();

  @override
  ValueValidator<T, ERROR> get normalize => validate;
}

final class CombinedValidator2<T, E0, E1>
    extends Validator<T, CombinedValidatorResult2<T, E0, E1>> {
  final Validator<T, E0> v0;
  final Validator<T, E1> v1;

  const CombinedValidator2(this.v0, this.v1) : super._();

  @override
  ValueValidator<T, CombinedValidatorResult2<T, E0, E1>> get normalize =>
      (ref, value) => v0
          .normalize(ref, value)
          .flatMap(
            (v) => notNullOr(
              v,
              then: (v) => AsyncData<CombinedValidatorResult2<T, E0, E1>?>(
                Validator2_0Failed<T, E0, E1>(v),
              ),
              orElse: v1
                  .normalize(ref, value)
                  .whenData(
                    (v) => whenNull(v, then: Validator2_1Failed<T, E0, E1>.new),
                  ),
            ),
          );
}

final class CombinedValidator3<T, E0, E1, E2>
    extends Validator<T, CombinedValidatorResult3<T, E0, E1, E2>> {
  final Validator<T, E0> v0;
  final Validator<T, E1> v1;
  final Validator<T, E2> v2;

  const CombinedValidator3(this.v0, this.v1, this.v2) : super._();

  @override
  ValueValidator<T, CombinedValidatorResult3<T, E0, E1, E2>> get normalize =>
      (ref, value) => v0
          .normalize(ref, value)
          .flatMap(
            (v) =>
                whenNull(
                  v,
                  then: (v) =>
                      AsyncData<CombinedValidatorResult3<T, E0, E1, E2>?>(
                        Validator3_0Failed<T, E0, E1, E2>(v),
                      ),
                ) ??
                CombinedValidator2<T, E1, E2>(v1, v2)
                    .normalize(ref, value)
                    .whenData(
                      (v12Result) => switch (v12Result) {
                        Validator2_0Failed<T, E1, E2>(:final error) =>
                          Validator3_1Failed<T, E0, E1, E2>(error),
                        Validator2_1Failed<T, E1, E2>(:final error) =>
                          Validator3_2Failed<T, E0, E1, E2>(error),
                        null => null,
                      },
                    ),
          );
}

sealed class CombinedValidatorResult2<V, E0, E1> {}

final class Validator2_0Failed<V, E0, E1>
    extends CombinedValidatorResult2<V, E0, E1> {
  final E0 error;
  Validator2_0Failed(this.error);
}

final class Validator2_1Failed<V, E0, E1>
    extends CombinedValidatorResult2<V, E0, E1> {
  final E1 error;
  Validator2_1Failed(this.error);
}

sealed class CombinedValidatorResult3<V, E0, E1, E2> {}

final class Validator3_0Failed<V, E0, E1, E2>
    extends CombinedValidatorResult3<V, E0, E1, E2> {
  final E0 error;
  Validator3_0Failed(this.error);
}

final class Validator3_1Failed<V, E0, E1, E2>
    extends CombinedValidatorResult3<V, E0, E1, E2> {
  final E1 error;
  Validator3_1Failed(this.error);
}

final class Validator3_2Failed<V, E0, E1, E2>
    extends CombinedValidatorResult3<V, E0, E1, E2> {
  final E2 error;
  Validator3_2Failed(this.error);
}
