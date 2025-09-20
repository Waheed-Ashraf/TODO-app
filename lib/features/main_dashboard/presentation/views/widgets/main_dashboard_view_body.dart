import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
              const Text(
                "Kanban Board",
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              const Text(
                "Streamline your workflow with the Kanban Board tool",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
                        Expanded(
                          child: Lane(
                            title: "Backlog",
                            color: const Color(0xff9895e0),
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
                        Expanded(
                          child: Lane(
                            title: "TODO",
                            color: const Color(0xfff84a4a),
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
                        Expanded(
                          child: Lane(
                            title: "In Progress",
                            color: const Color(0xff4a94f8),
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
                        Expanded(
                          child: Lane(
                            title: "Done",
                            color: const Color(0xff56c991),
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
