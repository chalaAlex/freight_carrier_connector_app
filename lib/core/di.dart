import 'package:clean_architecture/cofig/env/app_config.dart';
import 'package:clean_architecture/cofig/env/env_config.dart';
import 'package:clean_architecture/cofig/env/env.dart';
import 'package:clean_architecture/core/theme/theme_cubit.dart';
import 'package:clean_architecture/core/network/api_client.dart';
import 'package:clean_architecture/core/network/dio_factory.dart';
import 'package:clean_architecture/core/token/toke_local_data_source.dart';
import 'package:clean_architecture/core/token/toke_local_data_source_impl.dart';
import 'package:clean_architecture/feature/freight/data/datasources/freight_remote_data_source.dart';
import 'package:clean_architecture/feature/freight/data/datasources/freight_remote_data_source_impl.dart';
import 'package:clean_architecture/feature/freight/data/datasources/location_remote_data_source.dart';
import 'package:clean_architecture/feature/freight/data/datasources/location_remote_data_source_impl.dart';
import 'package:clean_architecture/feature/freight/data/datasources/cargo_type_remote_data_source.dart';
import 'package:clean_architecture/feature/freight/data/datasources/cargo_type_remote_data_source_impl.dart';
import 'package:clean_architecture/feature/freight/data/repositories/freight_repository_impl.dart';
import 'package:clean_architecture/feature/freight/data/repositories/location_repository_impl.dart';
import 'package:clean_architecture/feature/freight/data/repositories/cargo_type_repository_impl.dart';
import 'package:clean_architecture/feature/freight/domain/repositories/freight_repository.dart';
import 'package:clean_architecture/feature/freight/domain/repositories/location_repository.dart';
import 'package:clean_architecture/feature/freight/domain/repositories/cargo_type_repository.dart';
import 'package:clean_architecture/feature/freight/domain/usecases/create_freight_usecase.dart';
import 'package:clean_architecture/feature/freight/domain/usecases/get_freights_usecase.dart';
import 'package:clean_architecture/feature/freight/domain/usecases/get_locations_usecase.dart';
import 'package:clean_architecture/feature/freight/domain/usecases/get_cargo_types_usecase.dart';
import 'package:clean_architecture/feature/freight/presentation/bloc/freight_bloc.dart';
import 'package:clean_architecture/feature/freight/presentation/bloc/location_bloc.dart';
import 'package:clean_architecture/feature/freight/presentation/bloc/cargo_type_bloc.dart';
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
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> init(Environment prod) async {
  // ------------------ STORAGE ------------------ //
  sl.registerLazySingleton(() => const FlutterSecureStorage());

  // ------------------ TOKEN LOCAL DATASOURCE ------------------ //
  sl.registerLazySingleton<TokenLocalDataSource>(
    () => TokenLocalDataSourceImpl(sl()),
  );

  // ------------------ Network ------------------ //
  sl.registerLazySingleton<Dio>(() => DioFactory.createDio(sl()));
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
  sl.registerFactory<FreightRemoteDataSource>(
    () => FreightRemoteDataSourceImpl(client: sl()),
  );
  sl.registerFactory<LocationRemoteDataSource>(
    () => LocationRemoteDataSourceImpl(client: sl()),
  );
  sl.registerFactory<CargoTypeRemoteDataSource>(
    () => CargoTypeRemoteDataSourceImpl(sl()),
  );

  // ------------------ Repositories ------------------ //
  sl.registerFactory<SignUpRepository>(() => SignUpRepositoryImpl(sl()));
  sl.registerFactory<LoginRepository>(() => LoginRepositoryImpl(sl(), sl()));
  sl.registerFactory<TruckRepository>(() => TruckRepositoryImpl(sl()));
  sl.registerFactory<FreightRepository>(() => FreightRepositoryImpl(sl()));
  sl.registerFactory<LocationRepository>(() => LocationRepositoryImpl(sl()));
  sl.registerFactory<CargoTypeRepository>(() => CargoTypeRepositoryImpl(sl()));

  // ------------------ Usecases ------------------ //
  sl.registerFactory(() => SignUpUsecase(sl()));
  sl.registerFactory(() => LoginUsecase(sl()));
  sl.registerFactory(() => GetTrucksUseCase(sl()));
  sl.registerFactory(() => CreateFreightUseCase(sl()));
  sl.registerFactory(() => GetFreightsUseCase(sl()));
  sl.registerFactory(() => GetLocationsUseCase(sl()));
  sl.registerFactory(() => GetCargoTypesUseCase(sl()));

  // ------------------ Blocs ------------------ //
  sl.registerFactory(() => SignUpBloc(sl()));
  sl.registerFactory(() => LoginBloc(sl()));
  sl.registerLazySingleton<ThemeCubit>(() => ThemeCubit());
  sl.registerFactory(() => TruckBloc(sl()));
  sl.registerFactory(
    () => FreightBloc(createFreightUseCase: sl(), getFreightsUseCase: sl()),
  );
  sl.registerFactory(() => LocationBloc(getLocationsUseCase: sl()));
  sl.registerFactory(() => CargoTypeBloc(sl()));
}
