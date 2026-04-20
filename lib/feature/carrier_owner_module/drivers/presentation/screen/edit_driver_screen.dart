import 'dart:io';
import 'package:clean_architecture/core/colors/app_colors.dart';
import 'package:clean_architecture/core/di.dart';
import 'package:clean_architecture/core/storage/supabase_storage_service.dart';
import 'package:clean_architecture/feature/carrier_owner_module/drivers/domain/entity/driver_entity.dart';
import 'package:clean_architecture/feature/carrier_owner_module/drivers/presentation/bloc/driver_bloc.dart';
import 'package:clean_architecture/feature/carrier_owner_module/drivers/presentation/bloc/driver_event.dart';
import 'package:clean_architecture/feature/carrier_owner_module/drivers/presentation/bloc/driver_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class EditDriverScreen extends StatelessWidget {
  final DriverEntity driver;
  const EditDriverScreen({super.key, required this.driver});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<DriverBloc>(),
      child: _EditDriverView(driver: driver),
    );
  }
}

class _EditDriverView extends StatefulWidget {
  final DriverEntity driver;
  const _EditDriverView({required this.driver});

  @override
  State<_EditDriverView> createState() => _EditDriverViewState();
}

class _EditDriverViewState extends State<_EditDriverView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _firstNameCtrl;
  late final TextEditingController _lastNameCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _licenseNumberCtrl;
  DateTime? _licenseExpiry;
  File? _newLicenseImageFile;
  bool _uploading = false;

  @override
  void initState() {
    super.initState();
    final d = widget.driver;
    _firstNameCtrl = TextEditingController(text: d.firstName ?? '');
    _lastNameCtrl = TextEditingController(text: d.lastName ?? '');
    _emailCtrl = TextEditingController(text: d.email ?? '');
    _phoneCtrl = TextEditingController(text: d.phone ?? '');
    _licenseNumberCtrl = TextEditingController(text: d.licenseNumber ?? '');
    _licenseExpiry = d.licenseExpiry;
  }

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _licenseNumberCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _newLicenseImageFile = File(picked.path));
    }
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _licenseExpiry ?? now.add(const Duration(days: 365)),
      firstDate: now,
      lastDate: DateTime(now.year + 20),
    );
    if (picked != null) setState(() => _licenseExpiry = picked);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _uploading = true);
    try {
      String? licenseImageUrl;
      if (_newLicenseImageFile != null) {
        final storage = sl<SupabaseStorageService>();
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        licenseImageUrl = await storage.upload(
          path: 'licenses/$timestamp',
          file: _newLicenseImageFile!,
        );
      }

      if (!mounted) return;

      final body = <String, dynamic>{
        'firstName': _firstNameCtrl.text.trim(),
        'lastName': _lastNameCtrl.text.trim(),
        'email': _emailCtrl.text.trim(),
        'phone': _phoneCtrl.text.trim(),
        'licenseNumber': _licenseNumberCtrl.text.trim(),
        if (_licenseExpiry != null)
          'licenseExpiry': _licenseExpiry!.toIso8601String(),
        if (licenseImageUrl != null) 'licenseImage': licenseImageUrl,
      };

      context.read<DriverBloc>().add(
        UpdateDriver(id: widget.driver.id, body: body),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Image upload failed: $e')));
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DriverBloc, DriverState>(
      listener: (context, state) {
        if (state is DriverSuccess) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
          Navigator.pop(context);
        } else if (state is DriverError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit Driver'),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: BlocBuilder<DriverBloc, DriverState>(
          builder: (context, state) {
            final isLoading = state is DriverLoading || _uploading;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildField(_firstNameCtrl, 'First Name'),
                    const SizedBox(height: 12),
                    _buildField(_lastNameCtrl, 'Last Name'),
                    const SizedBox(height: 12),
                    _buildField(
                      _emailCtrl,
                      'Email',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 12),
                    _buildField(
                      _phoneCtrl,
                      'Phone',
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 12),
                    _buildField(_licenseNumberCtrl, 'License Number'),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: _pickDate,
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'License Expiry Date',
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        child: Text(
                          _licenseExpiry != null
                              ? DateFormat('yyyy-MM-dd').format(_licenseExpiry!)
                              : 'Select date',
                          style: TextStyle(
                            color: _licenseExpiry != null
                                ? Colors.black87
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // License image
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        height: 150,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: _newLicenseImageFile != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  _newLicenseImageFile!,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : widget.driver.licenseImageUrl != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  widget.driver.licenseImageUrl!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => const Icon(
                                    Icons.image_not_supported,
                                    size: 40,
                                    color: AppColors.grey,
                                  ),
                                ),
                              )
                            : const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.upload_file,
                                    size: 40,
                                    color: AppColors.grey,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Tap to replace license image',
                                    style: TextStyle(color: AppColors.grey),
                                  ),
                                ],
                              ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: isLoading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Save Changes',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildField(
    TextEditingController ctrl,
    String label, {
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: ctrl,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      validator: (v) =>
          (v == null || v.trim().isEmpty) ? '$label is required' : null,
    );
  }
}
