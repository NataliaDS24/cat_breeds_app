import 'package:cat_breeds_app/domain/entities/breed.dart';
import 'package:cat_breeds_app/domain/repositories/breed_repository.dart';

class SearchBreedsUseCase {
  final BreedRepository repository;

  SearchBreedsUseCase({
    required this.repository,
  });

  Future<List<Breed>> call({required String query}) {
    return repository.searchBreeds(query: query);
  }
}
