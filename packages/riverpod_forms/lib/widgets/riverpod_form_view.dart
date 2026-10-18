import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_forms/models/riverpod_form.dart' as rf;
import 'package:riverpod_forms/models/riverpod_form.dart';

class RiverpodFormView<FORM extends RiverpodForm>
    extends ConsumerStatefulWidget {
  final NotifierProvider<rf.FormNotifier<FORM>, rf.FormState<FORM>> form;
  final Widget Function(BuildContext context, rf.FormState<FORM> state) builder;

  const RiverpodFormView({
    super.key,
    required this.form,
    required this.builder,
  });

  @override
  ConsumerState<RiverpodFormView<FORM>> createState() =>
      _RiverpodFormViewState<FORM>();
}

class _RiverpodFormViewState<FORM extends RiverpodForm>
    extends ConsumerState<RiverpodFormView<FORM>> {
  @override
  Widget build(BuildContext context) =>
      widget.builder(context, ref.watch(widget.form));
}
