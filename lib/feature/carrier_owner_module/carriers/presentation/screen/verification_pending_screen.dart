import 'package:clean_architecture/cofig/routes_manager.dart';
import 'package:clean_architecture/cofig/size_manager.dart';
import 'package:clean_architecture/core/colors/app_colors.dart';
import 'package:clean_architecture/feature/carrier_owner_module/carriers/domain/entity/my_carrier_entity.dart';
import 'package:clean_architecture/feature/freight_oner_module/common/freight_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';

class VerificationPendingScreen extends StatelessWidget {
  final MyCarrierEntity carrier;

  const VerificationPendingScreen({super.key, required this.carrier});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Verification Pending'),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: SizeManager.screenHorizontalPadding,
              vertical: SizeManager.screenVerticalPadding,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Pending icon
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.amber.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.hourglass_top_rounded,
                    size: 56,
                    color: Colors.amber,
                  ),
                ),
                const SizedBox(height: SizeManager.s24),

                // Title
                Text(
                  'Pending Verification',
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: SizeManager.s12),

                // Subtitle
                Text(
                  'Your carrier has been registered successfully. Our admin team will review your documents and verify your carrier shortly.',
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.grey,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: SizeManager.s32),

                // Carrier info card
                Card(
                  elevation: SizeManager.cardElevation,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(SizeManager.cardRadius),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(SizeManager.s16),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(
                              SizeManager.r10,
                            ),
                          ),
                          child: const Icon(
                            Icons.local_shipping_rounded,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: SizeManager.s16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                carrier.displayName,
                                style: textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.black,
                                ),
                              ),
                              if (carrier.plateNumber != null) ...[
                                const SizedBox(height: SizeManager.s4),
                                Text(
                                  carrier.plateNumber!,
                                  style: textTheme.bodySmall?.copyWith(
                                    color: AppColors.grey,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: SizeManager.s8,
                            vertical: SizeManager.s4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.amber.shade100,
                            borderRadius: BorderRadius.circular(
                              SizeManager.r16,
                            ),
                          ),
                          child: Text(
                            'PENDING',
                            style: textTheme.labelSmall?.copyWith(
                              color: Colors.amber.shade800,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: SizeManager.s40),

                // Go to My Carriers button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FreightBottomNavigationBar(),
                        ),
                        (_) => false,
                      );
                      // Navigator.pushNamedAndRemoveUntil(
                      //   context,
                      //   Routes.freightListingScreen,
                      //   (route) => false,
                      // );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(
                        vertical: SizeManager.s16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(SizeManager.r12),
                      ),
                    ),
                    child: const Text(
                      'Go to My Carriers',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
