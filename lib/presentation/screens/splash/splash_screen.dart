import 'package:cat_breeds_app/config/assets.dart';
import 'package:cat_breeds_app/presentation/screens/splash/splash_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final provider = context.read<SplashProvider>();
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppAssets.splash),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
