import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_forms/src/models/riverpod_form.dart';
import 'package:riverpod_forms/src/providers/form_notifier.dart';

class RiverpodFormView<FORM extends RiverpodForm>
    extends ConsumerStatefulWidget {
  final NotifierProvider<FormNotifier<FORM>, RiverpodFormState<FORM>> form;
  final Widget Function(BuildContext context, RiverpodFormState<FORM> state)
  builder;

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
