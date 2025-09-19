import 'package:farmedia/core/repos/orders_repo/orders_repo.dart';
import 'package:farmedia/core/repos/orders_repo/orders_repo_impl.dart';
import 'package:farmedia/core/repos/products_repo/products_repo.dart';
import 'package:farmedia/core/repos/products_repo/products_repo_impl.dart';
import 'package:farmedia/core/services/data_service.dart';
import 'package:farmedia/core/services/firebase_auth_service.dart';
import 'package:farmedia/core/services/firestore_service.dart';
import 'package:farmedia/features/auth/data/repos/auth_repo_impl.dart';
import 'package:farmedia/features/auth/domain/repos/auth_repo.dart';
import 'package:farmedia/features/home/data/profile_repo/profile_repo.dart';
import 'package:farmedia/features/home/data/profile_repo_imp/profile_repo_imp.dart';
import 'package:farmedia/features/home/data/sell_product_repo/sell_product_repo.dart';
import 'package:farmedia/features/home/data/sell_product_repo_imp/sell_product_repo_imp.dart';
import 'package:farmedia/features/home/presentation/cubits/delete_account_cubit/delete_account_cubit.dart';
import 'package:farmedia/features/home/presentation/cubits/logout_cubit/logout_cubit.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupGetit() {
  getIt.registerSingleton<FirebaseAuthService>(FirebaseAuthService());
  getIt.registerSingleton<DatabaseService>(FireStoreService());
  getIt.registerSingleton<AuthRepo>(
    AuthRepoImpl(
      firebaseAuthService: getIt<FirebaseAuthService>(),
      databaseService: getIt<DatabaseService>(),
    ),
  );
  getIt.registerSingleton<ProfileRepo>(
    ProfileRepoImpl(firebaseAuthService: getIt<FirebaseAuthService>()),
  );
  getIt.registerSingleton<ProductsRepo>(
    ProductsRepoImpl(getIt<DatabaseService>()),
  );

  getIt.registerFactory(() => DeleteAccountCubit(getIt<ProfileRepo>()));
  getIt.registerFactory(() => LogoutCubit(getIt<ProfileRepo>()));
  getIt.registerSingleton<OrdersRepo>(OrdersRepoImpl(getIt<DatabaseService>()));
}
