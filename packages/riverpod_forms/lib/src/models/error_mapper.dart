import 'package:flutter/widgets.dart';
import 'package:riverpod_forms/riverpod_forms.dart';

typedef ErrorMapper<E> = String? Function(BuildContext context, E error);

typedef ItemErrorMapper<ITEM, E> = String? Function(
  BuildContext context,
  ItemError<ITEM, E> error,
);
