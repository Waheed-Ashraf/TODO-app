// lib/features/main_dashboard/presentation/views/main_dashboard_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_task/core/services/get_it_service.dart';
import 'package:todo_app_task/features/main_dashboard/presentation/view_model/bloc/board_bloc.dart';
import 'package:todo_app_task/features/main_dashboard/presentation/view_model/bloc/board_event.dart';
import 'package:todo_app_task/features/main_dashboard/presentation/views/widgets/main_dashboard_view_body.dart';

class MainDashboardView extends StatelessWidget {
  const MainDashboardView({super.key});
  static const String routeName = 'MainDashboardView';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<BoardBloc>()..add(BoardLoadAllColumns()),
      child: const MainDashboardViewBody(),
    );
  }
}
