import 'package:aptabase_flutter/src/core/aptabase_constants.dart';
import 'package:aptabase_flutter/src/domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'logger_test.dart';
import 'shared.dart';

void main() {
  final testStorageItem = StorageEventItem.create(
    eventName: 'test',
    props: const {'key': 'value'},
    session: FakeSession(),
    systemInfo: FakeSystemInfo(),
  );
  // TestWidgetsFlutterBinding.ensureInitialized();
  // late List<MethodCall> mockInfoLogs;
  // setUpAll(() {
  //   mockInfoLogs = mockPackageInfo();
  //   DeviceInfoPlusLinuxPlugin.registerWith();
  // });
  // tearDownAll(() => mockInfoLogs.clear());
  setUpAll(() {
    ///
    registerFallbackValue(TestTrackEvent());
    registerFallbackValue(testStorageItem);
  });
  group('AptabaseConfig', () {
    group('equality', () {
      group('AptabaseConfig', () {
        test('should return true if two AptabaseConfig objects are equal', () {
          // Arrange
          const config1 = AptabaseConfig(appKey: 'A-DEV-00000');
          const config2 = AptabaseConfig(appKey: 'A-DEV-00000');
          expect(config1 == config2, isTrue);
          expect(config1.hashCode, config2.hashCode);
          expect(config1, equals(config2));
        });

        test('should return false if two AptabaseConfig objects are not equal', () {
          const config1 = AptabaseConfig(appKey: 'A-DEV-00000');
          final config2 = AptabaseConfig(
            appKey: 'A-SH-00000',
            customBaseUrl: '',
            debug: true,
            sessionTimeout: const Duration(seconds: 8),
            maxExportBatchSize: 16,
            sheduledDelay: const Duration(seconds: 8),
            storageBuilder: (_) async => MockAptabaseStorage(),
          );
          expect(config1 == config2, isFalse);
          expect(config1.hashCode, isNot(config2.hashCode));
          expect(config1, isNot(config2));
          expect(config1, isNot(equals(config2)));
        });
      });
      group('default values', () {
        test('should have default values', () {
          const appKey = 'A-DEV-00000';
          const config = AptabaseConfig(appKey: appKey);

          expect(config.appKey, appKey);
          expect(config.debug, false);
          expect(config.maxExportBatchSize, AptabaseConstants.defaultMaxExportBatchSize);
          expect(config.sheduledDelay, AptabaseConstants.defaultSheduledDelay);
          expect(config.sessionTimeout, AptabaseConstants.defaultSessionTimeout);
          expect(config.storageBuilder, isNull);
          expect(config.host, AptabaseHosts.dev);
          expect(config.baseUrl, Uri.parse(AptabaseHosts.dev.url));
          expect(config, equals(const AptabaseConfig(appKey: appKey)));
        });

        test('should have default values', () {
          const appKey = 'A-SH-00000';
          const customUrl = 'https://custom.aptabase.com';
          const config = AptabaseConfig(
            appKey: appKey,
            customBaseUrl: customUrl,
          );
          const config2 = AptabaseConfig(
            appKey: appKey,
            customBaseUrl: customUrl,
          );

          expect(config.appKey, appKey);
          expect(config.debug, false);
          expect(config.maxExportBatchSize, AptabaseConstants.defaultMaxExportBatchSize);
          expect(config.sheduledDelay, AptabaseConstants.defaultSheduledDelay);
          expect(config.sessionTimeout, AptabaseConstants.defaultSessionTimeout);
          expect(config.storageBuilder, isNull);
          expect(config.host, AptabaseHosts.sh);
          expect(config.baseUrl, Uri.parse(customUrl));
          expect(config, equals(config2));
          expect(config.validateKey(), isTrue);
          expect(config.hashCode, config2.hashCode);
        });
      });
    });
  });
  group('track', () {
    //   test('should run track', () async {
    //     // final session = MockSession();
    //     // final storage = MockAptabaseStorage();
    //     // final batchProcessor = MockBatchProcessor();
    //     // final client = MockApiClient();
    //     // final logger = MockLogger();

    //     ///
    //     final aptabase = MockAptabase();
    //     // when(() => aptabase.client).thenReturn(client);
    //     // when(() => aptabase.processor).thenReturn(batchProcessor);
    //     // when(() => aptabase.storage).thenReturn(storage);
    //     // when(() => aptabase.session).thenReturn(session);
    //     // when(() => aptabase.logger).thenReturn(logger);
    //     // when(() => aptabase.isConnected).thenReturn(ValueNotifier(true));
    //     // when(() => aptabase.systemInfo).thenReturn(FakeSystemInfo());

    //     // when(() => storage.onValueChanged).thenAnswer((invocation) => const Stream<int>.empty());
    //     when(() => aptabase.trackEvent(any())).thenAnswer((_) async {});
    //     when(() => aptabase.trackCustomEvent(any(), any())).thenAnswer((_) async {});
    //     await aptabase.trackEvent(TestTrackEvent());
    //     await aptabase.trackCustomEvent(
    //       'event_name',
    //       {'key': 'value'},
    //     );
    //     verify(() => aptabase.trackEvent(captureAny())).called(1);
    //     verify(() => aptabase.trackCustomEvent(captureAny(), captureAny())).called(1);
    //   });
    // });
    group('callable track functins', () {
      test('should run trackCustomEvent', () async {
        final aptabase = MockAptabase();

        when(() => aptabase.trackCustomEvent(any(), any())).thenAnswer((_) async {});
        await aptabase.trackCustomEvent(
          'event_name',
          {'key': 'value'},
        );
        verify(() => aptabase.trackCustomEvent(captureAny(), captureAny())).called(1);
      });
      test('should run trackEvent', () async {
        final aptabase = MockAptabase();
        when(() => aptabase.trackEvent(any())).thenAnswer((_) async {});
        await aptabase.trackEvent(TestTrackEvent());
        verify(() => aptabase.trackEvent(captureAny())).called(1);
      });
    });

    group('write to storage', () {
      test('should write to storage', () async {
        final aptabase = MockAptabase();
        final logger = MockLogger();
        final storage = MockAptabaseStorage();
        final session = MockSession();
        final sysInfo = FakeSystemInfo();
        when(() => aptabase.logger).thenReturn(logger);
        when(() => aptabase.session).thenReturn(session);
        when(() => aptabase.systemInfo).thenReturn(sysInfo);

        when(() => aptabase.storage).thenReturn(storage);
        when(() => storage.onValueChanged).thenAnswer((invocation) => const Stream<int>.empty());
        when(() => storage.write(any())).thenAnswer((_) async {});
        // when(() => aptabase.trackEvent(any())).thenAnswer((_) async {
        //   await storage.write(testStorageItem);
        // });

        await aptabase.trackEvent(TestTrackEvent());
        verify(() => aptabase.trackEvent(captureAny())).called(1);
        // verify(() => storage.write(captureAny())).called(1);
      });
    });
  });
}
