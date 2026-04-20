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
import 'package:clean_architecture/feature/freight_oner_module/freight/data/datasources/freight_remote_data_source.dart';
import 'package:clean_architecture/feature/freight_oner_module/freight/data/datasources/freight_remote_data_source_impl.dart';
import 'package:clean_architecture/feature/freight_oner_module/freight/data/datasources/location_remote_data_source.dart';
import 'package:clean_architecture/feature/freight_oner_module/freight/data/datasources/location_remote_data_source_impl.dart';
import 'package:clean_architecture/feature/freight_oner_module/freight/data/datasources/cargo_type_remote_data_source.dart';
import 'package:clean_architecture/feature/freight_oner_module/freight/data/datasources/cargo_type_remote_data_source_impl.dart';
import 'package:clean_architecture/feature/freight_oner_module/freight/data/datasources/upload_remote_data_source.dart';
import 'package:clean_architecture/feature/freight_oner_module/freight/data/datasources/upload_remote_data_source_impl.dart';
import 'package:clean_architecture/feature/freight_oner_module/freight/data/datasources/truck_detail_remote_data_source.dart';
import 'package:clean_architecture/feature/freight_oner_module/freight/data/datasources/truck_detail_remote_data_source_impl.dart';
import 'package:clean_architecture/feature/freight_oner_module/freight/data/repositories/freight_repository_impl.dart';
import 'package:clean_architecture/feature/freight_oner_module/freight/data/repositories/location_repository_impl.dart';
import 'package:clean_architecture/feature/freight_oner_module/freight/data/repositories/cargo_type_repository_impl.dart';
import 'package:clean_architecture/feature/freight_oner_module/freight/data/repositories/upload_repository_impl.dart';
import 'package:clean_architecture/feature/freight_oner_module/freight/data/repositories/truck_detail_repository_impl.dart';
import 'package:clean_architecture/feature/freight_oner_module/freight/domain/repositories/freight_repository.dart';
import 'package:clean_architecture/feature/freight_oner_module/freight/domain/repositories/location_repository.dart';
import 'package:clean_architecture/feature/freight_oner_module/freight/domain/repositories/cargo_type_repository.dart';
import 'package:clean_architecture/feature/freight_oner_module/freight/domain/repositories/upload_repository.dart';
import 'package:clean_architecture/feature/freight_oner_module/freight/domain/repositories/truck_detail_repository.dart';
import 'package:clean_architecture/feature/freight_oner_module/freight/domain/usecases/create_freight_usecase.dart';
import 'package:clean_architecture/feature/freight_oner_module/freight/domain/usecases/get_all_freights_usecase.dart';
import 'package:clean_architecture/feature/freight_oner_module/freight/domain/usecases/get_my_freights_usecase.dart';
import 'package:clean_architecture/feature/freight_oner_module/freight/domain/usecases/get_locations_usecase.dart';
import 'package:clean_architecture/feature/freight_oner_module/freight/domain/usecases/get_cargo_types_usecase.dart';
import 'package:clean_architecture/feature/freight_oner_module/freight/domain/usecases/upload_usecase.dart';
import 'package:clean_architecture/feature/freight_oner_module/freight/domain/usecases/get_freight_detail_usecase.dart';
import 'package:clean_architecture/feature/freight_oner_module/freight/domain/usecases/get_truck_detail_usecase.dart';
import 'package:clean_architecture/feature/freight_oner_module/freight/presentation/bloc/freight/freight_bloc.dart';
import 'package:clean_architecture/feature/freight_oner_module/freight/presentation/bloc/location/location_bloc.dart';
import 'package:clean_architecture/feature/freight_oner_module/freight/presentation/bloc/cargoType/cargo_type_bloc.dart';
import 'package:clean_architecture/feature/freight_oner_module/freight/presentation/bloc/upload/upload_bloc.dart';
import 'package:clean_architecture/feature/freight_oner_module/freight/presentation/bloc/truck_detail/truck_detail_bloc.dart';
import 'package:clean_architecture/feature/freight_oner_module/landing/data/datasources/featured_carrier_remote_data_source.dart';
import 'package:clean_architecture/feature/freight_oner_module/landing/data/datasources/featured_carrier_remote_data_source_impl.dart';
import 'package:clean_architecture/feature/freight_oner_module/landing/data/repositories/featured_carrier_repository_impl.dart';
import 'package:clean_architecture/feature/freight_oner_module/landing/domain/repositories/featured_carrier_repository.dart';
import 'package:clean_architecture/feature/freight_oner_module/landing/domain/usecases/get_featured_carriers_usecase.dart';
import 'package:clean_architecture/feature/freight_oner_module/landing/presentation/bloc/featured_carrier_bloc.dart';
import 'package:clean_architecture/feature/freight_oner_module/company/data/datasources/company_remote_data_source.dart';
import 'package:clean_architecture/feature/freight_oner_module/company/data/datasources/company_remote_data_source_impl.dart';
import 'package:clean_architecture/feature/freight_oner_module/company/data/repositories/company_repository_impl.dart';
import 'package:clean_architecture/feature/freight_oner_module/company/domain/repository/company_repository.dart';
import 'package:clean_architecture/feature/freight_oner_module/company/domain/usecase/get_recommended_companies_usecase.dart';
import 'package:clean_architecture/feature/freight_oner_module/company/domain/usecase/get_top_rated_companies_usecase.dart';
import 'package:clean_architecture/feature/freight_oner_module/company/domain/usecase/get_company_detail_usecase.dart';
import 'package:clean_architecture/feature/freight_oner_module/company/presentation/bloc/company_bloc.dart';
import 'package:clean_architecture/feature/freight_oner_module/signup/data/datasources/login_remote_data_source.dart';
import 'package:clean_architecture/feature/freight_oner_module/signup/data/datasources/login_remote_data_source_impl.dart';
import 'package:clean_architecture/feature/freight_oner_module/signup/data/datasources/sign_up_remote_data_source.dart';
import 'package:clean_architecture/feature/freight_oner_module/signup/data/datasources/sign_up_remote_data_source_impl.dart';
import 'package:clean_architecture/feature/freight_oner_module/signup/data/repositories/login_repository_impl.dart';
import 'package:clean_architecture/feature/freight_oner_module/signup/data/repositories/sign_up_repository_impl.dart';
import 'package:clean_architecture/feature/freight_oner_module/signup/domain/repositories/login_repository.dart';
import 'package:clean_architecture/feature/freight_oner_module/signup/domain/repositories/sign_up_repository.dart';
import 'package:clean_architecture/feature/freight_oner_module/signup/domain/usecases/login_usecase.dart';
import 'package:clean_architecture/feature/freight_oner_module/signup/domain/usecases/sign_up_usecase.dart';
import 'package:clean_architecture/feature/freight_oner_module/signup/presentation/bloc/login/login_bloc.dart';
import 'package:clean_architecture/feature/freight_oner_module/signup/presentation/bloc/sign_up/sign_up_bloc.dart';
import 'package:clean_architecture/feature/freight_oner_module/truck_listing/data/datasources/truck_remote_data_source.dart';
import 'package:clean_architecture/feature/freight_oner_module/truck_listing/data/datasources/truck_remote_data_source_impl.dart';
import 'package:clean_architecture/feature/freight_oner_module/truck_listing/data/datasources/region_remote_data_source.dart';
import 'package:clean_architecture/feature/freight_oner_module/truck_listing/data/datasources/region_remote_data_source_impl.dart';
import 'package:clean_architecture/feature/freight_oner_module/truck_listing/data/datasources/feature_remote_data_source.dart';
import 'package:clean_architecture/feature/freight_oner_module/truck_listing/data/datasources/feature_remote_data_source_impl.dart';
import 'package:clean_architecture/feature/freight_oner_module/truck_listing/data/datasources/brand_remote_data_source.dart';
import 'package:clean_architecture/feature/freight_oner_module/truck_listing/data/datasources/brand_remote_data_source_impl.dart';
import 'package:clean_architecture/feature/freight_oner_module/truck_listing/data/repositories/truck_repository_impl.dart';
import 'package:clean_architecture/feature/freight_oner_module/truck_listing/data/repositories/region_repository_impl.dart';
import 'package:clean_architecture/feature/freight_oner_module/truck_listing/data/repositories/feature_repository_impl.dart';
import 'package:clean_architecture/feature/freight_oner_module/truck_listing/data/repositories/brand_repository_impl.dart';
import 'package:clean_architecture/feature/freight_oner_module/truck_listing/domain/repositories/truck_repository.dart';
import 'package:clean_architecture/feature/freight_oner_module/truck_listing/domain/repositories/region_repository.dart';
import 'package:clean_architecture/feature/freight_oner_module/truck_listing/domain/repositories/feature_repository.dart';
import 'package:clean_architecture/feature/freight_oner_module/truck_listing/domain/repositories/brand_repository.dart';
import 'package:clean_architecture/feature/freight_oner_module/truck_listing/domain/usecases/get_features_usecase.dart';
import 'package:clean_architecture/feature/freight_oner_module/truck_listing/domain/usecases/get_brands_usecase.dart';
import 'package:clean_architecture/feature/freight_oner_module/truck_listing/domain/usecases/get_trucks_usecase.dart';
import 'package:clean_architecture/feature/freight_oner_module/truck_listing/domain/usecases/get_regions_usecase.dart';
import 'package:clean_architecture/feature/freight_oner_module/truck_listing/presentation/bloc/feature_bloc.dart';
import 'package:clean_architecture/feature/freight_oner_module/truck_listing/presentation/bloc/brand_bloc.dart';
import 'package:clean_architecture/feature/freight_oner_module/truck_listing/presentation/bloc/truck_bloc.dart';
import 'package:clean_architecture/feature/freight_oner_module/truck_listing/presentation/bloc/region_bloc.dart';
import 'package:clean_architecture/feature/freight_oner_module/my_loads/data/datasources/my_loads_remote_data_source.dart';
import 'package:clean_architecture/feature/freight_oner_module/my_loads/data/datasources/my_loads_remote_data_source_impl.dart';
import 'package:clean_architecture/feature/freight_oner_module/my_loads/data/repositories/my_loads_repository_impl.dart';
import 'package:clean_architecture/feature/freight_oner_module/my_loads/domain/repositories/my_loads_repository.dart';
import 'package:clean_architecture/feature/freight_oner_module/my_loads/domain/usecases/get_my_loads_usecase.dart';
import 'package:clean_architecture/feature/freight_oner_module/my_loads/presentation/bloc/my_loads_bloc.dart';
import 'package:clean_architecture/feature/freight_oner_module/carrier/data/datasource/favourite_remote_data_source.dart';
import 'package:clean_architecture/feature/freight_oner_module/carrier/data/datasource/favourite_remote_data_source_impl.dart';
import 'package:clean_architecture/feature/freight_oner_module/carrier/data/repository/favourite_repository_impl.dart';
import 'package:clean_architecture/feature/freight_oner_module/carrier/domain/repository/favourite_repository.dart';
import 'package:clean_architecture/feature/freight_oner_module/carrier/domain/usecase/toggle_favourite_usecase.dart';
import 'package:clean_architecture/feature/freight_oner_module/carrier/presentation/bloc/favourite_bloc.dart';
import 'package:clean_architecture/feature/freight_oner_module/shipment_request/data/datasources/shipment_request_remote_data_source.dart';
import 'package:clean_architecture/feature/freight_oner_module/shipment_request/data/datasources/shipment_request_remote_data_source_impl.dart';
import 'package:clean_architecture/feature/freight_oner_module/shipment_request/data/repositories/shipment_request_repository_impl.dart';
import 'package:clean_architecture/feature/freight_oner_module/shipment_request/domain/repositories/shipment_request_repository.dart';
import 'package:clean_architecture/feature/freight_oner_module/shipment_request/domain/usecases/create_shipment_request_usecase.dart';
import 'package:clean_architecture/feature/freight_oner_module/shipment_request/domain/usecases/get_sent_requests_usecase.dart';
import 'package:clean_architecture/feature/freight_oner_module/shipment_request/domain/usecases/cancel_request_usecase.dart';
import 'package:clean_architecture/feature/freight_oner_module/shipment_request/domain/usecases/complete_request_usecase.dart';
import 'package:clean_architecture/feature/freight_oner_module/shipment_request/presentation/bloc/shipment_request_bloc.dart';
import 'package:clean_architecture/feature/freight_oner_module/shipment_request/presentation/bloc/sent_requests_bloc.dart';
import 'package:clean_architecture/feature/freight_oner_module/rating_and_review/data/datasources/review_remote_data_source.dart';
import 'package:clean_architecture/feature/freight_oner_module/rating_and_review/data/datasources/review_remote_data_source_impl.dart';
import 'package:clean_architecture/feature/freight_oner_module/rating_and_review/data/repositories/review_repository_impl.dart';
import 'package:clean_architecture/feature/freight_oner_module/rating_and_review/domain/repositories/review_repository.dart';
import 'package:clean_architecture/feature/freight_oner_module/rating_and_review/domain/usecases/get_completed_shipments_usecase.dart';
import 'package:clean_architecture/feature/freight_oner_module/rating_and_review/domain/usecases/submit_review_usecase.dart';
import 'package:clean_architecture/feature/freight_oner_module/rating_and_review/presentation/bloc/completed_shipments_bloc.dart';
import 'package:clean_architecture/feature/freight_oner_module/rating_and_review/presentation/bloc/review_bloc.dart';
import 'package:clean_architecture/feature/carrier_owner_module/freights/data/datasource/freights_remote_data_source.dart';
import 'package:clean_architecture/feature/carrier_owner_module/freights/data/datasource/freights_remote_data_source_impl.dart';
import 'package:clean_architecture/feature/carrier_owner_module/freights/data/repository/freights_repository_impl.dart';
import 'package:clean_architecture/feature/carrier_owner_module/freights/domain/repository/freights_repository.dart';
import 'package:clean_architecture/feature/carrier_owner_module/freights/domain/usecase/get_freights_usecase.dart'
    as carrier_freights;
import 'package:clean_architecture/feature/carrier_owner_module/freight_home_page/presentation/bloc/freight_listing_bloc.dart';
import 'package:clean_architecture/feature/carrier_owner_module/bids/data/datasource/bid_remote_data_source.dart';
import 'package:clean_architecture/feature/carrier_owner_module/bids/data/datasource/bid_remote_data_source_impl.dart';
import 'package:clean_architecture/feature/carrier_owner_module/bids/data/datasource/my_bids_remote_data_source.dart';
import 'package:clean_architecture/feature/carrier_owner_module/bids/data/datasource/my_bids_remote_data_source_impl.dart';
import 'package:clean_architecture/feature/carrier_owner_module/bids/data/repository/bid_repository_impl.dart';
import 'package:clean_architecture/feature/carrier_owner_module/bids/data/repository/my_bids_repository_impl.dart';
import 'package:clean_architecture/feature/carrier_owner_module/bids/domain/repository/bid_repository.dart';
import 'package:clean_architecture/feature/carrier_owner_module/bids/domain/repository/my_bids_repository.dart';
import 'package:clean_architecture/feature/carrier_owner_module/bids/domain/usecase/create_bid_usecase.dart';
import 'package:clean_architecture/feature/carrier_owner_module/bids/domain/usecase/accept_bid_usecase.dart';
import 'package:clean_architecture/feature/carrier_owner_module/bids/domain/usecase/reject_bid_usecase.dart';
import 'package:clean_architecture/feature/carrier_owner_module/bids/domain/usecase/get_bid_usecase.dart';
import 'package:clean_architecture/feature/carrier_owner_module/bids/domain/usecase/get_my_bids_usecase.dart';
import 'package:clean_architecture/feature/carrier_owner_module/bids/presentation/bloc/bid_bloc.dart';
import 'package:clean_architecture/feature/carrier_owner_module/bids/presentation/bloc/my_bids_cubit.dart';
import 'package:clean_architecture/feature/carrier_owner_module/carriers/data/datasource/my_carriers_remote_data_source.dart';
import 'package:clean_architecture/feature/carrier_owner_module/carriers/data/datasource/my_carriers_remote_data_source_impl.dart';
import 'package:clean_architecture/feature/carrier_owner_module/carriers/data/repository/my_carriers_repository_impl.dart';
import 'package:clean_architecture/feature/carrier_owner_module/carriers/domain/repository/my_carriers_repository.dart';
import 'package:clean_architecture/feature/carrier_owner_module/carriers/domain/usecase/get_my_carriers_usecase.dart';
import 'package:clean_architecture/feature/carrier_owner_module/carriers/presentation/bloc/my_carriers_bloc.dart';
import 'package:clean_architecture/feature/carrier_owner_module/carriers/data/datasource/carrier_registration_remote_data_source.dart';
import 'package:clean_architecture/feature/carrier_owner_module/carriers/data/datasource/carrier_registration_remote_data_source_impl.dart';
import 'package:clean_architecture/feature/carrier_owner_module/carriers/data/repository/carrier_registration_repository_impl.dart';
import 'package:clean_architecture/feature/carrier_owner_module/carriers/domain/repository/carrier_registration_repository.dart';
import 'package:clean_architecture/feature/carrier_owner_module/carriers/domain/usecase/create_carrier_usecase.dart';
import 'package:clean_architecture/feature/carrier_owner_module/carriers/presentation/bloc/carrier_registration_cubit.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:clean_architecture/feature/chat/data/datasources/chat_remote_data_source.dart';
import 'package:clean_architecture/feature/chat/data/datasources/chat_remote_data_source_impl.dart';
import 'package:clean_architecture/feature/chat/data/datasources/chat_socket_service.dart';
import 'package:clean_architecture/feature/chat/data/repositories/chat_repository_impl.dart';
import 'package:clean_architecture/feature/chat/domain/repositories/chat_repository.dart';
import 'package:clean_architecture/feature/chat/domain/usecases/get_or_create_room_usecase.dart';
import 'package:clean_architecture/feature/chat/domain/usecases/get_inbox_usecase.dart';
import 'package:clean_architecture/feature/chat/domain/usecases/get_messages_usecase.dart';
import 'package:clean_architecture/feature/chat/domain/usecases/mark_as_read_usecase.dart';
import 'package:clean_architecture/feature/chat/presentation/bloc/inbox/inbox_bloc.dart';
import 'package:clean_architecture/feature/chat/presentation/bloc/chat_room/chat_room_bloc.dart';
import 'package:clean_architecture/feature/notifications/data/datasources/notification_remote_data_source.dart';
import 'package:clean_architecture/feature/notifications/data/datasources/notification_remote_data_source_impl.dart';
import 'package:clean_architecture/feature/notifications/data/repositories/notification_repository_impl.dart';
import 'package:clean_architecture/feature/notifications/domain/repositories/notification_repository.dart';
import 'package:clean_architecture/feature/notifications/domain/usecases/get_notifications_usecase.dart';
import 'package:clean_architecture/feature/notifications/domain/usecases/mark_notification_read_usecase.dart';
import 'package:clean_architecture/feature/notifications/presentation/bloc/notification_bloc.dart';
import 'package:clean_architecture/feature/payment/data/datasource/payment_remote_data_source.dart';
import 'package:clean_architecture/feature/payment/data/datasource/payment_remote_data_source_impl.dart';
import 'package:clean_architecture/feature/payment/data/repository/payment_repository_impl.dart';
import 'package:clean_architecture/feature/payment/domain/repository/payment_repository.dart';
import 'package:clean_architecture/feature/payment/domain/usecase/initiate_payment_usecase.dart';
import 'package:clean_architecture/feature/payment/domain/usecase/get_payment_status_usecase.dart';
import 'package:clean_architecture/feature/payment/domain/usecase/release_payment_usecase.dart';
import 'package:clean_architecture/feature/payment/domain/usecase/dispute_payment_usecase.dart';
import 'package:clean_architecture/feature/payment/domain/usecase/get_wallet_usecase.dart';
import 'package:clean_architecture/feature/payment/domain/usecase/get_wallet_transactions_usecase.dart';
import 'package:clean_architecture/feature/payment/domain/usecase/request_withdrawal_usecase.dart';
import 'package:clean_architecture/feature/payment/presentation/bloc/payment/payment_bloc.dart';
import 'package:clean_architecture/feature/payment/presentation/bloc/wallet/wallet_bloc.dart';
import 'package:clean_architecture/feature/carrier_owner_module/drivers/data/datasource/driver_remote_data_source.dart';
import 'package:clean_architecture/feature/carrier_owner_module/drivers/data/datasource/driver_remote_data_source_impl.dart';
import 'package:clean_architecture/feature/carrier_owner_module/drivers/data/repository/driver_repository_impl.dart';
import 'package:clean_architecture/feature/carrier_owner_module/drivers/domain/repository/driver_repository.dart';
import 'package:clean_architecture/feature/carrier_owner_module/drivers/domain/usecase/create_driver_usecase.dart';
import 'package:clean_architecture/feature/carrier_owner_module/drivers/domain/usecase/get_my_drivers_usecase.dart';
import 'package:clean_architecture/feature/carrier_owner_module/drivers/domain/usecase/get_driver_usecase.dart';
import 'package:clean_architecture/feature/carrier_owner_module/drivers/domain/usecase/update_driver_usecase.dart';
import 'package:clean_architecture/feature/carrier_owner_module/drivers/domain/usecase/delete_driver_usecase.dart';
import 'package:clean_architecture/feature/carrier_owner_module/drivers/domain/usecase/assign_driver_usecase.dart';
import 'package:clean_architecture/feature/carrier_owner_module/drivers/domain/usecase/unassign_driver_usecase.dart';
import 'package:clean_architecture/feature/carrier_owner_module/drivers/presentation/bloc/driver_bloc.dart';

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
    () => TruckRemoteDataSourceImpl(dio: sl()),
  );
  sl.registerFactory<RegionRemoteDataSource>(
    () => RegionRemoteDataSourceImpl(client: sl()),
  );
  sl.registerFactory<FeatureRemoteDataSource>(
    () => FeatureRemoteDataSourceImpl(client: sl()),
  );
  sl.registerFactory<BrandRemoteDataSource>(
    () => BrandRemoteDataSourceImpl(client: sl()),
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
    () => FeaturedCarrierRemoteDataSourceImpl(sl()),
  );
  sl.registerFactory<CompanyRemoteDataSource>(
    () => CompanyRemoteDataSourceImpl(client: sl()),
  );
  sl.registerFactory<MyLoadsRemoteDataSource>(
    () => MyLoadsRemoteDataSourceImpl(apiClient: sl()),
  );
  sl.registerFactory<ShipmentRequestRemoteDataSource>(
    () => ShipmentRequestRemoteDataSourceImpl(apiClient: sl(), dio: sl()),
  );
  sl.registerFactory<FavouriteRemoteDataSource>(
    () => FavouriteRemoteDataSourceImpl(apiClient: sl()),
  );
  sl.registerFactory<ReviewRemoteDataSource>(
    () => ReviewRemoteDataSourceImpl(dio: sl()),
  );
  sl.registerFactory<FreightsRemoteDataSource>(
    () => FreightsRemoteDataSourceImpl(client: sl()),
  );
  sl.registerFactory<BidRemoteDataSource>(
    () => BidRemoteDataSourceImpl(client: sl()),
  );
  sl.registerFactory<MyBidsRemoteDataSource>(
    () => MyBidsRemoteDataSourceImpl(apiClient: sl()),
  );
  sl.registerFactory<MyCarriersRemoteDataSource>(
    () => MyCarriersRemoteDataSourceImpl(client: sl()),
  );
  // ------------------ Repositories ------------------ // //
  sl.registerFactory<SignUpRepository>(() => SignUpRepositoryImpl(sl()));
  sl.registerFactory<LoginRepository>(() => LoginRepositoryImpl(sl(), sl()));
  sl.registerFactory<TruckRepository>(() => TruckRepositoryImpl(sl()));
  sl.registerFactory<RegionRepository>(() => RegionRepositoryImpl(sl()));
  sl.registerFactory<FeatureRepository>(() => FeatureRepositoryImpl(sl()));
  sl.registerFactory<BrandRepository>(() => BrandRepositoryImpl(sl()));
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
  sl.registerFactory<CompanyRepository>(
    () => CompanyRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerFactory<MyLoadsRepository>(() => MyLoadsRepositoryImpl(sl()));
  sl.registerFactory<ShipmentRequestRepository>(
    () => ShipmentRequestRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerFactory<FavouriteRepository>(
    () => FavouriteRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerFactory<ReviewRepository>(
    () => ReviewRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerFactory<FreightsRepository>(
    () => FreightsRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerFactory<BidRepository>(
    () => BidRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerFactory<MyBidsRepository>(
    () => MyBidsRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerFactory<MyCarriersRepository>(
    () => MyCarriersRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerFactory<CarrierRegistrationRemoteDataSource>(
    () => CarrierRegistrationRemoteDataSourceImpl(client: sl()),
  );
  sl.registerFactory<CarrierRegistrationRepository>(
    () => CarrierRegistrationRepositoryImpl(remoteDataSource: sl()),
  );

  // ------------------ Usecases ------------------ //
  sl.registerFactory(() => SignUpUsecase(sl()));
  sl.registerFactory(() => LoginUsecase(sl()));
  sl.registerFactory(() => GetTrucksUseCase(sl()));
  sl.registerFactory(() => GetRegionsUseCase(sl()));
  sl.registerFactory(() => GetFeaturesUseCase(sl()));
  sl.registerFactory(() => GetBrandsUseCase(sl()));
  sl.registerFactory(() => CreateFreightUseCase(sl()));
  sl.registerFactory(() => GetFreightsUseCase(sl()));
  sl.registerFactory(() => GetAllFreightsUseCase(sl()));
  sl.registerFactory(() => GetLocationsUseCase(sl()));
  sl.registerFactory(() => GetCargoTypesUseCase(sl()));
  sl.registerFactory(() => UploadFileUseCase(sl()));
  sl.registerFactory(() => UploadMultipleFilesUseCase(sl()));
  sl.registerFactory(() => GetTruckDetailUseCase(sl()));
  sl.registerFactory(() => GetFreightDetailUseCase(sl()));
  sl.registerFactory(() => GetFeaturedCarriersUseCase(sl()));
  sl.registerFactory(() => GetRecommendedCompaniesUseCase(sl()));
  sl.registerFactory(() => GetTopRatedCompaniesUseCase(sl()));
  sl.registerFactory(() => GetCompanyDetailUseCase(sl()));
  sl.registerFactory(() => GetMyLoadsUseCase(sl()));
  sl.registerFactory(() => CreateShipmentRequestUseCase(sl()));
  sl.registerFactory(() => GetSentRequestsUseCase(sl()));
  sl.registerFactory(() => CancelRequestUseCase(sl()));
  sl.registerFactory(() => CompleteRequestUseCase(sl()));
  sl.registerFactory(() => MakeCarrierFavouriteUseCase(sl()));
  sl.registerFactory(() => DisableFavouriteUseCase(sl()));
  sl.registerFactory(() => GetCompletedShipmentsUseCase(sl()));
  sl.registerFactory(() => SubmitReviewUseCase(sl()));
  sl.registerFactory(
    () => carrier_freights.GetFreightsUseCase(sl<FreightsRepository>()),
  );
  sl.registerFactory(() => CreateBidUseCase(sl<BidRepository>()));
  sl.registerFactory(() => GetBidUseCase(sl<BidRepository>()));
  sl.registerFactory(() => AcceptBidUseCase(sl<BidRepository>()));
  sl.registerFactory(() => RejectBidUseCase(sl<BidRepository>()));
  sl.registerFactory(() => GetMyBidsUseCase(sl<MyBidsRepository>()));
  sl.registerFactory(() => GetMyCarriersUseCase(sl<MyCarriersRepository>()));
  sl.registerFactory(() => CreateCarrierUseCase(sl()));

  // ------------------ Carrier Owner Blocs ------------------ //

  sl.registerFactory(
    () => FreightListingBloc(
      getFreightsUseCase: sl<carrier_freights.GetFreightsUseCase>(),
    ),
  );
  sl.registerFactory(
    () => BidBloc(
      createBidUseCase: sl(),
      getBidUseCase: sl(),
      acceptBidUseCase: sl(),
      rejectBidUseCase: sl(),
    ),
  );
  sl.registerFactory(() => MyBidsCubit(getMyBidsUseCase: sl()));
  sl.registerFactory(() => MyCarriersBloc(getMyCarriersUseCase: sl()));
  sl.registerFactory(
    () => CarrierRegistrationCubit(
      createCarrierUseCase: sl(),
      storageService: sl(),
    ),
  );

  // ------------------ Blocs ------------------ //
  // sl.registerFactory(
  //   () => WalletBloc(
  //     getWalletUseCase: sl(),
  //     getWalletTransactionsUseCase: sl(),
  //     requestWithdrawalUseCase: sl(),
  //   ),
  // );
  sl.registerFactory(() => SignUpBloc(sl()));
  sl.registerFactory(() => LoginBloc(sl()));
  sl.registerLazySingleton<ThemeCubit>(() => ThemeCubit());
  sl.registerFactory(() => TruckBloc(sl()));
  sl.registerFactory(() => RegionBloc(sl()));
  sl.registerFactory(() => FeatureBloc(sl()));
  sl.registerFactory(() => BrandBloc(sl()));
  sl.registerFactory(
    () => FreightBloc(
      createFreightUseCase: sl(),
      getFreightsUseCase: sl(),
      getFreightDetailUseCase: sl(),
    ),
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

  sl.registerFactory(
    () => CompanyBloc(
      getRecommendedCompaniesUseCase: sl(),
      getTopRatedCompaniesUseCase: sl(),
      getCompanyDetailUseCase: sl(),
    ),
  );

  sl.registerFactory(() => MyLoadsBloc(sl()));

  sl.registerFactory(
    () => FavouriteBloc(
      makeCarrierFavouriteUseCase: sl(),
      disableFavouriteUseCase: sl(),
    ),
  );

  sl.registerFactory(
    () => ShipmentRequestBloc(
      createShipmentRequestUseCase: sl(),
      cancelRequestUseCase: sl(),
      completeRequestUseCase: sl(),
    ),
  );

  sl.registerFactory(() => SentRequestsBloc(getSentRequestsUseCase: sl()));
  sl.registerFactory(
    () => CompletedShipmentsBloc(getCompletedShipmentsUseCase: sl()),
  );
  sl.registerFactory(() => ReviewBloc(submitReviewUseCase: sl()));

  // ------------------ Chat Feature ------------------ //
  sl.registerLazySingleton<ChatSocketService>(() => ChatSocketService());
  sl.registerFactory<ChatRemoteDataSource>(
    () => ChatRemoteDataSourceImpl(apiClient: sl()),
  );
  sl.registerFactory<ChatRepository>(() => ChatRepositoryImpl(sl()));
  sl.registerFactory(() => GetOrCreateRoomUseCase(sl()));
  sl.registerFactory(() => GetInboxUseCase(sl()));
  sl.registerFactory(() => GetMessagesUseCase(sl()));
  sl.registerFactory(() => MarkAsReadUseCase(sl()));
  sl.registerFactory(
    () => InboxBloc(getInboxUseCase: sl(), socketService: sl()),
  );
  sl.registerFactory(
    () => ChatRoomBloc(
      getMessagesUseCase: sl(),
      markAsReadUseCase: sl(),
      socketService: sl(),
      storageService: sl(),
    ),
  );

  // ------------------ Notifications Feature ------------------ //
  sl.registerFactory<NotificationRemoteDataSource>(
    () => NotificationRemoteDataSourceImpl(apiClient: sl()),
  );
  sl.registerFactory<NotificationRepository>(
    () => NotificationRepositoryImpl(sl()),
  );
  sl.registerFactory(() => GetNotificationsUseCase(sl()));
  sl.registerFactory(() => MarkNotificationReadUseCase(sl()));
  sl.registerFactory(
    () => NotificationBloc(
      getNotificationsUseCase: sl(),
      markNotificationReadUseCase: sl(),
      chatSocketService: sl(),
    ),
  );

  // ------------------ Payment Feature ------------------ //
  sl.registerFactory<PaymentRemoteDataSource>(
    () => PaymentRemoteDataSourceImpl(dio: sl()),
  );
  sl.registerFactory<PaymentRepository>(
    () => PaymentRepositoryImpl(sl<PaymentRemoteDataSource>()),
  );
  sl.registerFactory(() => InitiatePaymentUseCase(sl()));
  sl.registerFactory(() => GetPaymentStatusUseCase(sl()));
  sl.registerFactory(() => ReleasePaymentUseCase(sl()));
  sl.registerFactory(() => DisputePaymentUseCase(sl()));
  sl.registerFactory(() => GetWalletUseCase(sl()));
  sl.registerFactory(() => GetWalletTransactionsUseCase(sl()));
  sl.registerFactory(() => RequestWithdrawalUseCase(sl()));
  sl.registerFactory(
    () => PaymentBloc(
      initiatePaymentUseCase: sl(),
      getPaymentStatusUseCase: sl(),
      releasePaymentUseCase: sl(),
      disputePaymentUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => WalletBloc(
      getWalletUseCase: sl(),
      getWalletTransactionsUseCase: sl(),
      requestWithdrawalUseCase: sl(),
    ),
  );

  // ------------------ Driver Management Feature ------------------ //
  sl.registerFactory<DriverRemoteDataSource>(
    () => DriverRemoteDataSourceImpl(apiClient: sl(), dio: sl()),
  );
  sl.registerFactory<DriverRepository>(
    () => DriverRepositoryImpl(dataSource: sl()),
  );
  sl.registerFactory(() => GetMyDriversUseCase(sl()));
  sl.registerFactory(() => GetDriverUseCase(sl()));
  sl.registerFactory(() => CreateDriverUseCase(sl()));
  sl.registerFactory(() => UpdateDriverUseCase(sl()));
  sl.registerFactory(() => DeleteDriverUseCase(sl()));
  sl.registerFactory(() => AssignDriverUseCase(sl()));
  sl.registerFactory(() => UnassignDriverUseCase(sl()));
  sl.registerFactory(
    () => DriverBloc(
      getMyDriversUseCase: sl(),
      getDriverUseCase: sl(),
      createDriverUseCase: sl(),
      updateDriverUseCase: sl(),
      deleteDriverUseCase: sl(),
      assignDriverUseCase: sl(),
      unassignDriverUseCase: sl(),
    ),
  );
}
