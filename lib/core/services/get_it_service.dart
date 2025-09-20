import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app_task/core/services/store_device_id.dart';
import 'package:todo_app_task/features/main_dashboard/data/repo/dashboard_repo.dart';
import 'package:todo_app_task/features/main_dashboard/data/repo_imp/dashboard_repo_imp.dart';
import 'package:todo_app_task/features/main_dashboard/presentation/view_model/board_bloc/board_bloc.dart';
import 'package:todo_app_task/features/main_dashboard/presentation/view_model/connectivity_bloc/connectivity_bloc.dart';
import 'package:todo_app_task/features/main_dashboard/presentation/view_model/connectivity_bloc/connectivity_event.dart';

final getIt = GetIt.instance;

Future<void> setupGetit() async {
  // Firestore
  getIt.registerLazySingleton<FirebaseFirestore>(
    () => FirebaseFirestore.instance,
  );

  // DeviceId (async singleton; use instanceName so we can await it)
  getIt.registerSingletonAsync<String>(
    () async => await DeviceIdService.getOrCreate(),
    instanceName: 'deviceId',
  );

  // Repository (depends on deviceId)
  getIt.registerSingletonAsync<DashboardRepository>(() async {
    final deviceId = await getIt.getAsync<String>(instanceName: 'deviceId');
    final db = getIt<FirebaseFirestore>();
    return DashboardRepoImp(db, deviceId: deviceId);
  });

  // Bloc factory (depends on repo)
  getIt.registerFactory<BoardBloc>(
    () => BoardBloc(repo: getIt<DashboardRepository>()),
  );
  getIt.registerLazySingleton<ConnectivityBloc>(
    () => ConnectivityBloc()..add(ConnectivityStart()),
  );

  // Wait for async singletons (deviceId, repo)
  await getIt.allReady();
}
