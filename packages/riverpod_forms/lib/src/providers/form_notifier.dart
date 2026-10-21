import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_forms/riverpod_forms.dart';

typedef FormProvider<FORM extends RiverpodForm> =
    NotifierProvider<FormNotifier<FORM>, RiverpodFormState<FORM>>;

FormProvider<FORM> makeFormProvider<FORM extends RiverpodForm>(FORM model) =>
    NotifierProvider<FormNotifier<FORM>, RiverpodFormState<FORM>>(
      () => FormNotifier.make(model),
    );

class FormNotifier<MODEL extends RiverpodForm>
    extends Notifier<RiverpodFormState<MODEL>> {
  MODEL model;
  final MODEL initialModel;

  static FormNotifier<M> make<M extends RiverpodForm>(M model) =>
      FormNotifier<M>(model);

  FormNotifier(this.model) : initialModel = model;

  void reset() {
    model = initialModel;
    ref.invalidateSelf();
  }

  @override
  RiverpodFormState<MODEL> build() {
    final values = model.map((config) => config.watch(ref)).toList();

    return RiverpodFormState<MODEL>(
      model,
      values.every((value) => value.isValid),
    );
  }
}
