import 'package:clean_architecture/core/request/create_freight_request.dart';
import 'package:clean_architecture/core/request/shipment_request.dart';
import 'package:clean_architecture/feature/shipment_request/data/model/shipment_request_response_model.dart';
import 'package:clean_architecture/feature/company/data/model/company_response.dart';
import 'package:clean_architecture/feature/freight/data/model/cargo_type_model.dart';
import 'package:clean_architecture/feature/freight/data/model/freight_detail_model.dart';
import 'package:clean_architecture/feature/my_loads/data/model/my_loads_base_response_model.dart';
import 'package:clean_architecture/feature/freight/data/model/location_model.dart';
import 'package:clean_architecture/feature/freight/data/model/truck_detail_model.dart';
import 'package:clean_architecture/feature/landing/data/model/featured_carrier_response.dart';
import 'package:clean_architecture/feature/signup/data/models/login_model.dart';
import 'package:clean_architecture/feature/signup/data/models/sign_up_model.dart';
import 'package:clean_architecture/feature/truck_listing/data/models/brand_response.dart';
import 'package:clean_architecture/feature/truck_listing/data/models/feature_response.dart';
import 'package:clean_architecture/feature/truck_listing/data/models/regions_model.dart';
import 'package:clean_architecture/feature/truck_listing/data/models/truck_model.dart';
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
    @Query("status") String? status,
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

  @POST("/shipmentRequests")
  Future<RequestResponse> createShipmentRequest(
    @Body() CreateShipmentRequest request,
  );
}
