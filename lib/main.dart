import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_task/core/helper_functions/on_generate_routes.dart';
import 'package:todo_app_task/core/services/custom_bloc_observer.dart';
import 'package:todo_app_task/core/services/get_it_service.dart';
import 'package:todo_app_task/core/services/shared_preferences_singleton.dart';
import 'package:todo_app_task/core/utils/app_colors.dart';
import 'package:todo_app_task/features/splash/presentation/views/splash_view.dart';
import 'package:todo_app_task/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Bloc.observer = CustomBlocObserver();
  await Prefs.init();
  setupGetit();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Light theme (optional if you want to support both)
      theme: ThemeData(
        fontFamily: 'Cairo',
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryColor),
      ),

      // Dark theme
      darkTheme: ThemeData(
        fontFamily: 'Cairo',
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xff181818),
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryColor,
          brightness: Brightness.dark,
        ),
      ),

      themeMode: ThemeMode.dark,

      onGenerateRoute: onGenerateRoute,
      initialRoute: SplashView.routeName,
      debugShowCheckedModeBanner: false,
    );
  }
}
