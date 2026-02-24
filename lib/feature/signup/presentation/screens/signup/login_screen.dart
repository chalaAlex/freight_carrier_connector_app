import 'package:animate_do/animate_do.dart';
import 'package:clean_architecture/cofig/context_extensions.dart';
import 'package:clean_architecture/cofig/size_manager.dart';
import 'package:clean_architecture/cofig/string_manager.dart';
import 'package:clean_architecture/feature/common/carrier_bottom_navigation_bar.dart';
import 'package:clean_architecture/feature/common/forgot_password_link.dart';
import 'package:clean_architecture/feature/common/freight_bottom_navigation_bar.dart';
import 'package:clean_architecture/feature/common/login_header.dart';
import 'package:clean_architecture/feature/signup/presentation/bloc/login/login_bloc.dart';
import 'package:clean_architecture/feature/signup/presentation/bloc/login/login_event.dart';
import 'package:clean_architecture/feature/signup/presentation/bloc/login/login_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listenWhen: (prev, curr) => prev.status != curr.status,
      listener: (context, state) => _handleLoginStateChange(context, state),
      child: Scaffold(
        backgroundColor: context.appColors.background,
        resizeToAvoidBottomInset: true,
        body: const _LoginContent(),
      ),
    );
  }

  void _handleLoginStateChange(BuildContext context, LoginState state) {
    if (state.status == LoginStatus.success) {
      final role = state.user?.data?.role;
      final targetPage = role == 'carrier_owner'
          ? const FreightBottomNavigationBar()
          : role == 'user'
          ? const CarrierBottomNavigationBar()
          : null;

      if (targetPage != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => targetPage),
            (_) => false,
          );
        });
      } else {
        Fluttertoast.showToast(
          msg: StringManager.unknownRole,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } else if (state.status == LoginStatus.failure) {
      Fluttertoast.showToast(
        msg: state.errorMessage ?? StringManager.loginFailed,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }
}

class _LoginContent extends StatefulWidget {
  const _LoginContent();

  @override
  State<_LoginContent> createState() => _LoginContentState();
}

class _LoginContentState extends State<_LoginContent> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<LoginBloc>().add(
        LoginSubmitted(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: IntrinsicHeight(
            child: Column(
              children: const [
                Flexible(child: LoginHeader()),
                Flexible(flex: 2, child: _LoginForm()),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: SizeManager.screenHorizontalPadding,
        vertical: SizeManager.screenVerticalPadding,
      ),
      child: Form(
        key: context.findAncestorStateOfType<_LoginContentState>()?._formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FadeInUp(
              duration: const Duration(milliseconds: 1600),
              child: Text(
                StringManager.loginTitle,
                textAlign: TextAlign.center,
                style: context.text.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: context.appColors.textPrimary,
                ),
              ),
            ),
            SizedBox(height: SizeManager.s32),
            const _EmailField(),
            SizedBox(height: SizeManager.s24),
            const _PasswordField(),
            SizedBox(height: SizeManager.s40),
            const _LoginButton(),
            SizedBox(height: SizeManager.s32),
            const ForgotPasswordLink(),
            SizedBox(height: SizeManager.s40),
          ],
        ),
      ),
    );
  }
}

class _EmailField extends StatelessWidget {
  const _EmailField();

  @override
  Widget build(BuildContext context) {
    final state = context.findAncestorStateOfType<_LoginContentState>()!;

    return TextFormField(
      controller: state._emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: StringManager.emailLabel,
        hintText: StringManager.emailHint,
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return StringManager.emailRequired;
        }
        return null;
      },
    );
  }
}

class _PasswordField extends StatefulWidget {
  const _PasswordField();

  @override
  State<_PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<_PasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    final state = context.findAncestorStateOfType<_LoginContentState>()!;

    return TextFormField(
      controller: state._passwordController,
      obscureText: _obscure,
      decoration: InputDecoration(
        labelText: StringManager.passwordLabel,
        suffixIcon: IconButton(
          icon: Icon(
            _obscure
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
          ),
          onPressed: () => setState(() => _obscure = !_obscure),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return StringManager.passwordRequired;
        }
        if (value.length < 6) return StringManager.passwordTooShort;
        return null;
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<LoginBloc>().state;
    final isLoading = state.status == LoginStatus.loading;

    return FadeInUp(
      duration: const Duration(milliseconds: 1800),
      child: ElevatedButton(
        onPressed: isLoading
            ? null
            : () => context
                  .findAncestorStateOfType<_LoginContentState>()
                  ?._submit(),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: SizeManager.s16),
        ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2.5),
              )
            : Text(StringManager.loginButton),
      ),
    );
  }
}
