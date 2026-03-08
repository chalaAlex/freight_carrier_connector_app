import 'package:flutter/material.dart';
import 'package:clean_architecture/core/colors/color_scheme.dart';
import 'package:clean_architecture/core/colors/app_colors.dart';
import 'package:clean_architecture/cofig/size_manager.dart';
import 'package:clean_architecture/feature/company/domain/entity/company_entity.dart';

class CompanyProfile extends StatefulWidget {
  final CompanyEntity company;

  const CompanyProfile({super.key, required this.company});

  @override
  State<CompanyProfile> createState() => _CompanyProfileState();
}

class _CompanyProfileState extends State<CompanyProfile> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = isDarkMode ? AppColorScheme.dark : AppColorScheme.light;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Carrier Profile',
          style: TextStyle(
            color: colorScheme.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.share, color: colorScheme.textPrimary),
            onPressed: () {
              // TODO: Implement share functionality
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeaderSection(colorScheme),
            _buildCompanyInfoSection(colorScheme),
            _buildStatsSection(colorScheme),
            _buildAboutSection(colorScheme),
            _buildCompanyInformationSection(colorScheme),
            _buildFleetBreakdownSection(colorScheme),
            _buildTrustComplianceSection(colorScheme),
            _buildViewAllTrucksButton(colorScheme),
            const SizedBox(height: SizeManager.s24),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection(AppColorScheme colorScheme) {
    final hasImage =
        widget.company.bannerImage != null &&
        widget.company.bannerImage!.isNotEmpty;

    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: hasImage ? null : AppColors.primary,
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(SizeManager.r12),
        ),
      ),
      child: Stack(
        children: [
          // Background Image
          if (hasImage)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(SizeManager.r12),
              ),
              child: Image.network(
                widget.company.bannerImage!,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: AppColors.primary,
                    child: Center(
                      child: Icon(
                        Icons.business,
                        size: 80,
                        color: Colors.white.withValues(alpha: 0.3),
                      ),
                    ),
                  );
                },
              ),
            ),
          // Gradient Overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.3),
                ],
              ),
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(SizeManager.r12),
              ),
            ),
          ),
          // Logo/Icon
          Positioned(
            bottom: 20,
            left: 20,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3),
              ),
              child:
                  widget.company.logo != null && widget.company.logo!.isNotEmpty
                  ? ClipOval(
                      child: Image.network(
                        widget.company.logo!,
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.business,
                            color: Colors.white,
                            size: 40,
                          );
                        },
                      ),
                    )
                  : const Icon(Icons.business, color: Colors.white, size: 40),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompanyInfoSection(AppColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.all(SizeManager.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.company.legalEntityName,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: colorScheme.textPrimary,
            ),
          ),
          const SizedBox(height: SizeManager.s8),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: SizeManager.s8,
                  vertical: SizeManager.s4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(SizeManager.r4),
                ),
                child: Text(
                  widget.company.isVerified ? 'Verified Carrier' : 'Carrier',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: widget.company.isVerified
                        ? AppColors.success
                        : colorScheme.textSecondary,
                  ),
                ),
              ),
              const SizedBox(width: SizeManager.s8),
              Icon(
                Icons.location_on,
                size: 16,
                color: colorScheme.textSecondary,
              ),
              const SizedBox(width: SizeManager.s4),
              Expanded(
                child: Text(
                  '${widget.company.headOfficeAddress.city}, ${widget.company.headOfficeAddress.regionState}, ${widget.company.headOfficeAddress.country}',
                  style: TextStyle(
                    fontSize: 14,
                    color: colorScheme.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(AppColorScheme colorScheme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: SizeManager.s16),
      padding: const EdgeInsets.all(SizeManager.s16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(SizeManager.r12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildStatItem(
            'TRIPS',
            '${widget.company.completedShipments}',
            'Completed',
            colorScheme,
          ),
          _buildStatDivider(colorScheme),
          _buildStatItem(
            'FLEET',
            '${widget.company.fleetSize}',
            'Active',
            colorScheme,
          ),
          _buildStatDivider(colorScheme),
          _buildStatItem(
            'RATING',
            widget.company.ratingAverage.toStringAsFixed(1),
            _buildStarRating(widget.company.ratingAverage),
            colorScheme,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    String label,
    String value,
    String subtitle,
    AppColorScheme colorScheme,
  ) {
    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: colorScheme.textSecondary,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: SizeManager.s4),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: colorScheme.textPrimary,
            ),
          ),
          const SizedBox(height: SizeManager.s4),
          Text(
            subtitle,
            style: TextStyle(fontSize: 12, color: colorScheme.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildStatDivider(AppColorScheme colorScheme) {
    return Container(
      height: 40,
      width: 1,
      color: colorScheme.border,
      margin: const EdgeInsets.symmetric(horizontal: SizeManager.s8),
    );
  }

  Widget _buildAboutSection(AppColorScheme colorScheme) {
    return Container(
      margin: const EdgeInsets.all(SizeManager.s16),
      padding: const EdgeInsets.all(SizeManager.s16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(SizeManager.r12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About the Company',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: colorScheme.textPrimary,
            ),
          ),
          const SizedBox(height: SizeManager.s12),
          Text(
            'Horn of Africa Haulers is a premier Private Limited Company providing reliable freight and logistics solutions across East Africa. Based in Mekelle, we specialize in heavy-duty transport with a dedicated fleet and regional expertise.',
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: colorScheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompanyInformationSection(AppColorScheme colorScheme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: SizeManager.s16),
      padding: const EdgeInsets.all(SizeManager.s16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(SizeManager.r12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Company Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: colorScheme.textPrimary,
            ),
          ),
          const SizedBox(height: SizeManager.s16),
          _buildInfoRow(
            'Reg Number',
            widget.company.companyRegistrationNumber,
            colorScheme,
          ),
          const SizedBox(height: SizeManager.s12),
          _buildInfoRow('Type', widget.company.companyType, colorScheme),
          const SizedBox(height: SizeManager.s12),
          _buildInfoRow(
            'Email',
            widget.company.email,
            colorScheme,
            isLink: true,
          ),
          const SizedBox(height: SizeManager.s12),
          _buildInfoRow(
            'Phone',
            widget.company.phone,
            colorScheme,
            isLink: true,
          ),
          const SizedBox(height: SizeManager.s12),
          _buildInfoRow(
            'Experience',
            '${widget.company.experience} years',
            colorScheme,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    String label,
    String value,
    AppColorScheme colorScheme, {
    bool isLink = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: TextStyle(fontSize: 14, color: colorScheme.textSecondary),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: isLink ? AppColors.primary : colorScheme.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFleetBreakdownSection(AppColorScheme colorScheme) {
    return Container(
      margin: const EdgeInsets.all(SizeManager.s16),
      padding: const EdgeInsets.all(SizeManager.s16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(SizeManager.r12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Fleet Breakdown',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.textPrimary,
                ),
              ),
              TextButton(
                onPressed: () {
                  // TODO: Implement view details
                },
                child: Text(
                  'View Details',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: SizeManager.s16),
          _buildFleetItem(
            Icons.local_shipping,
            'Dry Vans (53\')',
            '28',
            AppColors.warning,
            colorScheme,
          ),
          const SizedBox(height: SizeManager.s12),
          _buildFleetItem(
            Icons.ac_unit,
            'Reefers',
            '12',
            AppColors.primary,
            colorScheme,
          ),
          const SizedBox(height: SizeManager.s12),
          _buildFleetItem(
            Icons.straighten,
            'Flatbeds',
            '5',
            AppColors.success,
            colorScheme,
          ),
        ],
      ),
    );
  }

  Widget _buildFleetItem(
    IconData icon,
    String type,
    String count,
    Color iconColor,
    AppColorScheme colorScheme,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(SizeManager.s8),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(SizeManager.r6),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(width: SizeManager.s12),
        Expanded(
          child: Text(
            type,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: colorScheme.textPrimary,
            ),
          ),
        ),
        Text(
          count,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: colorScheme.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildTrustComplianceSection(AppColorScheme colorScheme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: SizeManager.s16),
      padding: const EdgeInsets.all(SizeManager.s16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(SizeManager.r12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Trust & Compliance',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: colorScheme.textPrimary,
            ),
          ),
          const SizedBox(height: SizeManager.s16),
          Row(
            children: [
              Expanded(
                child: _buildComplianceItem(
                  Icons.verified_user,
                  'INSURANCE',
                  'Active',
                  AppColors.success,
                  colorScheme,
                ),
              ),
              const SizedBox(width: SizeManager.s12),
              Expanded(
                child: _buildComplianceItem(
                  Icons.verified,
                  'DOTMC',
                  'Verified',
                  AppColors.primary,
                  colorScheme,
                ),
              ),
            ],
          ),
          const SizedBox(height: SizeManager.s12),
          Row(
            children: [
              Expanded(
                child: _buildComplianceItem(
                  Icons.security,
                  'SAFETY',
                  'Satisfactory',
                  AppColors.success,
                  colorScheme,
                ),
              ),
              const SizedBox(width: SizeManager.s12),
              Expanded(
                child: _buildComplianceItem(
                  Icons.schedule,
                  'AUTHORITY',
                  '7 Years',
                  AppColors.primary,
                  colorScheme,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildComplianceItem(
    IconData icon,
    String title,
    String status,
    Color statusColor,
    AppColorScheme colorScheme,
  ) {
    return Container(
      padding: const EdgeInsets.all(SizeManager.s12),
      decoration: BoxDecoration(
        color: colorScheme.background,
        borderRadius: BorderRadius.circular(SizeManager.r6),
        border: Border.all(color: colorScheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: statusColor, size: 16),
              const SizedBox(width: SizeManager.s4),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: SizeManager.s4),
          Text(
            status,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: statusColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildViewAllTrucksButton(AppColorScheme colorScheme) {
    return Container(
      margin: const EdgeInsets.all(SizeManager.s16),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // TODO: Navigate to trucks listing
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.warning,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: SizeManager.s16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SizeManager.r12),
          ),
          elevation: 0,
        ),
        child: Text(
          'View All Trucks (${widget.company.fleetSize})',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // Helper method to build star rating string
  String _buildStarRating(double rating) {
    int fullStars = rating.floor();
    bool hasHalfStar = (rating - fullStars) >= 0.5;
    int emptyStars = 5 - fullStars - (hasHalfStar ? 1 : 0);

    return '★' * fullStars + (hasHalfStar ? '⯨' : '') + '☆' * emptyStars;
  }
}
