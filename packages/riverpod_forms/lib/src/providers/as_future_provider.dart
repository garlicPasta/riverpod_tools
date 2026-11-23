import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EqualFuture<T, R>(
  final String id,
  final Future<dynamic> future, [
  final Object? idObject,
]) extends Equatable {
  @override
  List<Object?> get props => [id, idObject];
}

var futureToAsyncDataProvider = FutureProvider.family(
  (ref, EqualFuture future) => future.future,
);
