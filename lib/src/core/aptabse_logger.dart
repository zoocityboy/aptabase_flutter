// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';

import '../domain/domain.dart';

/// Callback for logging messages.
typedef AptabaseLogCallback = void Function(AptabaseLogRecord record);

/// Represents a log record in the AptabaseLogger.
///
/// A log record contains information such as the log message, log level,
/// creation timestamp, associated object, error, and stack trace.
class AptabaseLogRecord {
  /// Creates a new instance of [AptabaseLogRecord].
  ///
  /// The [message] parameter is the log message.
  /// The [level] parameter is the log level.
  /// The [createdAt] parameter is the creation timestamp.
  /// The [object] parameter is an optional associated object.
  /// The [error] parameter is an optional error object.
  /// The [stackTrace] parameter is an optional stack trace.
  /// The [tag] parameter is an optional custom tag for log record.
  const AptabaseLogRecord({
    required this.message,
    required this.level,
    required this.createdAt,
    this.object,
    this.error,
    this.stackTrace,
    this.tag,
  });

  /// The log message.
  final String message;

  /// The log level.
  final Level level;

  /// The creation timestamp.
  final DateTime createdAt;

  /// An optional associated object.
  final Object? object;

  /// An optional error object.
  final Object? error;

  /// An optional stack trace.
  final StackTrace? stackTrace;

  /// Custom tag for log record.
  final String? tag;
}

/// A logger class for logging messages with different log levels.
///
/// The [AptabaseLogger] class provides methods for logging messages at different log levels such as debug, info, warn, error, and wtf (what a terrible failure).
/// The log messages can be accompanied by an optional error object and stack trace.
///
/// Example usage:
/// ```dart
/// Logger logger = Logger();
/// logger.debug('Debug message');
/// logger.info('Info message');
/// logger.warn('Warning message');
/// logger.error('Error message');
/// logger.wtf('WTF message');
/// ```
class AptabaseLogger {
  /// Creates a new instance of the [AptabaseLogger] class.
  ///
  /// The [isDebug] parameter determines whether debug messages should be logged.
  /// By default, debug messages are not logged.
  const AptabaseLogger({this.isDebug = false, this.logCallback});

  /// Indicates whether debug messages should be logged.
  final bool isDebug;

  /// The log callback function.
  final AptabaseLogCallback? logCallback;

  /// Logs a message at the specified log level.
  ///
  /// The [message] parameter is the message to be logged.
  /// The [error] parameter is an optional error object.
  /// The [stackTrace] parameter is an optional stack trace.
  /// The [level] parameter specifies the log level.
  @protected
  @visibleForTesting
  void log(
    String message, {
    required Level level,
    Object? object,
    Object? error,
    StackTrace? stackTrace,
    String? tag,
  }) {
    if (!isDebug && level.value < Level.wtf.value) return;
    logCallback?.call(
      AptabaseLogRecord(
        message: message,
        createdAt: DateTimeX.now,
        level: level,
        object: object,
        error: error,
        stackTrace: stackTrace,
      ),
    );
  }

  /// Logs a debug message.
  ///
  /// The [message] parameter is the debug message to be logged.
  /// The [error] parameter is an optional error object.
  /// The [stackTrace] parameter is an optional stack trace.
  void debug(
    String message, {
    Object? object,
    Object? error,
    StackTrace? stackTrace,
    String? tag,
  }) =>
      log(
        message,
        object: object,
        error: error,
        stackTrace: stackTrace,
        level: Level.debug,
        tag: tag,
      );

  /// Logs an info message.
  ///
  /// The [message] parameter is the info message to be logged.
  /// The [error] parameter is an optional error object.
  /// The [stackTrace] parameter is an optional stack trace.
  void info(
    String message, {
    Object? object,
    Object? error,
    StackTrace? stackTrace,
    String? tag,
  }) =>
      log(message, object: object, error: error, stackTrace: stackTrace, level: Level.info);

  /// Logs a warning message.
  ///
  /// The [message] parameter is the warning message to be logged.
  /// The [error] parameter is an optional error object.
  /// The [stackTrace] parameter is an optional stack trace.
  void warn(
    String message, {
    Object? object,
    Object? error,
    StackTrace? stackTrace,
    String? tag,
  }) =>
      log(message, object: object, error: error, stackTrace: stackTrace, level: Level.warn);

  /// Logs an error message.
  ///
  /// The [message] parameter is the error message to be logged.
  /// The [error] parameter is an optional error object.
  /// The [stackTrace] parameter is an optional stack trace.
  void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    String? tag,
  }) =>
      log(
        message,
        error: error,
        stackTrace: stackTrace,
        level: Level.error,
      );

  /// Logs a "what a terrible failure" message.
  ///
  /// The [message] parameter is the "what a terrible failure" message to be logged.
  /// The [error] parameter is an optional error object.
  /// The [stackTrace] parameter is an optional stack trace.
  void wtf(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    String? tag,
  }) =>
      log(message, error: error, stackTrace: stackTrace, level: Level.wtf);
}

/// An enumeration of log levels.
///
/// The [Level] enum represents different log levels that can be used with the [AptabaseLogger] class.
/// Each log level has an associated integer value.
enum Level {
  /// Log level that includes all log messages.
  all(0),

  /// Log level that turns off all log messages.
  off(2000),

  /// Log level for debug messages.
  debug(100),

  /// Log level for info messages.
  info(500),

  /// Log level for warning messages.
  warn(900),

  /// Log level for error messages.
  error(1000),

  /// Log level for "what a terrible failure" messages.
  wtf(1200);

  /// Creates a new instance of the [Level] enum.
  const Level(this.value);

  /// The integer value associated with the log level.
  final int value;
}
