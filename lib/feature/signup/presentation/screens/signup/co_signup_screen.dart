import 'package:clean_architecture/cofig/size_manager.dart';
import 'package:clean_architecture/cofig/string_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:clean_architecture/cofig/context_extensions.dart';
import 'package:clean_architecture/cofig/routes_manager.dart';
import 'package:clean_architecture/feature/carrier/presentation/carrier_home_page.dart';
import 'package:clean_architecture/feature/signup/presentation/bloc/sign_up/sign_up_bloc.dart';
import 'package:clean_architecture/feature/signup/presentation/bloc/sign_up/sign_up_event.dart';
import 'package:clean_architecture/feature/signup/presentation/bloc/sign_up/sign_up_state.dart';

class CoSignupScreen extends StatefulWidget {
  const CoSignupScreen({super.key, this.role});
  final String? role;

  @override
  State<CoSignupScreen> createState() => _CoSignupScreenState();
}

class _CoSignupScreenState extends State<CoSignupScreen> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _agreedToTerms = false;

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<SignUpBloc>().add(
        SignUpSubmitted(
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          email: _emailController.text.trim(),
          phone: _phoneController.text.trim(),
          password: _passwordController.text.trim(),
          confirmPassword: _confirmPasswordController.text.trim(),
          role: widget.role ?? 'user',
        ),
      );
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final text = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: SizeManager.screenHorizontalPadding,
            vertical: SizeManager.screenVerticalPadding,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: SizeManager.s16),

                // Title
                Text(
                  StringManager.createAccount,
                  style: text.headlineLarge?.copyWith(
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(height: SizeManager.s8),
                Text(
                  StringManager.signupDescription,
                  style: text.bodyMedium?.copyWith(
                    color: colors.textSecondary,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: SizeManager.s40),

                // Name row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildTextField(
                        controller: _firstNameController,
                        label: StringManager.firstName,
                        hint: StringManager.firstNameHint,
                      ),
                    ),
                    const SizedBox(width: SizeManager.s16),
                    Expanded(
                      child: _buildTextField(
                        controller: _lastNameController,
                        label: StringManager.lastName,
                        hint: StringManager.lastNameHint,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: SizeManager.s24),

                _buildTextField(
                  controller: _emailController,
                  label: StringManager.email,
                  hint: StringManager.emailHint,
                  keyboardType: TextInputType.emailAddress,
                ),

                const SizedBox(height: SizeManager.s24),

                _buildTextField(
                  controller: _phoneController,
                  label: StringManager.phone,
                  hint: StringManager.phoneHint,
                  keyboardType: TextInputType.phone,
                  prefix: Text(
                    "+251 ",
                    style: TextStyle(color: colors.textSecondary),
                  ),
                ),

                const SizedBox(height: SizeManager.s24),

                _buildPasswordField(
                  controller: _passwordController,
                  label: StringManager.password,
                  obscure: _obscurePassword,
                  onToggle: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                ),

                const SizedBox(height: SizeManager.s8),
                Padding(
                  padding: EdgeInsets.only(left: SizeManager.s12),
                  child: Text(
                    StringManager.min8Chars,
                    style: text.bodySmall?.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ),

                const SizedBox(height: SizeManager.s24),

                _buildPasswordField(
                  controller: _confirmPasswordController,
                  label: StringManager.confirmPassword,
                  obscure: _obscureConfirm,
                  onToggle: () =>
                      setState(() => _obscureConfirm = !_obscureConfirm),
                ),

                const SizedBox(height: SizeManager.s32),

                // Terms & Privacy
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: SizeManager.checkboxSize,
                      width: SizeManager.checkboxSize,
                      child: Checkbox(
                        value: _agreedToTerms,
                        onChanged: (v) =>
                            setState(() => _agreedToTerms = v ?? false),
                        activeColor: colors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(SizeManager.r6),
                        ),
                      ),
                    ),
                    const SizedBox(width: SizeManager.s12),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: text.bodyMedium?.copyWith(
                            color: colors.textSecondary,
                          ),
                          children: [
                            TextSpan(text: StringManager.agreeTerms),
                            TextSpan(
                              text: StringManager.termsOfService,
                              style: TextStyle(color: colors.primary),
                            ),
                            const TextSpan(text: " & "),
                            TextSpan(
                              text: StringManager.privacyPolicy,
                              style: TextStyle(color: colors.primary),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: SizeManager.s32),

                // Continue Button
                BlocListener<SignUpBloc, SignUpState>(
                  listenWhen: (previous, current) =>
                      previous.status != current.status,
                  listener: (context, state) {
                    if (state.status == SignUpStatus.failure) {
                      Fluttertoast.showToast(
                        msg: state.errorMessage ?? StringManager.signupFailed,
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                      );
                    }
                    if (state.status == SignUpStatus.success) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CarrierHomePage(),
                        ),
                        (route) => false,
                      );
                    }
                  },
                  child: BlocBuilder<SignUpBloc, SignUpState>(
                    builder: (context, state) {
                      return ElevatedButton(
                        onPressed: _agreedToTerms ? _submit : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colors.primary,
                          foregroundColor: colors.onPrimary,
                          padding: const EdgeInsets.symmetric(
                            vertical: SizeManager.s16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              SizeManager.r12,
                            ),
                          ),
                          // ignore: deprecated_member_use
                          disabledBackgroundColor: colors.primary.withOpacity(
                            0.5,
                          ),
                          elevation: 0,
                        ),
                        child: Center(
                          child: state.status == SignUpStatus.loading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : Text(
                                  StringManager.loginBtn,
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: SizeManager.s24),

                // Already have account
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      StringManager.alreadyHaveAccount,
                      style: text.bodyMedium?.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                    GestureDetector(
                      onTap: () =>
                          Navigator.pushNamed(context, Routes.loginScreenRoute),
                      child: Text(
                        StringManager.login,
                        style: text.bodyMedium?.copyWith(
                          color: colors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: SizeManager.s40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    TextInputType? keyboardType,
    Widget? prefix,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefix: prefix,
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) return '$label is required';
        return null;
      },
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscure,
    required VoidCallback onToggle,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: IconButton(
          icon: Icon(
            obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          ),
          onPressed: onToggle,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return StringManager.passwordRequired;
        if (value.length < 8) return StringManager.passwordLengthError;
        return null;
      },
    );
  }
}
