import 'dart:developer' as developer;

/// A logger class for logging messages with different log levels.
///
/// The [Logger] class provides methods for logging messages at different log levels such as debug, info, warn, error, and wtf (what a terrible failure).
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
class Logger {
  /// Creates a new instance of the [Logger] class.
  ///
  /// The [isDebug] parameter determines whether debug messages should be logged.
  /// By default, debug messages are not logged.
  const Logger({this.isDebug = false});

  /// Indicates whether debug messages should be logged.
  final bool isDebug;

  /// Logs a message at the specified log level.
  ///
  /// The [message] parameter is the message to be logged.
  /// The [error] parameter is an optional error object.
  /// The [stackTrace] parameter is an optional stack trace.
  /// The [level] parameter specifies the log level.
  void _log(
    String message, {
    required LogLevel level,
    Object? object,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (!isDebug && level.value < LogLevel.wtf.value) return;
    developer.log(
      '''
[${level.name}] $message
${object != null ? '$object' : ''}
      ''',
      error: error,
      stackTrace: stackTrace,
      level: level.value,
      name: 'Aptabase',
      time: DateTime.now().toUtc(),
    );
  }

  /// Logs a debug message.
  ///
  /// The [message] parameter is the debug message to be logged.
  /// The [error] parameter is an optional error object.
  /// The [stackTrace] parameter is an optional stack trace.
  void debug(String message, {Object? object, Object? error, StackTrace? stackTrace}) => _log(
        message,
        object: object,
        error: error,
        stackTrace: stackTrace,
        level: LogLevel.debug,
      );

  /// Logs an info message.
  ///
  /// The [message] parameter is the info message to be logged.
  /// The [error] parameter is an optional error object.
  /// The [stackTrace] parameter is an optional stack trace.
  void info(String message, {Object? object, Object? error, StackTrace? stackTrace}) =>
      _log(message, object: object, error: error, stackTrace: stackTrace, level: LogLevel.info);

  /// Logs a warning message.
  ///
  /// The [message] parameter is the warning message to be logged.
  /// The [error] parameter is an optional error object.
  /// The [stackTrace] parameter is an optional stack trace.
  void warn(String message, {Object? object, Object? error, StackTrace? stackTrace}) =>
      _log(message, object: object, error: error, stackTrace: stackTrace, level: LogLevel.warn);

  /// Logs an error message.
  ///
  /// The [message] parameter is the error message to be logged.
  /// The [error] parameter is an optional error object.
  /// The [stackTrace] parameter is an optional stack trace.
  void error(String message, {Object? error, StackTrace? stackTrace}) => _log(
        message,
        error: error,
        stackTrace: stackTrace,
        level: LogLevel.error,
      );

  /// Logs a "what a terrible failure" message.
  ///
  /// The [message] parameter is the "what a terrible failure" message to be logged.
  /// The [error] parameter is an optional error object.
  /// The [stackTrace] parameter is an optional stack trace.
  void wtf(String message, {Object? error, StackTrace? stackTrace}) =>
      _log(message, error: error, stackTrace: stackTrace, level: LogLevel.wtf);
}

/// An enumeration of log levels.
///
/// The [LogLevel] enum represents different log levels that can be used with the [Logger] class.
/// Each log level has an associated integer value.
enum LogLevel {
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

  /// Creates a new instance of the [LogLevel] enum.
  const LogLevel(this.value);

  /// The integer value associated with the log level.
  final int value;
}
