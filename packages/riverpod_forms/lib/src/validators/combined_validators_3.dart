import 'package:async_value_tools/async_value_tools.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_forms/src/models/riverpod_form.dart';
import 'package:riverpod_forms/src/utils/functional_helpers.dart';

sealed class CombinedValidator3<V, E0, E1, E2> {}

final class Validator3_0Failed<V, E0, E1, E2>
    extends CombinedValidator3<V, E0, E1, E2> {
  final E0 error;
  Validator3_0Failed(this.error);
}

final class Validator3_1Failed<V, E0, E1, E2>
    extends CombinedValidator3<V, E0, E1, E2> {
  final E1 error;
  Validator3_1Failed(this.error);
}

final class Validator3_2Failed<V, E0, E1, E2>
    extends CombinedValidator3<V, E0, E1, E2> {
  final E2 error;
  Validator3_2Failed(this.error);
}

FormValueValidator<V, CombinedValidator3<V, E0, E1, E2>>
makeValidator3<V, E0, E1, E2>(
  FormValueValidator<V, E0> validator0,
  FormValueValidator<V, E1> validator1,
  FormValueValidator<V, E2> validator2,
) =>
    (Ref ref, value) => validator0(ref, value)
        .and2(validator1(ref, value), validator2(ref, value))
        .whenData(
          (validation) =>
              whenNotNull(
                validation.$1,
                then: (e0) => Validator3_0Failed<V, E0, E1, E2>(e0),
              ) ??
              whenNotNull(
                validation.$2,
                then: (e1) => Validator3_1Failed<V, E0, E1, E2>(e1),
              ) ??
              whenNotNull(
                validation.$3,
                then: (e2) => Validator3_2Failed<V, E0, E1, E2>(e2),
              ),
        );
