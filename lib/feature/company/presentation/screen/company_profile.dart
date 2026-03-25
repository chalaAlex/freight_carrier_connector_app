import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clean_architecture/core/colors/color_scheme.dart';
import 'package:clean_architecture/core/colors/app_colors.dart';
import 'package:clean_architecture/cofig/size_manager.dart';
import 'package:clean_architecture/feature/company/domain/entity/company_entity.dart';
import 'package:clean_architecture/feature/company/presentation/bloc/company_bloc.dart';
import 'package:clean_architecture/feature/company/presentation/bloc/company_event.dart';
import 'package:clean_architecture/feature/company/presentation/bloc/company_state.dart';

class CompanyProfile extends StatefulWidget {
  final String companyId;

  const CompanyProfile({super.key, required this.companyId});

  @override
  State<CompanyProfile> createState() => _CompanyProfileState();
}

class _CompanyProfileState extends State<CompanyProfile> {
  @override
  void initState() {
    super.initState();
    context.read<CompanyBloc>().add(LoadCompanyDetail(widget.companyId));
  }

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
          'Company Profile',
          style: TextStyle(
            color: colorScheme.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: BlocBuilder<CompanyBloc, CompanyState>(
        builder: (context, state) {
          if (state is CompanyDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is CompanyDetailError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48, color: colorScheme.error),
                  const SizedBox(height: SizeManager.s12),
                  Text(
                    state.message,
                    style: TextStyle(color: colorScheme.textSecondary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: SizeManager.s16),
                  TextButton(
                    onPressed: () => context.read<CompanyBloc>().add(
                      LoadCompanyDetail(widget.companyId),
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          if (state is CompanyDetailLoaded) {
            return _CompanyProfileBody(
              company: state.company,
              colorScheme: colorScheme,
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _CompanyProfileBody extends StatelessWidget {
  final CompanyEntity company;
  final AppColorScheme colorScheme;

  const _CompanyProfileBody({required this.company, required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildHeaderSection(colorScheme),
          _buildCompanyInfoSection(colorScheme),
          _buildStatsSection(colorScheme),
          _buildCompanyInformationSection(colorScheme),
          const SizedBox(height: SizeManager.s24),
        ],
      ),
    );
  }

  Widget _buildHeaderSection(AppColorScheme colorScheme) {
    final hasImage =
        company.bannerImage != null && company.bannerImage!.isNotEmpty;

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
          if (hasImage)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(SizeManager.r12),
              ),
              child: Image.network(
                company.bannerImage!,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: AppColors.primary,
                  child: Center(
                    child: Icon(
                      Icons.business,
                      size: 80,
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
                  ),
                ),
              ),
            ),
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
              child: company.logo != null && company.logo!.isNotEmpty
                  ? ClipOval(
                      child: Image.network(
                        company.logo!,
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.business,
                          color: Colors.white,
                          size: 40,
                        ),
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
            company.legalEntityName,
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
                  company.isVerified ? 'Verified Carrier' : 'Carrier',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: company.isVerified
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
                  '${company.headOfficeAddress.city}, ${company.headOfficeAddress.regionState}',
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
        border: Border.all(color: colorScheme.border),
      ),
      child: Row(
        children: [
          _StatItem(
            label: 'TRIPS',
            value: '${company.completedShipments}',
            subtitle: 'Completed',
            colorScheme: colorScheme,
          ),
          _StatDivider(colorScheme: colorScheme),
          _StatItem(
            label: 'FLEET',
            value: '${company.fleetSize}',
            subtitle: 'Active',
            colorScheme: colorScheme,
          ),
          _StatDivider(colorScheme: colorScheme),
          _StatItem(
            label: 'RATING',
            value: company.ratingAverage.toStringAsFixed(1),
            subtitle: '(${company.ratingQuantity} reviews)',
            colorScheme: colorScheme,
          ),
        ],
      ),
    );
  }

  Widget _buildCompanyInformationSection(AppColorScheme colorScheme) {
    return Container(
      margin: const EdgeInsets.all(SizeManager.s16),
      padding: const EdgeInsets.all(SizeManager.s16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(SizeManager.r12),
        border: Border.all(color: colorScheme.border),
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
          _InfoRow(
            label: 'Type',
            value: company.companyType,
            colorScheme: colorScheme,
          ),
          const SizedBox(height: SizeManager.s12),
          _InfoRow(
            label: 'Email',
            value: company.email,
            colorScheme: colorScheme,
            isLink: true,
          ),
          const SizedBox(height: SizeManager.s12),
          _InfoRow(
            label: 'Phone',
            value: company.phone,
            colorScheme: colorScheme,
            isLink: true,
          ),
          const SizedBox(height: SizeManager.s12),
          _InfoRow(
            label: 'Experience',
            value: '${company.experience} years',
            colorScheme: colorScheme,
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final String subtitle;
  final AppColorScheme colorScheme;

  const _StatItem({
    required this.label,
    required this.value,
    required this.subtitle,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: colorScheme.textSecondary,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: SizeManager.s4),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: colorScheme.textPrimary,
            ),
          ),
          const SizedBox(height: SizeManager.s4),
          Text(
            subtitle,
            style: TextStyle(fontSize: 11, color: colorScheme.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _StatDivider extends StatelessWidget {
  final AppColorScheme colorScheme;
  const _StatDivider({required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 1,
      color: colorScheme.border,
      margin: const EdgeInsets.symmetric(horizontal: SizeManager.s8),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final AppColorScheme colorScheme;
  final bool isLink;

  const _InfoRow({
    required this.label,
    required this.value,
    required this.colorScheme,
    this.isLink = false,
  });

  @override
  Widget build(BuildContext context) {
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
}
