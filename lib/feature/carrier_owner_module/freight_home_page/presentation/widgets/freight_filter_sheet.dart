import 'package:clean_architecture/cofig/context_extensions.dart';
import 'package:clean_architecture/core/colors/app_colors.dart';
import 'package:clean_architecture/feature/carrier_owner_module/freights/domain/entity/freight_filter.dart';
import 'package:flutter/material.dart';

class FreightFilterSheet extends StatefulWidget {
  final FreightFilter initial;

  const FreightFilterSheet({super.key, required this.initial});

  @override
  State<FreightFilterSheet> createState() => _FreightFilterSheetState();
}

class _FreightFilterSheetState extends State<FreightFilterSheet> {
  late String? _cargoType;
  late String? _pickupRegion;
  late String? _pickupCity;
  late String? _dropoffRegion;
  late String? _dropoffCity;
  late String? _truckType;
  late String? _pricingType;
  late String? _status;

  static const _truckTypes = [
    'FLATBED',
    'BOX',
    'REFRIGERATED',
    'TANKER',
    'LOWBED',
  ];
  
  static const _pricingTypes = ['FIXED', 'NEGOTIABLE'];
  
  static const _statuses = [
    'OPEN',
    'BIDDING',
    'BOOKED',
    'COMPLETED',
    'CANCELLED',
  ];

  @override
  void initState() {
    super.initState();
    _cargoType = widget.initial.cargoTypes?.firstOrNull;
    _pickupRegion = widget.initial.pickupRegion;
    _pickupCity = widget.initial.pickupCity;
    _dropoffRegion = widget.initial.dropoffRegion;
    _dropoffCity = widget.initial.dropoffCity;
    _truckType = widget.initial.truckTypes?.firstOrNull;
    _pricingType = widget.initial.pricingTypes?.firstOrNull;
    _status = widget.initial.statuses?.firstOrNull;
  }

  FreightFilter get _built => FreightFilter(
    cargoTypes: _cargoType?.isEmpty == true
        ? null
        : (_cargoType != null ? [_cargoType!] : null),
    pickupRegion: _pickupRegion?.isEmpty == true ? null : _pickupRegion,
    pickupCity: _pickupCity?.isEmpty == true ? null : _pickupCity,
    dropoffRegion: _dropoffRegion?.isEmpty == true ? null : _dropoffRegion,
    dropoffCity: _dropoffCity?.isEmpty == true ? null : _dropoffCity,
    truckTypes: _truckType != null ? [_truckType!] : null,
    pricingTypes: _pricingType != null ? [_pricingType!] : null,
    statuses: _status != null ? [_status!] : null,
  );

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Handle
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFDDDDEE),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Filter Freights',
                      style: context.text.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextButton(
                      onPressed: () => setState(() {
                        _cargoType = null;
                        _pickupRegion = null;
                        _pickupCity = null;
                        _dropoffRegion = null;
                        _dropoffCity = null;
                        _truckType = null;
                        _pricingType = null;
                        _status = null;
                      }),
                      child: Text(
                        'Clear all',
                        style: TextStyle(color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                  children: [
                    _ChipGroup(
                      options: const [
                        'Electronics',
                        'Food Stuff',
                        'Construction',
                        'Chemicals',
                        'Textile',
                      ],
                      selected: _cargoType,
                      onSelected: (v) => setState(() => _cargoType = v),
                    ),
                    const SizedBox(height: 16),
                    _SectionTitle('Route — Pickup'),
                    const SizedBox(height: 10),
                    _TextField(
                      label: 'Pickup Region',
                      hint: 'e.g. Oromia',
                      value: _pickupRegion,
                      onChanged: (v) => setState(() => _pickupRegion = v),
                    ),
                    const SizedBox(height: 10),
                    _TextField(
                      label: 'Pickup City',
                      hint: 'e.g. Addis Ababa',
                      value: _pickupCity,
                      onChanged: (v) => setState(() => _pickupCity = v),
                    ),
                    const SizedBox(height: 16),
                    _SectionTitle('Route — Dropoff'),
                    const SizedBox(height: 10),
                    _TextField(
                      label: 'Dropoff Region',
                      hint: 'e.g. Amhara',
                      value: _dropoffRegion,
                      onChanged: (v) => setState(() => _dropoffRegion = v),
                    ),
                    const SizedBox(height: 10),
                    _TextField(
                      label: 'Dropoff City',
                      hint: 'e.g. Dire Dawa',
                      value: _dropoffCity,
                      onChanged: (v) => setState(() => _dropoffCity = v),
                    ),
                    const SizedBox(height: 16),
                    _SectionTitle('Truck Requirement'),
                    const SizedBox(height: 10),
                    _ChipGroup(
                      options: _truckTypes,
                      selected: _truckType,
                      onSelected: (v) => setState(() => _truckType = v),
                    ),
                    const SizedBox(height: 16),
                    _SectionTitle('Pricing Type'),
                    const SizedBox(height: 10),
                    _ChipGroup(
                      options: _pricingTypes,
                      selected: _pricingType,
                      onSelected: (v) => setState(() => _pricingType = v),
                    ),
                    const SizedBox(height: 16),
                    _SectionTitle('Status'),
                    const SizedBox(height: 10),
                    _ChipGroup(
                      options: _statuses,
                      selected: _status,
                      onSelected: (v) => setState(() => _status = v),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  20,
                  12,
                  20,
                  MediaQuery.of(context).padding.bottom + 12,
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(_built),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Apply Filters',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: context.text.labelLarge?.copyWith(
        fontWeight: FontWeight.w700,
        color: AppColors.grey,
        letterSpacing: 0.4,
      ),
    );
  }
}

class _TextField extends StatelessWidget {
  final String label;
  final String hint;
  final String? value;
  final ValueChanged<String> onChanged;

  const _TextField({
    required this.label,
    required this.hint,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: value,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFF0F0FA),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
      ),
    );
  }
}

class _ChipGroup extends StatelessWidget {
  final List<String> options;
  final String? selected;
  final ValueChanged<String?> onSelected;

  const _ChipGroup({
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((opt) {
        final isSelected = selected == opt;
        return GestureDetector(
          onTap: () => onSelected(isSelected ? null : opt),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : const Color(0xFFF0F0FA),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? AppColors.primary : const Color(0xFFDDDDEE),
              ),
            ),
            child: Text(
              opt,
              style: context.text.bodySmall?.copyWith(
                color: isSelected
                    ? Colors.white
                    : context.appColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
