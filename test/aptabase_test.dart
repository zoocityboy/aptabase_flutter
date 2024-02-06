import 'package:aptabase_flutter/aptabase_flutter.dart';
import 'package:aptabase_flutter/src/data/helpers/batch_processor.dart';
import 'package:aptabase_flutter/src/domain/domain.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'shared.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late List<MethodCall> mockInfoLogs;
  setUpAll(() {
    mockInfoLogs = mockPackageInfo();
    DeviceInfoPlusLinuxPlugin.registerWith();
  });
  tearDownAll(() => mockInfoLogs.clear());
  group('Aptabase', () {
    group('initialzation', () {
      test('should throws exception when not initialized.', () {
        expect(() => Aptabase.instance, throwsA(isA<AptabaseNotInitializedException>()));
      });

      test('should return instance after instance initialized', () async {
        const config = AptabaseConfig(
          appKey: 'A-DEV-00000',
        );
        final aptabase = await Aptabase.init(config);
        expect(aptabase.isSuccess(), isTrue);
      });

      test('should throw exception when wrong format of AppKey', () async {
        const config = AptabaseConfig(
          appKey: 'A-00000',
        );
        final aptabase = await Aptabase.init(config);
        expect(aptabase.isError(), isTrue);
        expect(aptabase.exceptionOrNull(), isA<AptabseGenericFailure>());
      });

      test('should return instance after instance initialized', () async {
        await Aptabase.init(
          const AptabaseConfig(
            appKey: 'A-DEV-00000',
          ),
        );

        expect(Aptabase.instance, isA<Aptabase>());
      });

      test('should call all necessary steps', () async {
        const config = AptabaseConfig(
          appKey: 'A-DEV-00000',
        );
        final aptabase = await Aptabase.init(config);
        expect(aptabase.isSuccess(), isTrue);
      });
    });

    test('should close', () async {
      final storage = MockAptabaseStorage();
      final config = AptabaseConfig(
        appKey: 'A-DEV-00000',
        storageBuilder: (_) async => storage,
      );
      when(() => storage.onValueChanged).thenAnswer((invocation) => const Stream<int>.empty());
      final aptabase = await Aptabase.init(config);

      expect(aptabase.isSuccess(), isTrue);

      Aptabase.instance.close();
      verifyInOrder([
        storage.close,
      ]);
    });
  });

  group('Batch processor', () {
    test('should flush the processor', () async {
      final aptabase = MockAptabase();
      when(aptabase.flush).thenAnswer((_) async {});

      await aptabase.flush();
      verify(aptabase.flush).called(1);
    });

    test('should write event to storage', () async {
      final event = FakeTrackEvent();
      final aptabase = MockAptabase();
      final batchProcessor = MockBatchProcessor();
      when(() => aptabase.trackEvent(event)).thenAnswer((_) async {});
      when(() => aptabase.processor).thenReturn(batchProcessor);

      when(() => aptabase.storage.write(any())).thenAnswer((_) async {});

      await aptabase.trackEvent(event);

      verify(() => aptabase.trackEvent(event)).called(1);
      // verify(() => aptabase.storage.write(captureAny())).called(1);
    });
  });

  group('Events', () {
    test(
      'check properties',
      () async {
        final aptabase = MockAptabase();
        final session = FakeSession();
        final sysInfo = FakeSystemInfo();
        final event = FakeTrackEvent();
        final storage = MockAptabaseStorage();
        when(() => aptabase.session).thenReturn(session);
        when(() => aptabase.systemInfo).thenReturn(sysInfo);
        when(() => aptabase.storage).thenReturn(storage);

        when(() => aptabase.trackEvent(any())).thenAnswer((_) async {});

        await aptabase.trackEvent(event);
        // verifyInOrder([
        //   () => aptabase.session,
        //   () => aptabase.systemInfo,
        //   () => aptabase.storage,
        // ]);
        // verify(() => aptabase.storage.write(captureAny())).captured.single.match(
        //       (eventItem) =>
        //           eventItem.eventName == event.eventName &&
        //           eventItem.props == event.props &&
        //           eventItem.session == session &&
        //           eventItem.systemInfo == sysInfo,
        //       description: 'Event item does not match expected values',
        //     );
      },
      skip: true,
    );
  });
}
// // ...

// group('Aptabase', () {
//   // ...

//   group('trackCustomEvent', () {
//     test('should write event to storage', () async {
//       final aptabase = Aptabase.instance;
//       final eventName = 'custom_event';
//       final props = {'key': 'value'};

//       await aptabase.trackCustomEvent(eventName, props);

//       verify(() => aptabase.storage.write(captureAny())).captured.single.match(
//         (eventItem) =>
//             eventItem.eventName == eventName &&
//             eventItem.props == props &&
//             eventItem.session == aptabase.session &&
//             eventItem.systemInfo == aptabase.systemInfo,
//         description: 'Event item does not match expected values',
//       );
//     });
//   });

//   group('trackEvent', () {
//     test('should write event to storage', () async {
//       final aptabase = Aptabase.instance;
//       final event = AptabaseTrackEvent('event_name', {'key': 'value'});

//       await aptabase.trackEvent(event);

//       verify(() => aptabase.storage.write(captureAny())).captured.single.match(
//         (eventItem) =>
//             eventItem.eventName == event.eventName &&
//             eventItem.props == event.props &&
//             eventItem.session == aptabase.session &&
//             eventItem.systemInfo == aptabase.systemInfo,
//         description: 'Event item does not match expected values',
//       );
//     });
//   });

//   group('flush', () {
//     test('should flush the processor', () async {
//       final aptabase = Aptabase.instance;

//       await aptabase.flush();

//       verify(() => aptabase.processor.flush()).called(1);
//     });
//   });

//   // ...
// });