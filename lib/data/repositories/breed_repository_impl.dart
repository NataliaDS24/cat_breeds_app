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
  Future<List<Breed>> getAllBreeds() async {
    List<BreedModel> listBreeds = [];
    try {
      listBreeds = await breedRemoteDataSource.getAllBreeds();
      for (var breed in listBreeds) {
        if (breed.referenceImageId != null && breed.referenceImageId != '') {
          breed.imageUrl = await imageRemoteDataSource.getImageUrl(
            id: breed.referenceImageId!,
          );
        }
      }
      return listBreeds;
    } catch (e) {
      return listBreeds;
    }
  }
}
