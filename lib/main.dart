import 'package:cat_breeds_app/config/env.dart';
import 'package:cat_breeds_app/config/router/router_path.dart';
import 'package:cat_breeds_app/config/strings.dart';
import 'package:cat_breeds_app/config/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cat_breeds_app/config/router/router.dart' as router;

Future<void> runCatBreedsApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  await Env.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppStrings.appName,
      theme: ThemeDataApp.themeData,
      initialRoute: AppRoutes.splash,
      onGenerateRoute: router.generateRoute,
    );
  }
}
