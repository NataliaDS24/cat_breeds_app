import 'package:cat_breeds_app/data/datasources/breed_remote_data_source.dart';
import 'package:cat_breeds_app/data/datasources/image_remote_data_source.dart';
import 'package:cat_breeds_app/data/models/breed_model.dart';
import 'package:cat_breeds_app/data/repositories/breed_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockBreedRemoteDataSource extends Mock implements BreedRemoteDataSource {}

class MockImageRemoteDataSource extends Mock implements ImageRemoteDataSource {}

BreedModel buildBreed({
  required String id,
  String? referenceImageId,
  String? imageUrl,
}) {
  return BreedModel.fromMap(
    map: {
      'id': id,
      'name': 'Breed $id',
      'weight': {'imperial': '7-10', 'metric': '3-5'},
      if (referenceImageId != null) 'reference_image_id': referenceImageId,
      if (imageUrl != null) 'image': {'url': imageUrl},
    },
  );
}

void main() {
  late MockBreedRemoteDataSource breedRemoteDataSource;
  late MockImageRemoteDataSource imageRemoteDataSource;
  late BreedRepositoryImpl repository;

  setUp(() {
    breedRemoteDataSource = MockBreedRemoteDataSource();
    imageRemoteDataSource = MockImageRemoteDataSource();
    repository = BreedRepositoryImpl(
      breedRemoteDataSource: breedRemoteDataSource,
      imageRemoteDataSource: imageRemoteDataSource,
    );
  });

  group('getBreeds', () {
    test('passes page and limit to the data source and returns its breeds',
        () async {
      final breeds = [
        buildBreed(id: 'abys', imageUrl: 'https://cdn/abys.jpg'),
        buildBreed(id: 'aege', imageUrl: 'https://cdn/aege.jpg'),
      ];
      when(() => breedRemoteDataSource.getBreeds(page: 2, limit: 10))
          .thenAnswer((_) async => breeds);

      final result = await repository.getBreeds(page: 2, limit: 10);

      expect(result, breeds);
      verify(() => breedRemoteDataSource.getBreeds(page: 2, limit: 10))
          .called(1);
    });

    test('does not request images when the breeds already have one', () async {
      when(() => breedRemoteDataSource.getBreeds(page: 0, limit: 10))
          .thenAnswer(
        (_) async => [
          buildBreed(
            id: 'abys',
            referenceImageId: 'KWdLHmOqc',
            imageUrl: 'https://cdn/abys.jpg',
          ),
        ],
      );

      await repository.getBreeds(page: 0, limit: 10);

      verifyNever(
        () => imageRemoteDataSource.getImageUrl(id: any(named: 'id')),
      );
    });

    test('requests the image only for breeds with a reference id but no url',
        () async {
      when(() => breedRemoteDataSource.getBreeds(page: 0, limit: 10))
          .thenAnswer(
        (_) async => [
          buildBreed(id: 'abys', imageUrl: 'https://cdn/abys.jpg'),
          buildBreed(id: 'amer', referenceImageId: 'MuEGe1-Sz'),
          buildBreed(id: 'toyb'),
        ],
      );
      when(() => imageRemoteDataSource.getImageUrl(id: 'MuEGe1-Sz'))
          .thenAnswer((_) async => 'https://cdn/amer.jpg');

      final result = await repository.getBreeds(page: 0, limit: 10);

      expect(
        result.map((breed) => breed.imageUrl),
        ['https://cdn/abys.jpg', 'https://cdn/amer.jpg', null],
      );
      verify(() => imageRemoteDataSource.getImageUrl(id: 'MuEGe1-Sz'))
          .called(1);
      verifyNoMoreInteractions(imageRemoteDataSource);
    });

    test('keeps the breed without image when the image request fails',
        () async {
      when(() => breedRemoteDataSource.getBreeds(page: 0, limit: 10))
          .thenAnswer(
        (_) async => [
          buildBreed(id: 'amer', referenceImageId: 'MuEGe1-Sz'),
          buildBreed(id: 'arab', referenceImageId: 'zlpgGWqN7'),
        ],
      );
      when(() => imageRemoteDataSource.getImageUrl(id: 'MuEGe1-Sz'))
          .thenThrow(Exception('network error'));
      when(() => imageRemoteDataSource.getImageUrl(id: 'zlpgGWqN7'))
          .thenAnswer((_) async => 'https://cdn/arab.jpg');

      final result = await repository.getBreeds(page: 0, limit: 10);

      expect(result, hasLength(2));
      expect(result[0].imageUrl, isNull);
      expect(result[1].imageUrl, 'https://cdn/arab.jpg');
    });

    test('returns an empty list when the data source fails', () async {
      when(() => breedRemoteDataSource.getBreeds(page: 0, limit: 10))
          .thenThrow(Exception('network error'));

      final result = await repository.getBreeds(page: 0, limit: 10);

      expect(result, isEmpty);
    });
  });

  group('searchBreeds', () {
    test('passes the query to the data source and returns its breeds',
        () async {
      final breeds = [
        buildBreed(id: 'sibe', imageUrl: 'https://cdn/sibe.jpg'),
      ];
      when(() => breedRemoteDataSource.searchBreeds(query: 'sib'))
          .thenAnswer((_) async => breeds);

      final result = await repository.searchBreeds(query: 'sib');

      expect(result, breeds);
      verify(() => breedRemoteDataSource.searchBreeds(query: 'sib')).called(1);
    });

    test('requests the missing images of the results', () async {
      when(() => breedRemoteDataSource.searchBreeds(query: 'amer')).thenAnswer(
        (_) async => [buildBreed(id: 'amer', referenceImageId: 'MuEGe1-Sz')],
      );
      when(() => imageRemoteDataSource.getImageUrl(id: 'MuEGe1-Sz'))
          .thenAnswer((_) async => 'https://cdn/amer.jpg');

      final result = await repository.searchBreeds(query: 'amer');

      expect(result.single.imageUrl, 'https://cdn/amer.jpg');
    });

    test('returns an empty list when the data source fails', () async {
      when(() => breedRemoteDataSource.searchBreeds(query: 'sib'))
          .thenThrow(Exception('network error'));

      final result = await repository.searchBreeds(query: 'sib');

      expect(result, isEmpty);
    });
  });
}
