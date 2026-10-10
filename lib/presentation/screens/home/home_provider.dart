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
  })  : getBreedsUseCase = getBreedsUseCase ?? di.getBreedsUseCase,
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
  int _page = 0;

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
    listBreedsSearch = [];
    isShowSearch = false;
    notifyListeners();
  }

  Future<void> searchBreeds(String search) async {
    if (search.trim().isEmpty) return resetSearch();
    await changeLoading(true);
    listBreedsSearch = await searchBreedsUseCase(query: search.trim());
    isLoading = false;
    isShowSearch = true;
    notifyListeners();
  }
}
