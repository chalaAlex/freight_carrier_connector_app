import 'package:clean_architecture/core/di.dart';
import 'package:clean_architecture/feature/carrier/presentation/carrier_home_page.dart';
import 'package:clean_architecture/feature/common/carrier_bottom_navigation_bar.dart';
import 'package:clean_architecture/feature/freight/presentation/bloc/cargo_type_bloc.dart';
import 'package:clean_architecture/feature/freight/presentation/bloc/cargo_type_event.dart';
import 'package:clean_architecture/feature/freight/presentation/bloc/freight_bloc.dart';
import 'package:clean_architecture/feature/freight/presentation/bloc/location_bloc.dart';
import 'package:clean_architecture/feature/freight/presentation/bloc/location_event.dart';
import 'package:clean_architecture/feature/freight/presentation/screen/freight_home_page.dart';
import 'package:clean_architecture/feature/freight/presentation/screen/post_freight_page.dart';
import 'package:clean_architecture/feature/truck_listing/presentation/screens/truck_listing_screen.dart';
import 'package:clean_architecture/feature/signup/presentation/screens/signup/co_signup_screen.dart';
import 'package:clean_architecture/feature/signup/presentation/screens/signup/fo_signup_screen.dart';
import 'package:clean_architecture/feature/signup/presentation/screens/signup/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Routes {
  static const String initialRoute = "/roleSelection";
  static const String foSignupRoute = "/foSignup";
  static const String coSignupRoute = "/coSignup";
  static const String loginScreenRoute = "/login";
  static const String foHomePageRoute = "/foHomePage";
  static const String coHomePageRoute = "/coHomePage";
  static const String truckListingRoute = "/truckListing";
  static const String bottomNavBar = "/bottomNavBar";
  static const String postFreightRoute = "/postFreight";
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case Routes.foSignupRoute:
        return MaterialPageRoute(
          builder: (_) => const FoSignupScreen(role: "user"),
        );

      case Routes.loginScreenRoute:
        return MaterialPageRoute(builder: (_) => LoginScreen());

      case Routes.coSignupRoute:
        return MaterialPageRoute(
          builder: (_) => const CoSignupScreen(role: "carrier_owner"),
        );

      case Routes.foHomePageRoute:
        return MaterialPageRoute(builder: (_) => const FreightHomePage());

      case Routes.coHomePageRoute:
        return MaterialPageRoute(builder: (_) => const CarrierHomePage());

      case Routes.truckListingRoute:
        return MaterialPageRoute(builder: (_) => const TruckListingScreen());

      case Routes.bottomNavBar:
        return MaterialPageRoute(
          builder: (_) => const CarrierBottomNavigationBar(),
        );

      case Routes.postFreightRoute:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => sl<FreightBloc>()),
              BlocProvider(
                create: (_) =>
                    sl<LocationBloc>()..add(const FetchRegionsEvent()),
              ),
              BlocProvider(
                create: (_) =>
                    sl<CargoTypeBloc>()..add(const FetchCargoTypesEvent()),
              ),
            ],
            child: const PostFreightPage(),
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const FoSignupScreen(role: "user"),
        ); // Change later
    }
  }
}
