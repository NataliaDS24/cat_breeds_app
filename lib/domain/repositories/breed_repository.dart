import 'package:cat_breeds_app/domain/entities/breed.dart';

abstract class BreedRepository {
  Future<List<Breed>> getBreeds({
    required int page,
    required int limit,
  });

  Future<List<Breed>> searchBreeds({required String query});
}
