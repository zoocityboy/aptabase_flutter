// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:flutter/foundation.dart';

import '../domain/extensions/datetime_extension.dart';

/// Represents a session with a session ID and creation timestamp.
/// The session ID is evaluated based on the session timeout.
class AptabaseSession {
  static Random rnd = Random();
  final Duration sessionTimeout;
  @protected
  late String sessionId;
  @protected
  late DateTime createdAt;

  /// Creates a new session with the specified session timeout.
  AptabaseSession({
    required this.sessionTimeout,
  }) {
    sessionId = newSessionId();
    createdAt = DateTimeX.now;
  }

  /// Generates a new session ID based on the current timestamp and a random number.
  String newSessionId() {
    final epochInSeconds = (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();
    final random = rnd.nextInt(100000000).toString().padLeft(8, '0');

    return epochInSeconds + random;
  }

  /// Evaluates the session ID based on the current timestamp and the session timeout.
  /// If the elapsed time since the session creation is greater than the session timeout,
  /// a new session ID is generated.
  /// Returns the evaluated session ID.
  String evalSessionId() {
    final now = DateTimeX.now;
    final elapsed = now.difference(createdAt);
    if (elapsed > sessionTimeout) {
      sessionId = newSessionId();
    }

    createdAt = now;
    return sessionId;
  }
}
