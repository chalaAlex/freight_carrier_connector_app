import 'package:animate_do/animate_do.dart';
import 'package:clean_architecture/cofig/context_extensions.dart';
import 'package:clean_architecture/cofig/size_manager.dart';
import 'package:clean_architecture/cofig/string_manager.dart';
import 'package:clean_architecture/feature/freight_oner_module/signup/presentation/bloc/forgot_password/forgot_password_bloc.dart';
import 'package:clean_architecture/feature/freight_oner_module/signup/presentation/bloc/forgot_password/forgot_password_event.dart';
import 'package:clean_architecture/feature/freight_oner_module/signup/presentation/bloc/forgot_password/forgot_password_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
      listener: (context, state) {
        if (state.status == ForgotPasswordStatus.success) {
          Fluttertoast.showToast(
            msg: 'Password reset link sent to your email',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white,
          );
          Navigator.pop(context);
        } else if (state.status == ForgotPasswordStatus.failure) {
          Fluttertoast.showToast(
            msg: state.errorMessage ?? 'Failed to send reset link',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        }
      },
      child: Scaffold(
        backgroundColor: context.appColors.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: context.appColors.textPrimary),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: const _ForgotPasswordContent(),
      ),
    );
  }
}

class _ForgotPasswordContent extends StatefulWidget {
  const _ForgotPasswordContent();

  @override
  State<_ForgotPasswordContent> createState() => _ForgotPasswordContentState();
}

class _ForgotPasswordContentState extends State<_ForgotPasswordContent> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<ForgotPasswordBloc>().add(
        ForgotPasswordSubmitted(email: _emailController.text.trim()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: SizeManager.screenHorizontalPadding,
        vertical: SizeManager.screenVerticalPadding,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: SizeManager.s32),
            FadeInUp(
              duration: const Duration(milliseconds: 800),
              child: Icon(
                Icons.lock_reset,
                size: 80,
                color: context.appColors.primary,
              ),
            ),
            const SizedBox(height: SizeManager.s32),
            FadeInUp(
              duration: const Duration(milliseconds: 1000),
              child: Text(
                'Forgot Password?',
                textAlign: TextAlign.center,
                style: context.text.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.appColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: SizeManager.s16),
            FadeInUp(
              duration: const Duration(milliseconds: 1200),
              child: Text(
                'Enter your email address and we\'ll send you a link to reset your password.',
                textAlign: TextAlign.center,
                style: context.text.bodyMedium?.copyWith(
                  color: context.appColors.textSecondary,
                ),
              ),
            ),
            const SizedBox(height: SizeManager.s16),
            FadeInUp(
              duration: const Duration(milliseconds: 1400),
              child: TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: StringManager.emailLabel,
                  hintText: StringManager.emailHint,
                  prefixIcon: const Icon(Icons.email_outlined),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return StringManager.emailRequired;
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: SizeManager.s32),
            FadeInUp(
              duration: const Duration(milliseconds: 1600),
              child: BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
                builder: (context, state) {
                  final isLoading =
                      state.status == ForgotPasswordStatus.loading;
                  return ElevatedButton(
                    onPressed: isLoading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: SizeManager.s16,
                      ),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2.5),
                          )
                        : const Text('Send Reset Link'),
                  );
                },
              ),
            ),
            const SizedBox(height: SizeManager.s24),
            FadeInUp(
              duration: const Duration(milliseconds: 1800),
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Back to Login',
                  style: TextStyle(
                    color: context.appColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
