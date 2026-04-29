import 'package:json_annotation/json_annotation.dart';

part 'shipment_request.g.dart';

@JsonSerializable()
class CreateShipmentRequest {
  final String carrierId;
  final List<String> freightIds;
  final int? proposedPrice;

  const CreateShipmentRequest({
    required this.carrierId,
    required this.freightIds,
    this.proposedPrice,
  });

  factory CreateShipmentRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateShipmentRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateShipmentRequestToJson(this);
}
