import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../network/network_info.dart';
import '../../data/datasources/auth_local_datasource.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/datasources/posts_remote_datasource.dart';
import '../../data/datasources/products_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/posts_repository_impl.dart';
import '../../data/repositories/products_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/posts_repository.dart';
import '../../domain/repositories/products_repository.dart';
import '../../domain/usecases/get_posts_usecase.dart';
import '../../domain/usecases/get_products_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../presentation/blocs/auth/auth_bloc.dart';
import '../../presentation/blocs/posts/posts_bloc.dart';
import '../../presentation/blocs/products/products_bloc.dart';
import '../../presentation/blocs/theme/theme_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  sl.registerLazySingleton<http.Client>(() => http.Client());
  sl.registerLazySingleton<Connectivity>(() => Connectivity());

  // Core
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(sl<Connectivity>()),
  );

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl<http.Client>()),
  );
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sl<SharedPreferences>()),
  );
  sl.registerLazySingleton<ProductsRemoteDataSource>(
    () => ProductsRemoteDataSourceImpl(sl<http.Client>()),
  );
  sl.registerLazySingleton<PostsRemoteDataSource>(
    () => PostsRemoteDataSourceImpl(sl<http.Client>()),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl<AuthRemoteDataSource>(),
      localDataSource: sl<AuthLocalDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );
  sl.registerLazySingleton<ProductsRepository>(
    () => ProductsRepositoryImpl(
      remoteDataSource: sl<ProductsRemoteDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );
  sl.registerLazySingleton<PostsRepository>(
    () => PostsRepositoryImpl(
      remoteDataSource: sl<PostsRemoteDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => LoginUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => GetProductsUseCase(sl<ProductsRepository>()));
  sl.registerLazySingleton(() => GetPostsUseCase(sl<PostsRepository>()));

  // BLoCs — registered as factory so new instance per provision
  sl.registerFactory(
    () => AuthBloc(
      loginUseCase: sl<LoginUseCase>(),
      authRepository: sl<AuthRepository>(),
    ),
  );
  sl.registerFactory(
    () => ProductsBloc(getProductsUseCase: sl<GetProductsUseCase>()),
  );
  sl.registerFactory(
    () => PostsBloc(getPostsUseCase: sl<GetPostsUseCase>()),
  );

  // Cubit — singleton so theme persists
  sl.registerLazySingleton(
    () => ThemeCubit(sl<SharedPreferences>()),
  );
}
