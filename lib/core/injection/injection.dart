import 'package:eliberty_toolbox/features/auth/data/datasources/auth_local_ds.dart';
import 'package:eliberty_toolbox/features/auth/data/datasources/auth_remote_ds.dart';
import 'package:eliberty_toolbox/features/auth/domain/usecases/sign_out.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/data/repositories/auth_repo_impl.dart';
import '../../features/auth/domain/repositories/auth_repo.dart';
import '../../features/auth/domain/usecases/get_user_from_cache.dart';
import '../../features/auth/domain/usecases/sign_in_with_email.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../services/cache_service.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => CacheService(sharedPreferences));

  // Datasources
  sl.registerLazySingleton(() => AuthLocalDatasource(sl()));
  sl.registerLazySingleton(() => AuthRemoteDatasource());

  // Repository
  sl.registerLazySingleton<AuthRepo>(
    () => AuthRepoImpl(localDatasource: sl(), remoteDatasource: sl()),
  );

  // Usecases
  sl.registerLazySingleton(() => GetUserFromCache(sl()));
  sl.registerLazySingleton(() => SignInWithEmail(sl()));
  sl.registerLazySingleton(() => SignOut(sl()));

  // Cubit
  sl.registerFactory(
    () => AuthCubit(getUserFromCache: sl(), loginUser: sl(), logoutUser: sl()),
  );
}
