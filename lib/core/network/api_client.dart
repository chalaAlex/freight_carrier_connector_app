import 'package:clean_architecture/core/request/create_freight_request.dart';
import 'package:clean_architecture/feature/carrier_owner_module/carriers/data/model/create_carrier_request.dart';
import 'package:clean_architecture/core/request/shipment_request.dart';
import 'package:clean_architecture/feature/carrier_owner_module/bids/data/model/bid_model.dart';
import 'package:clean_architecture/feature/carrier_owner_module/bids/data/model/get_bid_response.dart';
import 'package:clean_architecture/feature/carrier_owner_module/carriers/data/model/my_carriers_model.dart';
import 'package:clean_architecture/feature/freight_oner_module/shipment_request/data/model/shipment_request_response_model.dart';
import 'package:clean_architecture/feature/freight_oner_module/company/data/model/company_response.dart';
import 'package:clean_architecture/feature/freight_oner_module/freight/data/model/cargo_type_model.dart';
import 'package:clean_architecture/feature/freight_oner_module/freight/data/model/freight_detail_model.dart';
import 'package:clean_architecture/feature/freight_oner_module/my_loads/data/model/my_loads_base_response_model.dart';
import 'package:clean_architecture/feature/freight_oner_module/freight/data/model/location_model.dart';
import 'package:clean_architecture/feature/freight_oner_module/freight/data/model/truck_detail_model.dart';
import 'package:clean_architecture/feature/freight_oner_module/landing/data/model/featured_carrier_response.dart';
import 'package:clean_architecture/feature/freight_oner_module/signup/data/models/login_model.dart';
import 'package:clean_architecture/feature/freight_oner_module/signup/data/models/sign_up_model.dart';
import 'package:clean_architecture/feature/freight_oner_module/truck_listing/data/models/brand_response.dart';
import 'package:clean_architecture/feature/freight_oner_module/truck_listing/data/models/feature_response.dart';
import 'package:clean_architecture/feature/freight_oner_module/truck_listing/data/models/regions_model.dart';
import 'package:clean_architecture/feature/freight_oner_module/truck_listing/data/models/truck_model.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
part 'api_client.g.dart';

@RestApi()
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  @POST("/users/signup")
  Future<SignUpModel> signUp(
    @Field("firstName") String firstName,
    @Field("lastName") String lastName,
    @Field("email") String email,
    @Field("phone") String phone,
    @Field("password") String password,
    @Field("passwordConfirm") String passwordConfirm,
    @Field("role") String role,
  );

  @POST("/users/login")
  Future<LoginBaseResponse> login(
    @Field("email") String email,
    @Field("password") String password,
  );

  @GET("/carrier")
  Future<TruckBaseResponse> getTrucks({
    @Query("page") int? page,
    @Query("limit") int? limit,
    @Query("search") String? search,
    @Query("company") String? company,
    @Query("isAvailable") bool? isAvailable,
    @Query("carrierType") String? carrierType,
    @Query("startLocation") String? startLocation,
    @Query("destinationLocation") String? destinationLocation,
  });

  @GET("/carrier")
  Future<TruckBaseResponse> getFreight({
    @Query("page") int? page,
    @Query("limit") int? limit,
    @Query("search") String? search,
    @Query("status") String? status,
  });

  @GET("/carrier/{id}")
  Future<TruckDetailBaseResponse> getTruckDetail(@Path("id") String id);

  @GET("/location")
  Future<LocationBaseResponse> getLocation({
    @Query("page") int? page,
    @Query("limit") int? limit,
    @Query("search") String? search,
    @Query("region") String? region,
  });

  @GET("/cargoType")
  Future<CargoTypeBaseResponse> getCargoTypes();

  @GET("/freights/my-freights")
  Future<MyLoadsBaseResponseModel> getMyFreight({
    @Query("page") int? page,
    @Query("limit") int? limit,
    @Query("status") String? status,
  });

  @GET("/freights")
  Future<MyLoadsBaseResponseModel> getFreights({
    @Query("page") int? page,
    @Query("limit") int? limit,
    @Query("limit") String? status,
    @Query("cargo.type") List<String>? cargoTypes,
    @Query("truckRequirement.type") List<String>? truckTypes,
    @Query("pricing.type") List<String>? pricingTypes,
    @Query("status") List<String>? statuses,
    @Query("route.pickup.region") String? pickupRegion,
    @Query("route.pickup.city") String? pickupCity,
    @Query("route.dropoff.region") String? dropoffRegion,
    @Query("route.dropoff.city") String? dropoffCity,
  });

  @GET("/carrier/:id")
  Future<TruckDetailBaseResponse> getTruck();

  @POST("/freights")
  Future<MyLoadsBaseResponseModel> createFreight(
    @Body() CreateFreightRequest request,
  );

  @PATCH("/carrier/{id}/makeFavourite")
  Future<TruckDetailBaseResponse> makeCarrierFavourite(@Path("id") String id);

  @PATCH("/carrier/{id}/disableFavourite")
  Future<TruckDetailBaseResponse> disableFavourite(@Path("id") String id);

  @GET("/freights/{id}")
  Future<FreightDetailBaseResponse> getFreightDetail(@Path("id") String id);

  @GET("/companies")
  Future<CompanyBaseResponse> getComoany();

  @GET("/carrier/getFeaturedCarier")
  Future<FeaturedCarrierBaseResponse> getFeaturedCarriers();

  @GET("/companies/getTopRatedCompanies")
  Future<CompanyBaseResponse> getTopRatedCompanies();

  @GET("/companies/getRecommendedCompanies")
  Future<CompanyBaseResponse> getRecommendedCompanies();

  @GET("/companies/{id}")
  Future<CompanyDetailResponse> getCompanyDetail(@Path("id") String id);

  @GET("/regions")
  Future<RegionsBaseResponse> getAllRegions();

  @GET("/features")
  Future<FeatureBaseResponse> getAllFeatures();

  @GET("/brands")
  Future<BrandBaseResponse> getAllBrands();

  @GET("/carrier/my-carriers")
  Future<MyCarriersResponseModel> getMyCarriers();

  @POST("/freights/{freightId}/bids")
  Future<CreateBidResponseModel> createBid(
    @Path("freightId") String freightId,
    @Field("carrierId") String carrierId,
    @Field("bidAmount") double bidAmount,
    @Field("message") String message,
  );

  @GET("/bid/my-bids")
  Future<dynamic> getMyBids();

  @GET("/bid/{id}")
  Future<GetBidResponse> getBid(@Path("id") String id);

  @PATCH("/bid/{id}/accept")
  Future<dynamic> acceptBid(@Path("id") String id);

  @PATCH("/bid/{id}/reject")
  Future<dynamic> rejectBid(@Path("id") String id);

  @POST("/shipmentRequests")
  Future<RequestResponse> createShipmentRequest(
    @Body() CreateShipmentRequest request,
  );

  // -------------------- Chat Endpoints --------------------

  @POST("/chat/rooms")
  Future<dynamic> getOrCreateRoom(@Field("otherUserId") String otherUserId);

  @GET("/chat/rooms")
  Future<dynamic> getInbox();

  @GET("/chat/rooms/{roomId}/messages")
  Future<dynamic> getChatMessages(
    @Path("roomId") String roomId,
    @Query("page") int page,
    @Query("limit") int limit,
  );

  @PATCH("/chat/rooms/{roomId}/messages/read")
  Future<dynamic> markChatAsRead(@Path("roomId") String roomId);

  // -------------------- Notification Endpoints --------------------

  @GET("/notifications")
  Future<dynamic> getNotifications();

  @PATCH("/notifications/{id}/read")
  Future<dynamic> markNotificationAsRead(@Path("id") String id);

  @POST("/carrier")
  Future<dynamic> createCarrier(@Body() CreateCarrierRequest request);

  // -------------------- Driver Endpoints --------------------

  @GET("/driver/my-drivers")
  Future<dynamic> getMyDrivers();

  @GET("/driver/{id}")
  Future<dynamic> getDriver(@Path("id") String id);

  @POST("/driver")
  Future<dynamic> createDriver(@Body() Map<String, dynamic> body);

  @PATCH("/driver/{id}")
  Future<dynamic> updateDriver(
    @Path("id") String id,
    @Body() Map<String, dynamic> body,
  );

  @DELETE("/driver/{id}")
  Future<void> deleteDriver(@Path("id") String id);
}
