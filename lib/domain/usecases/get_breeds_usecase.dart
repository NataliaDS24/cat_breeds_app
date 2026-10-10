import 'package:cat_breeds_app/domain/entities/breed.dart';
import 'package:cat_breeds_app/domain/repositories/breed_repository.dart';

class GetBreedsUseCase {
  final BreedRepository repository;

  GetBreedsUseCase({
    required this.repository,
  });

  Future<List<Breed>> call({
    required int page,
    required int limit,
  }) {
    return repository.getBreeds(
      page: page,
      limit: limit,
    );
  }
}
