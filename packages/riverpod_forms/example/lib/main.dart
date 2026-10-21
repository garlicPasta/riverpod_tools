import 'package:flutter/material.dart' hide FormState;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_forms/riverpod_forms.dart';

var checkIfEmailIsTaken = FutureProvider.family<bool, String>(
  (ref, email) => Future.delayed(
    Duration(seconds: 2),
    () => ['user1@example.com', 'user2@example.com'].contains(email),
  ),
);

final emailField =
    makeTextField<
      CombinedValidatorResult3<String?, IsRequired, RegexMismatch, bool>
    >(
      validator: CombinedValidator3(
        makeIsRequiredValidator<String>(),
        makeIsValidEmailValidator(),
        RiverpodValidator(
          (ref, value) => ref
              .watch(checkIfEmailIsTaken(value ?? ''))
              .whenData((isTaken) => isTaken ? true : null),
        ),
      ),
    );

final passwordField0 =
    makeTextField<CombinedValidatorResult2<String?, IsRequired, MinLength>>(
      validator: CombinedValidator2(
        makeIsRequiredValidator<String>(),
        makeMinLengthValidator(6),
      ),
    );

final passwordField1 = makeTextField(
  validator: CombinedValidator2(
    makeIsRequiredValidator<String>(),
    makeIsEqual(passwordField0),
  ),
);

final rolesSelect = FormSingleValueProxy<Role, IsRequired>(
  values: (_) => AsyncData(Role.values),
  validator: makeIsRequiredValidator<Role>(),
);

final hobbiesMultiSelect = FormMu

void main() {
  runApp(const ProviderScope(child: ExampleApp()));
}

final NotifierProvider<FormNotifier<SignUpForm>, RiverpodFormState<SignUpForm>>
signUpFormProvider =
    NotifierProvider<FormNotifier<SignUpForm>, RiverpodFormState<SignUpForm>>(
      () => FormNotifier.make(SignUpForm()),
    );

enum Role { admin, user, guest }

class UserFormResult(
  final String email,
  final String password,
  final Role role,
);

class SignUpForm extends RiverpodForm<UserFormResult> {
  final email = emailField;
  final password = passwordField0;
  final confirmPassword = passwordField1;
  final roles = rolesSelect;

  @override
  Iterator<FormValueProxy> get iterator =>
      <FormValueProxy>[email, password, confirmPassword, roles].iterator;

  @override
  UserFormResult getResult(snapshot) => UserFormResult(
    email.getValid(snapshot),
    password.getValid(snapshot),
    roles.getValid(snapshot),
  );
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'riverpod_forms example',
    theme: ThemeData(colorSchemeSeed: Colors.blue, useMaterial3: true),
    home: const SignUpScreen(),
  );
}

class SignUpScreen extends ConsumerWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
    appBar: AppBar(title: const Text('Sign up')),
    body: Align(
      alignment: Alignment.topCenter,
      child: Container(
        padding: const EdgeInsets.all(16),
        constraints: BoxConstraints(maxWidth: 600),
        child: RiverpodFormView(
          form: signUpFormProvider,
          builder: (_, state) => Column(
            spacing: 12,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              RiverpodFormTextField(
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email',
                ),
                valueProxy: state.model.email,
                errorMapping: (error) => switch (error) {
                  Validator3_0Failed(error: IsRequired _) =>
                    'Email is required',
                  Validator3_1Failed(error: RegexMismatch _) =>
                    'Email format is invalid',
                  Validator3_2Failed(error: bool _) => 'Email is already taken',
                },
              ),
              RiverpodFormTextField(
                decoration: const InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter at least 6 characters',
                ),
                valueProxy: state.model.password,
                errorMapping: (error) => switch (error) {
                  Validator2_0Failed() => 'Password is required',
                  Validator2_1Failed() =>
                    'Password must have at least 6 characters',
                },
              ),
              RiverpodFormTextField(
                decoration: const InputDecoration(
                  labelText: 'Confirm password',
                  hintText: 'Re-enter your password',
                ),
                valueProxy: state.model.confirmPassword,
                errorMapping: (error) => switch (error) {
                  Validator2_0Failed() => 'Password is required',
                  Validator2_1Failed() => 'Passwords must match',
                },
              ),
              RiverpodFormChoiceChips(
                valueProxy: state.model.roles,
                labelMapping: (role) => role.name,
                errorMapping: (error) => 'Role is required',
              ),
              FilledButton(
                onPressed: state.isValid
                    ? () {
                        final result = state.model.validateThenGetResult(ref);
                        final String message = result != null
                            ? 'Ready to submit for ${result.email}'
                            : 'Form is invalid';
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text(message)));
                      }
                    : null,
                child: Text(state.isValid ? 'Submit' : 'Fix errors first'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
