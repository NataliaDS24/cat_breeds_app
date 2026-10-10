import 'package:cat_breeds_app/config/config_imports.dart';
import 'package:cat_breeds_app/presentation/screens/home/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchBarWidget extends StatefulWidget implements PreferredSizeWidget {
  const SearchBarWidget({super.key});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();

  @override
  Size get preferredSize => const Size(double.infinity, 60);
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _clearSearch(HomeProvider provider) {
    controller.clear();
    provider.resetSearch();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HomeProvider>();
    return Container(
      height: 60,
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller,
        onChanged: provider.onSearchChanged,
        onFieldSubmitted: provider.searchBreeds,
        textInputAction: TextInputAction.search,
        style: AppTextStyles.whiteInterSemiBold16,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.white),
          ),
          icon: provider.isShowSearch
              ? IconButton(
                  onPressed: () => _clearSearch(provider),
                  icon: const Icon(Icons.search_off),
                  color: AppColors.white,
                )
              : null,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.white),
          ),
          suffixIcon: IconButton(
            onPressed: () => provider.searchBreeds(controller.text),
            icon: const Icon(Icons.search),
            color: AppColors.white,
          ),
        ),
      ),
    );
  }
}
