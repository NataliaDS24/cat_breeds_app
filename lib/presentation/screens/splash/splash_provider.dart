import 'package:cat_breeds_app/config/router/router_path.dart';
import 'package:flutter/material.dart';

class SplashProvider extends ChangeNotifier {
  final BuildContext context;

  SplashProvider({
    required this.context,
  }) {
    navigateToHome();
  }

  void navigateToHome() {
    Future.delayed(const Duration(
      seconds: 2,
    )).whenComplete(
      () => Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.home,
        (route) => false,
      ),
    );
  }
}
