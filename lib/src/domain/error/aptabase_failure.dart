import 'package:meta/meta.dart';

import 'aptabase_exception.dart';

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

  /// Tries to parse the given [error] and returns an appropriate [AptabaseFailure] instance.
  static AptabaseFailure tryParse(Object error) {
    return switch (error) {
      // ignore: unused_local_variable
      AptabaseException(message: final message) => const AptabseGenericFailure(),
      _ => const UnknownApiFailure()
    };
  }
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
sealed class AptabaseApiFailure extends AptabaseFailure {
  const AptabaseApiFailure(this.statusCode, super.message);

  /// The HTTP status code.
  final int statusCode;

  /// Tries to parse the given [error] and returns an appropriate [AptabaseApiFailure] instance.
  static AptabaseApiFailure tryParse(Object error) {
    if (error is AptabaseApiFailure) {
      return error;
    }
    return const UnknownApiFailure();
  }
}

/// Represents an unknown API failure.
class UnknownApiFailure extends AptabaseApiFailure {
  /// Creates a new unknown API failure.
  const UnknownApiFailure() : super(0, 'Unknown Error');
}

/// Represents a "Not Found" API failure.
class NotFoundApiFailure extends AptabaseApiFailure {
  /// Creates a new "Not Found" API failure.
  const NotFoundApiFailure(int statusCode) : super(statusCode, 'Not Found');
}

/// Represents a "Server Error" API failure.
class ServerApiFailure extends AptabaseApiFailure {
  /// Creates a new "Server Error" API failure.
  const ServerApiFailure() : super(500, 'Server Error');
}

/// Represents a "No Internet" API failure.
class NoInternetApiFailure extends AptabaseApiFailure {
  /// Creates a new "No Internet" API failure.
  const NoInternetApiFailure() : super(0, 'No Internet');
}
