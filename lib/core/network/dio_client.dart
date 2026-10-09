import 'package:cat_breeds_app/core/network/pretty_dio_logger.dart';
import 'package:dio/dio.dart';

class DioClient {
  factory DioClient() {
    return _singleton;
  }

  DioClient._internal() {
    dio.interceptors.add(
      PrettyDioLoggerApp.prettyDioLogger,
    );
  }

  static final DioClient _singleton = DioClient._internal();

  final Dio dio = Dio();

  Options get authHeaders => Options(
        headers: {
          'x-api-key':
              'live_99Qe4Ppj34NdplyLW67xCV7Ds0oSLKGgcWWYnSzMJY9C0QOu0HUR4azYxWkyW2nr',
        },
      );
}
