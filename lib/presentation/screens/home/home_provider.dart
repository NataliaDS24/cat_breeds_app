import 'package:cat_breeds_app/domain/entities/breed.dart';
import 'package:cat_breeds_app/domain/usecases/get_all_breeds_usecase.dart';
import 'package:cat_breeds_app/injection_container.dart' as di;
import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier {
  HomeProvider({
    GetAllBreedsUseCase? getAllBreedsUseCase,
  }) : getAllBreedsUseCase = getAllBreedsUseCase ?? di.getAllBreedsUseCase {
    getAllBreeds();
  }

  final GetAllBreedsUseCase getAllBreedsUseCase;
  List<Breed> listBreeds = [];
  List<Breed> listBreedsSearch = [];
  bool isLoading = true;
  bool isShowSearch = false;

  Future<void> getAllBreeds() async {
    listBreeds = await getAllBreedsUseCase();
    isLoading = false;
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
    await changeLoading(true);
    listBreedsSearch = listBreeds
        .where(
          (element) => element.name.toUpperCase().contains(
                search.toUpperCase(),
              ),
        )
        .toList();
    isLoading = false;
    isShowSearch = true;
    notifyListeners();
  }
}
