import 'package:clean_architecture/cofig/context_extensions.dart';
import 'package:clean_architecture/cofig/routes_manager.dart';
import 'package:clean_architecture/cofig/size_manager.dart';
import 'package:clean_architecture/core/di.dart';
import 'package:clean_architecture/core/network/api_client.dart';
import 'package:clean_architecture/core/widgets/ai_suggestion_sheet.dart';
import 'package:clean_architecture/feature/carrier_owner_module/carriers/presentation/bloc/carrier_registration_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegisterCarrierStep1Screen extends StatefulWidget {
  const RegisterCarrierStep1Screen({super.key});

  @override
  State<RegisterCarrierStep1Screen> createState() =>
      _RegisterCarrierStep1ScreenState();
}

class _RegisterCarrierStep1ScreenState
    extends State<RegisterCarrierStep1Screen> {
  final _formKey = GlobalKey<FormState>();

  final _brandController = TextEditingController();
  final _modelController = TextEditingController();
  final _plateController = TextEditingController();
  final _loadCapacityController = TextEditingController();
  final _startLocationController = TextEditingController();
  final _destinationController = TextEditingController();
  final _aboutTruckController = TextEditingController();

  static const _availableFeatures = [
    'AC',
    'GPS',
    'Refrigerated',
    'Flatbed',
    'Tanker',
    'Crane',
  ];

  final Set<String> _selectedFeatures = {};

  @override
  void dispose() {
    _brandController.dispose();
    _modelController.dispose();
    _plateController.dispose();
    _loadCapacityController.dispose();
    _startLocationController.dispose();
    _destinationController.dispose();
    _aboutTruckController.dispose();
    super.dispose();
  }

  void _onNext() {
    if (!_formKey.currentState!.validate()) return;

    final formData = CarrierRegistrationFormData(
      brand: _brandController.text.trim(),
      model: _modelController.text.trim(),
      plateNumber: _plateController.text.trim(),
      loadCapacity: double.parse(_loadCapacityController.text.trim()),
      features: _selectedFeatures.toList(),
      startLocation: _startLocationController.text.trim(),
      destinationLocation: _destinationController.text.trim(),
      aboutTruck: _aboutTruckController.text.trim(),
    );

    Navigator.pushNamed(
      context,
      Routes.registerCarrierStep2,
      arguments: formData,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.appColors;
    return Scaffold(
      backgroundColor: cs.background,
      appBar: AppBar(
        backgroundColor: cs.surface,
        elevation: 0,
        title: Text(
          'Register Carrier (1/2)',
          style: context.text.titleLarge?.copyWith(fontWeight: FontWeight.w700),
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
            _buildField(
              controller: _brandController,
              label: 'Brand',
              hint: 'e.g. Mercedes',
              validator: _requiredValidator,
            ),
            const SizedBox(height: SizeManager.s16),
            _buildField(
              controller: _modelController,
              label: 'Model',
              hint: 'e.g. Actros',
              validator: _requiredValidator,
            ),
            const SizedBox(height: SizeManager.s16),
            _buildField(
              controller: _plateController,
              label: 'Plate Number',
              hint: 'e.g. AA-12345',
              validator: _requiredValidator,
            ),
            const SizedBox(height: SizeManager.s16),
            _buildField(
              controller: _loadCapacityController,
              label: 'Load Capacity (kg)',
              hint: 'e.g. 5000',
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Required';
                final n = double.tryParse(v.trim());
                if (n == null || n <= 0) return 'Enter a valid capacity';
                return null;
              },
            ),
            const SizedBox(height: SizeManager.s16),
            _buildField(
              controller: _startLocationController,
              label: 'Start Location',
              hint: 'e.g. Addis Ababa',
              validator: _requiredValidator,
            ),
            const SizedBox(height: SizeManager.s16),
            _buildField(
              controller: _destinationController,
              label: 'Destination Location',
              hint: 'e.g. Dire Dawa',
              validator: _requiredValidator,
            ),
            const SizedBox(height: SizeManager.s16),
            _buildField(
              controller: _aboutTruckController,
              label: 'About Truck',
              hint: 'Describe your truck...',
              maxLines: 4,
              maxLength: 150,
              validator: _requiredValidator,
              aiButton: _buildAiButton(),
            ),
            const SizedBox(height: SizeManager.s16),
            _buildFeaturesSection(),
            const SizedBox(height: SizeManager.s32),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _onNext,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(SizeManager.r12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Next',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: SizeManager.s24),
          ],
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    int maxLines = 1,
    int? maxLength,
    String? Function(String?)? validator,
    Widget? aiButton,
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
            if (aiButton != null) ...[const Spacer(), aiButton],
          ],
        ),
        const SizedBox(height: SizeManager.s8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
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

  Widget _buildFeaturesSection() {
    final cs = context.appColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Features',
          style: context.text.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: cs.textPrimary,
          ),
        ),
        const SizedBox(height: SizeManager.s8),
        Wrap(
          spacing: SizeManager.s8,
          runSpacing: SizeManager.s8,
          children: _availableFeatures.map((feature) {
            final selected = _selectedFeatures.contains(feature);
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (selected) {
                    _selectedFeatures.remove(feature);
                  } else {
                    _selectedFeatures.add(feature);
                  }
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(
                  horizontal: SizeManager.s16,
                  vertical: SizeManager.s8,
                ),
                decoration: BoxDecoration(
                  color: selected ? cs.primary : cs.surface,
                  borderRadius: BorderRadius.circular(SizeManager.r20),
                  border: Border.all(color: selected ? cs.primary : cs.border),
                ),
                child: Text(
                  feature,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: selected ? cs.onPrimary : cs.textSecondary,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) return 'Required';
    return null;
  }

  Widget _buildAiButton() {
    final cs = context.appColors;
    return GestureDetector(
      onTap: _improveCarrierDescription,
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
    );
  }

  Future<void> _improveCarrierDescription() async {
    final suggestion = await showAiSuggestionSheet(
      context: context,
      fetchSuggestion: () async {
        final response = await sl<ApiClient>().improveCarrierDescription({
          'brand': _brandController.text.trim().isEmpty
              ? null
              : _brandController.text.trim(),
          'model': _modelController.text.trim().isEmpty
              ? null
              : _modelController.text.trim(),
          'plateNumber': _plateController.text.trim().isEmpty
              ? null
              : _plateController.text.trim(),
          'loadCapacity': _loadCapacityController.text.trim().isEmpty
              ? null
              : double.tryParse(_loadCapacityController.text.trim()),
          'features': _selectedFeatures.isEmpty
              ? null
              : _selectedFeatures.toList(),
          'startLocation': _startLocationController.text.trim().isEmpty
              ? null
              : _startLocationController.text.trim(),
          'destinationLocation': _destinationController.text.trim().isEmpty
              ? null
              : _destinationController.text.trim(),
          'currentDescription': _aboutTruckController.text.trim().isEmpty
              ? null
              : _aboutTruckController.text.trim(),
        });
        return response.data.suggestion;
      },
    );
    if (suggestion != null) {
      setState(() => _aboutTruckController.text = suggestion);
    }
  }
}
