import 'package:flutter/material.dart' hide FormState;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_forms/riverpod_forms.dart';

final checkIfEmailIsTaken = FutureProvider.family<bool, String>(
  (_, email) => Future.delayed(
    Duration(seconds: 2),
    () => ['user1@example.com', 'user2@example.com'].contains(email),
  ),
);

final emailField = makeTextField(
  validator: isRequired<String>()
      .and(isEmail())
      .and(
        .riverpod(
          (ref, value) => ref
              .watch(checkIfEmailIsTaken(value ?? ''))
              .whenData((isTaken) => isTaken ? true : null),
        ),
      ),
);

final passwordField0 =
    makeTextField<CombinedValidatorResult2<String?, IsRequired, MinLength>>(
      validator: isRequired<String>().and(stringHasMinLegth(6)),
    );

final passwordField1 = makeTextField(
  isEnabled: (ref) => !(passwordField0.watchValue(ref)?.isEmpty ?? true),
  validator: isRequired<String>().and(isEqual(passwordField0)),
);

enum Role { admin, user, guest }

final rolesSelect = SingleFormValue<Role, IsRequired>(
  values: (_) => AsyncData(Role.values),
  validator: isRequired(),
);

final rightsProvider = FutureProvider<List<String>>(
  (ref) => Future.delayed(
    Duration(seconds: 2),
    () => ['Reading', 'Hiking', 'Cooking', 'Gaming', 'Photography'],
  ),
);

final hobbiesMultiSelect = MultiFormValue(
  values: (ref) => ref.watch(rightsProvider),
  validator: isRequired<List<String>>().and(sizeLessThan<String>(1)),
);

final FormProvider<SignUpForm> signUpFormProvider = makeFormProvider(
  SignUpForm(),
);

class UserFormResult(
  final String email,
  final String password,
  final Role role,
  final List<String> hobbies,
);

class SignUpForm extends RiverpodForm<UserFormResult> {
  final email = emailField;
  final password = passwordField0;
  final confirmPassword = passwordField1;
  final roles = rolesSelect;
  final hobbies = hobbiesMultiSelect;

  @override
  Iterator<FormValue> get iterator =>
      <FormValue>[email, password, confirmPassword, roles, hobbies].iterator;

  @override
  UserFormResult getResult(snapshot) => UserFormResult(
    email.getValid(snapshot),
    password.getValid(snapshot),
    roles.getValid(snapshot),
    hobbies.getValid(snapshot),
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
              RiverpodFormMultiselectChips(
                valueProxy: state.model.hobbies,
                labelMapping: (hobby) => hobby,
                errorMapping: (error) => switch (error) {
                  Validator2_0Failed(error: IsRequired _) => '',
                  Validator2_1Failed(error: ListSizeLessThan error) =>
                    'Select at least ${error.size} hobbies',
                },
              ),
              FilledButton(
                onPressed: state.isValid
                    ? () {
                        final result = state.model.validateThenGetResult(ref);
                        final String message = result != null
                            ? 'Ready to submit for ${result.email} (${result.hobbies.length} hobbies)'
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

void main() {
  runApp(const ProviderScope(child: ExampleApp()));
}
