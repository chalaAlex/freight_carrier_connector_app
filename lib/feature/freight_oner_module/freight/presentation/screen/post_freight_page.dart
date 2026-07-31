import 'dart:io';
import 'package:clean_architecture/cofig/context_extensions.dart';
import 'package:clean_architecture/core/di.dart';
import 'package:clean_architecture/core/network/api_client.dart';
import 'package:clean_architecture/core/utils/cargo_truck_mapping.dart';
import 'package:clean_architecture/core/widgets/ai_suggestion_sheet.dart';
import 'package:clean_architecture/feature/freight_oner_module/freight/presentation/bloc/location/location_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:clean_architecture/cofig/size_manager.dart';
import 'package:clean_architecture/core/request/create_freight_request.dart';
import 'package:clean_architecture/feature/freight_oner_module/freight/presentation/bloc/cargoType/cargo_type_bloc.dart';
import 'package:clean_architecture/feature/freight_oner_module/freight/presentation/bloc/cargoType/cargo_type_state.dart';
import 'package:clean_architecture/feature/freight_oner_module/freight/presentation/bloc/freight/freight_bloc.dart';
import 'package:clean_architecture/feature/freight_oner_module/freight/presentation/bloc/freight/freight_event.dart';
import 'package:clean_architecture/feature/freight_oner_module/freight/presentation/bloc/freight/freight_state.dart';
import 'package:clean_architecture/feature/freight_oner_module/freight/presentation/bloc/location/location_bloc.dart';
import 'package:clean_architecture/feature/freight_oner_module/freight/presentation/bloc/location/location_state.dart';
import 'package:clean_architecture/feature/freight_oner_module/freight/presentation/bloc/upload/upload_bloc.dart';
import 'package:clean_architecture/feature/freight_oner_module/freight/presentation/bloc/upload/upload_event.dart';
import 'package:clean_architecture/feature/freight_oner_module/freight/presentation/bloc/upload/upload_state.dart';
import 'package:clean_architecture/feature/freight_oner_module/freight/domain/entity/location_entity.dart';
import 'package:clean_architecture/feature/freight_oner_module/freight/presentation/widgets/stateful_freight_dropdown.dart';
import 'package:clean_architecture/feature/freight_oner_module/freight/presentation/widgets/truck_type_selector.dart';
import 'package:clean_architecture/feature/freight_oner_module/freight/presentation/widgets/pricing_type_selector.dart';
import 'package:clean_architecture/feature/freight_oner_module/freight/presentation/widgets/image_upload_section.dart';
import 'package:clean_architecture/feature/freight_oner_module/freight/presentation/bloc/cargoType/cargo_type_event.dart';

class PostFreightPage extends StatefulWidget {
  const PostFreightPage({super.key});

  @override
  State<PostFreightPage> createState() => _PostFreightPageState();
}

class _PostFreightPageState extends State<PostFreightPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _descriptionController = TextEditingController();
  final _weightController = TextEditingController();
  final _quantityController = TextEditingController();
  final _pickupAddressController = TextEditingController();
  final _dropoffAddressController = TextEditingController();
  final _pickupDateController = TextEditingController();
  final _deliveryDeadlineController = TextEditingController();
  final _capacityController = TextEditingController();
  final _priceController = TextEditingController();

  // State
  String? _selectedCargoType;
  final List<String> _selectedTruckTypes = [];
  String _selectedPricingType = 'Fixed';

  // Image state
  final List<File> _selectedImages = [];
  final ImagePicker _imagePicker = ImagePicker();
  static const int _maxImages = 5;
  final List<String> _uploadedImageUrls = [];
  bool _isUploadingImages = false;

  // Cargo types
  List<String> _cargoTypes = [];
  bool _isLoadingCargoTypes = false;
  String? _cargoTypesError;

  // Location state
  List<RegionEntity> _regions = [];
  bool _isLoadingLocations = false;
  String? _locationsError;
  String? _selectedPickupRegion;
  String? _selectedPickupCity;
  String? _selectedDropoffRegion;
  String? _selectedDropoffCity;
  List<String> _pickupCities = [];
  List<String> _dropoffCities = [];

  @override
  void initState() {
    super.initState();
    _checkInitialCargoTypeState();
    _checkInitialLocationState();
  }

  void _checkInitialCargoTypeState() {
    final s = context.read<CargoTypeBloc>().state;
    if (s is CargoTypeLoaded) {
      setState(() {
        _isLoadingCargoTypes = false;
        _cargoTypes = s.cargoTypes
            .map((e) => e.cargoType ?? '')
            .where((t) => t.isNotEmpty)
            .toList();
      });
    } else if (s is CargoTypeError) {
      setState(() {
        _isLoadingCargoTypes = false;
        _cargoTypesError = s.message;
      });
    } else if (s is CargoTypeLoading) {
      setState(() => _isLoadingCargoTypes = true);
    }
  }

  void _checkInitialLocationState() {
    final s = context.read<LocationBloc>().state;
    if (s is LocationLoaded) {
      setState(() {
        _isLoadingLocations = false;
        _regions = s.regions;
      });
    } else if (s is LocationError) {
      _retryLoadLocations();
    } else {
      setState(() => _isLoadingLocations = true);
      context.read<LocationBloc>().add(const FetchRegionsEvent());
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _weightController.dispose();
    _quantityController.dispose();
    _pickupAddressController.dispose();
    _dropoffAddressController.dispose();
    _pickupDateController.dispose();
    _deliveryDeadlineController.dispose();
    _capacityController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _publishFreight() {
    if (!_formKey.currentState!.validate()) return;
    if (!_validateRequiredFields()) return;
    if (!_validateImages()) return;

    final pickupDate = _parseDate(_pickupDateController.text);
    final deliveryDeadline = _parseDate(_deliveryDeadlineController.text);
    if (pickupDate == null || deliveryDeadline == null) {
      _showToast("Invalid date format", Colors.red);
      return;
    }

    final request = CreateFreightRequest(
      cargo: Cargo(
        type: _selectedCargoType!,
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        weightKg: _weightController.text.trim().isEmpty
            ? null
            : double.tryParse(_weightController.text.trim()),
        quantity: _quantityController.text.trim().isEmpty
            ? null
            : int.tryParse(_quantityController.text.trim()),
      ),
      route: FreightRoute(
        pickup: Location(
          region: _selectedPickupRegion!,
          city: _selectedPickupCity!,
          address: _pickupAddressController.text,
        ),
        dropoff: Location(
          region: _selectedDropoffRegion!,
          city: _selectedDropoffCity!,
          address: _dropoffAddressController.text,
        ),
      ),
      schedule: Schedule(
        pickupDate: pickupDate,
        deliveryDeadline: deliveryDeadline,
      ),
      truckRequirement: TruckRequirement(
        type: _selectedTruckTypes,
        minCapacityKg: _capacityController.text.trim().isEmpty
            ? null
            : double.tryParse(_capacityController.text.trim()),
      ),
      pricing: Pricing(
        type: _selectedPricingType.toUpperCase(),
        amount: _selectedPricingType == 'Negotiable'
            ? null
            : double.parse(_priceController.text),
      ),
      image: _uploadedImageUrls,
    );

    context.read<FreightBloc>().add(CreateFreightEvent(request));
  }

  bool _validateRequiredFields() {
    if (_selectedCargoType == null ||
        _selectedPickupRegion == null ||
        _selectedPickupCity == null ||
        _pickupAddressController.text.isEmpty ||
        _selectedDropoffRegion == null ||
        _selectedDropoffCity == null ||
        _dropoffAddressController.text.isEmpty ||
        _pickupDateController.text.isEmpty ||
        _deliveryDeadlineController.text.isEmpty) {
      _showToast("Please fill in all required fields", Colors.red);
      return false;
    }

    // Only validate price if pricing type is not Negotiable
    if (_selectedPricingType != 'Negotiable' && _priceController.text.isEmpty) {
      _showToast("Please enter an amount for fixed pricing", Colors.red);
      return false;
    }

    return true;
  }

  bool _validateImages() {
    if (_selectedImages.isEmpty) {
      _showToast("Please add at least one image", Colors.red);
      return false;
    }
    if (_uploadedImageUrls.length != _selectedImages.length) {
      _showToast("Please wait for images to finish uploading", Colors.orange);
      return false;
    }
    return true;
  }

  DateTime? _parseDate(String dateStr) {
    try {
      final parts = dateStr.split('/');
      if (parts.length == 3)
        return DateTime(
          int.parse(parts[2]),
          int.parse(parts[0]),
          int.parse(parts[1]),
        );
      return null;
    } catch (_) {
      return null;
    }
  }

  void _showToast(String message, Color backgroundColor) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: backgroundColor,
      textColor: Colors.white,
    );
  }

  Future<void> _selectDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        controller.text =
            '${picked.month.toString().padLeft(2, '0')}/${picked.day.toString().padLeft(2, '0')}/${picked.year}';
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      if (image != null) {
        final file = File(image.path);
        final sizeMB = await file.length() / (1024 * 1024);
        if (sizeMB > 5.0) {
          _showToast('Image must be < 5MB', Colors.red);
          return;
        }
        setState(() => _selectedImages.add(file));
        _showToast(
          'Image added (${_selectedImages.length}/$_maxImages)',
          Colors.green,
        );
        _uploadNewImage(file);
      }
    } catch (e) {
      _showToast('Failed to pick image: $e', Colors.red);
    }
  }

  void _uploadNewImage(File imageFile) {
    context.read<UploadBloc>().add(
      UploadSingleFileEvent(
        file: imageFile,
        path: 'freights/freight_${DateTime.now().millisecondsSinceEpoch}',
      ),
    );
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
      if (index < _uploadedImageUrls.length) _uploadedImageUrls.removeAt(index);
    });
    _showToast(
      'Image removed (${_selectedImages.length}/$_maxImages)',
      Colors.green,
    );
  }

  DropdownState _getCargoTypeDropdownState() {
    if (_isLoadingCargoTypes) return DropdownState.loading;
    if (_cargoTypesError != null) return DropdownState.error;
    if (_cargoTypes.isEmpty) return DropdownState.empty;
    return DropdownState.loaded;
  }

  DropdownState _getLocationDropdownState() {
    if (_isLoadingLocations) return DropdownState.loading;
    if (_locationsError != null) return DropdownState.error;
    if (_regions.isEmpty) return DropdownState.empty;
    return DropdownState.loaded;
  }

  void _retryLoadCargoTypes() {
    setState(() {
      _isLoadingCargoTypes = true;
      _cargoTypesError = null;
    });
    context.read<CargoTypeBloc>().add(const FetchCargoTypesEvent());
  }

  void _retryLoadLocations() {
    setState(() {
      _isLoadingLocations = true;
      _locationsError = null;
    });
    context.read<LocationBloc>().add(const FetchRegionsEvent());
  }

  void _onPickupRegionChanged(String? value) {
    setState(() {
      _selectedPickupRegion = value;
      _selectedPickupCity = null;
      _pickupCities =
          _regions
              .firstWhere(
                (r) => r.region == value,
                orElse: () => const RegionEntity(region: '', cities: []),
              )
              .cities ??
          [];
    });
  }

  void _onDropoffRegionChanged(String? value) {
    setState(() {
      _selectedDropoffRegion = value;
      _selectedDropoffCity = null;
      _dropoffCities =
          _regions
              .firstWhere(
                (r) => r.region == value,
                orElse: () => const RegionEntity(region: '', cities: []),
              )
              .cities ??
          [];
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.appColors;
    return MultiBlocListener(
      listeners: [
        _buildFreightBlocListener(),
        _buildLocationBlocListener(),
        _buildUploadBlocListener(),
        _buildCargoTypeBlocListener(),
      ],
      child: Scaffold(
        backgroundColor: cs.background,
        appBar: AppBar(
          backgroundColor: cs.surface,
          elevation: 0,
          title: Text(
            'Post Freight',
            style: context.text.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(
              horizontal: SizeManager.screenHorizontalPadding,
              vertical: SizeManager.s24,
            ),
            children: [
              // ── Cargo Details ──────────────────────────────────────
              _sectionHeader('Cargo Details', Icons.inventory_2),
              const SizedBox(height: SizeManager.s16),
              _buildDropdownField(
                label: 'Cargo Type *',
                value: _selectedCargoType,
                hint: 'Select cargo type',
                items: _cargoTypes,
                onChanged: (v) {
                  setState(() {
                    _selectedCargoType = v;
                    // Automatically select suitable truck types based on cargo
                    if (v != null) {
                      final suitableTruckTypes =
                          CargoTruckMapping.getTruckTypesForCargo(v);
                      _selectedTruckTypes
                        ..clear()
                        ..addAll(suitableTruckTypes);

                      // Show info message about auto-selection
                      if (!suitableTruckTypes.isNotEmpty) {
                        _selectedTruckTypes.clear();
                      }
                    }
                  });
                },
                state: _getCargoTypeDropdownState(),
                errorMessage: _cargoTypesError,
                onRetry: _retryLoadCargoTypes,
              ),
              const SizedBox(height: SizeManager.s16),
              Row(
                children: [
                  // Expanded(
                  //   child: _buildTextField(
                  //     controller: _weightController,
                  //     label: 'Weight (kg)',
                  //     hint: 'e.g. 1000',
                  //     keyboardType: TextInputType.number,
                  //     inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  //   ),
                  // ),
                  const SizedBox(width: SizeManager.s12),
                  // Expanded(
                  //   child: _buildTextField(
                  //     controller: _quantityController,
                  //     label: 'Quantity',
                  //     hint: 'e.g. 10',
                  //     keyboardType: TextInputType.number,
                  //     inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  //   ),
                  // ),
                ],
              ),
              const SizedBox(height: SizeManager.s16),

              const SizedBox(height: SizeManager.s24),
              // ── Route ──────────────────────────────────────────────
              _sectionHeader('Route Information', Icons.route),
              const SizedBox(height: SizeManager.s16),
              _buildSectionLabel('Pickup Location'),
              const SizedBox(height: SizeManager.s12),
              _buildDropdownField(
                label: 'Region *',
                value: _selectedPickupRegion,
                hint: 'Select region',
                items: _regions
                    .map((r) => r.region ?? '')
                    .where((r) => r.isNotEmpty)
                    .toList(),
                onChanged: _onPickupRegionChanged,
                state: _getLocationDropdownState(),
                errorMessage: _locationsError,
                onRetry: _retryLoadLocations,
              ),
              const SizedBox(height: SizeManager.s16),
              _buildDropdownField(
                label: 'City *',
                value: _selectedPickupCity,
                hint: _selectedPickupRegion == null
                    ? 'Select region first'
                    : 'Select city',
                items: _pickupCities,
                onChanged: (v) => setState(() => _selectedPickupCity = v),
                state: _selectedPickupRegion == null
                    ? DropdownState.initial
                    : (_pickupCities.isEmpty
                          ? DropdownState.empty
                          : DropdownState.loaded),
              ),
              const SizedBox(height: SizeManager.s16),
              _buildTextField(
                controller: _pickupAddressController,
                label: 'Address *',
                hint: 'Enter pickup address',
                validator: _requiredValidator,
              ),
              const SizedBox(height: SizeManager.s24),
              _buildSectionLabel('Dropoff Location'),
              const SizedBox(height: SizeManager.s12),
              _buildDropdownField(
                label: 'Region *',
                value: _selectedDropoffRegion,
                hint: 'Select region',
                items: _regions
                    .map((r) => r.region ?? '')
                    .where((r) => r.isNotEmpty)
                    .toList(),
                onChanged: _onDropoffRegionChanged,
                state: _getLocationDropdownState(),
                errorMessage: _locationsError,
                onRetry: _retryLoadLocations,
              ),
              const SizedBox(height: SizeManager.s16),
              _buildDropdownField(
                label: 'City *',
                value: _selectedDropoffCity,
                hint: _selectedDropoffRegion == null
                    ? 'Select region first'
                    : 'Select city',
                items: _dropoffCities,
                onChanged: (v) => setState(() => _selectedDropoffCity = v),
                state: _selectedDropoffRegion == null
                    ? DropdownState.initial
                    : (_dropoffCities.isEmpty
                          ? DropdownState.empty
                          : DropdownState.loaded),
              ),
              const SizedBox(height: SizeManager.s16),
              _buildTextField(
                controller: _dropoffAddressController,
                label: 'Address *',
                hint: 'Enter dropoff address',
                validator: _requiredValidator,
              ),

              const SizedBox(height: SizeManager.s24),
              // ── Schedule ───────────────────────────────────────────
              _sectionHeader('Schedule', Icons.calendar_today),
              const SizedBox(height: SizeManager.s16),
              _buildTextField(
                controller: _pickupDateController,
                label: 'Pickup Date *',
                hint: 'MM/DD/YYYY',
                readOnly: true,
                onTap: () => _selectDate(context, _pickupDateController),
                suffixIcon: const Icon(Icons.calendar_today, size: 18),
                validator: _requiredValidator,
              ),
              const SizedBox(height: SizeManager.s16),
              _buildTextField(
                controller: _deliveryDeadlineController,
                label: 'Delivery Deadline *',
                hint: 'MM/DD/YYYY',
                readOnly: true,
                onTap: () => _selectDate(context, _deliveryDeadlineController),
                suffixIcon: const Icon(Icons.calendar_today, size: 18),
                validator: _requiredValidator,
              ),

              const SizedBox(height: SizeManager.s24),
              // ── Truck Requirements ─────────────────────────────────
              _sectionHeader('Truck Requirements', Icons.local_shipping),
              const SizedBox(height: SizeManager.s16),
              _buildTruckTypesSection(),
              const SizedBox(height: SizeManager.s16),

              // _buildTextField(
              //   controller: _capacityController,
              //   label: 'Minimum Capacity (kg)',
              //   hint: 'e.g. 5000',
              //   keyboardType: TextInputType.number,
              //   inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              // ),
              const SizedBox(height: SizeManager.s24),
              // ── Pricing ────────────────────────────────────────────
              _sectionHeader('Pricing', Icons.attach_money),
              const SizedBox(height: SizeManager.s16),
              _buildPricingTypeSection(),
              // Only show amount field if pricing type is not Negotiable
              if (_selectedPricingType != 'Negotiable') ...[
                const SizedBox(height: SizeManager.s16),
                _buildTextField(
                  controller: _priceController,
                  label: 'Amount (ETB) *',
                  hint: 'e.g. 50000',
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: _requiredValidator,
                ),
              ],

              const SizedBox(height: SizeManager.s24),
              // ── Description ────────────────────────────────────────
              _sectionHeader('Description', Icons.description),
              const SizedBox(height: SizeManager.s16),
              _buildTextFieldWithAi(
                controller: _descriptionController,
                label: 'Description',
                hint: 'Describe your cargo...',
                maxLines: 3,
                maxLength: 300,
                onAiTap: _improveFreightDescription,
              ),

              const SizedBox(height: SizeManager.s24),
              // ── Images ─────────────────────────────────────────────
              _sectionHeader('Freight Images', Icons.image),
              const SizedBox(height: SizeManager.s16),
              _buildImageSection(),

              const SizedBox(height: SizeManager.s32),
              _buildPublishButton(),
              const SizedBox(height: SizeManager.s24),
            ],
          ),
        ),
      ),
    );
  }

  // ── Helpers ──────────────────────────────────────────────────────────────

  Widget _sectionHeader(String title, IconData icon) {
    final cs = context.appColors;
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(SizeManager.s8),
          decoration: BoxDecoration(
            color: cs.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(SizeManager.r10),
          ),
          child: Icon(icon, size: 18, color: cs.primary),
        ),
        const SizedBox(width: SizeManager.s12),
        Text(
          title,
          style: context.text.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: cs.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionLabel(String label) {
    final cs = context.appColors;
    return Text(
      label,
      style: context.text.bodyMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: cs.textPrimary,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    int maxLines = 1,
    int? maxLength,
    bool readOnly = false,
    VoidCallback? onTap,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    final cs = context.appColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.text.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: cs.textPrimary,
          ),
        ),
        const SizedBox(height: SizeManager.s8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          maxLines: maxLines,
          maxLength: maxLength,
          readOnly: readOnly,
          onTap: onTap,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: cs.textSecondary.withValues(alpha: 0.7),
            ),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: cs.surface,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: SizeManager.s16,
              vertical: SizeManager.s12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(SizeManager.r12),
              borderSide: BorderSide(color: cs.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(SizeManager.r12),
              borderSide: BorderSide(color: cs.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(SizeManager.r12),
              borderSide: BorderSide(color: cs.primary, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(SizeManager.r12),
              borderSide: BorderSide(color: cs.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(SizeManager.r12),
              borderSide: BorderSide(color: cs.error, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required String hint,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required DropdownState state,
    String? errorMessage,
    VoidCallback? onRetry,
  }) {
    final cs = context.appColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.text.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: cs.textPrimary,
          ),
        ),
        const SizedBox(height: SizeManager.s8),
        StatefulFreightDropdown(
          colorScheme: cs,
          value: value,
          label: '',
          hint: hint,
          items: items,
          onChanged: onChanged,
          state: state,
          errorMessage: errorMessage,
          onRetry: onRetry,
        ),
      ],
    );
  }

  Widget _buildTruckTypesSection() {
    final cs = context.appColors;
    final hasAutoSelection =
        _selectedCargoType != null &&
        CargoTruckMapping.hasMapping(_selectedCargoType!);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Truck Type',
              style: context.text.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: cs.textPrimary,
              ),
            ),
            // if (hasAutoSelection) ...[
            //   const SizedBox(width: SizeManager.s8),
            //   Container(
            //     padding: const EdgeInsets.symmetric(
            //       horizontal: SizeManager.s8,
            //       vertical: SizeManager.s4,
            //     ),
            //     decoration: BoxDecoration(
            //       color: Colors.blue.withValues(alpha: 0.1),
            //       borderRadius: BorderRadius.circular(SizeManager.r12),
            //       border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
            //     ),
            //     child: Row(
            //       mainAxisSize: MainAxisSize.min,
            //       children: [
            //         Icon(Icons.auto_awesome, size: 12, color: Colors.blue),
            //         const SizedBox(width: 4),
            //         Text(
            //           'Auto-selected',
            //           style: TextStyle(
            //             fontSize: 10,
            //             fontWeight: FontWeight.w600,
            //             color: Colors.blue,
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ],
          ],
        ),
        if (hasAutoSelection) ...[
          const SizedBox(height: SizeManager.s8),
          Container(
            padding: const EdgeInsets.all(SizeManager.s12),
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(SizeManager.r10),
              border: Border.all(color: Colors.blue.withValues(alpha: 0.2)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, size: 16, color: Colors.blue),
                const SizedBox(width: SizeManager.s8),
                Expanded(
                  child: Text(
                    CargoTruckMapping.getRecommendationReason(
                      _selectedCargoType!,
                    ),
                    style: context.text.bodySmall?.copyWith(
                      color: Colors.blue.shade700,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: SizeManager.s8),
        TruckTypeSelector(
          colorScheme: cs,
          selectedTypes: _selectedTruckTypes,
          onTypesSelected: (types) => setState(() {
            _selectedTruckTypes
              ..clear()
              ..addAll(types);
          }),
          isReadOnly: hasAutoSelection,
        ),
        if (hasAutoSelection) ...[
          const SizedBox(height: SizeManager.s8),
          Text(
            'Truck types are automatically selected based on your cargo type. You can still modify them if needed.',
            style: context.text.bodySmall?.copyWith(
              color: cs.textSecondary,
              fontSize: 11,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPricingTypeSection() {
    final cs = context.appColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pricing Type *',
          style: context.text.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: cs.textPrimary,
          ),
        ),
        const SizedBox(height: SizeManager.s8),
        PricingTypeSelector(
          colorScheme: cs,
          selectedType: _selectedPricingType,
          onTypeSelected: (type) => setState(() => _selectedPricingType = type),
        ),
      ],
    );
  }

  Widget _buildImageSection() {
    final cs = context.appColors;
    return ImageUploadSection(
      colorScheme: cs,
      selectedImages: _selectedImages,
      uploadedImageUrls: _uploadedImageUrls,
      isUploading: _isUploadingImages,
      maxImages: _maxImages,
      onPickImage: _pickImage,
      onRemoveImage: _removeImage,
    );
  }

  Widget _buildPublishButton() {
    return BlocBuilder<FreightBloc, FreightState>(
      builder: (context, state) {
        final isLoading = state is FreightLoading;
        return SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: isLoading ? null : _publishFreight,
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(SizeManager.r12),
              ),
              elevation: 0,
            ),
            child: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text(
                    'Publish Freight',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
          ),
        );
      },
    );
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) return 'Required';
    return null;
  }

  Future<void> _improveFreightDescription() async {
    final suggestion = await showAiSuggestionSheet(
      context: context,
      fetchSuggestion: () async {
        final response = await sl<ApiClient>().improveFreightDescription({
          'cargoType': _selectedCargoType,
          'weightKg': _weightController.text.trim().isEmpty
              ? null
              : double.tryParse(_weightController.text.trim()),
          'quantity': _quantityController.text.trim().isEmpty
              ? null
              : int.tryParse(_quantityController.text.trim()),
          'pickupRegion': _selectedPickupRegion,
          'pickupCity': _selectedPickupCity,
          'dropoffRegion': _selectedDropoffRegion,
          'dropoffCity': _selectedDropoffCity,
          'pickupDate': _pickupDateController.text.trim().isEmpty
              ? null
              : _pickupDateController.text.trim(),
          'deliveryDeadline': _deliveryDeadlineController.text.trim().isEmpty
              ? null
              : _deliveryDeadlineController.text.trim(),
          'truckTypes': _selectedTruckTypes.isEmpty
              ? null
              : _selectedTruckTypes,
          'minCapacityKg': _capacityController.text.trim().isEmpty
              ? null
              : double.tryParse(_capacityController.text.trim()),
          'pricingType': _selectedPricingType,
          'currentDescription': _descriptionController.text.trim().isEmpty
              ? null
              : _descriptionController.text.trim(),
        });
        return response.data.suggestion;
      },
    );
    if (suggestion != null) {
      setState(() => _descriptionController.text = suggestion);
    }
  }

  Widget _buildTextFieldWithAi({
    required TextEditingController controller,
    required String label,
    required String hint,
    required VoidCallback onAiTap,
    int maxLines = 1,
    int? maxLength,
    String? Function(String?)? validator,
  }) {
    final cs = context.appColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: context.text.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: cs.textPrimary,
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: onAiTap,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: SizeManager.s10,
                  vertical: SizeManager.s4,
                ),
                decoration: BoxDecoration(
                  color: cs.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(SizeManager.r20),
                  border: Border.all(color: cs.primary.withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.auto_awesome, size: 13, color: cs.primary),
                    const SizedBox(width: 4),
                    Text(
                      'Improve with AI',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: cs.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: SizeManager.s8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          maxLength: maxLength,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: cs.textSecondary.withValues(alpha: 0.7),
            ),
            filled: true,
            fillColor: cs.surface,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: SizeManager.s16,
              vertical: SizeManager.s12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(SizeManager.r12),
              borderSide: BorderSide(color: cs.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(SizeManager.r12),
              borderSide: BorderSide(color: cs.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(SizeManager.r12),
              borderSide: BorderSide(color: cs.primary, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(SizeManager.r12),
              borderSide: BorderSide(color: cs.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(SizeManager.r12),
              borderSide: BorderSide(color: cs.error, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  // ── BLoC Listeners ────────────────────────────────────────────────────────

  BlocListener _buildFreightBlocListener() {
    return BlocListener<FreightBloc, FreightState>(
      listener: (context, state) {
        if (state is FreightCreateSuccess) {
          _showToast("Freight published successfully!", Colors.green);
          Navigator.pop(context);
        } else if (state is FreightError) {
          _showToast(state.message, Colors.red);
        }
      },
    );
  }

  BlocListener _buildLocationBlocListener() {
    return BlocListener<LocationBloc, LocationState>(
      listener: (context, state) {
        if (state is LocationLoading) {
          setState(() {
            _isLoadingLocations = true;
            _locationsError = null;
          });
        } else if (state is LocationLoaded) {
          setState(() {
            _isLoadingLocations = false;
            _regions = state.regions;
          });
        } else if (state is LocationError) {
          setState(() {
            _isLoadingLocations = false;
            _locationsError = state.message;
          });
        }
      },
    );
  }

  BlocListener _buildUploadBlocListener() {
    return BlocListener<UploadBloc, UploadState>(
      listener: (context, state) {
        if (state is UploadLoading) {
          setState(() => _isUploadingImages = true);
        } else if (state is UploadSuccess) {
          setState(() {
            _isUploadingImages = false;
            _uploadedImageUrls.addAll(state.uploadedUrls);
          });
          _showToast(
            'Image uploaded! (${_uploadedImageUrls.length} total)',
            Colors.green,
          );
          context.read<UploadBloc>().add(const ResetUploadEvent());
        } else if (state is UploadError) {
          setState(() => _isUploadingImages = false);
          _showToast('Upload failed: ${state.message}', Colors.red);
          context.read<UploadBloc>().add(const ResetUploadEvent());
        }
      },
    );
  }

  BlocListener _buildCargoTypeBlocListener() {
    return BlocListener<CargoTypeBloc, CargoTypeState>(
      listener: (context, state) {
        if (state is CargoTypeLoading) {
          setState(() {
            _isLoadingCargoTypes = true;
            _cargoTypesError = null;
          });
        } else if (state is CargoTypeLoaded) {
          setState(() {
            _isLoadingCargoTypes = false;
            _cargoTypes = state.cargoTypes
                .map((e) => e.cargoType ?? '')
                .where((t) => t.isNotEmpty)
                .toList();
          });
        } else if (state is CargoTypeError) {
          setState(() {
            _isLoadingCargoTypes = false;
            _cargoTypesError = state.message;
          });
        }
      },
    );
  }
}
