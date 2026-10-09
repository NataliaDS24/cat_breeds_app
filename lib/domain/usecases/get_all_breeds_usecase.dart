import 'package:cat_breeds_app/domain/entities/breed.dart';
import 'package:cat_breeds_app/domain/repositories/breed_repository.dart';

class GetAllBreedsUseCase {
  final BreedRepository repository;

  GetAllBreedsUseCase({
    required this.repository,
  });

  Future<List<Breed>> call() {
    return repository.getAllBreeds();
  }
}
