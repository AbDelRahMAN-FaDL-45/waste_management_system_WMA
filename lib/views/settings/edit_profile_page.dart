import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartbins/core/app_colors.dart';
import 'package:smartbins/providers/auth_provider.dart';
import 'package:smartbins/views/auth/widgets/change_password_page.dart';
import 'package:smartbins/widgets/custom_button.dart';
import 'package:smartbins/widgets/smartbins_logo.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nationalIdController = TextEditingController();

  bool _populated = false;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_populated) return;
    final user = Provider.of<AuthProvider>(context, listen: false).currentUser;
    if (user != null) {
      _firstNameController.text = user.firstName;
      _lastNameController.text = user.lastName;
      _emailController.text = user.email;
      _phoneController.text = user.phoneNumber;
      _nationalIdController.text = user.nationalId ?? '';
      _populated = true;
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _nationalIdController.dispose();
    super.dispose();
  }

  void _showSnack(String msg, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(children: [
        Icon(
          error ? Icons.error_outline : Icons.check_circle_outline,
          color: Colors.white,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(msg,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w600)),
        ),
      ]),
      backgroundColor: error ? Colors.red.shade700 : AppColors.primaryGreen,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 4),
    ));
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.currentUser;

    if (user == null) {
      _showSnack('User not loaded yet. Please wait and try again.', error: true);
      await authProvider.getCurrentUser();
      return;
    }

    setState(() => _isLoading = true);

    final success = await authProvider.editUser(
      id: user.id,
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      email: _emailController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
    );

    setState(() => _isLoading = false);

    if (!mounted) return;
    if (success) {
      _showSnack('Profile updated successfully!');
      Navigator.pop(context);
    } else {
      _showSnack(authProvider.error ?? 'Failed to update profile', error: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    // Populate fields if user data arrived after initial build
    if (!_populated && user != null) {
      _firstNameController.text = user.firstName;
      _lastNameController.text = user.lastName;
      _emailController.text = user.email;
      _phoneController.text = user.phoneNumber;
      _nationalIdController.text = user.nationalId ?? '';
      _populated = true;
    }

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

                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Row(children: [
                        Icon(Icons.arrow_back, color: AppColors.dark, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'EDIT PROFILE',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: AppColors.dark,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ]),
                    ),
                    const SmartBinsLogo(),
                  ],
                ),
                const SizedBox(height: 40),

                // Avatar
                Center(
                  child: Column(children: [
                    Stack(alignment: Alignment.bottomRight, children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFFFFE4C4),
                          border: Border.all(color: Colors.white, width: 4),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.person,
                            size: 50, color: AppColors.dark),
                      ),
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppColors.primaryGreen,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(Icons.check,
                            color: Colors.white, size: 16),
                      ),
                    ]),
                    const SizedBox(height: 16),
                    const Text(
                      'CHANGE PROFILE PHOTO',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryGreen,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ]),
                ),
                const SizedBox(height: 32),

                // Show spinner if user not loaded yet
                if (user == null && authProvider.isLoading)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: CircularProgressIndicator(
                          color: AppColors.primaryGreen),
                    ),
                  )
                else ...[
                  _buildField(
                    label: 'FIRST NAME',
                    hint: 'First Name',
                    icon: Icons.person_outline,
                    controller: _firstNameController,
                    validator: (v) => v == null || v.trim().isEmpty
                        ? 'First name is required'
                        : null,
                  ),
                  const SizedBox(height: 20),

                  _buildField(
                    label: 'LAST NAME',
                    hint: 'Last Name',
                    icon: Icons.person_outline,
                    controller: _lastNameController,
                    validator: (v) => v == null || v.trim().isEmpty
                        ? 'Last name is required'
                        : null,
                  ),
                  const SizedBox(height: 20),

                  _buildField(
                    label: 'NATIONAL ID',
                    hint: 'National ID',
                    icon: Icons.badge_outlined,
                    controller: _nationalIdController,
                    readOnly: true,
                    enabled: false,
                  ),
                  const SizedBox(height: 20),

                  _buildField(
                    label: 'EMAIL ADDRESS',
                    hint: 'email@example.com',
                    icon: Icons.email_outlined,
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) =>
                    v == null || !v.contains('@') || !v.contains('.')
                        ? 'Enter a valid email'
                        : null,
                  ),
                  const SizedBox(height: 20),

                  _buildField(
                    label: 'PHONE NUMBER',
                    hint: '+1234567890',
                    icon: Icons.phone_outlined,
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    validator: (v) => v == null || v.trim().length < 10
                        ? 'Enter a valid phone number'
                        : null,
                  ),
                  const SizedBox(height: 32),

                  // Security Settings
                  const Text(
                    'SECURITY SETTINGS',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.gray,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 16),

                  GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) => const ChangePasswordPage()),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Row(children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.badgeBg,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.lock_outline,
                              color: AppColors.primaryGreen, size: 20),
                        ),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Password',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.dark)),
                              SizedBox(height: 4),
                              Text('Tap to change your password',
                                  style: TextStyle(
                                      fontSize: 11, color: AppColors.gray)),
                            ],
                          ),
                        ),
                        const Text('CHANGE',
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primaryGreen,
                                letterSpacing: 0.3)),
                      ]),
                    ),
                  ),
                  const SizedBox(height: 32),

                  _isLoading
                      ? const Center(
                      child: CircularProgressIndicator(
                          color: AppColors.primaryGreen))
                      : CustomButton(
                      text: 'SAVE CHANGES', onPressed: _saveChanges),
                  const SizedBox(height: 24),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required String label,
    required String hint,
    required IconData icon,
    required TextEditingController controller,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    bool readOnly = false,
    bool enabled = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.gray,
                letterSpacing: 0.8)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: enabled
                ? AppColors.inputBg
                : AppColors.inputBg.withOpacity(0.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            validator: validator,
            readOnly: readOnly,
            enabled: enabled,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: enabled ? AppColors.dark : AppColors.gray),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.gray),
              prefixIcon: Icon(icon, color: AppColors.gray, size: 20),
              suffixIcon: readOnly
                  ? const Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: Icon(Icons.lock_outline,
                      color: AppColors.gray, size: 16))
                  : null,
              border: InputBorder.none,
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              errorStyle: const TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }
}