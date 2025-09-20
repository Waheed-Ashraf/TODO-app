import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_task/core/services/get_it_service.dart';
import 'package:todo_app_task/core/utils/app_text_styles.dart';
import 'package:todo_app_task/features/main_dashboard/presentation/view_model/board_bloc/board_bloc.dart';
import 'package:todo_app_task/features/main_dashboard/presentation/view_model/board_bloc/board_event.dart';
import 'package:todo_app_task/features/main_dashboard/presentation/view_model/connectivity_bloc/connectivity_bloc.dart';
import 'package:todo_app_task/features/main_dashboard/presentation/view_model/connectivity_bloc/connectivity_state.dart';
import 'package:todo_app_task/features/main_dashboard/presentation/views/widgets/main_dashboard_view_body.dart';

class MainDashboardView extends StatelessWidget {
  const MainDashboardView({super.key});
  static const String routeName = 'MainDashboardView';

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<BoardBloc>()..add(BoardLoadAllColumns()),
        ),
        BlocProvider(
          create: (_) => getIt<ConnectivityBloc>(),
        ), // already started in getIt
      ],
      child: BlocBuilder<ConnectivityBloc, ConnectivityState>(
        builder: (context, state) {
          return Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  if (!state.online)
                    Container(
                      width: double.infinity,
                      color: Colors.amber.shade800,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.wifi_off, size: 18, color: Colors.white),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'You’re offline. Changes won’t sync.',
                              style: TextStyles.titleMd,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const Expanded(child: MainDashboardViewBody()),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
