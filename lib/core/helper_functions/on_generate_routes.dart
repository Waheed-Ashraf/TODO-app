import 'package:flutter/material.dart';
import 'package:todo_app_task/features/main_dashboard/presentation/views/main_dashboard_view.dart';
import 'package:todo_app_task/features/splash/presentation/views/splash_view.dart';

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case SplashView.routeName:
      return MaterialPageRoute(builder: (context) => const SplashView());
    case MainDashboardView.routeName:
      return MaterialPageRoute(builder: (context) => const MainDashboardView());
    default:
      return MaterialPageRoute(builder: (context) => const Scaffold());
  }
}
