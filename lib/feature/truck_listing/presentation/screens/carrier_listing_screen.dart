import 'package:flutter/material.dart';
import 'package:clean_architecture/cofig/size_manager.dart';
import 'package:clean_architecture/core/colors/app_colors.dart';
import 'package:clean_architecture/core/colors/color_scheme.dart';

class CarrierListingScreen extends StatefulWidget {
  const CarrierListingScreen({super.key});

  @override
  State<CarrierListingScreen> createState() => _CarrierListingScreenState();
}

class _CarrierListingScreenState extends State<CarrierListingScreen> {
  late ScrollController _scrollController;
  late TextEditingController _searchController;

  String _selectedFilter = 'All';
  String? _selectedCompany;
  String? _selectedCarrierType;
  String? _selectedRegion;

  final List<String> _companies = [
    'All',
    'Logistics Pro Ltd.',
    'FastTrack Haulage',
    'Eagle Transport',
    'QuickMile Express',
  ];
  final List<String> _carrierTypes = [
    'Flatbed',
    'Refrigerated',
    'Dry Van',
    'Tanker',
    'Container',
  ];
  final List<String> _regions = [
    'Addis Ababa',
    'Afar',
    'Amhara',
    'Benishangul-Gumuz',
    'Gambela',
    'Oromia',
    'Sidama',
  ];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = isDarkMode ? AppColorScheme.dark : AppColorScheme.light;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(colorScheme),
            _buildSearchBar(colorScheme),
            _buildFilterChips(colorScheme),
            Expanded(child: _buildCarrierList(colorScheme)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to add carrier
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: AppColors.white),
      ),
    );
  }

  Widget _buildAppBar(AppColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(SizeManager.s16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(SizeManager.s12),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(SizeManager.r12),
            ),
            child: const Icon(
              Icons.local_shipping,
              color: AppColors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: SizeManager.s12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'FreightConnect',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.textPrimary,
                ),
              ),
              Text(
                'AVAILABLE TRUCKS',
                style: TextStyle(
                  fontSize: 10,
                  color: colorScheme.textSecondary,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.notifications_outlined,
              color: colorScheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(AppColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: SizeManager.s16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              style: TextStyle(fontSize: 14, color: colorScheme.textPrimary),
              decoration: InputDecoration(
                hintText: 'Search carrier or model...',
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: colorScheme.textSecondary,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  size: 20,
                  color: colorScheme.textSecondary,
                ),
                filled: true,
                fillColor: colorScheme.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(SizeManager.r12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: SizeManager.s12,
                  vertical: SizeManager.s12,
                ),
              ),
            ),
          ),
          const SizedBox(width: SizeManager.s12),
          Container(
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(SizeManager.r12),
            ),
            child: IconButton(
              onPressed: () {},
              icon: Icon(Icons.tune, color: colorScheme.textPrimary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips(AppColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: SizeManager.s16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: SizeManager.s16),
        child: Row(
          children: [
            _buildFilterChip(
              label: 'All',
              isSelected: _selectedFilter == 'All',
              onTap: () => setState(() => _selectedFilter = 'All'),
              colorScheme: colorScheme,
            ),
            const SizedBox(width: SizeManager.s8),
            _buildFilterChip(
              label: 'Company',
              isSelected: _selectedFilter == 'Company',
              hasDropdown: true,
              onTap: () => _showFilterBottomSheet(
                context,
                'Select Company',
                'Filter by company',
                _companies,
                _selectedCompany,
                (value) => setState(() {
                  _selectedCompany = value;
                  _selectedFilter = 'Company';
                }),
                colorScheme,
              ),
              colorScheme: colorScheme,
            ),
            const SizedBox(width: SizeManager.s8),
            _buildFilterChip(
              label: 'Carrier Type',
              isSelected: _selectedFilter == 'Carrier Type',
              hasDropdown: true,
              onTap: () => _showFilterBottomSheet(
                context,
                'Select Carrier Type',
                'Filter by carrier type',
                _carrierTypes,
                _selectedCarrierType,
                (value) => setState(() {
                  _selectedCarrierType = value;
                  _selectedFilter = 'Carrier Type';
                }),
                colorScheme,
              ),
              colorScheme: colorScheme,
            ),
            const SizedBox(width: SizeManager.s8),
            _buildFilterChip(
              label: 'Region',
              isSelected: _selectedFilter == 'Region',
              hasDropdown: true,
              onTap: () => _showFilterBottomSheet(
                context,
                'Select Region',
                'Filter logistics hubs by region in Ethiopia',
                _regions,
                _selectedRegion,
                (value) => setState(() {
                  _selectedRegion = value;
                  _selectedFilter = 'Region';
                }),
                colorScheme,
              ),
              colorScheme: colorScheme,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required AppColorScheme colorScheme,
    bool hasDropdown = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: SizeManager.s16,
          vertical: SizeManager.s10,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : colorScheme.surface,
          borderRadius: BorderRadius.circular(SizeManager.r20),
          border: Border.all(
            color: isSelected ? AppColors.primary : colorScheme.border,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.white : colorScheme.textPrimary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                fontSize: 14,
              ),
            ),
            if (hasDropdown) ...[
              const SizedBox(width: SizeManager.s4),
              Icon(
                Icons.keyboard_arrow_down,
                size: 16,
                color: isSelected ? AppColors.white : colorScheme.textPrimary,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCarrierList(AppColorScheme colorScheme) {
    // Mock data
    final carriers = [
      {
        'model': 'Volvo FH16 Flatbed',
        'company': 'Logistics Pro Ltd.',
        'rating': 4.9,
        'price': 2.50,
        'status': 'AVAILABLE NOW',
        'image': 'https://via.placeholder.com/150',
      },
      {
        'model': 'Scania R-Series',
        'company': 'FastTrack Haulage',
        'rating': 4.5,
        'price': 1.95,
        'status': 'BUSY',
        'image': 'https://via.placeholder.com/150',
      },
      {
        'model': 'Kenworth T680',
        'company': 'Eagle Transport',
        'rating': 5.0,
        'price': 2.10,
        'status': 'AVAILABLE NOW',
        'image': 'https://via.placeholder.com/150',
      },
      {
        'model': 'Freightliner Cascadia',
        'company': 'QuickMile Express',
        'rating': 4.8,
        'price': 2.35,
        'status': 'AVAILABLE NOW',
        'image': 'https://via.placeholder.com/150',
      },
    ];

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(SizeManager.s16),
      itemCount: carriers.length,
      itemBuilder: (context, index) {
        final carrier = carriers[index];
        return _buildCarrierCard(carrier, colorScheme);
      },
    );
  }

  Widget _buildCarrierCard(
    Map<String, dynamic> carrier,
    AppColorScheme colorScheme,
  ) {
    final isAvailable = carrier['status'] == 'AVAILABLE NOW';

    return Container(
      margin: const EdgeInsets.only(bottom: SizeManager.s16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(SizeManager.r16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(SizeManager.r16),
              bottomLeft: Radius.circular(SizeManager.r16),
            ),
            child: Container(
              width: 110,
              height: 110,
              color: colorScheme.border,
              child: Image.network(
                carrier['image'],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.local_shipping,
                    size: 40,
                    color: colorScheme.textSecondary,
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(SizeManager.s12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          carrier['model'],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: colorScheme.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: SizeManager.s8,
                          vertical: SizeManager.s4,
                        ),
                        decoration: BoxDecoration(
                          color: isAvailable
                              ? AppColors.success.withValues(alpha: 0.1)
                              : colorScheme.border,
                          borderRadius: BorderRadius.circular(SizeManager.r4),
                        ),
                        child: Text(
                          carrier['status'],
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: isAvailable
                                ? AppColors.success
                                : colorScheme.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: SizeManager.s4),
                  Text(
                    carrier['company'],
                    style: TextStyle(
                      fontSize: 13,
                      color: colorScheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: SizeManager.s8),
                  Row(
                    children: [
                      Icon(Icons.star, size: 16, color: AppColors.warning),
                      const SizedBox(width: SizeManager.s4),
                      Text(
                        carrier['rating'].toString(),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.textPrimary,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '\$${carrier['price'].toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      Text(
                        '/mi',
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
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet(
    BuildContext context,
    String title,
    String subtitle,
    List<String> options,
    String? selectedValue,
    Function(String?) onChanged,
    AppColorScheme colorScheme,
  ) {
    final tempSelected = <String>{};
    if (selectedValue != null) {
      tempSelected.add(selectedValue);
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.7,
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(SizeManager.r24),
                topRight: Radius.circular(SizeManager.r24),
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: SizeManager.s12),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colorScheme.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: SizeManager.s24),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: SizeManager.s24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: SizeManager.s8),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 14,
                          color: colorScheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: SizeManager.s24),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: SizeManager.s24,
                  ),
                  child: TextField(
                    style: TextStyle(
                      fontSize: 14,
                      color: colorScheme.textPrimary,
                    ),
                    decoration: InputDecoration(
                      hintText:
                          'Search for a ${title.toLowerCase().replaceAll('select ', '')}...',
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: colorScheme.textSecondary,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        size: 20,
                        color: colorScheme.textSecondary,
                      ),
                      filled: true,
                      fillColor: colorScheme.background,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(SizeManager.r12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: SizeManager.s12,
                        vertical: SizeManager.s12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: SizeManager.s16),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: SizeManager.s24,
                    ),
                    itemCount: options.length,
                    itemBuilder: (context, index) {
                      final option = options[index];
                      final isSelected = tempSelected.contains(option);

                      return InkWell(
                        onTap: () {
                          setModalState(() {
                            if (isSelected) {
                              tempSelected.remove(option);
                            } else {
                              tempSelected.clear();
                              tempSelected.add(option);
                            }
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: SizeManager.s16,
                          ),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: colorScheme.border,
                                width: 1,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  option,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: colorScheme.textPrimary,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isSelected
                                      ? AppColors.primary
                                      : Colors.transparent,
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.primary
                                        : colorScheme.border,
                                    width: 2,
                                  ),
                                ),
                                child: isSelected
                                    ? const Icon(
                                        Icons.check,
                                        size: 16,
                                        color: AppColors.white,
                                      )
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(SizeManager.s24),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        onChanged(
                          tempSelected.isEmpty ? null : tempSelected.first,
                        );
                        Navigator.pop(context);
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
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Apply Selection',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: SizeManager.s8),
                          const Icon(Icons.arrow_forward, size: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
