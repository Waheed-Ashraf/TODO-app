import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_task/core/services/get_it_service.dart';
import 'package:todo_app_task/core/utils/app_colors.dart';
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
        BlocProvider(create: (_) => getIt<ConnectivityBloc>()),
      ],
      child: BlocBuilder<ConnectivityBloc, ConnectivityState>(
        builder: (context, state) {
          final width = MediaQuery.sizeOf(context).width;
          final isTabletWidth = width >= 800;

          return Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  if (!state.online)
                    Container(
                      width: double.infinity,
                      color: AppColors.secondary.withOpacity(.22),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.wifi_off, size: 18, color: AppColors.text),
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

                  if (!isTabletWidth)
                    Container(
                      width: double.infinity,
                      color: AppColors.info.withOpacity(.18),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.tablet_mac,
                            size: 18,
                            color: AppColors.text,
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'For the best Kanban experience, please use a tablet or larger screen.',
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
