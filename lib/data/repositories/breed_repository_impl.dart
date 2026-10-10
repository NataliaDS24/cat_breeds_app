import 'package:cat_breeds_app/data/datasources/breed_remote_data_source.dart';
import 'package:cat_breeds_app/data/datasources/image_remote_data_source.dart';
import 'package:cat_breeds_app/data/models/breed_model.dart';
import 'package:cat_breeds_app/domain/entities/breed.dart';
import 'package:cat_breeds_app/domain/repositories/breed_repository.dart';

class BreedRepositoryImpl implements BreedRepository {
  BreedRepositoryImpl({
    required this.breedRemoteDataSource,
    required this.imageRemoteDataSource,
  });

  final BreedRemoteDataSource breedRemoteDataSource;
  final ImageRemoteDataSource imageRemoteDataSource;

  @override
  Future<List<Breed>> getBreeds({
    required int page,
    required int limit,
  }) async {
    List<BreedModel> listBreeds = [];
    try {
      listBreeds = await breedRemoteDataSource.getBreeds(
        page: page,
        limit: limit,
      );
      await _fillMissingImages(listBreeds);
      return listBreeds;
    } catch (e) {
      return listBreeds;
    }
  }

  @override
  Future<List<Breed>> searchBreeds({required String query}) async {
    List<BreedModel> listBreeds = [];
    try {
      listBreeds = await breedRemoteDataSource.searchBreeds(query: query);
      await _fillMissingImages(listBreeds);
      return listBreeds;
    } catch (e) {
      return listBreeds;
    }
  }

  Future<void> _fillMissingImages(List<BreedModel> listBreeds) async {
    await Future.wait(
      listBreeds
          .where(
            (breed) =>
                breed.imageUrl == null &&
                breed.referenceImageId != null &&
                breed.referenceImageId != '',
          )
          .map((breed) async {
        try {
          breed.imageUrl = await imageRemoteDataSource.getImageUrl(
            id: breed.referenceImageId!,
          );
        } catch (_) {}
      }),
    );
  }
}
