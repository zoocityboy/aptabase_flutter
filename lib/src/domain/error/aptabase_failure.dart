import 'package:meta/meta.dart';

import '../domain.dart';
import 'aptabase_error_response.dart';

/// Represents a failure that can occur in the Aptabase domain.
@immutable
sealed class AptabaseFailure {
  const AptabaseFailure(this.message);

  /// The error message.
  final String message;

  @override
  String toString() {
    return 'AptabaseFailure(message: $message)';
  }
}

/// Represents a failure caused by an AptabaseException.
class AptabaseExceptionFailure extends AptabaseFailure {
  /// Constructor for creating an AptabaseExceptionFailure with the given exception.
  ///
  /// The [exception] parameter is the AptabaseException that caused the failure.
  AptabaseExceptionFailure(AptabaseException exception) : super(exception.toString());
}

/// Represents a runtime failure in the Aptabase domain.
sealed class AptabaseRuntimeFailure extends AptabaseFailure {
  const AptabaseRuntimeFailure(super.message);

  @override
  String toString() {
    return 'AptabaseRuntimeFailure(message: $message)';
  }
}

/// Represents a generic failure in the Aptabase domain.
class AptabseGenericFailure extends AptabaseRuntimeFailure {
  /// Creates a new generic failure.
  const AptabseGenericFailure() : super('Generic Failure');
}

/// Represents a failure related to the Aptabase API.
sealed class AptabaseHttpFailure extends AptabaseFailure {
  const AptabaseHttpFailure(
    this.statusCode,
    super.message,
  );

  /// The HTTP status code.
  final int statusCode;
}

/// Represents a "Client Error" API failure.
class HttpFailure extends AptabaseHttpFailure {
  /// Creates a new "Client Error" API failure.
  const HttpFailure(super.statusCode, super.message, {this.error});

  /// The error object.
  final AptabaseErrorResponse? error;

  @override
  String toString() {
    return 'HttpFailure(statusCode: $statusCode, message: $message, error: $error)';
  }
}

/// Represents an "Offline" API failure.
class OfflineHttpFailure extends AptabaseHttpFailure {
  /// Creates an "Offline" API failure.
  const OfflineHttpFailure() : super(0, 'Offline');

  @override
  String toString() {
    return 'OfflineHttpFailure(statusCode: $statusCode, message: $message)';
  }
}

/// Represents a "Server Error" API failure.
class ServerApiFailure extends AptabaseHttpFailure {
  /// Creates a new "Server Error" API failure.
  const ServerApiFailure(int statusCode) : super(statusCode, 'Server Error');
}
