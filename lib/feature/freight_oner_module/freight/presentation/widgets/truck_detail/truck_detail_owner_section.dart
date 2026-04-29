import 'package:clean_architecture/cofig/routes_manager.dart';
import 'package:clean_architecture/feature/freight_oner_module/company/presentation/screen/company_profile.dart';
import 'package:flutter/material.dart';
import 'package:clean_architecture/cofig/size_manager.dart';
import 'package:clean_architecture/core/colors/app_colors.dart';
import 'package:clean_architecture/core/colors/color_scheme.dart';
import 'package:clean_architecture/feature/freight_oner_module/freight/domain/entity/truck_detail_entity.dart';

class TruckDetailOwnerSection extends StatelessWidget {
  final TruckOwnerEntity? owner;
  final String? companyId;
  final String? companyName;
  final num? companyRatingAverage;
  final num? companyRatingQuantity;
  final bool isItCompaniesCarrier;

  const TruckDetailOwnerSection({
    super.key,
    this.owner,
    this.companyId,
    this.companyName,
    this.companyRatingAverage,
    this.companyRatingQuantity,
    this.isItCompaniesCarrier = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = isDarkMode ? AppColorScheme.dark : AppColorScheme.light;

    if (isItCompaniesCarrier) {
      if (companyId != null) {
        return _CompanyCard(
          companyId: companyId!,
          companyName: companyName,
          ratingAverage: companyRatingAverage,
          ratingQuantity: companyRatingQuantity,
          colorScheme: colorScheme,
        );
      }
      return const SizedBox.shrink();
    }

    if (owner != null) {
      return _OwnerCard(owner: owner!, colorScheme: colorScheme);
    }

    return const SizedBox.shrink();
  }
}

// ── Owner card ────────────────────────────────────────────────────────────

class _OwnerCard extends StatelessWidget {
  final TruckOwnerEntity owner;
  final AppColorScheme colorScheme;

  const _OwnerCard({required this.owner, required this.colorScheme});

  String get _initials {
    final first = owner.firstName ?? '';
    final last = owner.lastName ?? '';
    return '${first.isNotEmpty ? first[0] : ''}${last.isNotEmpty ? last[0] : ''}'
        .toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: SizeManager.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About Carrier Owner',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: colorScheme.textPrimary,
            ),
          ),
          const SizedBox(height: SizeManager.s16),
          InkWell(
            onTap: () => Navigator.pushNamed(context, Routes.carrierUserDetail),
            borderRadius: BorderRadius.circular(SizeManager.r12),
            child: Container(
              padding: const EdgeInsets.all(SizeManager.s12),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(SizeManager.r12),
                border: Border.all(color: colorScheme.border),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                    child: Text(
                      _initials,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: SizeManager.s12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              '${owner.firstName ?? ''} ${owner.lastName ?? ''}'
                                  .trim(),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: colorScheme.textPrimary,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.verified,
                              size: 16,
                              color: AppColors.primary,
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              size: 14,
                              color: AppColors.warning,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${owner.ratingAverage?.toStringAsFixed(1) ?? '0.0'} (${owner.ratingQuantity ?? 0} reviews)',
                              style: TextStyle(
                                fontSize: 12,
                                color: colorScheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right, color: colorScheme.textSecondary),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Company card ──────────────────────────────────────────────────────────

class _CompanyCard extends StatelessWidget {
  final String companyId;
  final String? companyName;
  final num? ratingAverage;
  final num? ratingQuantity;
  final AppColorScheme colorScheme;

  const _CompanyCard({
    required this.companyId,
    required this.colorScheme,
    this.companyName,
    this.ratingAverage,
    this.ratingQuantity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: SizeManager.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About Company',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: colorScheme.textPrimary,
            ),
          ),
          const SizedBox(height: SizeManager.s16),
          InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CompanyProfile(companyId: companyId),
              ),
            ),
            borderRadius: BorderRadius.circular(SizeManager.r12),
            child: Container(
              padding: const EdgeInsets.all(SizeManager.s12),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(SizeManager.r12),
                border: Border.all(color: colorScheme.border),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.business,
                      color: AppColors.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: SizeManager.s12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          companyName ?? 'Company',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: colorScheme.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              size: 14,
                              color: AppColors.warning,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${ratingAverage?.toStringAsFixed(1) ?? '0.0'} (${ratingQuantity ?? 0} reviews)',
                              style: TextStyle(
                                fontSize: 12,
                                color: colorScheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right, color: colorScheme.textSecondary),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
