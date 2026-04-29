import 'package:json_annotation/json_annotation.dart';
part 'bid_model.g.dart';

@JsonSerializable()
class CreateBidResponseModel {
  final int? statusCode;
  final String? message;
  final BidData? data;

  CreateBidResponseModel({this.statusCode, this.message, this.data});

  factory CreateBidResponseModel.fromJson(Map<String, dynamic> json) =>
      _$CreateBidResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$CreateBidResponseModelToJson(this);
}

@JsonSerializable()
class BidData {
  final BidModel? bid;

  BidData({this.bid});

  factory BidData.fromJson(Map<String, dynamic> json) =>
      _$BidDataFromJson(json);

  Map<String, dynamic> toJson() => _$BidDataToJson(this);
}

@JsonSerializable()
class BidModel {
  @JsonKey(name: '_id')
  final String? id;
  final String? freightOwnerId;
  final String? carrierOwnerId;
  final String? carrierId;
  final String? freightId;
  final double? bidAmount;
  final String? message;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  BidModel({
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

  factory BidModel.fromJson(Map<String, dynamic> json) =>
      _$BidModelFromJson(json);

  Map<String, dynamic> toJson() => _$BidModelToJson(this);
}
