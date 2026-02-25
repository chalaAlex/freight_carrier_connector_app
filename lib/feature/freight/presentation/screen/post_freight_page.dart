import 'dart:io';
import 'package:clean_architecture/feature/freight/presentation/bloc/location/location_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:clean_architecture/cofig/size_manager.dart';
import 'package:clean_architecture/core/colors/app_colors.dart';
import 'package:clean_architecture/core/colors/color_scheme.dart';
import 'package:clean_architecture/core/request/create_freight_request.dart';
import 'package:clean_architecture/feature/freight/presentation/bloc/cargoType/cargo_type_bloc.dart';
import 'package:clean_architecture/feature/freight/presentation/bloc/cargoType/cargo_type_state.dart';
import 'package:clean_architecture/feature/freight/presentation/bloc/freight/freight_bloc.dart';
import 'package:clean_architecture/feature/freight/presentation/bloc/freight/freight_event.dart';
import 'package:clean_architecture/feature/freight/presentation/bloc/freight/freight_state.dart';
import 'package:clean_architecture/feature/freight/presentation/bloc/location/location_bloc.dart';
import 'package:clean_architecture/feature/freight/presentation/bloc/location/location_state.dart';
import 'package:clean_architecture/feature/freight/presentation/bloc/upload/upload_bloc.dart';
import 'package:clean_architecture/feature/freight/presentation/bloc/upload/upload_event.dart';
import 'package:clean_architecture/feature/freight/presentation/bloc/upload/upload_state.dart';
import 'package:clean_architecture/feature/freight/domain/entity/location_entity.dart';
import 'package:clean_architecture/feature/freight/presentation/widgets/freight_form_field.dart';
import 'package:clean_architecture/feature/freight/presentation/widgets/stateful_freight_dropdown.dart';
import 'package:clean_architecture/feature/freight/presentation/widgets/freight_section.dart';
import 'package:clean_architecture/feature/freight/presentation/widgets/truck_type_selector.dart';
import 'package:clean_architecture/feature/freight/presentation/widgets/pricing_type_selector.dart';
import 'package:clean_architecture/feature/freight/presentation/widgets/image_upload_section.dart';
import 'package:clean_architecture/feature/freight/presentation/widgets/step_indicator.dart';
import 'package:clean_architecture/feature/freight/presentation/bloc/cargoType/cargo_type_event.dart';

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
  String _selectedTruckType = 'BOX';
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

  // Location state with proper state management
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
    // Check current BLoC states on initialization
    _checkInitialCargoTypeState();
    _checkInitialLocationState();
  }

  void _checkInitialCargoTypeState() {
    final cargoTypeState = context.read<CargoTypeBloc>().state;
    if (cargoTypeState is CargoTypeLoaded) {
      setState(() {
        _isLoadingCargoTypes = false;
        _cargoTypesError = null;
        _cargoTypes = cargoTypeState.cargoTypes
            .map((e) => e.cargoType ?? '')
            .where((t) => t.isNotEmpty)
            .toList();
      });
    } else if (cargoTypeState is CargoTypeError) {
      setState(() {
        _isLoadingCargoTypes = false;
        _cargoTypesError = cargoTypeState.message;
      });
    } else if (cargoTypeState is CargoTypeLoading) {
      setState(() {
        _isLoadingCargoTypes = true;
        _cargoTypesError = null;
      });
    }
  }

  void _checkInitialLocationState() {
    final locationState = context.read<LocationBloc>().state;
    if (locationState is LocationLoaded) {
      setState(() {
        _isLoadingLocations = false;
        _locationsError = null;
        _regions = locationState.regions;
      });
    } else if (locationState is LocationError) {
      setState(() {
        _isLoadingLocations = false;
        _locationsError = locationState.message;
      });
    } else if (locationState is LocationLoading) {
      setState(() {
        _isLoadingLocations = true;
        _locationsError = null;
      });
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

  // Step tracking
  int get _currentStep {
    if (_descriptionController.text.isEmpty ||
        _weightController.text.isEmpty ||
        _quantityController.text.isEmpty) {
      return 1;
    }

    if (_selectedPickupRegion == null ||
        _selectedPickupCity == null ||
        _pickupAddressController.text.isEmpty ||
        _selectedDropoffRegion == null ||
        _selectedDropoffCity == null ||
        _dropoffAddressController.text.isEmpty ||
        _pickupDateController.text.isEmpty ||
        _deliveryDeadlineController.text.isEmpty) {
      return 2;
    }

    return 3;
  }

  String get _stepDescription {
    switch (_currentStep) {
      case 1:
        return 'Cargo Details';
      case 2:
        return 'Route & Schedule';
      case 3:
        return 'Requirements & Pricing';
      default:
        return 'Details';
    }
  }

  void _publishFreight() {
    if (_formKey.currentState!.validate()) {
      if (!_validateAllFields()) return;
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
          description: _descriptionController.text,
          weightKg: double.parse(_weightController.text),
          quantity: int.parse(_quantityController.text),
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
          type: _selectedTruckType,
          minCapacityKg: double.parse(_capacityController.text),
        ),
        pricing: Pricing(
          type: _selectedPricingType.toUpperCase(),
          amount: double.parse(_priceController.text),
        ),
        image: _uploadedImageUrls,
      );

      context.read<FreightBloc>().add(CreateFreightEvent(request));
    }
  }

  bool _validateAllFields() {
    if (_descriptionController.text.isEmpty ||
        _weightController.text.isEmpty ||
        _quantityController.text.isEmpty ||
        _selectedCargoType == null ||
        _selectedPickupRegion == null ||
        _selectedPickupCity == null ||
        _pickupAddressController.text.isEmpty ||
        _selectedDropoffRegion == null ||
        _selectedDropoffCity == null ||
        _dropoffAddressController.text.isEmpty ||
        _pickupDateController.text.isEmpty ||
        _deliveryDeadlineController.text.isEmpty ||
        _capacityController.text.isEmpty ||
        _priceController.text.isEmpty) {
      _showToast("Please fill in all required fields", Colors.red);
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
      _showToast(
        "Please wait for all images to finish uploading",
        Colors.orange,
      );
      return false;
    }

    return true;
  }

  DateTime? _parseDate(String dateStr) {
    try {
      final parts = dateStr.split('/');
      if (parts.length == 3) {
        return DateTime(
          int.parse(parts[2]),
          int.parse(parts[0]),
          int.parse(parts[1]),
        );
      }
      return null;
    } catch (e) {
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
    final DateTime? picked = await showDatePicker(
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
        final File imageFile = File(image.path);
        final int fileSizeInBytes = await imageFile.length();
        final double fileSizeInMB = fileSizeInBytes / (1024 * 1024);

        if (fileSizeInMB > 5.0) {
          _showToast(
            'Image size must be less than 5MB. Current: ${fileSizeInMB.toStringAsFixed(1)}MB',
            Colors.red,
          );
          return;
        }

        setState(() {
          _selectedImages.add(imageFile);
        });

        _showToast(
          'Image added (${_selectedImages.length}/$_maxImages)',
          Colors.green,
        );

        _uploadNewImage(imageFile);
      }
    } catch (e) {
      _showToast('Failed to pick image: ${e.toString()}', Colors.red);
    }
  }

  void _uploadNewImage(File imageFile) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final basePath = 'freights/freight_$timestamp';

    context.read<UploadBloc>().add(
      UploadSingleFileEvent(file: imageFile, path: basePath),
    );
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
      if (index < _uploadedImageUrls.length) {
        _uploadedImageUrls.removeAt(index);
      }
    });
    _showToast(
      'Image removed (${_selectedImages.length}/$_maxImages)',
      Colors.green,
    );
  }

  // State management helpers
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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = isDarkMode ? AppColorScheme.dark : AppColorScheme.light;

    return MultiBlocListener(
      listeners: [
        _buildFreightBlocListener(),
        _buildLocationBlocListener(),
        _buildUploadBlocListener(),
        _buildCargoTypeBlocListener(),
      ],
      child: Scaffold(
        backgroundColor: colorScheme.background,
        appBar: _buildAppBar(colorScheme),
        body: BlocBuilder<FreightBloc, FreightState>(
          builder: (context, state) {
            // final isLoading = state is FreightLoading;
            return Stack(
              children: [
                _buildForm(colorScheme),
                // if (isLoading) _buildLoadingOverlay(),
              ],
            );
          },
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(AppColorScheme colorScheme) {
    return AppBar(
      backgroundColor: colorScheme.background,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: colorScheme.textPrimary),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'Post Freight',
        style: TextStyle(
          color: colorScheme.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: colorScheme.border),
      ),
    );
  }

  Widget _buildForm(AppColorScheme colorScheme) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(SizeManager.s16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StepIndicator(
              colorScheme: colorScheme,
              currentStep: _currentStep,
              stepDescription: _stepDescription,
            ),
            const SizedBox(height: SizeManager.s24),
            _buildCargoDetailsSection(colorScheme),
            const SizedBox(height: SizeManager.s16),
            _buildRouteSection(colorScheme),
            const SizedBox(height: SizeManager.s16),
            _buildScheduleSection(colorScheme),
            const SizedBox(height: SizeManager.s16),
            _buildTruckRequirementsSection(colorScheme),
            const SizedBox(height: SizeManager.s16),
            _buildPricingSection(colorScheme),
            const SizedBox(height: SizeManager.s16),
            _buildImageUploadSection(colorScheme),
            const SizedBox(height: SizeManager.s24),
            _buildPublishButton(),
            const SizedBox(height: SizeManager.s24),
          ],
        ),
      ),
    );
  }

  Widget _buildCargoDetailsSection(AppColorScheme colorScheme) {
    return FreightSection(
      colorScheme: colorScheme,
      icon: Icons.inventory_2,
      title: 'Cargo Details',
      child: Column(
        children: [
          StatefulFreightDropdown(
            colorScheme: colorScheme,
            value: _selectedCargoType,
            label: 'Cargo Type *',
            hint: 'Select cargo type',
            items: _cargoTypes,
            onChanged: (value) => setState(() => _selectedCargoType = value),
            state: _getCargoTypeDropdownState(),
            errorMessage: _cargoTypesError,
            onRetry: _retryLoadCargoTypes,
          ),
          const SizedBox(height: SizeManager.s16),
          FreightFormField(
            colorScheme: colorScheme,
            controller: _descriptionController,
            label: 'Description *',
            hint: 'Enter cargo description',
            maxLines: 3,
          ),
          const SizedBox(height: SizeManager.s16),
          Row(
            children: [
              Expanded(
                child: FreightFormField(
                  colorScheme: colorScheme,
                  controller: _weightController,
                  label: 'Weight (kg) *',
                  hint: 'e.g., 1000',
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: SizeManager.s12),
              Expanded(
                child: FreightFormField(
                  colorScheme: colorScheme,
                  controller: _quantityController,
                  label: 'Quantity *',
                  hint: 'e.g., 10',
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRouteSection(AppColorScheme colorScheme) {
    return FreightSection(
      colorScheme: colorScheme,
      icon: Icons.route,
      title: 'Route Information',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pickup Location',
            style: TextStyle(
              color: colorScheme.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: SizeManager.s12),
          StatefulFreightDropdown(
            colorScheme: colorScheme,
            value: _selectedPickupRegion,
            label: 'Region *',
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
          StatefulFreightDropdown(
            colorScheme: colorScheme,
            value: _selectedPickupCity,
            label: 'City *',
            hint: _selectedPickupRegion == null
                ? 'Select region first'
                : 'Select city',
            items: _pickupCities,
            onChanged: (value) => setState(() => _selectedPickupCity = value),
            state: _selectedPickupRegion == null
                ? DropdownState.initial
                : (_pickupCities.isEmpty
                      ? DropdownState.empty
                      : DropdownState.loaded),
          ),
          const SizedBox(height: SizeManager.s16),
          FreightFormField(
            colorScheme: colorScheme,
            controller: _pickupAddressController,
            label: 'Address *',
            hint: 'Enter pickup address',
          ),
          const SizedBox(height: SizeManager.s24),
          Text(
            'Dropoff Location',
            style: TextStyle(
              color: colorScheme.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: SizeManager.s12),
          StatefulFreightDropdown(
            colorScheme: colorScheme,
            value: _selectedDropoffRegion,
            label: 'Region *',
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
          StatefulFreightDropdown(
            colorScheme: colorScheme,
            value: _selectedDropoffCity,
            label: 'City *',
            hint: _selectedDropoffRegion == null
                ? 'Select region first'
                : 'Select city',
            items: _dropoffCities,
            onChanged: (value) => setState(() => _selectedDropoffCity = value),
            state: _selectedDropoffRegion == null
                ? DropdownState.initial
                : (_dropoffCities.isEmpty
                      ? DropdownState.empty
                      : DropdownState.loaded),
          ),
          const SizedBox(height: SizeManager.s16),
          FreightFormField(
            colorScheme: colorScheme,
            controller: _dropoffAddressController,
            label: 'Address *',
            hint: 'Enter dropoff address',
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleSection(AppColorScheme colorScheme) {
    return FreightSection(
      colorScheme: colorScheme,
      icon: Icons.calendar_today,
      title: 'Schedule',
      child: Column(
        children: [
          FreightFormField(
            colorScheme: colorScheme,
            controller: _pickupDateController,
            label: 'Pickup Date *',
            hint: 'MM/DD/YYYY',
            readOnly: true,
            onTap: () => _selectDate(context, _pickupDateController),
            suffixIcon: const Icon(Icons.calendar_today, size: 20),
          ),
          const SizedBox(height: SizeManager.s16),
          FreightFormField(
            colorScheme: colorScheme,
            controller: _deliveryDeadlineController,
            label: 'Delivery Deadline *',
            hint: 'MM/DD/YYYY',
            readOnly: true,
            onTap: () => _selectDate(context, _deliveryDeadlineController),
            suffixIcon: const Icon(Icons.calendar_today, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildTruckRequirementsSection(AppColorScheme colorScheme) {
    return FreightSection(
      colorScheme: colorScheme,
      icon: Icons.local_shipping,
      title: 'Truck Requirements',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Truck Type *',
            style: TextStyle(
              color: colorScheme.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: SizeManager.s12),
          TruckTypeSelector(
            colorScheme: colorScheme,
            selectedType: _selectedTruckType,
            onTypeSelected: (type) => setState(() => _selectedTruckType = type),
          ),
          const SizedBox(height: SizeManager.s16),
          FreightFormField(
            colorScheme: colorScheme,
            controller: _capacityController,
            label: 'Minimum Capacity (kg) *',
            hint: 'e.g., 5000',
            keyboardType: TextInputType.number,
          ),
        ],
      ),
    );
  }

  Widget _buildPricingSection(AppColorScheme colorScheme) {
    return FreightSection(
      colorScheme: colorScheme,
      icon: Icons.attach_money,
      title: 'Pricing',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pricing Type *',
            style: TextStyle(
              color: colorScheme.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: SizeManager.s12),
          PricingTypeSelector(
            colorScheme: colorScheme,
            selectedType: _selectedPricingType,
            onTypeSelected: (type) =>
                setState(() => _selectedPricingType = type),
          ),
          const SizedBox(height: SizeManager.s16),
          FreightFormField(
            colorScheme: colorScheme,
            controller: _priceController,
            label: 'Amount (ETB) *',
            hint: 'e.g., 50000',
            keyboardType: TextInputType.number,
          ),
        ],
      ),
    );
  }

  Widget _buildImageUploadSection(AppColorScheme colorScheme) {
    return FreightSection(
      colorScheme: colorScheme,
      icon: Icons.image,
      title: 'Freight Images',
      child: ImageUploadSection(
        colorScheme: colorScheme,
        selectedImages: _selectedImages,
        uploadedImageUrls: _uploadedImageUrls,
        isUploading: _isUploadingImages,
        maxImages: _maxImages,
        onPickImage: _pickImage,
        onRemoveImage: _removeImage,
      ),
    );
  }

  Widget _buildPublishButton() {
    return BlocBuilder<FreightBloc, FreightState>(
      builder: (context, state) {
        final isLoading = state is FreightLoading;
        return SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: isLoading ? null : _publishFreight,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              disabledBackgroundColor: AppColors.grey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(SizeManager.r6),
              ),
            ),
            child: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: AppColors.white,
                      strokeWidth: 2,
                    ),
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

  // Widget _buildLoadingOverlay() {
  //   return Container(
  //     color: Colors.black.withValues(alpha: 0.3),
  //     child: const Center(
  //       child: CircularProgressIndicator(color: AppColors.primary),
  //     ),
  //   );
  // }

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
            _locationsError = null;
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
          setState(() {
            _isUploadingImages = true;
          });
        } else if (state is UploadSuccess) {
          setState(() {
            _isUploadingImages = false;
            _uploadedImageUrls.addAll(state.uploadedUrls);
          });
          for (int i = 0; i < state.uploadedUrls.length; i++) {}
          _showToast(
            'Image uploaded successfully! (${_uploadedImageUrls.length} total)',
            Colors.green,
          );
          context.read<UploadBloc>().add(const ResetUploadEvent());
        } else if (state is UploadError) {
          setState(() {
            _isUploadingImages = false;
          });
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
            _cargoTypesError = null;
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
