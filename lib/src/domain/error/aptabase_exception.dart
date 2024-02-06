import 'aptabase_error_response.dart';

/// Represents an exception specific to the Aptabase SDK.
class AptabaseException implements Exception {
  /// Creates an instance of [AptabaseException] with the given [message].
  const AptabaseException(this.message);

  /// The message of the exception.
  final String message;
}

/// Represents an exception that is thrown
/// when the Aptabase SDK is not initialized.
class AptabaseNotInitializedException extends AptabaseException {
  /// Creates an instance of [AptabaseNotInitializedException].
  const AptabaseNotInitializedException()
      : super(
          'Aptabase SDK is not initialized. Please call Aptabase.init() first.',
        );

  @override
  String toString() {
    return message;
  }
}

/// Represents an exception that is thrown when the
/// Aptabase SDK is not supported on the current platform.
class AptabaseNotSupportedPlatformException extends AptabaseException {
  /// Creates an instance of [AptabaseNotSupportedPlatformException].
  const AptabaseNotSupportedPlatformException()
      : super(
          'Aptabase SDK is not supported on this platform.',
        );

  @override
  String toString() {
    return message;
  }
}

/// Represents an exception that is thrown
/// when the provided Aptabase AppKey is invalid.
class AptabaseInvalidAppKeyException extends AptabaseException {
  /// Creates an instance of [AptabaseInvalidAppKeyException].
  const AptabaseInvalidAppKeyException()
      : super(
          'Aptabase AppKey is invalid. Check the format and try again.',
        );

  @override
  String toString() {
    return message;
  }
}

/// Represents an exception that is thrown
class AptabaseNetworkException extends AptabaseException {
  /// Creates an instance of [AptabaseNetworkException].
  const AptabaseNetworkException(
    this.statusCode,
    super.message, {
    this.error,
    this.type,
  });

  /// The HTTP status code.
  final int statusCode;

  /// The error object.
  final AptabaseErrorResponse? error;

  /// The error type.
  final String? type;

  @override
  String toString() {
    return 'Request failed with status: $statusCode\n$message\n$type\n$error';
  }
}
