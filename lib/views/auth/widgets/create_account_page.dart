import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartbins/core/app_colors.dart';
import 'package:smartbins/providers/auth_provider.dart';
import 'package:smartbins/views/auth/widgets/auth_footer.dart';
import 'package:smartbins/views/auth/widgets/auth_header.dart';
import 'package:smartbins/views/auth/widgets/custom_textfield.dart';
import 'package:smartbins/views/auth/widgets/login_page.dart';
import 'package:smartbins/views/home/widgets/home_page.dart';
import 'package:smartbins/widgets/custom_button.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  bool _acceptTerms = false;
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nationalIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _nationalIdController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.primaryGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  String? _validateName(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    if (value.trim().length < 2) {
      return '$fieldName must be at least 2 characters';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    if (!value.contains('@') || !value.contains('.')) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }
    if (value.trim().length < 10) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  String? _validateNationalId(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'National ID is required';
    }
    if (value.trim().length < 5) {
      return 'National ID must be at least 5 characters';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  Future<void> _createAccount() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_acceptTerms) {
      _showError('Please accept the Terms of Protocol');
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final success = await authProvider.registerAndLogin(
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
      phoneNumber: _phoneController.text.trim(),
      nationalId: _nationalIdController.text.trim(),
    );

    if (success && mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const HomePage()),
            (route) => false,
      );
    } else if (mounted) {
      _showError(authProvider.error ?? 'Registration failed. Please try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                const AuthHeader(showSystemVersion: true),
                const SizedBox(height: 40),

                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.badgeBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.sensors_rounded,
                    color: AppColors.primaryGreen,
                    size: 24,
                  ),
                ),
                const SizedBox(height: 24),

                const Text(
                  'JOIN SMARTBINS',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: AppColors.dark,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),

                const Text(
                  'INDUSTRIAL WASTE MANAGEMENT SYSTEM',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.gray,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 32),

                CustomTextField(
                  label: 'FIRST NAME',
                  hint: 'OPERATOR FIRST NAME',
                  prefixIcon: Icons.badge_outlined,
                  controller: _firstNameController,
                  validator: (v) => _validateName(v, 'First name'),
                ),
                const SizedBox(height: 20),

                CustomTextField(
                  label: 'LAST NAME',
                  hint: 'OPERATOR LAST NAME',
                  prefixIcon: Icons.badge_outlined,
                  controller: _lastNameController,
                  validator: (v) => _validateName(v, 'Last name'),
                ),
                const SizedBox(height: 20),

                CustomTextField(
                  label: 'PHONE NUMBER',
                  hint: '+1234567890',
                  prefixIcon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  controller: _phoneController,
                  validator: _validatePhone,
                ),
                const SizedBox(height: 20),

                CustomTextField(
                  label: 'EMAIL ADDRESS',
                  hint: 'ADMIN@BINWISE.TECH',
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  validator: _validateEmail,
                ),
                const SizedBox(height: 20),

                CustomTextField(
                  label: 'NATIONAL ID',
                  hint: 'NATIONAL ID NUMBER',
                  prefixIcon: Icons.credit_card_outlined,
                  controller: _nationalIdController,
                  validator: _validateNationalId,
                ),
                const SizedBox(height: 20),

                CustomTextField(
                  label: 'PASSWORD',
                  hint: '••••••••',
                  prefixIcon: Icons.lock_outline,
                  obscureText: true,
                  controller: _passwordController,
                  validator: _validatePassword,
                ),
                const SizedBox(height: 20),

                CustomTextField(
                  label: 'CONFIRM PASSWORD',
                  hint: '••••••••',
                  prefixIcon: Icons.verified_user_outlined,
                  obscureText: true,
                  controller: _confirmController,
                  validator: _validateConfirmPassword,
                ),
                const SizedBox(height: 24),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => setState(() => _acceptTerms = !_acceptTerms),
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: _acceptTerms ? AppColors.primaryGreen : AppColors.inputBg,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: _acceptTerms ? AppColors.primaryGreen : AppColors.lightGray,
                            width: 2,
                          ),
                        ),
                        child: _acceptTerms
                            ? const Icon(
                          Icons.check,
                          size: 14,
                          color: Colors.white,
                        )
                            : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 12,
                            height: 1.5,
                            color: AppColors.gray,
                          ),
                          children: [
                            const TextSpan(
                              text: 'I accept the ',
                            ),
                            TextSpan(
                              text: 'Terms of Protocol',
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                color: AppColors.dark,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            const TextSpan(
                              text: ' and the automated data collection guidelines for industrial monitoring.',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                authProvider.isLoading
                    ? const Center(child: CircularProgressIndicator(color: AppColors.primaryGreen))
                    : CustomButton(
                  text: 'CREATE ACCOUNT',
                  onPressed: _createAccount,
                ),
                const SizedBox(height: 24),

                AuthFooter(
                  leftText: 'ALREADY AUTHORIZED?',
                  actionText: 'LOG IN',
                  onAction: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                    );
                  },
                ),
                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.primaryGreen,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'GATEWAY SECURED',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryGreen,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'SEC. REF: 88-0412-7XX',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: AppColors.gray.withOpacity(0.6),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}