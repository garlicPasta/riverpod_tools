import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

var futureToAsyncDataProvider = FutureProvider.family(
  (ref, Future<dynamic> future) => future,
);

