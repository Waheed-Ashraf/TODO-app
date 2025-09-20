import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_task/core/utils/app_colors.dart';
import 'package:todo_app_task/core/utils/app_text_styles.dart';

import 'package:todo_app_task/features/main_dashboard/data/enums/board_column_enum.dart';
import 'package:todo_app_task/features/main_dashboard/presentation/view_model/board_bloc/board_bloc.dart';
import 'package:todo_app_task/features/main_dashboard/presentation/view_model/board_bloc/board_event.dart';
import 'package:todo_app_task/features/main_dashboard/presentation/view_model/board_bloc/board_state.dart';
import 'package:todo_app_task/features/main_dashboard/presentation/views/widgets/lane.dart';

class MainDashboardViewBody extends StatelessWidget {
  const MainDashboardViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 8),
              // Title
              Text(
                'Kanban Board',
                style: TextStyles.titleLg.copyWith(color: AppColors.text),
              ),
              const SizedBox(height: 6),
              // Subtitle
              Text(
                'Streamline your workflow with the Kanban Board tool',
                style: TextStyles.bodyMuted(.9),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              Expanded(
                child: BlocBuilder<BoardBloc, BoardState>(
                  buildWhen: (p, c) =>
                      p.lanes != c.lanes ||
                      p.hoveringColumn != c.hoveringColumn,
                  builder: (context, state) {
                    final bloc = context.read<BoardBloc>();
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Backlog
                        Expanded(
                          child: Lane(
                            title: 'Backlog',
                            color: AppColors.secondaryLight, // themed color
                            column: BoardColumn.backlog,
                            tasks: state.lanes[BoardColumn.backlog]!,
                            onAcceptTask: (payload, target, {insertIndex}) =>
                                bloc.add(
                                  BoardAcceptTask(
                                    payload: payload,
                                    targetColumn: target,
                                    insertIndex: insertIndex,
                                  ),
                                ),
                            onHover: (isHover) => bloc.add(
                              BoardSetHovering(
                                isHover ? BoardColumn.backlog : null,
                              ),
                            ),
                            hovering:
                                state.hoveringColumn == BoardColumn.backlog,
                            onReorder: (col, from, to) => bloc.add(
                              BoardReorderWithinColumn(
                                column: col,
                                fromIndex: from,
                                toIndex: to,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // TODO
                        Expanded(
                          child: Lane(
                            title: 'To Do',
                            color: AppColors.danger,
                            column: BoardColumn.todo,
                            tasks: state.lanes[BoardColumn.todo]!,
                            onAcceptTask: (payload, target, {insertIndex}) =>
                                bloc.add(
                                  BoardAcceptTask(
                                    payload: payload,
                                    targetColumn: target,
                                    insertIndex: insertIndex,
                                  ),
                                ),
                            onHover: (isHover) => bloc.add(
                              BoardSetHovering(
                                isHover ? BoardColumn.todo : null,
                              ),
                            ),
                            hovering: state.hoveringColumn == BoardColumn.todo,
                            onReorder: (col, from, to) => bloc.add(
                              BoardReorderWithinColumn(
                                column: col,
                                fromIndex: from,
                                toIndex: to,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // In Progress
                        Expanded(
                          child: Lane(
                            title: 'In Progress',
                            color: AppColors.info,
                            column: BoardColumn.inProgress,
                            tasks: state.lanes[BoardColumn.inProgress]!,
                            onAcceptTask: (payload, target, {insertIndex}) =>
                                bloc.add(
                                  BoardAcceptTask(
                                    payload: payload,
                                    targetColumn: target,
                                    insertIndex: insertIndex,
                                  ),
                                ),
                            onHover: (isHover) => bloc.add(
                              BoardSetHovering(
                                isHover ? BoardColumn.inProgress : null,
                              ),
                            ),
                            hovering:
                                state.hoveringColumn == BoardColumn.inProgress,
                            onReorder: (col, from, to) => bloc.add(
                              BoardReorderWithinColumn(
                                column: col,
                                fromIndex: from,
                                toIndex: to,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Done
                        Expanded(
                          child: Lane(
                            title: 'Done',
                            color: AppColors.success,
                            column: BoardColumn.done,
                            tasks: state.lanes[BoardColumn.done]!,
                            onAcceptTask: (payload, target, {insertIndex}) =>
                                bloc.add(
                                  BoardAcceptTask(
                                    payload: payload,
                                    targetColumn: target,
                                    insertIndex: insertIndex,
                                  ),
                                ),
                            onHover: (isHover) => bloc.add(
                              BoardSetHovering(
                                isHover ? BoardColumn.done : null,
                              ),
                            ),
                            hovering: state.hoveringColumn == BoardColumn.done,
                            onReorder: (col, from, to) => bloc.add(
                              BoardReorderWithinColumn(
                                column: col,
                                fromIndex: from,
                                toIndex: to,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
