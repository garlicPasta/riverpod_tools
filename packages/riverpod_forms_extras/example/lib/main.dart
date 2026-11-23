import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart' hide FormState;
import 'package:riverpod_forms/riverpod_forms.dart';
import 'package:riverpod_forms_extras/riverpod_forms_extras.dart';

final titleField = makeTextField(validator: isRequired<String>());
final periodField = makeDateRangeField(
  validator: isRequired<DateTimeRange>()
      .and(
        dateRangeContains(
          DateTimeRange(
            start: DateTime.now(),
            end: DateTime.now().add(Duration(days: 1)),
          ),
        ),
      )
      .and(durationIsShorterThan(Duration(days: 7))),
);

final attachmentsField = makeFilePickField(
  validator: isRequired<List<PickedFile>>().and(filesSmallerThan(1024)),
);

final FormProvider<UploadForm> uploadFormProvider = makeFormProvider(
  UploadForm(),
);

class UploadFormResult(
  final String title,
  final DateTimeRange period,
  final List<PickedFile> attachments,
);

class UploadForm extends RiverpodForm<UploadFormResult> {
  final title = titleField;
  final period = periodField;
  final attachments = attachmentsField;

  @override
  Iterator<FormValue> get iterator =>
      <FormValue>[title, period, attachments].iterator;

  @override
  UploadFormResult getResult(snapshot) => UploadFormResult(
    title.getValid(snapshot),
    period.getValid(snapshot),
    attachments.getValid(snapshot),
  );
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'riverpod_forms_extras example',
    theme: ThemeData(colorSchemeSeed: Colors.blue, useMaterial3: true),
    home: const UploadScreen(),
  );
}

class UploadScreen extends ConsumerWidget {
  const UploadScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
    appBar: AppBar(title: const Text('Upload')),
    body: Align(
      alignment: Alignment.topCenter,
      child: Container(
        padding: const EdgeInsets.all(16),
        constraints: const BoxConstraints(maxWidth: 600),
        child: RiverpodFormView(
          form: uploadFormProvider,
          builder: (_, state) => Column(
            spacing: 12,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              RiverpodFormTextField(
                decoration: const InputDecoration(labelText: 'Title'),
                valueProxy: state.model.title,
                errorMapping: (_, IsRequired e) => 'Required',
              ),
              RiverpodFormDateRangePicker(
                decoration: const InputDecoration(labelText: 'Period'),
                valueProxy: state.model.period,
                errorMapping: (context, e) => e.on(
                  on0: (IsRequired e) => 'Is required',
                  on1: (DateRangeDoesNotContain e) => 'Doe not contain',
                  on2: (DurationLongerThan e) => 'Is too long',
                ),
              ),
              RiverpodFormFilePicker(
                field: state.model.attachments,
                itemErrorMapping: (context, error) => error.error.on(
                  on0: (_) => null,
                  on1: (EqualList<ItemError<PickedFile, FileBiggerThan>> _) =>
                      '${error.item.name} is too big',
                ),
                listErrorMapping:
                    (
                      BuildContext context,
                      CombinedValidatorResult2<
                        List<PickedFile>,
                        IsRequired,
                        EqualIterable<
                          List<ItemError<PickedFile, FileBiggerThan>>
                        >
                      >
                      error,
                    ) => error.on(
                      on0: (IsRequired s) => 'Required',
                      on1: (s) => null,
                    ),
              ),
              FilledButton(
                onPressed: () {
                  final result = state.model.validateThenGetResult(ref);
                  final message = result != null
                      ? 'Ready to upload ${result.attachments.length} file(s) '
                            'for "${result.title}"'
                      : 'Form is invalid';
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(message)));
                },
                child: const Text('Submit'),
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
