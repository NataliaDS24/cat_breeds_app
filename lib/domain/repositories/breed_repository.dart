import 'package:cat_breeds_app/domain/entities/breed.dart';

abstract class BreedRepository {
  Future<List<Breed>> getAllBreeds();
}
