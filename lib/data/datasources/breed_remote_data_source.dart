import 'package:cat_breeds_app/config/env.dart';
import 'package:cat_breeds_app/core/network/api_const.dart';
import 'package:cat_breeds_app/core/network/dio_client.dart';
import 'package:cat_breeds_app/data/models/breed_model.dart';

class BreedRemoteDataSource {
  factory BreedRemoteDataSource() {
    return _singleton;
  }

  BreedRemoteDataSource._internal();

  static final BreedRemoteDataSource _singleton =
      BreedRemoteDataSource._internal();

  final DioClient dioClient = DioClient();

  Future<List<BreedModel>> getBreeds({
    required int page,
    required int limit,
  }) async {
    final String url = '${Env.baseUrl}${ApiConst.breeds}';
    final response = await dioClient.dio.get(
      url,
      queryParameters: {
        'page': page,
        'limit': limit,
      },
      options: dioClient.authHeaders,
    );
    List valueList = response.data;
    return valueList
        .map((element) => BreedModel.fromMap(map: element))
        .toList();
  }

  Future<List<BreedModel>> searchBreeds({required String query}) async {
    final String url = '${Env.baseUrl}${ApiConst.breedsSearch}';
    final response = await dioClient.dio.get(
      url,
      queryParameters: {
        'q': query,
      },
      options: dioClient.authHeaders,
    );
    List valueList = response.data;
    return valueList
        .map((element) => BreedModel.fromMap(map: element))
        .toList();
  }
}
