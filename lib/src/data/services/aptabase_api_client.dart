// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

import 'package:http/http.dart' as http;
import 'package:result_dart/functions.dart';
import 'package:result_dart/result_dart.dart';
import 'package:universal_io/io.dart';

import '../../core/aptabase_constants.dart';
import '../../domain/domain.dart';
import '../../domain/error/aptabase_error_response.dart';

class AptabaseApiClient implements AptabaseClient {
  final String baseUrl;
  final String appKey;
  AptabaseApiClient({
    required this.baseUrl,
    required this.appKey,
  });
  final client = http.Client();

  static HttpClient https = newUniversalHttpClient()
    ..connectionTimeout = const Duration(seconds: 1)
    ..idleTimeout = const Duration(seconds: 1);
  @override
  Future<Unit> createRequest(String path, Object body) async {
    try {
      final postUrl = Uri.parse('$baseUrl$path');
      final request = await https.postUrl(postUrl);
      request
        ..addHeaders(appKey)
        ..write(jsonEncode(body));
      final response = await request.close();
      Timer(const Duration(milliseconds: 50), request.abort);
      if (response.statusCode >= 400) {
        throw await response.networkException();
      }
      return unit;
    } on AptabaseNetworkException catch (_) {
      rethrow;
    } catch (e) {
      /// Catch standard http exceptions
      /// - TimeoutException
      /// - SocketException
      /// - RedirectException
      /// - FormatException
      /// - TlsException
      /// - HttpException
      throw AptabaseNetworkException(0, e.toString(), type: e.runtimeType.toString());
    }
  }

  @override
  Future<Result<Unit, AptabaseHttpFailure>> sendEvents(
    List<StorageEventItem> eventItems,
  ) async {
    Future<Result<Unit, AptabaseHttpFailure>> sendRequest() async {
      try {
        final body = eventItems.map((e) => e.toMap()).toList();
        await createRequest(ApiPath.batch, body);
        return successOf(unit);
      } on AptabaseNetworkException catch (e) {
        return HttpFailure(e.statusCode, e.message, error: e.error).toFailure();
      }
    }

    return Isolate.run(sendRequest);
  }

  @override
  Future<Result<Unit, AptabaseHttpFailure>> trackEvent(StorageEventItem eventItem) async {
    try {
      await createRequest(ApiPath.single, eventItem.toMap());
      return successOf(unit);
    } on AptabaseNetworkException catch (e) {
      return HttpFailure(e.statusCode, e.message, error: e.error).toFailure();
    }
  }
}
