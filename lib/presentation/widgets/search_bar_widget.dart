import 'package:cat_breeds_app/config/config_imports.dart';
import 'package:cat_breeds_app/presentation/screens/home/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchBarWidget extends StatefulWidget implements PreferredSizeWidget {
  const SearchBarWidget({super.key});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();

  @override
  Size get preferredSize => const Size(double.infinity, 64);
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
    setState(() {});
  }

  void _onChanged(HomeProvider provider, String value) {
    provider.onSearchChanged(value);
    // Rebuild to show or hide the clear button
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<HomeProvider>();
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    );
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      child: TextField(
        controller: controller,
        onChanged: (value) => _onChanged(provider, value),
        onSubmitted: provider.searchBreeds,
        textInputAction: TextInputAction.search,
        style: AppTextStyles.textPrimaryInterRegular16,
        decoration: InputDecoration(
          hintText: AppStrings.searchHint,
          hintStyle: AppTextStyles.textSecondaryInterRegular16,
          filled: true,
          fillColor: AppColors.white,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
          border: border,
          enabledBorder: border,
          focusedBorder: border,
          prefixIcon: const Icon(
            Icons.search,
            color: AppColors.textSecondary,
          ),
          suffixIcon: controller.text.isEmpty
              ? null
              : IconButton(
                  onPressed: () => _clearSearch(provider),
                  icon: const Icon(Icons.close),
                  color: AppColors.textSecondary,
                ),
        ),
      ),
    );
  }
}
