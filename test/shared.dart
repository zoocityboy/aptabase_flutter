import 'package:aptabase_flutter/aptabase_flutter.dart';
import 'package:aptabase_flutter/src/core/aptabase_constants.dart';
import 'package:aptabase_flutter/src/core/aptabse_logger.dart';
import 'package:aptabase_flutter/src/core/sys_info.dart';
import 'package:aptabase_flutter/src/data/data.dart';
import 'package:aptabase_flutter/src/domain/domain.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

List<MethodCall> mockPackageInfo() {
  const channel = MethodChannel('dev.fluttercommunity.plus/package_info');
  final log = <MethodCall>[];

  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
    channel,
    (MethodCall methodCall) async {
      log.add(methodCall);
      switch (methodCall.method) {
        case 'getAll':
          return <String, dynamic>{
            'appName': 'package_info_example',
            'buildNumber': '1',
            'packageName': 'io.flutter.plugins.packageinfoexample',
            'version': '1.0',
            'installerStore': null,
          };
        default:
          assert(false, 'not implemented ${methodCall.method}');
          return null;
      }
    },
  );
  return log;
}

class MockAptabase extends Mock implements Aptabase {}

class MockAptabaseConfig extends Mock implements AptabaseConfig {}

class MockBatchProcessor extends Mock implements BatchProcessor {}

class MockApiClient extends Mock implements AptabaseApiClient {}

class MockSession extends Mock implements AptabaseSession {}

class MockSystemInfo extends Mock implements SystemInfo {}

class FakeAptabaseConfig extends Fake implements AptabaseConfig {
  @override
  String get appKey => 'A-DEV-00000';
  @override
  Uri? get baseUrl => Uri.parse('https://localhost');

  @override
  bool get debug => false;

  @override
  String? get customBaseUrl => null;

  @override
  Duration get sessionTimeout => AptabaseConstants.defaultSessionTimeout;

  @override
  Duration get sheduledDelay => AptabaseConstants.defaultSheduledDelay;

  @override
  int get maxExportBatchSize => AptabaseConstants.defaultMaxExportBatchSize;

  @override
  AptabaseStorageBuilder? get storageBuilder => null;

  @override
  AptabaseLogCallback? get logCallback => null;

  @override
  bool validateKey() {
    return true;
  }

  @override
  AptabaseHosts get host => AptabaseHosts.dev;
}

class FakeEventSystemProperties extends Fake implements EventSystemProperties {
  @override
  bool get isDebug => false;
  @override
  String get osName => 'vm';
  @override
  String get osVersion => '1.0';
  @override
  String get locale => 'en';

  @override
  String get appVersion => 'app_version';

  @override
  String get appBuildNumber => '1.0.0';

  @override
  String get sdkVersion => 'aptabase_sdk@1.0.0';
}

class FakeSystemInfo extends Fake implements SystemInfo {
  @override
  String get osName => 'vm';
  @override
  String get osVersion => '1.0';
  @override
  String get locale => 'en';
  @override
  String get appVersion => 'app_version';
  @override
  String get buildNumber => '1.0.0';
}

class FakeSession extends Fake implements AptabaseSession {
  @override
  String evalSessionId() => 'session_id';
  @override
  DateTime get createdAt => DateTime(1900);
}

class FakeTrackEvent extends Fake implements AptabaseTrackEvent {
  @override
  String get eventName => 'test';
  @override
  Map<String, Object>? get props => {
        'test': 'test',
      };
}

class TestTrackEvent extends AptabaseTrackEvent {
  TestTrackEvent()
      : super(
          eventName: 'test',
          props: {'test': 'value'},
        );
}

class MockAptabaseStorage extends Mock implements AptabaseStorage {}

// class FakeAptabase extends Fake implements Aptabase {
//   @override
//   AptabaseStorage get storage => MockAptabaseStorage();
//   @override
//   AptabaseConfig get config => MockAptabaseConfig();

//   @override
//   AptabaseSession get session => MockSession();

//   @override
//   BatchProcessor get processor => MockBatchProcessor();

//   @override
//   Future<void> flush() async {}
// }
