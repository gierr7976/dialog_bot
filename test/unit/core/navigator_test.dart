import 'package:dialog_bot/src/core/entity/lib.dart';
import 'package:dialog_bot/src/core/repo/lib.dart';
import 'package:dialog_bot/src/core/view/lib.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:teledart/model.dart';
import 'package:teledart/teledart.dart';
import 'package:test/test.dart';

import 'navigator_test.mocks.dart';

@GenerateMocks([
  VisitorRepository,
  FlowPoint,
  InputPoint,
  TeleDartMessage,
  TeleDart,
  Input,
  User,
  CommandInput
])
void main() => group(
      'FlowNavigator unit test',
      () {
        initRepo();
        continueFlow();
        command();
        removeRepo();
      },
    );

void continueFlow() => test(
      'Continue flow test',
      () async {
        final FlowNavigator navigator = FlowNavigator(
          tg: MockTeleDart(),
          message: mockMessage(from: 1),
          root: RootPoint(
            home: 'a',
            roots: [
              mockPoint(
                name: 'a',
                next: '/a/b',
                sub: [
                  mockPoint(
                    name: 'b',
                    next: '/c',
                    shouldStore: true,
                  ),
                ],
              ),
              mockPoint(name: 'c'),
            ],
          ),
          scope: InputScope(
            input: CommandInput(
              command: 'a',
              description: '',
            ),
            variants: [Uri.parse('/a')],
          ),
        );

        final List<Uri> sequence = [
          Uri.parse('/a'),
          Uri.parse('/a/b'),
          Uri.parse('/c'),
        ];

        navigator.stream.listen(
          (state) {
            expect(state!.visitor.route, sequence.first);
            sequence.removeAt(0);
          },
        );

        await navigator.run();

        final MockVisitorRepository repository =
            GetIt.instance<VisitorRepository>() as MockVisitorRepository;

        expect(
          verify(repository.store(captureAny)).captured.map((e) => e.route),
          [
            Uri.parse('/a/b'),
          ],
        );
      },
    );

void command() => test(
      'Navigation to command test',
      () async {
        final MockFlowPoint root = mockPoint(name: 'root');
        final MockInputPoint someCommand = mockCommand('someCommand');
        final MockTeleDartMessage message = mockMessage(text: '/someCommand');

        final FlowNavigator navigator = FlowNavigator(
          tg: MockTeleDart(),
          message: message,
          root: RootPoint(
            home: 'root',
            roots: [
              root,
              someCommand,
            ],
          ),
          scope: InputScope(
            input: CommandInput(
              command: 'someCommand',
              description: '',
            ),
            variants: [
              Uri.parse('/someCommand'),
            ],
          ),
        );

        await navigator.run();

        verify(someCommand.handle(captureAny)).called(1);
      },
    );

MockFlowPoint mockPoint({
  required String name,
  List<FlowPoint>? sub,
  String? next,
  bool shouldStore = false,
}) {
  final MockFlowPoint mock = MockFlowPoint();
  when(mock.name).thenReturn(name);
  when(mock.build()).thenReturn(sub);
  when(mock.handle(any)).thenAnswer((_) => next);
  when(mock.shouldStore).thenReturn(shouldStore);

  return mock;
}

MockInputPoint mockCommand(String command) {
  final MockCommandInput input = MockCommandInput();
  when(input.command).thenReturn('someCommand');
  when(input.matches(any)).thenReturn(true);

  final MockInputPoint mock = MockInputPoint();
  when(mock.name).thenReturn(input.command);
  when(mock.trigger).thenReturn(input);
  when(mock.build()).thenReturn(null);
  when(mock.handle(any)).thenReturn(null);

  return mock;
}

MockTeleDartMessage mockMessage({String text = '', int from = 0}) {
  final MockUser user = MockUser();
  when(user.id).thenReturn(from);

  final MockTeleDartMessage mock = MockTeleDartMessage();
  when(mock.text).thenReturn(text);
  when(mock.from).thenReturn(user);
  return mock;
}

MockCommandInput mockCommandInput(String name) {
  final MockCommandInput mock = MockCommandInput();
  when(mock.command).thenReturn(name);

  return mock;
}

void initRepo() => setUp(
      () {
        final MockVisitorRepository repository = MockVisitorRepository();
        when(
          repository.fetch(0),
        ).thenAnswer(
          (_) async => Visitor(
            key: ObjectId(),
            id: 0,
            route: Uri.parse(r'/root'),
          ),
        );
        when(
          repository.fetch(1),
        ).thenAnswer(
          (_) async => Visitor(
            key: ObjectId(),
            id: 1,
            route: Uri.parse(r'/a'),
          ),
        );
        GetIt.instance.registerSingletonAsync<VisitorRepository>(
          () async => repository,
        );
      },
    );

void removeRepo() => tearDown(
      () => GetIt.instance.unregister<VisitorRepository>(),
    );
