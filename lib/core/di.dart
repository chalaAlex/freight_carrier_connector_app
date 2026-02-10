import 'package:clean_architecture/cofig/env/app_config.dart';
import 'package:clean_architecture/cofig/env/env_config.dart';
import 'package:clean_architecture/cofig/env/env.dart';
import 'package:clean_architecture/core/theme/theme_cubit.dart';
import 'package:clean_architecture/core/network/api_client.dart';
import 'package:clean_architecture/core/network/dio_factory.dart';
import 'package:clean_architecture/feature/signup/data/datasources/login_remote_data_source.dart';
import 'package:clean_architecture/feature/signup/data/datasources/login_remote_data_source_impl.dart';
import 'package:clean_architecture/feature/signup/data/datasources/sign_up_remote_data_source.dart';
import 'package:clean_architecture/feature/signup/data/datasources/sign_up_remote_data_source_impl.dart';
import 'package:clean_architecture/feature/signup/data/repositories/login_repository_impl.dart';
import 'package:clean_architecture/feature/signup/data/repositories/sign_up_repository_impl.dart';
import 'package:clean_architecture/feature/signup/domain/repositories/login_repository.dart';
import 'package:clean_architecture/feature/signup/domain/repositories/sign_up_repository.dart';
import 'package:clean_architecture/feature/signup/domain/usecases/login_usecase.dart';
import 'package:clean_architecture/feature/signup/domain/usecases/sign_up_usecase.dart';
import 'package:clean_architecture/feature/signup/presentation/bloc/login/login_bloc.dart';
import 'package:clean_architecture/feature/signup/presentation/bloc/sign_up/sign_up_bloc.dart';
import 'package:clean_architecture/feature/truck_listing/data/datasources/truck_remote_data_source.dart';
import 'package:clean_architecture/feature/truck_listing/data/datasources/truck_remote_data_source_impl.dart';
import 'package:clean_architecture/feature/truck_listing/data/repositories/truck_repository_impl.dart';
import 'package:clean_architecture/feature/truck_listing/domain/repositories/truck_repository.dart';
import 'package:clean_architecture/feature/truck_listing/domain/usecases/get_trucks_usecase.dart';
import 'package:clean_architecture/feature/truck_listing/presentation/bloc/truck_bloc.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> init(Environment prod) async {
  // ------------------ Network ------------------ //
  sl.registerLazySingleton<Dio>(() => DioFactory.createDio());
  sl.registerLazySingleton<ApiClient>(() => ApiClient(sl()));

  // ------------------ Environments ------------------ //
  sl.registerSingleton<AppConfig>(EnvConfig.config);

  // ------------------ Data Sources ------------------ //
  sl.registerFactory<SignUpRemoteDataSource>(
    () => SignUpRemoteDataSourceImpl(client: sl()),
  );
  sl.registerFactory<LoginRemoteDataSource>(
    () => LoginRemoteDataSourceImpl(client: sl()),
  );
  sl.registerFactory<TruckRemoteDataSource>(
    () => TruckRemoteDataSourceImpl(client: sl()),
  );

  // ------------------ Repositories ------------------ //
  sl.registerFactory<SignUpRepository>(() => SignUpRepositoryImpl(sl()));
  sl.registerFactory<LoginRepository>(() => LoginRepositoryImpl(sl()));
  sl.registerFactory<TruckRepository>(() => TruckRepositoryImpl(sl()));

  // ------------------ Usecases ------------------ //
  sl.registerFactory(() => SignUpUsecase(sl()));
  sl.registerFactory(() => LoginUsecase(sl()));
  sl.registerFactory(() => GetTrucksUseCase(sl()));

  // ------------------ Blocs ------------------ //
  sl.registerFactory(() => SignUpBloc(sl()));
  sl.registerFactory(() => LoginBloc(sl()));
  sl.registerLazySingleton<ThemeCubit>(() => ThemeCubit());
  sl.registerFactory(() => TruckBloc(sl()));
}
