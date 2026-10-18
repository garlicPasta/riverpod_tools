import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_forms/riverpod_forms.dart';
import 'package:riverpod_forms/riverpod_forms.dart' as rf;

void main() {
  runApp(const ProviderScope(child: ExampleApp()));
}

final NotifierProvider<rf.FormNotifier<SignUpForm>, rf.FormState<SignUpForm>>
signUpFormProvider =
    NotifierProvider<rf.FormNotifier<SignUpForm>, rf.FormState<SignUpForm>>(
      () => rf.FormNotifier.make(
        SignUpForm(
          rf.FormSingleValueProxy<
            String,
            CombinedValidator2<String, IsRequired, RegexMismatch>
          >(
            validator: makeValidator2(
              makeIsRequiredValidator<String>(),
              makeRegexValidator(
                RegExp(r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'),
              ),
            ),
          ),
          rf.FormSingleValueProxy<
            String,
            CombinedValidator2<String, IsRequired, MinLength>
          >(
            validator: makeValidator2(
              makeIsRequiredValidator<String>(),
              makeMinLengthValidator(6),
            ),
          ),
          rf.FormSingleValueProxy<Role, IsRequired>(
            values: (_) => AsyncData(Role.values),
            validator: makeIsRequiredValidator<Role>(),
          ),
        ),
      ),
    );

enum Role { admin, user, guest }

class SignUpForm extends rf.RiverpodForm {
  final rf.FormValueProxy<
    String,
    CombinedValidator2<String, IsRequired, RegexMismatch>
  >
  email;
  final rf.FormValueProxy<
    String,
    CombinedValidator2<String, IsRequired, MinLength>
  >
  password;

  final rf.FormValueProxy<Role, IsRequired> roles;

  SignUpForm(this.email, this.password, this.roles);

  @override
  Iterator<rf.FormValueProxy<dynamic, dynamic>> get iterator =>
      <rf.FormValueProxy<dynamic, dynamic>>[email, password, roles].iterator;
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
    body: Padding(
      padding: const EdgeInsets.all(16),
      child: RiverpodFormView(
        form: signUpFormProvider,
        builder: (_, state) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            RiverpodFormTextField<
              CombinedValidator2<String, IsRequired, RegexMismatch>
            >(
              valueProxy: state.model.email,
              errorMapping: (error) => switch (error) {
                Validator0Failed(error: IsRequired _) => 'Email is required',
                Validator1Failed(error: RegexMismatch _) =>
                  'Please enter a valid email address',
              },
            ),
            const SizedBox(height: 12),
            RiverpodFormTextField<
              CombinedValidator2<String, IsRequired, MinLength>
            >(
              valueProxy: state.model.password,
              errorMapping: (error) => switch (error) {
                Validator0Failed<String, IsRequired, MinLength> _ =>
                  'Password is required',
                Validator1Failed<String, IsRequired, MinLength> _ =>
                  'Password must have at least 6 characters',
              },
            ),
            RiverpodFormChoiceChips<Role, IsRequired>(
              valueProxy: state.model.roles,
              labelMapping: (role) => role.name,
              errorMapping: (error) => 'Role is required',
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () {
                final String message = state.isValid
                    ? 'Form is valid and ready to submit'
                    : 'Form is invalid';
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(message)));
              },
              child: Text(state.isValid ? 'Submit' : 'Fix errors first'),
            ),
          ],
        ),
      ),
    ),
  );
}
