import 'package:clean_architecture/feature/carrier/presentation/carrier_home_page.dart';
import 'package:clean_architecture/feature/freight/presentation/freight_home_page.dart';
import 'package:clean_architecture/feature/truck_listing/presentation/screens/truck_listing_screen.dart';
import 'package:clean_architecture/feature/signup/presentation/screens/signup/co_signup_screen.dart';
import 'package:clean_architecture/feature/signup/presentation/screens/signup/fo_signup_screen.dart';
import 'package:clean_architecture/feature/signup/presentation/screens/signup/login_screen.dart';
import 'package:flutter/material.dart';

class Routes {
  static const String initialRoute = "/roleSelection";
  static const String foSignupRoute = "/foSignup";
  static const String coSignupRoute = "/coSignup";
  static const String loginScreenRoute = "/login";
  static const String foHomePageRoute = "/foHomePage";
  static const String coHomePageRoute = "/coHomePage";
  static const String truckListingRoute = "/truckListing";
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case Routes.foSignupRoute:
        return MaterialPageRoute(
          builder: (_) => const FoSignupScreen(role: "user"),
        );

      case Routes.loginScreenRoute:
        return MaterialPageRoute(builder: (_) =>  LoginScreen());

      case Routes.coSignupRoute:
        return MaterialPageRoute(
          builder: (_) => const CoSignupScreen(role: "carrier_owner"),
        );

      case Routes.foHomePageRoute:
        return MaterialPageRoute(
          builder: (_) => const FreightHomePage(),
        );

      case Routes.coHomePageRoute:
        return MaterialPageRoute(
          builder: (_) => const CarrierHomePage(),
        );

      case Routes.truckListingRoute:
        return MaterialPageRoute(
          builder: (_) => const TruckListingScreen(),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const FoSignupScreen(role: "user"),
        ); // Change later
    }
  }
}
