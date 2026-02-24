import 'package:clean_architecture/cofig/env/environment.dart';
import 'package:clean_architecture/cofig/env/env_config.dart';
import 'package:clean_architecture/cofig/routes_manager.dart';
import 'package:clean_architecture/core/theme/app_theme.dart';
import 'package:clean_architecture/core/theme/theme_cubit.dart';
import 'package:clean_architecture/core/theme/theme_state.dart';
import 'package:clean_architecture/core/di.dart';
import 'package:clean_architecture/feature/common/role_selection.dart';
import 'package:clean_architecture/feature/freight/presentation/bloc/cargoType/cargo_type_bloc.dart';
import 'package:clean_architecture/feature/freight/presentation/bloc/cargoType/cargo_type_event.dart';
import 'package:clean_architecture/feature/freight/presentation/bloc/freight/freight_bloc.dart';
import 'package:clean_architecture/feature/freight/presentation/bloc/location/location_bloc.dart';
import 'package:clean_architecture/feature/freight/presentation/bloc/location/location_event.dart';
import 'package:clean_architecture/feature/freight/presentation/bloc/upload/upload_bloc.dart';
import 'package:clean_architecture/feature/truck_listing/presentation/bloc/truck_bloc.dart';
import 'package:clean_architecture/feature/signup/presentation/bloc/login/login_bloc.dart';
import 'package:clean_architecture/feature/signup/presentation/bloc/sign_up/sign_up_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  EnvConfig.init(Environment.dev);
  //Environment & Supabase initialization
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
        BlocProvider(create: (_) => sl<FreightBloc>()),
        BlocProvider(
          create: (_) => sl<LocationBloc>()..add(const FetchRegionsEvent()),
        ),
        BlocProvider(
          create: (_) => sl<CargoTypeBloc>()..add(const FetchCargoTypesEvent()),
        ),
        BlocProvider(create: (_) => sl<UploadBloc>()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'Smart Truck App',
            debugShowCheckedModeBanner: false,
            onGenerateRoute: RouteGenerator.getRoute,
            theme: TAppTheme.lightTheme,
            darkTheme: TAppTheme.darkTheme,
            themeMode: ThemeMode.system,
            home: RoleSelection(),
          );
        },
      ),
    );
  }
}
