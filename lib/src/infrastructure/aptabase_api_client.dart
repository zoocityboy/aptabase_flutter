// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:result_dart/functions.dart';
import 'package:result_dart/result_dart.dart';
import 'package:universal_io/io.dart';

import '../constants.dart';
import '../domain/aptabase_client.dart';
import '../domain/error/aptabase_failure.dart';
import '../domain/extensions/http_extensions.dart';
import '../domain/model/event_item.dart';

class AptabaseApiClient implements AptabaseClient {
  final String baseUrl;
  final String appKey;
  AptabaseApiClient({
    required this.baseUrl,
    required this.appKey,
  });

  static HttpClient https = newUniversalHttpClient()
    ..connectionTimeout = const Duration(seconds: 5)
    ..idleTimeout = const Duration(seconds: 10)
    ..autoUncompress = true;
  @override
  Future<HttpClientRequest> createRequest(String path) async {
    final request = await https.postUrl(Uri.parse('$baseUrl$path'))
      ..addHeaders(appKey);
    return request;
  }

  @override
  Future<Result<Unit, AptabaseApiFailure>> sendEvents(
    List<EventItem> eventItems,
  ) async {
    try {
      final request = await createRequest(ApiPath.batch);
      final items = eventItems.map((e) => e.toJson()).toList();
      final body = '[${items.map((e) => e).join(',')}]';
      request.write(body);
      final response = await request.close();

      return switch (response.statusCode) {
        (< 300) => successOf(unit),
        (>= 400 && < 500) => Failure(NotFoundApiFailure(response.statusCode)),
        _ => Failure(AptabaseApiFailure.tryParse(response)),
      };
    } catch (e) {
      return Failure(AptabaseApiFailure.tryParse(e));
    }
  }

  @override
  Future<Result<Unit, AptabaseApiFailure>> trackEvent(EventItem eventItem) async {
    try {
      final request = await createRequest(ApiPath.single);
      request.write(eventItem.toJson());
      final response = await request.close();

      return switch (response.statusCode) {
        (< 300) => successOf(unit),
        (>= 400 && < 500) => Failure(NotFoundApiFailure(response.statusCode)),
        _ => Failure(AptabaseApiFailure.tryParse(response)),
      };
    } catch (e) {
      return Failure(AptabaseApiFailure.tryParse(e));
    }
  }
}
