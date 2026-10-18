import 'package:async_value_tools/async_value_tools.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_forms/models/riverpod_form.dart';
import 'package:riverpod_forms/utils/functional_helpers.dart';

sealed class CombinedValidator2<V, E0, E1> {}

final class Validator0Failed<V, E0, E1> extends CombinedValidator2<V, E0, E1> {
  final E0 error;
  Validator0Failed(this.error);
}

final class Validator1Failed<V, E0, E1> extends CombinedValidator2<V, E0, E1> {
  final E1 error;
  Validator1Failed(this.error);
}

FormValueValidator<V, CombinedValidator2<V, E0, E1>> makeValidator2<V, E0, E1>(
  FormValueValidator<V, E0> validator0,
  FormValueValidator<V, E1> validator1,
) =>
    (Ref ref, value) => validator0(ref, value)
        .and(validator1(ref, value))
        .whenData(
          (validation) =>
              whenNotNull(
                validation.$1,
                then: (e0) => Validator0Failed<V, E0, E1>(e0),
              ) ??
              whenNotNull(
                validation.$2,
                then: (e1) => Validator1Failed<V, E0, E1>(e1),
              ),
        );
