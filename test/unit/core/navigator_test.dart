import 'package:dialog_bot/src/core/common/lib.dart';
import 'package:dialog_bot/src/core/entity/lib.dart';
import 'package:dialog_bot/src/core/repo/lib.dart';
import 'package:dialog_bot/src/core/view/lib.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'navigator_test.mocks.dart';

@GenerateMocks(
    [VisitorRepository, FlowPoint, TeleDartMessage, TeleDart, Input, User])
void main() => group(
      'FlowNavigator unit test',
      () {
        init();
        continueFlow();
        removeRepo();
      },
    );

void init() => test(
      'Initialization test',
      () async {
        _initRepository();
        final MockFlowPoint root = mockPoint(name: 'root');

        final FlowNavigator navigator = FlowNavigator(
          tg: MockTeleDart(),
          message: mockMessage(),
          trigger: MockInput(),
          roots: [root],
        );

        await navigator.init();

        expect(
          navigator.ready.visitor.route,
          Uri.parse('/root'),
        );
      },
    );

void continueFlow() => test(
      'Continue flow test',
      () async {
        _initRepository();
        final MockFlowPoint root = mockPoint(
          name: 'home',
          sub: [
            mockPoint(
              name: 'a',
              next: 'b',
              sub: [
                mockPoint(
                  name: 'b',
                  next: '/home/c',
                  shouldStore: true,
                ),
              ],
            ),
            mockPoint(name: 'c'),
          ],
        );

        final FlowNavigator navigator = FlowNavigator(
          tg: MockTeleDart(),
          message: mockMessage(from: 1),
          trigger: MockInput(),
          roots: [root],
        );

        final List<Uri> sequence = [
          Uri.parse('/home/a'),
          Uri.parse('/home/a/b'),
          Uri.parse('/home/c'),
        ];

        navigator.stream.listen(
          (state) {
            expect(state!.visitor.route, sequence.first);
            sequence.removeAt(0);
          },
        );

        await navigator.start();

        final MockVisitorRepository repository =
            GetIt.instance<VisitorRepository>() as MockVisitorRepository;

        expect(
          verify(repository.store(captureAny)).captured.map((e) => e.route),
          [
            Uri.parse('/home/a/b'),
          ],
        );
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

MockTeleDartMessage mockMessage({String text = '', int from = 0}) {
  final MockUser user = MockUser();
  when(user.id).thenReturn(from);

  final MockTeleDartMessage mock = MockTeleDartMessage();
  when(mock.text).thenReturn(text);
  when(mock.from).thenReturn(user);
  return mock;
}

void _initRepository() {
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
      route: Uri.parse(r'/home/a'),
    ),
  );
  GetIt.instance.registerSingletonAsync<VisitorRepository>(
    () async => repository,
  );
}

void removeRepo() => tearDown(
      () => GetIt.instance.unregister<VisitorRepository>(),
    );
