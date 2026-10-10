import 'dart:async';

import 'package:cat_breeds_app/core/network/api_const.dart';
import 'package:cat_breeds_app/domain/entities/breed.dart';
import 'package:cat_breeds_app/domain/usecases/get_breeds_usecase.dart';
import 'package:cat_breeds_app/domain/usecases/search_breeds_usecase.dart';
import 'package:cat_breeds_app/injection_container.dart' as di;
import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier {
  HomeProvider({
    GetBreedsUseCase? getBreedsUseCase,
    SearchBreedsUseCase? searchBreedsUseCase,
  }) : getBreedsUseCase = getBreedsUseCase ?? di.getBreedsUseCase,
       searchBreedsUseCase = searchBreedsUseCase ?? di.searchBreedsUseCase {
    getBreeds();
  }

  final GetBreedsUseCase getBreedsUseCase;
  final SearchBreedsUseCase searchBreedsUseCase;
  List<Breed> listBreeds = [];
  List<Breed> listBreedsSearch = [];
  bool isLoading = true;
  bool isLoadingMore = false;
  bool hasMoreBreeds = true;
  bool isShowSearch = false;
  bool isSearching = false;
  int _page = 0;
  Timer? _searchDebounce;
  int _searchRequestId = 0;
  static const _searchDebounceDuration = Duration(milliseconds: 400);

  Future<void> getBreeds() async {
    final breeds = await getBreedsUseCase(
      page: _page,
      limit: ApiConst.breedsPageLimit,
    );
    listBreeds = breeds;
    hasMoreBreeds = breeds.length == ApiConst.breedsPageLimit;
    isLoading = false;
    notifyListeners();
  }

  Future<void> loadMoreBreeds() async {
    if (isLoading || isLoadingMore || !hasMoreBreeds || isShowSearch) return;
    isLoadingMore = true;
    notifyListeners();
    final breeds = await getBreedsUseCase(
      page: _page + 1,
      limit: ApiConst.breedsPageLimit,
    );
    if (breeds.isNotEmpty) _page++;
    listBreeds = [...listBreeds, ...breeds];
    hasMoreBreeds = breeds.length == ApiConst.breedsPageLimit;
    isLoadingMore = false;
    notifyListeners();
  }

  Future<void> changeLoading(bool loading) async {
    isLoading = loading;
    notifyListeners();
  }

  Future<void> resetSearch() async {
    _searchDebounce?.cancel();
    _searchRequestId++;
    listBreedsSearch = [];
    isSearching = false;
    isShowSearch = false;
    notifyListeners();
  }

  void onSearchChanged(String search) {
    _searchDebounce?.cancel();
    if (search.trim().isEmpty) {
      resetSearch();
      return;
    }
    _searchDebounce = Timer(
      _searchDebounceDuration,
      () => searchBreeds(search),
    );
  }

  Future<void> searchBreeds(String search) async {
    _searchDebounce?.cancel();
    if (search.trim().isEmpty) return resetSearch();
    final requestId = ++_searchRequestId;
    isSearching = true;
    notifyListeners();
    final breeds = await searchBreedsUseCase(query: search.trim());
    // Ignore responses from searches that were replaced by a newer one
    if (requestId != _searchRequestId) return;
    listBreedsSearch = breeds;
    isSearching = false;
    isShowSearch = true;
    notifyListeners();
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    super.dispose();
  }
}
