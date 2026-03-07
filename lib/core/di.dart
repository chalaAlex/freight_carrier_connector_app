import 'package:clean_architecture/cofig/env/app_config.dart';
import 'package:clean_architecture/cofig/env/env_config.dart';
import 'package:clean_architecture/cofig/env/environment.dart';
import 'package:clean_architecture/core/storage/supabase_config.dart';
import 'package:clean_architecture/core/storage/supabase_storage_service.dart';
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
import 'package:clean_architecture/feature/freight/data/datasources/upload_remote_data_source.dart';
import 'package:clean_architecture/feature/freight/data/datasources/upload_remote_data_source_impl.dart';
import 'package:clean_architecture/feature/freight/data/datasources/truck_detail_remote_data_source.dart';
import 'package:clean_architecture/feature/freight/data/datasources/truck_detail_remote_data_source_impl.dart';
import 'package:clean_architecture/feature/freight/data/repositories/freight_repository_impl.dart';
import 'package:clean_architecture/feature/freight/data/repositories/location_repository_impl.dart';
import 'package:clean_architecture/feature/freight/data/repositories/cargo_type_repository_impl.dart';
import 'package:clean_architecture/feature/freight/data/repositories/upload_repository_impl.dart';
import 'package:clean_architecture/feature/freight/data/repositories/truck_detail_repository_impl.dart';
import 'package:clean_architecture/feature/freight/domain/repositories/freight_repository.dart';
import 'package:clean_architecture/feature/freight/domain/repositories/location_repository.dart';
import 'package:clean_architecture/feature/freight/domain/repositories/cargo_type_repository.dart';
import 'package:clean_architecture/feature/freight/domain/repositories/upload_repository.dart';
import 'package:clean_architecture/feature/freight/domain/repositories/truck_detail_repository.dart';
import 'package:clean_architecture/feature/freight/domain/usecases/create_freight_usecase.dart';
import 'package:clean_architecture/feature/freight/domain/usecases/get_freights_usecase.dart';
import 'package:clean_architecture/feature/freight/domain/usecases/get_locations_usecase.dart';
import 'package:clean_architecture/feature/freight/domain/usecases/get_cargo_types_usecase.dart';
import 'package:clean_architecture/feature/freight/domain/usecases/upload_usecase.dart';
import 'package:clean_architecture/feature/freight/domain/usecases/get_truck_detail_usecase.dart';
import 'package:clean_architecture/feature/freight/presentation/bloc/freight/freight_bloc.dart';
import 'package:clean_architecture/feature/freight/presentation/bloc/location/location_bloc.dart';
import 'package:clean_architecture/feature/freight/presentation/bloc/cargoType/cargo_type_bloc.dart';
import 'package:clean_architecture/feature/freight/presentation/bloc/upload/upload_bloc.dart';
import 'package:clean_architecture/feature/freight/presentation/bloc/truck_detail/truck_detail_bloc.dart';
import 'package:clean_architecture/feature/landing/data/datasources/featured_carrier_remote_data_source.dart';
import 'package:clean_architecture/feature/landing/data/datasources/featured_carrier_remote_data_source_impl.dart';
import 'package:clean_architecture/feature/landing/data/repositories/featured_carrier_repository_impl.dart';
import 'package:clean_architecture/feature/landing/domain/repositories/featured_carrier_repository.dart';
import 'package:clean_architecture/feature/landing/domain/usecases/get_featured_carriers_usecase.dart';
import 'package:clean_architecture/feature/landing/presentation/bloc/featured_carrier_bloc.dart';
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
import 'package:supabase_flutter/supabase_flutter.dart';

final sl = GetIt.instance;

Future<void> init(Environment prod) async {
  // ------------------ Initialize Supabase ------------------ //
  await Supabase.initialize(
    url: SupabaseConfig.supabaseUrl,
    anonKey: SupabaseConfig.supabaseAnonKey,
  );

  // ------------------ STORAGE ------------------ //
  sl.registerLazySingleton(() => const FlutterSecureStorage());

  // ------------------ Supabase Storage ------------------ //
  sl.registerLazySingleton<SupabaseClient>(() => Supabase.instance.client);
  sl.registerLazySingleton<SupabaseStorageService>(
    () => SupabaseStorageService(sl(), SupabaseConfig.storageBucket),
  );

  // ------------------ TOKEN LOCAL DATASOURCE ------------------ //
  sl.registerLazySingleton<TokenLocalDataSource>(
    () => TokenLocalDataSourceImpl(sl()),
  );

  // ------------------ Environments ------------------ //
  sl.registerSingleton<AppConfig>(EnvConfig.config);

  // ------------------ Network ------------------ //
  sl.registerLazySingleton<Dio>(
    () => DioFactory.createDio(sl(), sl<AppConfig>().baseUrl),
  );
  sl.registerLazySingleton<ApiClient>(() => ApiClient(sl()));

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
  sl.registerFactory<FileRemoteDataSource>(
    () => FileRemoteDataSourceImpl(sl()),
  );
  sl.registerFactory<TruckDetailRemoteDataSource>(
    () => TruckDetailRemoteDataSourceImpl(client: sl()),
  );
  sl.registerFactory<FeaturedCarrierRemoteDataSource>(
    () => FeaturedCarrierRemoteDataSourceImpl(client: sl()),
  );

  // ------------------ Repositories ------------------ //
  sl.registerFactory<SignUpRepository>(() => SignUpRepositoryImpl(sl()));
  sl.registerFactory<LoginRepository>(() => LoginRepositoryImpl(sl(), sl()));
  sl.registerFactory<TruckRepository>(() => TruckRepositoryImpl(sl()));
  sl.registerFactory<FreightRepository>(() => FreightRepositoryImpl(sl()));
  sl.registerFactory<LocationRepository>(() => LocationRepositoryImpl(sl()));
  sl.registerFactory<CargoTypeRepository>(() => CargoTypeRepositoryImpl(sl()));
  sl.registerFactory<FileRepository>(() => FileRepositoryImpl(sl()));
  sl.registerFactory<TruckDetailRepository>(
    () => TruckDetailRepositoryImpl(sl()),
  );
  sl.registerFactory<FeaturedCarrierRepository>(
    () => FeaturedCarrierRepositoryImpl(sl()),
  );

  // ------------------ Usecases ------------------ //
  sl.registerFactory(() => SignUpUsecase(sl()));
  sl.registerFactory(() => LoginUsecase(sl()));
  sl.registerFactory(() => GetTrucksUseCase(sl()));
  sl.registerFactory(() => CreateFreightUseCase(sl()));
  sl.registerFactory(() => GetFreightsUseCase(sl()));
  sl.registerFactory(() => GetLocationsUseCase(sl()));
  sl.registerFactory(() => GetCargoTypesUseCase(sl()));
  sl.registerFactory(() => UploadFileUseCase(sl()));
  sl.registerFactory(() => UploadMultipleFilesUseCase(sl()));
  sl.registerFactory(() => GetTruckDetailUseCase(sl()));
  sl.registerFactory(() => GetFeaturedCarriersUseCase(sl()));

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
  sl.registerFactory(
    () => UploadBloc(uploadFileUseCase: sl(), uploadMultipleFilesUseCase: sl()),
  );
  sl.registerFactory(() => TruckDetailBloc(getTruckDetailUseCase: sl()));
  sl.registerFactory(
    () => FeaturedCarrierBloc(getFeaturedCarriersUseCase: sl()),
  );
}
