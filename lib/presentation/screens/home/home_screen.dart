import 'package:cat_breeds_app/config/config_imports.dart';
import 'package:cat_breeds_app/presentation/screens/home/home_provider.dart';
import 'package:cat_breeds_app/presentation/widgets/appbar_home.dart';
import 'package:cat_breeds_app/presentation/widgets/card_breed.dart';
import 'package:cat_breeds_app/presentation/widgets/loading_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HomeProvider>();
    return Scaffold(
      appBar: const AppBarHome(),
      body: Column(
        children: [
          if (provider.isSearching)
            const LinearProgressIndicator(color: AppColors.primary),
          Expanded(
            child: provider.isLoading
                ? const LoadingDataWidget()
                : provider.listBreeds.isEmpty && !provider.isShowSearch ||
                      provider.listBreedsSearch.isEmpty && provider.isShowSearch
                ? const Center(
                    child: Text(
                      AppStrings.notBreeds,
                      style: AppTextStyles.primaryInterSemiBold20,
                    ),
                  )
                : NotificationListener<ScrollNotification>(
                    onNotification: (notification) {
                      if (notification.metrics.extentAfter < 500) {
                        provider.loadMoreBreeds();
                      }
                      return false;
                    },
                    child: ListView.builder(
                      cacheExtent: 1000,
                      itemCount: !provider.isShowSearch
                          ? provider.listBreeds.length +
                                (provider.isLoadingMore ? 1 : 0)
                          : provider.listBreedsSearch.length,
                      itemBuilder: (context, index) {
                        if (!provider.isShowSearch &&
                            index == provider.listBreeds.length) {
                          return const Padding(
                            padding: EdgeInsets.all(20),
                            child: LoadingDataWidget(),
                          );
                        }
                        return CardBreed(
                          breed: !provider.isShowSearch
                              ? provider.listBreeds[index]
                              : provider.listBreedsSearch[index],
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
