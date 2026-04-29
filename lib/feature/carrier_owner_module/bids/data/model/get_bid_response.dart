import 'package:json_annotation/json_annotation.dart';
part 'get_bid_response.g.dart';

@JsonSerializable()
class GetBidResponse {
  final int? statusCode;
  final String? message;
  final GetBidData? data;

  GetBidResponse({this.statusCode, this.message, this.data});

  factory GetBidResponse.fromJson(Map<String, dynamic> json) =>
      _$GetBidResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetBidResponseToJson(this);
}

@JsonSerializable()
class GetBidData {
  final GetBidModel? bidding;

  GetBidData({this.bidding});

  factory GetBidData.fromJson(Map<String, dynamic> json) =>
      _$GetBidDataFromJson(json);

  Map<String, dynamic> toJson() => _$GetBidDataToJson(this);
}

@JsonSerializable()
class GetBidModel {
  @JsonKey(name: '_id')
  final String? id;
  final GetBidFreightOwner? freightOwnerId;
  final String? carrierOwnerId;
  final String? carrierId;
  final String? freightId;
  final double? bidAmount;
  final String? message;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  GetBidModel({
    this.id,
    this.freightOwnerId,
    this.carrierOwnerId,
    this.carrierId,
    this.freightId,
    this.bidAmount,
    this.message,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory GetBidModel.fromJson(Map<String, dynamic> json) =>
      _$GetBidModelFromJson(json);

  Map<String, dynamic> toJson() => _$GetBidModelToJson(this);
}

@JsonSerializable()
class GetBidFreightOwner {
  @JsonKey(name: '_id')
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? profileImage;
  final double? ratingAverage;
  final int? ratingQuantity;

  GetBidFreightOwner({
    this.id,
    this.firstName,
    this.lastName,
    this.profileImage,
    this.ratingAverage,
    this.ratingQuantity,
  });

  factory GetBidFreightOwner.fromJson(Map<String, dynamic> json) =>
      _$GetBidFreightOwnerFromJson(json);

  Map<String, dynamic> toJson() => _$GetBidFreightOwnerToJson(this);
}
