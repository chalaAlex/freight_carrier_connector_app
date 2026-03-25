import 'package:flutter/material.dart';
import 'package:clean_architecture/cofig/size_manager.dart';
import 'package:clean_architecture/feature/freight/domain/entity/truck_detail_entity.dart';
import 'package:clean_architecture/feature/freight/presentation/widgets/truck_detail/truck_detail_header.dart';
import 'package:clean_architecture/feature/freight/presentation/widgets/truck_detail/truck_detail_price_section.dart';
import 'package:clean_architecture/feature/freight/presentation/widgets/truck_detail/truck_detail_owner_section.dart';
import 'package:clean_architecture/feature/freight/presentation/widgets/truck_detail/truck_detail_specifications.dart';
import 'package:clean_architecture/feature/freight/presentation/widgets/truck_detail/truck_detail_features.dart';
import 'package:clean_architecture/feature/freight/presentation/widgets/truck_detail/truck_detail_about.dart';
import 'package:clean_architecture/feature/freight/presentation/widgets/truck_detail/truck_detail_chat_button.dart';

class TruckDetailContent extends StatelessWidget {
  final TruckEntity truck;

  const TruckDetailContent({super.key, required this.truck});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomScrollView(
          slivers: [
            TruckDetailHeader(truck: truck),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TruckDetailPriceSection(truck: truck),
                  const SizedBox(height: SizeManager.s16),
                  // const SizedBox(height: SizeManager.s24),
                  TruckDetailSpecifications(truck: truck),
                  const SizedBox(height: SizeManager.s24),
                  TruckDetailFeatures(features: truck.features ?? []),
                  const SizedBox(height: SizeManager.s24),
                  TruckDetailAbout(aboutText: truck.aboutTruck ?? ''),
                  const SizedBox(height: SizeManager.s24),
                  // TruckDetailReviews(owner: truck.truckOwner),
                  TruckDetailOwnerSection(
                    owner: truck.truckOwner,
                    companyId: truck.companyId,
                    companyName: truck.companyName,
                    companyRatingAverage: truck.companyRatingAverage,
                    companyRatingQuantity: truck.companyRatingQuantity,
                    isItCompaniesCarrier: truck.isItCompaniesCarrier ?? false,
                  ),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ],
        ),
        TruckDetailChatButton(truck: truck),
      ],
    );
  }
}
