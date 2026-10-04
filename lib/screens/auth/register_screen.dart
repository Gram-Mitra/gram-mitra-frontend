import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization/app_translations.dart';
import '../../providers/app_state_provider.dart';
import '../../providers/auth_provider.dart';
import '../welcome/welcome_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  int _currentStep = 1;

  // Step 1: Account Credentials (auth.users & profiles.phone)
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  bool _obscurePassword = true;

  // Step 2: Personal Information (profiles.full_name, profiles.age)
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();

  // Step 3: Location Details (profiles.state, profiles.district, profiles.village)
  final _stateController = TextEditingController(text: 'Maharashtra');
  final _districtController = TextEditingController(text: 'Palghar');
  final _villageController = TextEditingController(text: 'Palghar');

  final _formKeyStep1 = GlobalKey<FormState>();
  final _formKeyStep2 = GlobalKey<FormState>();
  final _formKeyStep3 = GlobalKey<FormState>();

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    _nameController.dispose();
    _ageController.dispose();
    _stateController.dispose();
    _districtController.dispose();
    _villageController.dispose();
    super.dispose();
  }

  void _onNext() {
    if (_currentStep == 1) {
      if (!_formKeyStep1.currentState!.validate()) return;
      setState(() => _currentStep = 2);
    } else if (_currentStep == 2) {
      if (!_formKeyStep2.currentState!.validate()) return;
      setState(() => _currentStep = 3);
    } else if (_currentStep == 3) {
      _onSubmit();
    }
  }

  void _onBack() {
    if (_currentStep > 1) {
      setState(() => _currentStep -= 1);
    } else {
      Navigator.of(context).pop();
    }
  }

  void _onSubmit() async {
    if (!_formKeyStep3.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final success = await authProvider.register(
      password: _passwordController.text,
      phone: _phoneController.text.trim(),
      email: _emailController.text.trim().isNotEmpty ? _emailController.text.trim() : null,
      fullName: _nameController.text.trim().isNotEmpty ? _nameController.text.trim() : null,
      age: int.tryParse(_ageController.text.trim()),
      state: _stateController.text.trim().isNotEmpty ? _stateController.text.trim() : null,
      district: _districtController.text.trim().isNotEmpty ? _districtController.text.trim() : null,
      village: _villageController.text.trim().isNotEmpty ? _villageController.text.trim() : null,
    );

    if (!mounted) return;

    if (success) {
      final displayName = authProvider.user?.fullName ?? _nameController.text.trim();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => WelcomeScreen(userName: displayName.isNotEmpty ? displayName : null),
        ),
      );
    } else {
      final error = authProvider.errorMessage ?? 'Something went wrong while creating your account. Please try again.';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          backgroundColor: AppColors.statusError,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<AppStateProvider>(context).currentLanguage;
    final authProvider = Provider.of<AuthProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: isDark ? AppColors.darkTextPrimary : null),
          onPressed: _onBack,
        ),
        title: Text(
          AppTranslations.text(lang, 'register'),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _getStepTitle(lang),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isDark ? const Color(0xFF81C784) : AppColors.primaryGreen,
                        ),
                      ),
                      Text(
                        'Step $_currentStep of 3',
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: _currentStep / 3,
                      backgroundColor: isDark ? AppColors.darkBorder : AppColors.borderSubtle,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isDark ? const Color(0xFF81C784) : AppColors.primaryGreen,
                      ),
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
            ),
            // Form Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: _buildStepForm(lang, isDark),
              ),
            ),
            // Action Buttons
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  if (_currentStep > 1) ...[
                    Expanded(
                      flex: 1,
                      child: SizedBox(
                        height: 52,
                        child: OutlinedButton(
                          onPressed: _onBack,
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.borderSubtle),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: Text(
                            AppTranslations.text(lang, 'back'),
                            style: TextStyle(
                              color: isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                  ],
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        onPressed: authProvider.isLoading ? null : _onNext,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryGreen,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: authProvider.isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                              )
                            : Text(
                                _currentStep == 3
                                    ? AppTranslations.text(lang, 'complete_registration')
                                    : AppTranslations.text(lang, 'continue'),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getStepTitle(String lang) {
    switch (_currentStep) {
      case 1:
        return AppTranslations.text(lang, 'step_1_title');
      case 2:
        return AppTranslations.text(lang, 'step_2_title');
      case 3:
        return AppTranslations.text(lang, 'step_3_title');
      default:
        return '';
    }
  }

  Widget _buildStepForm(String lang, bool isDark) {
    if (_currentStep == 1) {
      return Form(
        key: _formKeyStep1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Create your login credentials',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Your phone number will be used for account authentication and recovery.',
              style: TextStyle(
                fontSize: 13,
                color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            // Phone Number (Required)
            Text(
              '${AppTranslations.text(lang, 'phone_number')} *',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              style: TextStyle(color: isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal),
              decoration: InputDecoration(
                hintText: 'e.g. 9876543210',
                prefixIcon: Icon(Icons.phone_outlined, color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Phone number is required';
                if (v.trim().length < 10) return 'Please enter a valid 10-digit phone number';
                return null;
              },
            ),
            const SizedBox(height: 20),
            // Password (Required, min 6 chars)
            Text(
              '${AppTranslations.text(lang, 'password')} *',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              style: TextStyle(color: isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal),
              decoration: InputDecoration(
                hintText: 'Minimum 6 characters',
                prefixIcon: Icon(Icons.lock_outline_rounded, color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted),
                suffixIcon: IconButton(
                  icon: Icon(_obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted),
                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                ),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Password is required';
                if (v.length < 6) return 'Password must be at least 6 characters';
                return null;
              },
            ),
            const SizedBox(height: 20),
            // Email (Optional)
            Text(
              AppTranslations.text(lang, 'email'),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(color: isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal),
              decoration: InputDecoration(
                hintText: 'e.g. kisan@gmail.com',
                prefixIcon: Icon(Icons.email_outlined, color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted),
              ),
            ),
          ],
        ),
      );
    } else if (_currentStep == 2) {
      return Form(
        key: _formKeyStep2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Personal Details',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Helps in personalizing rural welfare services for you.',
              style: TextStyle(fontSize: 13, color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted),
            ),
            const SizedBox(height: 24),
            // Full Name (profiles.full_name)
            Text(
              AppTranslations.text(lang, 'full_name'),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _nameController,
              textCapitalization: TextCapitalization.words,
              style: TextStyle(color: isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal),
              decoration: InputDecoration(
                hintText: 'e.g. Ramesh Patil',
                prefixIcon: Icon(Icons.person_outline_rounded, color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted),
              ),
            ),
            const SizedBox(height: 20),
            // Age (profiles.age)
            Text(
              AppTranslations.text(lang, 'age'),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _ageController,
              keyboardType: TextInputType.number,
              style: TextStyle(color: isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal),
              decoration: InputDecoration(
                hintText: 'e.g. 42',
                prefixIcon: Icon(Icons.calendar_today_outlined, color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted),
              ),
            ),
          ],
        ),
      );
    } else {
      return Form(
        key: _formKeyStep3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Village Location',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Used to link your village to nearby healthcare, panchayat grievances, and mandi listings.',
              style: TextStyle(
                fontSize: 13,
                color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            // State (profiles.state)
            Text(
              AppTranslations.text(lang, 'state'),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _stateController,
              style: TextStyle(color: isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal),
              decoration: InputDecoration(
                hintText: 'e.g. Maharashtra',
                prefixIcon: Icon(Icons.map_outlined, color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted),
              ),
            ),
            const SizedBox(height: 20),
            // District (profiles.district)
            Text(
              AppTranslations.text(lang, 'district'),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _districtController,
              style: TextStyle(color: isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal),
              decoration: InputDecoration(
                hintText: 'e.g. Palghar',
                prefixIcon: Icon(Icons.location_city_outlined, color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted),
              ),
            ),
            const SizedBox(height: 20),
            // Village (profiles.village)
            Text(
              AppTranslations.text(lang, 'village'),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _villageController,
              style: TextStyle(color: isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal),
              decoration: InputDecoration(
                hintText: 'e.g. Palghar',
                prefixIcon: Icon(Icons.home_work_outlined, color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted),
              ),
            ),
          ],
        ),
      );
    }
  }
}
