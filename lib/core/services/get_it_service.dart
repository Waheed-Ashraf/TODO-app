import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupGetit() {
  // getIt.registerSingleton<FirebaseAuthService>(FirebaseAuthService());
  // getIt.registerSingleton<DatabaseService>(FireStoreService());
  // getIt.registerSingleton<AuthRepo>(
  //   AuthRepoImpl(
  //     firebaseAuthService: getIt<FirebaseAuthService>(),
  //     databaseService: getIt<DatabaseService>(),
  //   ),
  // );
  // getIt.registerSingleton<ProfileRepo>(
  //   ProfileRepoImpl(firebaseAuthService: getIt<FirebaseAuthService>()),
  // );
  // getIt.registerSingleton<ProductsRepo>(
  //   ProductsRepoImpl(getIt<DatabaseService>()),
  // );

  // getIt.registerFactory(() => DeleteAccountCubit(getIt<ProfileRepo>()));
  // getIt.registerFactory(() => LogoutCubit(getIt<ProfileRepo>()));
  // getIt.registerSingleton<OrdersRepo>(OrdersRepoImpl(getIt<DatabaseService>()));
}
