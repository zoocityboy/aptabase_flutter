import 'package:aptabase_flutter/src/core/core.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockLogger extends Mock implements AptabaseLogger {}

void main() {
  group('logger', () {
    setUp(() => registerFallbackValue(Level.debug));
    group('AptabaseLogger', () {
      group('log record', () {
        test('should have default values', () {
          const tag = 'tag';
          final log = AptabaseLogRecord(message: 'test', level: Level.debug, createdAt: DateTime.now(), tag: tag);

          expect(log.message, 'test');
          expect(log.level, Level.debug);
          expect(log.error, isNull);
          expect(log.stackTrace, isNull);
          expect(log.object, isNull);
          expect(log.tag, tag);
        });
      });
      test(
          'when intialize logget '
          'debug should be off and logCallback should be null', () {
        const logger = AptabaseLogger();
        expect(logger.isDebug, false);
        expect(logger.logCallback, isNotNull);
      });

      test("shouldn't log when isDebug false", () {
        AptabaseLogRecord? record;
        AptabaseLogger(logCallback: (value) => record = value).debug('Debug message');
        expect(record, isNull);
      });
      test('emmit log record if isDebug', () {
        AptabaseLogRecord? record;
        final logger = AptabaseLogger(logCallback: (value) => record = value, isDebug: true)..debug('Debug message');
        expect(record, isNotNull);
        expect(record?.level, Level.debug);

        logger.info('info message');
        expect(record?.level, Level.info);

        logger.warn('warn message');
        expect(record?.level, Level.warn);
        logger.error('error message');
        expect(record?.level, Level.error);
        logger.wtf('wtf message');
        expect(record?.level, Level.wtf);
      });

      // Write similar tests for other log levels (info, warn, error, wtf)
    });
    test('should log when isDebug true', () {
      final AptabaseLogger logger = MockLogger();
      when(
        () => logger.log(
          any(),
          level: any(named: 'level'),
          object: any(named: 'object'),
          error: any(named: 'error'),
          stackTrace: any(named: 'stackTrace'),
          tag: any(named: 'tag'),
        ),
      ).thenReturn(null);
      when(() => logger.isDebug).thenReturn(true);
      when(() => logger.logCallback?.call(any())).thenReturn(null);
      when(
        () => logger.debug(
          any(),
          object: any(named: 'object'),
          error: any(named: 'error'),
          stackTrace: any(named: 'stackTrace'),
          tag: any(named: 'tag'),
        ),
      ).thenAnswer((_) async {
        logger.log('test', level: Level.debug);
        return;
      });

      logger.debug('test');
      logger.debug('test');
      // logger.debug('test', error: 'error');
      // logger.debug('test', stackTrace: StackTrace.fromString('stackTrace'));
      // logger.debug('test', tag: 'tag');

      verify(
        () => logger.debug(
          captureAny(),
          object: captureAny(named: 'object'),
          error: captureAny(named: 'error'),
          stackTrace: captureAny(named: 'stackTrace'),
          tag: captureAny(named: 'tag'),
        ),
      ).called(greaterThan(1));
      // verify(
      //   () => logger.log(
      //     captureAny(),
      //     object: captureAny(named: 'object'),
      //     error: captureAny(named: 'error'),
      //     stackTrace: captureAny(named: 'stackTrace'),
      //     tag: captureAny(named: 'tag'),
      //     level: captureAny(named: 'level'),
      //   ),
      // ).called(greaterThan(1));
      // verify(() => logger.debug('test')).called(1);
    });
  });
}
