import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_forms/src/models/riverpod_form.dart';
import 'package:riverpod_forms/src/validators/combined_validators_2.dart';
import 'package:riverpod_forms/src/validators/is_required_validator.dart';
import 'package:riverpod_forms/src/validators/string_validators.dart';

import 'provider_tester.dart';

final class NewUserFormModel extends RiverpodForm {
  NewUserFormModel()
    : email =
          FormSingleValueProxy<
            String,
            CombinedValidator2<String, IsRequired, MinLength>
          >(
            validator: makeValidator2(
              makeIsRequiredValidator(),
              makeMinLengthValidator(3),
            ),
          ),
      password = FormSingleValueProxy<String, IsRequired>(
        validator: makeIsRequiredValidator(),
      );

  final FormValueProxy<
    String,
    CombinedValidator2<String, IsRequired, MinLength>
  >
  email;
  final FormValueProxy<String, IsRequired> password;

  @override
  Iterator<FormValueProxy<dynamic, dynamic>> get iterator =>
      <FormValueProxy<dynamic, dynamic>>[email, password].iterator;
}

void main() {
  final NotifierProvider<
    FormNotifier<NewUserFormModel>,
    RiverpodFormState<NewUserFormModel>
  >
  newUserFormProvider =
      NotifierProvider<
        FormNotifier<NewUserFormModel>,
        RiverpodFormState<NewUserFormModel>
      >(() => FormNotifier.make(NewUserFormModel()));

  group('FormNotifier', () {
    group('a new user form with empty email and password', () {
      test(
        'emit an invalid state',
        () =>
            ProviderTester<
                  void,
                  void,
                  NotifierProvider<
                    FormNotifier<NewUserFormModel>,
                    RiverpodFormState<NewUserFormModel>
                  >
                >.read(
                  setup: (_, _) {},
                  provider: (_, _) => newUserFormProvider,
                  overrides: (_, _) => [],
                  emits: (_, _) => [
                    isA<RiverpodFormState<NewUserFormModel>>().having(
                      (s) => s.isValid,
                      'isValid',
                      false,
                    ),
                  ],
                )
                .run(),
      );
    });

    group('email and password are updated to valid values', () {
      test(
        'emit valid state after revalidation',
        () =>
            ProviderTester<
                  void,
                  void,
                  NotifierProvider<
                    FormNotifier<NewUserFormModel>,
                    RiverpodFormState<NewUserFormModel>
                  >
                >(
                  setup: (_, _) {},
                  provider: (_, _) => newUserFormProvider,
                  overrides: (_, _) => [],
                  act: (c, _, _, provider) {
                    final FormNotifier<NewUserFormModel> notifier = c.read(
                      provider.notifier,
                    );
                    notifier.model.email.setValue('user@example.com');
                    notifier.model.password.setValue('password123');
                  },
                  emits: (_, _) => [
                    isA<RiverpodFormState<NewUserFormModel>>().having(
                      (s) => s.isValid,
                      'initial isValid',
                      false,
                    ),
                    isA<RiverpodFormState<NewUserFormModel>>().having(
                      (s) => s.isValid,
                      'isValid after updates',
                      true,
                    ),
                  ],
                )
                .run(),
      );
    });
  });
}
