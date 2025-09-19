import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_task/core/helper_functions/on_generate_routes.dart';
import 'package:todo_app_task/core/services/custom_bloc_observer.dart';
import 'package:todo_app_task/core/services/get_it_service.dart';
import 'package:todo_app_task/core/services/shared_preferences_singleton.dart';
import 'package:todo_app_task/core/utils/app_colors.dart';
import 'package:todo_app_task/features/splash/presentation/views/splash_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = CustomBlocObserver();
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Prefs.init();

  setupGetit();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Cairo',
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryColor),
      ),

      onGenerateRoute: onGenerateRoute,
      initialRoute: SplashView.routeName,
      debugShowCheckedModeBanner: false,
    );
  }
}
