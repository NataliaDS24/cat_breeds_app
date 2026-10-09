import 'package:cat_breeds_app/config/env.dart';
import 'package:cat_breeds_app/core/network/api_const.dart';
import 'package:cat_breeds_app/core/network/dio_client.dart';

class ImageRemoteDataSource {
  factory ImageRemoteDataSource() {
    return _singleton;
  }

  ImageRemoteDataSource._internal();

  static final ImageRemoteDataSource _singleton =
      ImageRemoteDataSource._internal();

  final DioClient dioClient = DioClient();

  Future<String> getImageUrl({required String id}) async {
    final String url = '${Env.baseUrl}${ApiConst.images}/$id';
    final response = await dioClient.dio.get(
      url,
      options: dioClient.authHeaders,
    );
    return response.data['url'];
  }
}
