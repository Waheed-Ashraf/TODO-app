import 'package:flutter/material.dart';
import 'package:todo_app_task/features/main_dashboard/presentation/views/widgets/main_dashboard_view_body.dart';

class MainDashboardView extends StatelessWidget {
  const MainDashboardView({super.key});
  static const String routeName = 'MainDashboardView';
  @override
  Widget build(BuildContext context) {
    return const MainDashboardViewBody();
  }
}
