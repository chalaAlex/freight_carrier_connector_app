import 'package:clean_architecture/feature/carrier_owner_module/carriers/domain/entity/my_carrier_entity.dart';
import 'package:clean_architecture/feature/carrier_owner_module/carriers/presentation/bloc/carrier_registration_state.dart';
import 'package:clean_architecture/feature/carrier_owner_module/carriers/presentation/screen/register_carrier_step1_screen.dart';
import 'package:clean_architecture/feature/carrier_owner_module/carriers/presentation/screen/register_carrier_step2_screen.dart';
import 'package:clean_architecture/feature/carrier_owner_module/carriers/presentation/screen/verification_pending_screen.dart';
import 'package:clean_architecture/feature/freight_oner_module/carrier/presentation/carrier_home_page.dart';
import 'package:clean_architecture/feature/freight_oner_module/common/carrier_bottom_navigation_bar.dart';
import 'package:clean_architecture/feature/freight_oner_module/freight/presentation/screen/carrier_user_detail.dart';
import 'package:clean_architecture/feature/freight_oner_module/freight/presentation/screen/carrier_user_review_all.dart';
import 'package:clean_architecture/feature/freight_oner_module/freight/presentation/screen/freight_home_page.dart';
import 'package:clean_architecture/feature/freight_oner_module/freight/presentation/screen/post_freight_page.dart';
import 'package:clean_architecture/feature/freight_oner_module/freight/presentation/screen/rate_driver_screen.dart';
import 'package:clean_architecture/feature/freight_oner_module/freight/presentation/screen/truck_detail_screen.dart';
import 'package:clean_architecture/feature/freight_oner_module/rating_and_review/domain/entity/review_entity.dart';
import 'package:clean_architecture/feature/freight_oner_module/rating_and_review/presentation/screen/completed_shipments_screen.dart';
import 'package:clean_architecture/feature/freight_oner_module/rating_and_review/presentation/screen/submit_review_screen.dart';
import 'package:clean_architecture/feature/freight_oner_module/shipment_request/domain/entity/shipment_request_entity.dart';
import 'package:clean_architecture/feature/freight_oner_module/shipment_request/presentation/screen/shipment_request_home_page.dart';
import 'package:clean_architecture/feature/freight_oner_module/signup/presentation/screens/signup/co_signup_screen.dart';
import 'package:clean_architecture/feature/freight_oner_module/signup/presentation/screens/signup/fo_signup_screen.dart';
import 'package:clean_architecture/feature/carrier_owner_module/freight_home_page/presentation/screen/freight_listing.dart';
import 'package:clean_architecture/feature/freight_oner_module/signup/presentation/screens/signup/login_screen.dart';
import 'package:clean_architecture/feature/chat/presentation/screens/inbox_screen.dart';
import 'package:clean_architecture/core/di.dart';
import 'package:clean_architecture/feature/chat/presentation/bloc/inbox/inbox_bloc.dart';
import 'package:clean_architecture/feature/notifications/presentation/screens/notification_screen.dart';
import 'package:clean_architecture/feature/notifications/presentation/bloc/notification_bloc.dart';
import 'package:clean_architecture/feature/payment/presentation/screen/payment_initiate_screen.dart';
import 'package:clean_architecture/feature/payment/presentation/screen/payment_status_screen.dart';
import 'package:clean_architecture/feature/payment/presentation/screen/wallet_screen.dart';
import 'package:clean_architecture/feature/payment/presentation/screen/wallet_transactions_screen.dart';
import 'package:clean_architecture/feature/carrier_owner_module/drivers/domain/entity/driver_entity.dart';
import 'package:clean_architecture/feature/carrier_owner_module/drivers/presentation/screen/driver_list_screen.dart';
import 'package:clean_architecture/feature/carrier_owner_module/drivers/presentation/screen/create_driver_screen.dart';
import 'package:clean_architecture/feature/carrier_owner_module/drivers/presentation/screen/driver_detail_screen.dart';
import 'package:clean_architecture/feature/carrier_owner_module/drivers/presentation/screen/edit_driver_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  static const String completedShipments = "/completedShipments";
  static const String submitReview = "/submitReview";
  static const String shipmentRequestHome = "/shipmentRequestHome";
  static const String createShipmentRequest = "/createShipmentRequest";
  static const String inboxRoute = "/inbox";
  static const String chatRoomRoute = "/chatRoom";
  static const String notificationRoute = "/notifications";
  static const String registerCarrierStep1 = "/registerCarrierStep1";
  static const String registerCarrierStep2 = "/registerCarrierStep2";
  static const String carrierVerificationPending =
      "/carrierVerificationPending";
  static const String freightListingScreen = "/freightListingScreen";
  static const String paymentInitiate = "/paymentInitiate";
  static const String paymentStatus = "/paymentStatus";
  static const String walletScreen = "/wallet";
  static const String walletTransactions = "/walletTransactions";
  static const String driverListScreen = "/driverList";
  static const String createDriverScreen = "/createDriver";
  static const String driverDetailScreen = "/driverDetail";
  static const String editDriverScreen = "/editDriver";
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case Routes.foSignupRoute:
        return MaterialPageRoute(
          builder: (_) => const FoSignupScreen(role: "freight_owner"),
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

      case Routes.freightListingScreen:
        return MaterialPageRoute(builder: (_) => const FreightListingScreen());

      case Routes.carrierUserDetail:
        return MaterialPageRoute(builder: (_) => const CarrierUserDetail());

      case Routes.viewAllReiviews:
        return MaterialPageRoute(builder: (_) => const CarrierUserReviewAll());

      case Routes.reviewDriver:
        return MaterialPageRoute(builder: (_) => const RateDriverScreen());

      case Routes.completedShipments:
        return MaterialPageRoute(
          builder: (_) => const CompletedShipmentsScreen(),
        );

      case Routes.shipmentRequestHome:
        return MaterialPageRoute(
          builder: (_) => const ShipmentRequestHomePage(),
        );

      case Routes.submitReview:
        final request = routeSettings.arguments as SentRequestEntity?;
        if (request == null) {
          return MaterialPageRoute(
            builder: (_) =>
                const Scaffold(body: Center(child: Text('Request required'))),
          );
        }
        final shipment = CompletedShipmentEntity(
          id: request.id,
          carrierId: request.carrier?.id ?? '',
          carrierBrand: request.carrier?.brand,
          carrierModel: request.carrier?.model,
          plateNumber: request.carrier?.plateNumber,
          status: request.status,
          isReviewed: request.isReviewed,
          createdAt: request.createdAt,
        );
        return MaterialPageRoute(
          builder: (_) => SubmitReviewScreen(shipment: shipment),
        );

      case Routes.inboxRoute:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => sl<InboxBloc>(),
            child: const InboxScreen(),
          ),
        );

      case Routes.notificationRoute:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => sl<NotificationBloc>(),
            child: const NotificationScreen(),
          ),
        );

      case Routes.paymentInitiate:
        final args = routeSettings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => PaymentInitiateScreen(
            bookingType: args?['bookingType'] as String? ?? 'REQUEST',
            sourceId: args?['sourceId'] as String? ?? '',
            totalAmount: (args?['totalAmount'] as num?)?.toDouble() ?? 0,
            freightRoute: args?['freightRoute'] as String? ?? '',
          ),
        );

      case Routes.paymentStatus:
        final args = routeSettings.arguments as Map<String, dynamic>?;
        final paymentId = args?['paymentId'] as String? ?? '';
        return MaterialPageRoute(
          builder: (_) => PaymentStatusScreen(paymentId: paymentId),
        );

      case Routes.walletScreen:
        return MaterialPageRoute(builder: (_) => const WalletScreen());

      case Routes.walletTransactions:
        return MaterialPageRoute(
          builder: (_) => const WalletTransactionsScreen(),
        );

      case Routes.registerCarrierStep1:
        return MaterialPageRoute(
          builder: (_) => const RegisterCarrierStep1Screen(),
        );

      case Routes.registerCarrierStep2:
        final formData = routeSettings.arguments as CarrierRegistrationFormData;
        return MaterialPageRoute(
          builder: (_) => RegisterCarrierStep2Screen(formData: formData),
        );

      case Routes.carrierVerificationPending:
        final carrier = routeSettings.arguments as MyCarrierEntity;
        return MaterialPageRoute(
          builder: (_) => VerificationPendingScreen(carrier: carrier),
        );

      case Routes.driverListScreen:
        return MaterialPageRoute(builder: (_) => const DriverListScreen());

      case Routes.createDriverScreen:
        return MaterialPageRoute(builder: (_) => const CreateDriverScreen());

      case Routes.driverDetailScreen:
        final driver = routeSettings.arguments as DriverEntity;
        return MaterialPageRoute(
          builder: (_) => DriverDetailScreen(driver: driver),
        );

      case Routes.editDriverScreen:
        final driver = routeSettings.arguments as DriverEntity;
        return MaterialPageRoute(
          builder: (_) => EditDriverScreen(driver: driver),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const FoSignupScreen(role: "freight_owner"),
        );
    }
  }
}
