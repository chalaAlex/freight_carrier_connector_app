import 'package:clean_architecture/core/request/create_freight_request.dart';
import 'package:clean_architecture/feature/company/data/model/company_response.dart';
import 'package:clean_architecture/feature/freight/data/model/cargo_type_model.dart';
import 'package:clean_architecture/feature/freight/data/model/freight_response_model.dart';
import 'package:clean_architecture/feature/freight/data/model/location_model.dart';
import 'package:clean_architecture/feature/freight/data/model/truck_detail_model.dart';
import 'package:clean_architecture/feature/landing/data/model/featured_carrier_response.dart';
import 'package:clean_architecture/feature/signup/data/models/login_model.dart';
import 'package:clean_architecture/feature/signup/data/models/sign_up_model.dart';
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

  @GET("/carrier/:id")
  Future<TruckDetailBaseResponse> getTruck();

  @POST("/freights")
  Future<FreightBaseResponse> createFreight(
    @Body() CreateFreightRequest request,
  );

  @GET("/carrier/getFeaturedCarier")
  Future<FeaturedCarrierBaseResponse> getFeaturedCarriers();

  @GET("/companies/getTopRatedCompanies")
  Future<CompanyBaseResponse> getTopRatedCompanies();

  @GET("/companies/getRecommendedCompanies")
  Future<CompanyBaseResponse> getRecommendedCompanies();

  @GET("/companies/:id")
  Future<CompanyBaseResponse> getCompany();
}
