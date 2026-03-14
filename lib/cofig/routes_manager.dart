import 'package:clean_architecture/feature/carrier/presentation/carrier_home_page.dart';
import 'package:clean_architecture/feature/common/carrier_bottom_navigation_bar.dart';
import 'package:clean_architecture/feature/freight/presentation/screen/carrier_user_detail.dart';
import 'package:clean_architecture/feature/freight/presentation/screen/carrier_user_review_all.dart';
import 'package:clean_architecture/feature/freight/presentation/screen/freight_home_page.dart';
import 'package:clean_architecture/feature/freight/presentation/screen/post_freight_page.dart';
import 'package:clean_architecture/feature/freight/presentation/screen/rate_driver_screen.dart';
import 'package:clean_architecture/feature/freight/presentation/screen/truck_detail_screen.dart';
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
  static const String truckDetailRoute = "/truckDetail";
  static const String bottomNavBar = "/bottomNavBar";
  static const String postFreightRoute = "/postFreight";
  static const String carrierUserDetail = "/carrierUserDetail";
  static const String viewAllReiviews = "/viewAllReiviews";
  static const String reviewDriver = "/reviewDriver";
  static const String companyProfile = "/companyProfile";
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

      // case Routes.truckListingRoute:
      //   return MaterialPageRoute(builder: (_) => const TruckListingScreen());

      case Routes.truckDetailRoute:
        final truckId = routeSettings.arguments as String?;
        if (truckId == null) {
          return MaterialPageRoute(
            builder: (_) => const Scaffold(
              body: Center(child: Text('Truck ID is required')),
            ),
          );
        }
        return MaterialPageRoute(
          builder: (_) => TruckDetailScreen(truckId: truckId),
        );

      case Routes.bottomNavBar:
        return MaterialPageRoute(
          builder: (_) => const CarrierBottomNavigationBar(),
        );

      case Routes.postFreightRoute:
        return MaterialPageRoute(builder: (_) => const PostFreightPage());

      case Routes.carrierUserDetail:
        return MaterialPageRoute(builder: (_) => const CarrierUserDetail());

      case Routes.viewAllReiviews:
        return MaterialPageRoute(builder: (_) => const CarrierUserReviewAll());

      case Routes.reviewDriver:
        return MaterialPageRoute(builder: (_) => const RateDriverScreen());

      // case Routes.companyProfile:
      //   return MaterialPageRoute(builder: (_) => const CompanyProfile(company: null,));

      default:
        return MaterialPageRoute(
          builder: (_) => const FoSignupScreen(role: "user"),
        ); // Change later
    }
  }
}
