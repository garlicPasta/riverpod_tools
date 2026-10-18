final class CombinedValidator3<V, E0, E1, E2> {}

final class Validator0Failed<V, E0>
    extends CombinedValidator3<V, E0, dynamic, dynamic> {}

final class Validator1Failed<V, E0>
    extends CombinedValidator3<V, dynamic, E0, dynamic> {}

final class Validator2Failed<V, E0>
    extends CombinedValidator3<V, dynamic, E0, dynamic> {}
