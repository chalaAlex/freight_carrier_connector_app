import 'dart:io';
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
import 'package:clean_architecture/feature/freight/presentation/bloc/location/location_event.dart';
import 'package:clean_architecture/feature/freight/presentation/bloc/location/location_state.dart';
import 'package:clean_architecture/feature/freight/presentation/bloc/upload/upload_bloc.dart';
import 'package:clean_architecture/feature/freight/presentation/bloc/upload/upload_event.dart';
import 'package:clean_architecture/feature/freight/presentation/bloc/upload/upload_state.dart';
import 'package:clean_architecture/feature/freight/domain/entity/location_entity.dart';

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
  List<String> _uploadedImageUrls = [];
  bool _isUploadingImages = false;

  // Location state
  List<RegionEntity> _regions = [];
  String? _selectedPickupRegion;
  String? _selectedPickupCity;
  String? _selectedDropoffRegion;
  String? _selectedDropoffCity;
  List<String> _pickupCities = [];
  List<String> _dropoffCities = [];

  // Step tracking
  int get _currentStep {
    // Step 1: Cargo Details
    if (_descriptionController.text.isEmpty ||
        _weightController.text.isEmpty ||
        _quantityController.text.isEmpty) {
      return 1;
    }

    // Step 2: Route & Schedule
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

    // Step 3: Requirements & Pricing
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

  double get _progressPercentage {
    return _currentStep / 3;
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
    if (_formKey.currentState!.validate()) {
      // Validate required fields
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
        Fluttertoast.showToast(
          msg: "Please fill in all required fields",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        return;
      }

      // Parse dates
      final pickupDate = _parseDate(_pickupDateController.text);
      final deliveryDeadline = _parseDate(_deliveryDeadlineController.text);

      if (pickupDate == null || deliveryDeadline == null) {
        Fluttertoast.showToast(
          msg: "Invalid date format",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        return;
      }

      // Create request object
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
      );
      // Dispatch event to BLoC
      context.read<FreightBloc>().add(CreateFreightEvent(request));
    }
  }

  DateTime? _parseDate(String dateStr) {
    try {
      // Expected format: mm/dd/yyyy
      final parts = dateStr.split('/');
      if (parts.length == 3) {
        final month = int.parse(parts[0]);
        final day = int.parse(parts[1]);
        final year = int.parse(parts[2]);
        return DateTime(year, month, day);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = isDarkMode ? AppColorScheme.dark : AppColorScheme.light;

    return MultiBlocListener(
      listeners: [
        BlocListener<FreightBloc, FreightState>(
          listener: (context, state) {
            if (state is FreightCreateSuccess) {
              Fluttertoast.showToast(
                msg: "Freight published successfully!",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.green,
                textColor: Colors.white,
              );
              Navigator.pop(context);
            } else if (state is FreightError) {
              Fluttertoast.showToast(
                msg: state.message,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.red,
                textColor: Colors.white,
              );
            }
          },
        ),
        BlocListener<LocationBloc, LocationState>(
          listener: (context, state) {
            if (state is LocationLoaded) {
              setState(() {
                _regions = state.regions;
              });
            }
          },
        ),
        BlocListener<UploadBloc, UploadState>(
          listener: (context, state) {
            if (state is UploadLoading) {
              setState(() {
                _isUploadingImages = true;
              });
              print(
                '📤 Uploading images: ${state.currentIndex}/${state.totalFiles}',
              );
            } else if (state is UploadSuccess) {
              setState(() {
                _isUploadingImages = false;
                // Accumulate URLs instead of replacing them
                _uploadedImageUrls.addAll(state.uploadedUrls);
              });
              print('✅ Upload successful!');
              print('📸 Uploaded image URLs:');
              for (int i = 0; i < state.uploadedUrls.length; i++) {
                print('   Image ${i + 1}: ${state.uploadedUrls[i]}');
              }
              _showSuccesToastMessage(
                'Image uploaded successfully! (${_uploadedImageUrls.length} total)',
              );

              // Reset upload state after handling
              context.read<UploadBloc>().add(const ResetUploadEvent());
            } else if (state is UploadError) {
              setState(() {
                _isUploadingImages = false;
              });
              print('❌ Upload failed: ${state.message}');
              _showErrorSnackBar('Upload failed: ${state.message}');

              // Reset upload state after handling
              context.read<UploadBloc>().add(const ResetUploadEvent());
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: colorScheme.background,
        appBar: _buildAppBar(colorScheme),
        body: BlocBuilder<FreightBloc, FreightState>(
          builder: (context, state) {
            final isLoading = state is FreightLoading;
            return Stack(
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(SizeManager.s16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildStepIndicator(),
                          const SizedBox(height: SizeManager.s24),
                          _buildCargoDetailsSection(colorScheme),
                          const SizedBox(height: SizeManager.s24),
                          _buildRouteInformationSection(colorScheme),
                          const SizedBox(height: SizeManager.s24),
                          _buildScheduleSection(colorScheme),
                          const SizedBox(height: SizeManager.s24),
                          _buildTruckRequirementsSection(colorScheme),
                          const SizedBox(height: SizeManager.s24),
                          _buildPricingSection(colorScheme),
                          const SizedBox(height: SizeManager.s32),
                          _buildImageUpload(colorScheme),
                          const SizedBox(height: SizeManager.s32),
                          _buildPublishButton(isLoading),
                          const SizedBox(height: SizeManager.s24),
                        ],
                      ),
                    ),
                  ),
                ),
                if (isLoading)
                  Container(
                    // ignore: deprecated_member_use
                    color: Colors.black.withOpacity(0.3),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
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
      actions: [
        TextButton(
          onPressed: () {},
          child: const Text(
            'Save Draft',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStepIndicator() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Step $_currentStep of 3: $_stepDescription',
              style: const TextStyle(
                color: AppColors.grey,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: SizeManager.s12,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                // ignore: deprecated_member_use
                color: AppColors.primary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'REQUIRED',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: SizeManager.s12),
        // Progress bar
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: _progressPercentage,
            // ignore: deprecated_member_use
            backgroundColor: AppColors.grey.withOpacity(0.2),
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            minHeight: 6,
          ),
        ),
      ],
    );
  }

  Widget _buildCargoDetailsSection(AppColorScheme colorScheme) {
    return _buildSection(
      colorScheme: colorScheme,
      icon: Icons.inventory_2_outlined,
      title: 'CARGO DETAILS',
      children: [
        _buildLabel(colorScheme, 'CARGO TYPE'),
        const SizedBox(height: SizeManager.s8),
        BlocBuilder<CargoTypeBloc, CargoTypeState>(
          builder: (context, state) {
            if (state is CargoTypeLoading) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: SizeManager.s12,
                  vertical: SizeManager.s16,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.background,
                  borderRadius: BorderRadius.circular(SizeManager.r6),
                  border: Border.all(color: colorScheme.border, width: 1),
                ),
                child: const Center(
                  child: SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                      strokeWidth: 2,
                    ),
                  ),
                ),
              );
            }

            if (state is CargoTypeError) {
              return Container(
                padding: const EdgeInsets.all(SizeManager.s12),
                decoration: BoxDecoration(
                  color: colorScheme.background,
                  borderRadius: BorderRadius.circular(SizeManager.r6),
                  border: Border.all(color: AppColors.error, width: 1),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: AppColors.error,
                      size: 20,
                    ),
                    const SizedBox(width: SizeManager.s8),
                    Expanded(
                      child: Text(
                        state.message,
                        style: TextStyle(
                          color: colorScheme.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            if (state is CargoTypeLoaded) {
              final cargoTypes = state.cargoTypes
                  .map((e) => e.cargoType ?? '')
                  .where((e) => e.isNotEmpty)
                  .toList();

              return _buildDropdown(
                colorScheme: colorScheme,
                value: _selectedCargoType,
                items: cargoTypes,
                hint: 'Select Cargo Type',
                onChanged: (value) {
                  setState(() {
                    _selectedCargoType = value;
                  });
                },
              );
            }

            return _buildDropdown(
              colorScheme: colorScheme,
              value: _selectedCargoType,
              items: const [],
              hint: 'Select Cargo Type',
              onChanged: (value) {},
            );
          },
        ),
        const SizedBox(height: SizeManager.s16),
        _buildLabel(colorScheme, 'DESCRIPTION'),
        const SizedBox(height: SizeManager.s8),
        _buildTextField(
          colorScheme: colorScheme,
          controller: _descriptionController,
          hint: 'e.g. 500 boxes of electronics, fragile handling required',
          maxLines: 3,
        ),
        const SizedBox(height: SizeManager.s16),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel(colorScheme, 'WEIGHT (KG)'),
                  const SizedBox(height: SizeManager.s8),
                  _buildTextField(
                    colorScheme: colorScheme,
                    controller: _weightController,
                    hint: '0.00',
                    keyboardType: TextInputType.number,
                    prefixIcon: Icons.scale,
                  ),
                ],
              ),
            ),
            const SizedBox(width: SizeManager.s12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel(colorScheme, 'QUANTITY'),
                  const SizedBox(height: SizeManager.s8),
                  _buildTextField(
                    colorScheme: colorScheme,
                    controller: _quantityController,
                    hint: 'Units',
                    keyboardType: TextInputType.number,
                    prefixIcon: Icons.inventory,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRouteInformationSection(AppColorScheme colorScheme) {
    return _buildSection(
      colorScheme: colorScheme,
      icon: Icons.route,
      title: 'ROUTE INFORMATION',
      children: [
        BlocBuilder<LocationBloc, LocationState>(
          builder: (context, state) {
            if (state is LocationLoading) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(SizeManager.s32),
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              );
            }

            if (state is LocationError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(SizeManager.s16),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: AppColors.error,
                        size: 48,
                      ),
                      const SizedBox(height: SizeManager.s12),
                      Text(
                        state.message,
                        style: TextStyle(
                          color: colorScheme.textSecondary,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: SizeManager.s16),
                      ElevatedButton.icon(
                        onPressed: () {
                          context.read<LocationBloc>().add(
                            const FetchRegionsEvent(),
                          );
                        },
                        icon: const Icon(Icons.refresh, size: 18),
                        label: const Text('Retry'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: SizeManager.s16,
                            vertical: SizeManager.s8,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return Row(
              children: [
                Container(
                  width: 4,
                  height: 400,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [AppColors.success, AppColors.error],
                    ),
                  ),
                ),
                const SizedBox(width: SizeManager.s12),
                Expanded(
                  child: Column(
                    children: [
                      // Pickup Region Dropdown
                      _buildLabel(colorScheme, 'PICKUP REGION'),
                      const SizedBox(height: SizeManager.s8),
                      _buildDropdown(
                        colorScheme: colorScheme,
                        value: _selectedPickupRegion,
                        items: _regions
                            .map((r) => r.region ?? '')
                            .where((r) => r.isNotEmpty)
                            .toList(),
                        hint: 'Select Pickup Region',
                        onChanged: (value) {
                          setState(() {
                            _selectedPickupRegion = value;
                            _selectedPickupCity = null;
                            _pickupCities =
                                _regions
                                    .firstWhere((r) => r.region == value)
                                    .cities ??
                                [];
                          });
                        },
                      ),
                      const SizedBox(height: SizeManager.s12),
                      // Pickup City Dropdown
                      _buildLabel(colorScheme, 'PICKUP CITY'),
                      const SizedBox(height: SizeManager.s8),
                      _buildDropdown(
                        colorScheme: colorScheme,
                        value: _selectedPickupCity,
                        items: _pickupCities,
                        hint: 'Select Pickup City',
                        onChanged: (value) {
                          setState(() {
                            _selectedPickupCity = value;
                          });
                        },
                      ),
                      const SizedBox(height: SizeManager.s12),
                      // Pickup Address
                      _buildLabel(colorScheme, 'PICKUP ADDRESS'),
                      const SizedBox(height: SizeManager.s8),
                      _buildTextField(
                        colorScheme: colorScheme,
                        controller: _pickupAddressController,
                        hint: 'Enter pickup address',
                      ),
                      const SizedBox(height: SizeManager.s16),
                      // Dropoff Region Dropdown
                      _buildLabel(colorScheme, 'DROP-OFF REGION'),
                      const SizedBox(height: SizeManager.s8),
                      _buildDropdown(
                        colorScheme: colorScheme,
                        value: _selectedDropoffRegion,
                        items: _regions
                            .map((r) => r.region ?? '')
                            .where((r) => r.isNotEmpty)
                            .toList(),
                        hint: 'Select Drop-off Region',
                        onChanged: (value) {
                          setState(() {
                            _selectedDropoffRegion = value;
                            _selectedDropoffCity = null;
                            _dropoffCities =
                                _regions
                                    .firstWhere((r) => r.region == value)
                                    .cities ??
                                [];
                          });
                        },
                      ),
                      const SizedBox(height: SizeManager.s12),
                      // Dropoff City Dropdown
                      _buildLabel(colorScheme, 'DROP-OFF CITY'),
                      const SizedBox(height: SizeManager.s8),
                      _buildDropdown(
                        colorScheme: colorScheme,
                        value: _selectedDropoffCity,
                        items: _dropoffCities,
                        hint: 'Select Drop-off City',
                        onChanged: (value) {
                          setState(() {
                            _selectedDropoffCity = value;
                          });
                        },
                      ),
                      const SizedBox(height: SizeManager.s12),
                      // Dropoff Address
                      _buildLabel(colorScheme, 'DROP-OFF ADDRESS'),
                      const SizedBox(height: SizeManager.s8),
                      _buildTextField(
                        colorScheme: colorScheme,
                        controller: _dropoffAddressController,
                        hint: 'Enter drop-off address',
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildScheduleSection(AppColorScheme colorScheme) {
    return _buildSection(
      colorScheme: colorScheme,
      icon: Icons.calendar_today,
      title: 'SCHEDULE',
      children: [
        _buildLabel(colorScheme, 'PICKUP DATE'),
        const SizedBox(height: SizeManager.s8),
        _buildTextField(
          colorScheme: colorScheme,
          controller: _pickupDateController,
          hint: 'mm/dd/yyyy, --:--',
          readOnly: true,
          suffixIcon: Icons.calendar_today,
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
            );
            if (date != null) {
              _pickupDateController.text =
                  '${date.month}/${date.day}/${date.year}';
            }
          },
        ),
        const SizedBox(height: SizeManager.s16),
        _buildLabel(colorScheme, 'DELIVERY DEADLINE'),
        const SizedBox(height: SizeManager.s8),
        _buildTextField(
          colorScheme: colorScheme,
          controller: _deliveryDeadlineController,
          hint: 'mm/dd/yyyy, --:--',
          readOnly: true,
          suffixIcon: Icons.calendar_today,
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
            );
            if (date != null) {
              _deliveryDeadlineController.text =
                  '${date.month}/${date.day}/${date.year}';
            }
          },
        ),
      ],
    );
  }

  Widget _buildTruckRequirementsSection(AppColorScheme colorScheme) {
    return _buildSection(
      colorScheme: colorScheme,
      icon: Icons.local_shipping,
      title: 'TRUCK REQUIREMENTS',
      children: [
        Row(
          children: [
            _buildTruckTypeChip(colorScheme, 'BOX', Icons.inventory_2),
            const SizedBox(width: SizeManager.s8),
            _buildTruckTypeChip(colorScheme, 'FLATBED', Icons.view_agenda),
            const SizedBox(width: SizeManager.s8),
            _buildTruckTypeChip(colorScheme, 'REEFER', Icons.ac_unit),
          ],
        ),
        const SizedBox(height: SizeManager.s12),
        _buildTruckTypeChip(colorScheme, 'TANKER', Icons.water_drop),
        const SizedBox(height: SizeManager.s16),
        _buildLabel(colorScheme, 'REQUIRED CAPACITY (TONS)'),
        const SizedBox(height: SizeManager.s8),
        _buildTextField(
          colorScheme: colorScheme,
          controller: _capacityController,
          hint: 'e.g. 1h',
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }

  Widget _buildPricingSection(AppColorScheme colorScheme) {
    return _buildSection(
      colorScheme: colorScheme,
      icon: Icons.attach_money,
      title: 'PRICING',
      children: [
        Row(
          children: [
            Expanded(child: _buildPricingTypeButton(colorScheme, 'Fixed')),
            const SizedBox(width: SizeManager.s12),
            Expanded(child: _buildPricingTypeButton(colorScheme, 'Negotiable')),
          ],
        ),
        const SizedBox(height: SizeManager.s16),
        _buildLabel(colorScheme, 'OFFERED PRICE (ETB)'),
        const SizedBox(height: SizeManager.s8),
        _buildTextField(
          colorScheme: colorScheme,
          controller: _priceController,
          hint: 'ETB 0.00',
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: SizeManager.s8),
        Text(
          'Exclusive of taxes and any local fees',
          style: TextStyle(color: colorScheme.textSecondary, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildSection({
    required AppColorScheme colorScheme,
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(SizeManager.s16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(SizeManager.r12),
        border: Border.all(color: colorScheme.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 20),
              const SizedBox(width: SizeManager.s8),
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: SizeManager.s16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildLabel(AppColorScheme colorScheme, String text) {
    return Text(
      text,
      style: TextStyle(
        color: colorScheme.textSecondary,
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildTextField({
    required AppColorScheme colorScheme,
    required TextEditingController controller,
    required String hint,
    IconData? prefixIcon,
    IconData? suffixIcon,
    int maxLines = 1,
    TextInputType? keyboardType,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      readOnly: readOnly,
      onTap: onTap,
      onChanged: (_) => setState(() {}), // Update step indicator
      style: TextStyle(color: colorScheme.textPrimary, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          // ignore: deprecated_member_use
          color: colorScheme.textSecondary.withOpacity(0.5),
          fontSize: 14,
        ),
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: colorScheme.textSecondary, size: 20)
            : null,
        suffixIcon: suffixIcon != null
            ? Icon(suffixIcon, color: colorScheme.textSecondary, size: 20)
            : null,
        filled: true,
        fillColor: colorScheme.background,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SizeManager.r6),
          borderSide: BorderSide(color: colorScheme.border, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SizeManager.r6),
          borderSide: BorderSide(color: colorScheme.border, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SizeManager.r6),
          borderSide: const BorderSide(color: AppColors.primary, width: 1),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: SizeManager.s12,
          vertical: SizeManager.s12,
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required AppColorScheme colorScheme,
    required String? value,
    required List<String> items,
    required String hint,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: SizeManager.s12),
      decoration: BoxDecoration(
        color: colorScheme.background,
        borderRadius: BorderRadius.circular(SizeManager.r6),
        border: Border.all(color: colorScheme.border, width: 1),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          dropdownColor: colorScheme.surface,
          style: TextStyle(color: colorScheme.textPrimary, fontSize: 14),
          hint: Text(
            hint,
            style: TextStyle(
              // ignore: deprecated_member_use
              color: colorScheme.textSecondary.withOpacity(0.5),
              fontSize: 14,
            ),
          ),
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: colorScheme.textSecondary,
          ),
          items: items.map((String item) {
            return DropdownMenuItem<String>(value: item, child: Text(item));
          }).toList(),
          onChanged: items.isEmpty ? null : onChanged,
        ),
      ),
    );
  }

  Widget _buildTruckTypeChip(
    AppColorScheme colorScheme,
    String label,
    IconData icon,
  ) {
    final isSelected = _selectedTruckType == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTruckType = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: SizeManager.s12,
          vertical: SizeManager.s8,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : colorScheme.background,
          borderRadius: BorderRadius.circular(SizeManager.r6),
          border: Border.all(
            color: isSelected ? AppColors.primary : colorScheme.border,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.white : colorScheme.textSecondary,
              size: 16,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.white : colorScheme.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPricingTypeButton(AppColorScheme colorScheme, String type) {
    final isSelected = _selectedPricingType == type;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPricingType = type;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: SizeManager.s12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : colorScheme.background,
          borderRadius: BorderRadius.circular(SizeManager.r6),
          border: Border.all(
            color: isSelected ? AppColors.primary : colorScheme.border,
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            type,
            style: TextStyle(
              color: isSelected ? AppColors.white : colorScheme.textSecondary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageUpload(AppColorScheme colorScheme) {
    return _buildSection(
      colorScheme: colorScheme,
      icon: Icons.camera_alt_outlined,
      title: 'FREIGHT IMAGES (OPTIONAL)',
      children: [
        _buildLabel(colorScheme, 'ADD PHOTOS OF YOUR FREIGHT'),
        const SizedBox(height: SizeManager.s8),
        Text(
          'Add up to $_maxImages photos to help carriers understand your freight better',
          style: TextStyle(color: colorScheme.textSecondary, fontSize: 12),
        ),
        const SizedBox(height: SizeManager.s16),

        // Image grid
        if (_selectedImages.isNotEmpty) ...[
          _buildImageGrid(colorScheme),
          const SizedBox(height: SizeManager.s16),
        ],

        // Upload status
        if (_uploadedImageUrls.isNotEmpty) ...[
          Container(
            padding: const EdgeInsets.all(SizeManager.s12),
            decoration: BoxDecoration(
              // ignore: deprecated_member_use
              color: AppColors.success.withOpacity(0.1),
              borderRadius: BorderRadius.circular(SizeManager.r6),
              // ignore: deprecated_member_use
              border: Border.all(color: AppColors.success.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.cloud_done,
                  color: AppColors.success,
                  size: 20,
                ),
                const SizedBox(width: SizeManager.s8),
                Expanded(
                  child: Text(
                    '${_uploadedImageUrls.length} images uploaded to cloud',
                    style: const TextStyle(
                      color: AppColors.success,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: SizeManager.s16),
        ],

        // Add image buttons
        if (_selectedImages.length < _maxImages) ...[
          Row(
            children: [
              Expanded(
                child: _buildImageSourceButton(
                  colorScheme: colorScheme,
                  icon: Icons.camera_alt,
                  label: 'Camera',
                  onTap: () => _pickImage(ImageSource.camera),
                ),
              ),
              const SizedBox(width: SizeManager.s12),
              Expanded(
                child: _buildImageSourceButton(
                  colorScheme: colorScheme,
                  icon: Icons.photo_library,
                  label: 'Gallery',
                  onTap: () => _pickImage(ImageSource.gallery),
                ),
              ),
            ],
          ),
        ] else ...[
          Container(
            padding: const EdgeInsets.all(SizeManager.s12),
            decoration: BoxDecoration(
              // ignore: deprecated_member_use
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(SizeManager.r6),
              // ignore: deprecated_member_use
              border: Border.all(color: AppColors.primary.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.check_circle,
                  color: AppColors.primary,
                  size: 20,
                ),
                const SizedBox(width: SizeManager.s8),
                Text(
                  'Maximum $_maxImages images added',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],

        // Note: Upload button removed - images are uploaded automatically when selected
      ],
    );
  }

  Widget _buildImageGrid(AppColorScheme colorScheme) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: SizeManager.s8,
        mainAxisSpacing: SizeManager.s8,
        childAspectRatio: 1,
      ),
      itemCount: _selectedImages.length,
      itemBuilder: (context, index) {
        return _buildImageItem(colorScheme, index);
      },
    );
  }

  Widget _buildImageItem(AppColorScheme colorScheme, int index) {
    final bool isUploaded = index < _uploadedImageUrls.length;
    final bool isUploading =
        _isUploadingImages && index == _selectedImages.length - 1;

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(SizeManager.r6),
            border: Border.all(color: colorScheme.border),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(SizeManager.r6),
            child: Image.file(
              _selectedImages[index],
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
        ),
        // Upload status indicator
        if (isUploading)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(SizeManager.r6),
                color: Colors.black.withValues(alpha: 0.5),
              ),
              child: const Center(
                child: CircularProgressIndicator(
                  color: AppColors.white,
                  strokeWidth: 3,
                ),
              ),
            ),
          ),
        // Uploaded checkmark
        if (isUploaded && !isUploading)
          Positioned(
            bottom: 4,
            left: 4,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: AppColors.success,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: AppColors.white, size: 16),
            ),
          ),
        // Remove button
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: () => _removeImage(index),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: AppColors.error,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, color: AppColors.white, size: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImageSourceButton({
    required AppColorScheme colorScheme,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: SizeManager.s16),
        decoration: BoxDecoration(
          color: colorScheme.background,
          borderRadius: BorderRadius.circular(SizeManager.r6),
          border: Border.all(color: colorScheme.border, width: 1),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary, size: 32),
            const SizedBox(height: SizeManager.s8),
            Text(
              label,
              style: TextStyle(
                color: colorScheme.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
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

        // Check file size (limit to 5MB)
        final int fileSizeInBytes = await imageFile.length();
        final double fileSizeInMB = fileSizeInBytes / (1024 * 1024);

        if (fileSizeInMB > 5.0) {
          _showErrorSnackBar(
            'Image size must be less than 5MB. Current size: ${fileSizeInMB.toStringAsFixed(1)}MB',
          );
          return;
        }

        setState(() {
          _selectedImages.add(imageFile);
        });
        _showSuccesToastMessage(
          'Image added successfully (${_selectedImages.length}/$_maxImages)',
        );

        // Automatically upload the newly added image
        _uploadNewImage(imageFile);
      }
    } catch (e) {
      _showErrorSnackBar('Failed to pick image: ${e.toString()}');
    }
  }

  void _uploadNewImage(File imageFile) {
    print('🚀 Auto-uploading new image...');

    // Generate unique base path for this image
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final basePath = 'freights/freight_$timestamp';

    // Trigger upload via BLoC for single file
    context.read<UploadBloc>().add(
      UploadSingleFileEvent(file: imageFile, path: basePath),
    );
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
      // Also remove the corresponding uploaded URL if it exists
      if (index < _uploadedImageUrls.length) {
        _uploadedImageUrls.removeAt(index);
      }
    });
    _showSuccesToastMessage(
      'Image removed (${_selectedImages.length}/$_maxImages)',
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showSuccesToastMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }

  Widget _buildPublishButton(bool isLoading) {
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
            borderRadius: BorderRadius.circular(SizeManager.r12),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'Publish Freight',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(width: 8),
            Icon(Icons.arrow_forward, size: 20),
          ],
        ),
      ),
    );
  }
}
