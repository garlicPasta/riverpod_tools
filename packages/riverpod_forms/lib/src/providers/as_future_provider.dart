import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final _uuid = Uuid();

class EqualFuture<T, R> extends Equatable {
  final String id;
  final Future<dynamic> future;
  final Object? idObject;

  EqualFuture(this.future, {String? id, this.idObject}) : id = id ?? _uuid.v4();

  @override
  List<Object?> get props => [id, idObject];
}

var futureToAsyncDataProvider = FutureProvider.family(
  (ref, EqualFuture future) => future.future,
);
