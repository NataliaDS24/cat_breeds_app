import 'dart:async';

import 'package:cat_breeds_app/data/models/breed_model.dart';
import 'package:cat_breeds_app/domain/entities/breed.dart';
import 'package:cat_breeds_app/domain/usecases/get_breeds_usecase.dart';
import 'package:cat_breeds_app/domain/usecases/search_breeds_usecase.dart';
import 'package:cat_breeds_app/presentation/screens/home/home_provider.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetBreedsUseCase extends Mock implements GetBreedsUseCase {}

class MockSearchBreedsUseCase extends Mock implements SearchBreedsUseCase {}

const pageLimit = 10;
const debounce = Duration(milliseconds: 400);

Breed buildBreed(String id) {
  return BreedModel.fromMap(
    map: {
      'id': id,
      'name': 'Breed $id',
      'weight': {'imperial': '7-10', 'metric': '3-5'},
    },
  );
}

List<Breed> buildPage(int page, {int length = pageLimit}) {
  return List.generate(length, (index) => buildBreed('p$page-$index'));
}

/// Lets the pending futures (like the initial load) complete
Future<void> flush() => Future<void>.delayed(Duration.zero);

void main() {
  late MockGetBreedsUseCase getBreedsUseCase;
  late MockSearchBreedsUseCase searchBreedsUseCase;

  setUp(() {
    getBreedsUseCase = MockGetBreedsUseCase();
    searchBreedsUseCase = MockSearchBreedsUseCase();
  });

  void stubPage(int page, List<Breed> breeds) {
    when(() => getBreedsUseCase(page: page, limit: pageLimit))
        .thenAnswer((_) async => breeds);
  }

  void stubSearch(String query, List<Breed> breeds) {
    when(() => searchBreedsUseCase(query: query))
        .thenAnswer((_) async => breeds);
  }

  HomeProvider buildProvider() {
    return HomeProvider(
      getBreedsUseCase: getBreedsUseCase,
      searchBreedsUseCase: searchBreedsUseCase,
    );
  }

  /// Provider with the first page already loaded
  Future<HomeProvider> buildLoadedProvider({int firstPageLength = pageLimit}) async {
    stubPage(0, buildPage(0, length: firstPageLength));
    final provider = buildProvider();
    await flush();
    return provider;
  }

  group('initial load', () {
    test('loads the first page and stops loading', () async {
      final firstPage = buildPage(0);
      stubPage(0, firstPage);

      final provider = buildProvider();
      expect(provider.isLoading, isTrue);
      await flush();

      expect(provider.isLoading, isFalse);
      expect(provider.listBreeds, firstPage);
      expect(provider.hasMoreBreeds, isTrue);
      verify(() => getBreedsUseCase(page: 0, limit: pageLimit)).called(1);
    });

    test('has no more breeds when the first page is not full', () async {
      final provider = await buildLoadedProvider(firstPageLength: 4);

      expect(provider.listBreeds, hasLength(4));
      expect(provider.hasMoreBreeds, isFalse);
    });
  });

  group('loadMoreBreeds', () {
    test('requests the next page and appends it to the list', () async {
      final provider = await buildLoadedProvider();
      final secondPage = buildPage(1);
      stubPage(1, secondPage);

      await provider.loadMoreBreeds();

      expect(provider.listBreeds, hasLength(20));
      expect(provider.listBreeds.sublist(10), secondPage);
      expect(provider.isLoadingMore, isFalse);
    });

    test('requests consecutive pages', () async {
      final provider = await buildLoadedProvider();
      stubPage(1, buildPage(1));
      stubPage(2, buildPage(2));

      await provider.loadMoreBreeds();
      await provider.loadMoreBreeds();

      expect(provider.listBreeds, hasLength(30));
      verifyInOrder([
        () => getBreedsUseCase(page: 0, limit: pageLimit),
        () => getBreedsUseCase(page: 1, limit: pageLimit),
        () => getBreedsUseCase(page: 2, limit: pageLimit),
      ]);
    });

    test('stops paginating after a page that is not full', () async {
      final provider = await buildLoadedProvider();
      stubPage(1, buildPage(1, length: 7));

      await provider.loadMoreBreeds();
      await provider.loadMoreBreeds();

      expect(provider.listBreeds, hasLength(17));
      expect(provider.hasMoreBreeds, isFalse);
      verifyNever(() => getBreedsUseCase(page: 2, limit: pageLimit));
    });

    test('does not advance the page when the response is empty', () async {
      final provider = await buildLoadedProvider();
      stubPage(1, []);

      await provider.loadMoreBreeds();

      expect(provider.listBreeds, hasLength(10));
      expect(provider.hasMoreBreeds, isFalse);
    });

    test('ignores new calls while a page is loading', () async {
      final provider = await buildLoadedProvider();
      final secondPage = Completer<List<Breed>>();
      when(() => getBreedsUseCase(page: 1, limit: pageLimit))
          .thenAnswer((_) => secondPage.future);

      final firstCall = provider.loadMoreBreeds();
      expect(provider.isLoadingMore, isTrue);
      await provider.loadMoreBreeds();
      secondPage.complete(buildPage(1));
      await firstCall;

      expect(provider.listBreeds, hasLength(20));
      verify(() => getBreedsUseCase(page: 1, limit: pageLimit)).called(1);
    });

    test('does nothing while the first page is loading', () async {
      final firstPage = Completer<List<Breed>>();
      when(() => getBreedsUseCase(page: 0, limit: pageLimit))
          .thenAnswer((_) => firstPage.future);
      final provider = buildProvider();

      await provider.loadMoreBreeds();

      verifyNever(() => getBreedsUseCase(page: 1, limit: pageLimit));
      firstPage.complete(buildPage(0));
    });

    test('does nothing while search results are shown', () async {
      final provider = await buildLoadedProvider();
      stubSearch('sib', [buildBreed('sibe')]);
      await provider.searchBreeds('sib');

      await provider.loadMoreBreeds();

      verifyNever(() => getBreedsUseCase(page: 1, limit: pageLimit));
    });
  });

  group('searchBreeds', () {
    test('shows the results of the trimmed query', () async {
      final provider = await buildLoadedProvider();
      final results = [buildBreed('sibe')];
      stubSearch('sib', results);

      await provider.searchBreeds('  sib  ');

      expect(provider.listBreedsSearch, results);
      expect(provider.isShowSearch, isTrue);
      expect(provider.isSearching, isFalse);
    });

    test('is searching while the request is in progress', () async {
      final provider = await buildLoadedProvider();
      final results = Completer<List<Breed>>();
      when(() => searchBreedsUseCase(query: 'sib'))
          .thenAnswer((_) => results.future);

      final search = provider.searchBreeds('sib');
      expect(provider.isSearching, isTrue);
      results.complete([buildBreed('sibe')]);
      await search;

      expect(provider.isSearching, isFalse);
    });

    test('resets the search when the query is empty', () async {
      final provider = await buildLoadedProvider();
      stubSearch('sib', [buildBreed('sibe')]);
      await provider.searchBreeds('sib');

      await provider.searchBreeds('   ');

      expect(provider.isShowSearch, isFalse);
      expect(provider.listBreedsSearch, isEmpty);
      verify(() => searchBreedsUseCase(query: 'sib')).called(1);
      verifyNoMoreInteractions(searchBreedsUseCase);
    });

    test('ignores the response of a search replaced by a newer one', () async {
      final provider = await buildLoadedProvider();
      final oldResults = Completer<List<Breed>>();
      final newResults = [buildBreed('siam')];
      when(() => searchBreedsUseCase(query: 'sib'))
          .thenAnswer((_) => oldResults.future);
      stubSearch('siam', newResults);

      final oldSearch = provider.searchBreeds('sib');
      await provider.searchBreeds('siam');
      oldResults.complete([buildBreed('sibe')]);
      await oldSearch;

      expect(provider.listBreedsSearch, newResults);
    });

    test('ignores the response of a search cancelled by a reset', () async {
      final provider = await buildLoadedProvider();
      final results = Completer<List<Breed>>();
      when(() => searchBreedsUseCase(query: 'sib'))
          .thenAnswer((_) => results.future);

      final search = provider.searchBreeds('sib');
      await provider.resetSearch();
      results.complete([buildBreed('sibe')]);
      await search;

      expect(provider.isShowSearch, isFalse);
      expect(provider.isSearching, isFalse);
      expect(provider.listBreedsSearch, isEmpty);
    });
  });

  group('onSearchChanged', () {
    test('searches once with the last text after the debounce', () {
      fakeAsync((async) {
        stubPage(0, buildPage(0));
        stubSearch('sib', [buildBreed('sibe')]);
        final provider = buildProvider();
        async.flushMicrotasks();

        provider.onSearchChanged('s');
        async.elapse(const Duration(milliseconds: 100));
        provider.onSearchChanged('si');
        async.elapse(const Duration(milliseconds: 100));
        provider.onSearchChanged('sib');
        async.elapse(debounce - const Duration(milliseconds: 1));

        verifyNever(() => searchBreedsUseCase(query: any(named: 'query')));

        async.elapse(const Duration(milliseconds: 1));

        verify(() => searchBreedsUseCase(query: 'sib')).called(1);
        verifyNoMoreInteractions(searchBreedsUseCase);
        expect(provider.isShowSearch, isTrue);
      });
    });

    test('clearing the text cancels the pending search', () {
      fakeAsync((async) {
        stubPage(0, buildPage(0));
        final provider = buildProvider();
        async.flushMicrotasks();

        provider.onSearchChanged('sib');
        async.elapse(const Duration(milliseconds: 200));
        provider.onSearchChanged('');
        async.elapse(debounce * 2);

        verifyNever(() => searchBreedsUseCase(query: any(named: 'query')));
        expect(provider.isShowSearch, isFalse);
      });
    });

    test('dispose cancels the pending search', () {
      fakeAsync((async) {
        stubPage(0, buildPage(0));
        final provider = buildProvider();
        async.flushMicrotasks();

        provider.onSearchChanged('sib');
        provider.dispose();
        async.elapse(debounce * 2);

        verifyNever(() => searchBreedsUseCase(query: any(named: 'query')));
      });
    });
  });
}
