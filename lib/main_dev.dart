import 'package:clean_architecture/cofig/env/environment.dart';
import 'package:clean_architecture/cofig/env/env_config.dart';
import 'package:clean_architecture/cofig/routes_manager.dart';
import 'package:clean_architecture/core/theme/app_theme.dart';
import 'package:clean_architecture/core/theme/theme_cubit.dart';
import 'package:clean_architecture/core/theme/theme_state.dart';
import 'package:clean_architecture/core/di.dart';
import 'package:clean_architecture/feature/chat/presentation/bloc/inbox/inbox_bloc.dart';
import 'package:clean_architecture/feature/notifications/presentation/bloc/notification_bloc.dart';
import 'package:clean_architecture/feature/notifications/presentation/bloc/notification_event.dart';
import 'package:clean_architecture/feature/freight_oner_module/common/role_selection.dart';
import 'package:clean_architecture/feature/freight_oner_module/freight/presentation/bloc/cargoType/cargo_type_bloc.dart';
import 'package:clean_architecture/feature/freight_oner_module/freight/presentation/bloc/cargoType/cargo_type_event.dart';
import 'package:clean_architecture/feature/freight_oner_module/freight/presentation/bloc/freight/freight_bloc.dart';
import 'package:clean_architecture/feature/freight_oner_module/freight/presentation/bloc/location/location_bloc.dart';
import 'package:clean_architecture/feature/freight_oner_module/freight/presentation/bloc/location/location_event.dart';
import 'package:clean_architecture/feature/freight_oner_module/freight/presentation/bloc/upload/upload_bloc.dart';
import 'package:clean_architecture/feature/freight_oner_module/freight/presentation/bloc/truck_detail/truck_detail_bloc.dart';
import 'package:clean_architecture/feature/freight_oner_module/truck_listing/presentation/bloc/truck_bloc.dart';
import 'package:clean_architecture/feature/freight_oner_module/truck_listing/presentation/bloc/region_bloc.dart';
import 'package:clean_architecture/feature/freight_oner_module/truck_listing/presentation/bloc/feature_bloc.dart';
import 'package:clean_architecture/feature/freight_oner_module/truck_listing/presentation/bloc/brand_bloc.dart';
import 'package:clean_architecture/feature/freight_oner_module/landing/presentation/bloc/featured_carrier_bloc.dart';
import 'package:clean_architecture/feature/freight_oner_module/landing/presentation/bloc/featured_carrier_event.dart';
import 'package:clean_architecture/feature/freight_oner_module/company/presentation/bloc/company_bloc.dart';
import 'package:clean_architecture/feature/freight_oner_module/company/presentation/bloc/company_event.dart';
import 'package:clean_architecture/feature/freight_oner_module/my_loads/presentation/bloc/my_loads_bloc.dart';
import 'package:clean_architecture/feature/freight_oner_module/my_loads/presentation/bloc/my_loads_event.dart';
import 'package:clean_architecture/feature/freight_oner_module/shipment_request/presentation/bloc/shipment_request_bloc.dart';
import 'package:clean_architecture/feature/freight_oner_module/shipment_request/presentation/bloc/sent_requests_bloc.dart';
import 'package:clean_architecture/feature/freight_oner_module/rating_and_review/presentation/bloc/completed_shipments_bloc.dart';
import 'package:clean_architecture/feature/freight_oner_module/rating_and_review/presentation/bloc/review_bloc.dart';
import 'package:clean_architecture/feature/freight_oner_module/signup/presentation/bloc/login/login_bloc.dart';
import 'package:clean_architecture/feature/freight_oner_module/signup/presentation/bloc/sign_up/sign_up_bloc.dart';
import 'package:clean_architecture/feature/payment/presentation/bloc/payment/payment_bloc.dart';
import 'package:clean_architecture/feature/payment/presentation/bloc/wallet/wallet_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  EnvConfig.init(Environment.dev);
  await init(Environment.dev);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<SignUpBloc>()),
        BlocProvider(create: (_) => sl<LoginBloc>()),
        BlocProvider(create: (_) => sl<ThemeCubit>()),
        BlocProvider(create: (_) => sl<TruckBloc>()),
        BlocProvider(create: (_) => sl<RegionBloc>()),
        BlocProvider(create: (_) => sl<FeatureBloc>()),
        BlocProvider(create: (_) => sl<BrandBloc>()),
        BlocProvider(create: (_) => sl<TruckDetailBloc>()),
        BlocProvider(create: (_) => sl<FreightBloc>()),
        BlocProvider(create: (_) => sl<PaymentBloc>()),

        BlocProvider(
          create: (_) => sl<LocationBloc>()..add(const FetchRegionsEvent()),
        ),
        BlocProvider(
          create: (_) => sl<CargoTypeBloc>()..add(const FetchCargoTypesEvent()),
        ),
        BlocProvider(create: (_) => sl<UploadBloc>()),
        BlocProvider(
          create: (_) =>
              sl<FeaturedCarrierBloc>()..add(const LoadFeaturedCarriers()),
        ),
        BlocProvider(
          create: (_) => sl<CompanyBloc>()
            ..add(const LoadRecommendedCompanies())
            ..add(const LoadTopRatedCompanies()),
        ),
        BlocProvider(
          create: (_) => sl<MyLoadsBloc>()..add(const FetchMyLoads('OPEN')),
        ),
        BlocProvider(create: (_) => sl<ShipmentRequestBloc>()),
        BlocProvider(create: (_) => sl<SentRequestsBloc>()),
        BlocProvider(create: (_) => sl<CompletedShipmentsBloc>()),
        BlocProvider(create: (_) => sl<ReviewBloc>()),
        // InboxBloc — global so real-time inbox updates work across navigation
        BlocProvider(create: (_) => sl<InboxBloc>()),
        BlocProvider(create: (_) => sl<WalletBloc>()),
        // NotificationBloc — global so the bell badge updates across all pages
        BlocProvider(
          create: (_) =>
              sl<NotificationBloc>()..add(const NotificationsFetchRequested()),
        ),
        // Note: ChatRoomBloc is NOT global — it is scoped per ChatRoomScreen
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'Smart Truck App',
            debugShowCheckedModeBanner: false,
            onGenerateRoute: RouteGenerator.getRoute,
            theme: TAppTheme.lightTheme,
            darkTheme: TAppTheme.darkTheme,
            themeMode: state.themeMode,
            home: RoleSelection(),
          );
        },
      ),
    );
  }
}
