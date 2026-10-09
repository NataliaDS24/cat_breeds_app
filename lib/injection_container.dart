import 'package:cat_breeds_app/data/datasources/breed_remote_data_source.dart';
import 'package:cat_breeds_app/data/datasources/image_remote_data_source.dart';
import 'package:cat_breeds_app/data/repositories/breed_repository_impl.dart';
import 'package:cat_breeds_app/domain/repositories/breed_repository.dart';
import 'package:cat_breeds_app/domain/usecases/get_all_breeds_usecase.dart';

final BreedRepository breedRepository = BreedRepositoryImpl(
  breedRemoteDataSource: BreedRemoteDataSource(),
  imageRemoteDataSource: ImageRemoteDataSource(),
);

final GetAllBreedsUseCase getAllBreedsUseCase = GetAllBreedsUseCase(
  repository: breedRepository,
);
