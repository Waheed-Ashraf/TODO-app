// lib/main.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:todo_app_task/core/helper_functions/on_generate_routes.dart';
import 'package:todo_app_task/core/services/custom_bloc_observer.dart';
import 'package:todo_app_task/core/services/get_it_service.dart';
import 'package:todo_app_task/core/services/shared_preferences_singleton.dart';
import 'package:todo_app_task/core/theme/app_theme.dart';
import 'package:todo_app_task/features/splash/presentation/views/splash_view.dart';
import 'package:todo_app_task/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Bloc.observer = CustomBlocObserver();
  await Prefs.init();
  await setupGetit();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      themeMode: ThemeMode.dark,
      onGenerateRoute: onGenerateRoute,
      initialRoute: SplashView.routeName,
    );
  }
}
