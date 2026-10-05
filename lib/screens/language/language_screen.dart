import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/config/env_config.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization/app_translations.dart';
import '../../providers/app_state_provider.dart';
import '../../services/sarvam_service.dart';
import '../auth/login_screen.dart';

class LanguageScreen extends StatefulWidget {
  final bool isInitialSelection;

  const LanguageScreen({super.key, this.isInitialSelection = false});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String _selectedLang = 'en';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedLang = Provider.of<AppStateProvider>(context, listen: false).currentLanguage;
  }

  void _onContinue() async {
    setState(() => _isLoading = true);
    final appState = Provider.of<AppStateProvider>(context, listen: false);
    await appState.setLanguage(_selectedLang);
    setState(() => _isLoading = false);

    if (!mounted) return;

    if (widget.isInitialSelection) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    } else {
      Navigator.of(context).pop();
    }
  }

  void _showApiKeyDialog() {
    final controller = TextEditingController(text: EnvConfig.sarvamApiKey);
    bool testing = false;
    String? statusMessage;
    bool isSuccess = false;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (dialogCtx, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              title: Row(
                children: [
                  const Icon(Icons.vpn_key_rounded, color: AppColors.primaryGreen),
                  const SizedBox(width: 8),
                  const Text('Sarvam AI Config', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Sarvam AI powers dynamic Indic translation across 11+ Indian languages.',
                      style: TextStyle(fontSize: 13, color: AppColors.textMuted),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: controller,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Sarvam Subscription Key',
                        hintText: 'Enter SARVAM_API_KEY',
                        prefixIcon: const Icon(Icons.key, size: 20),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Default loaded from: .env (SARVAM_API_KEY)',
                      style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                    ),
                    if (statusMessage != null) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isSuccess ? Colors.green.shade50 : Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSuccess ? Colors.green.shade300 : Colors.red.shade300,
                          ),
                        ),
                        child: Text(
                          statusMessage!,
                          style: TextStyle(
                            fontSize: 12,
                            color: isSuccess ? Colors.green.shade800 : Colors.red.shade800,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('Cancel'),
                ),
                OutlinedButton(
                  onPressed: testing
                      ? null
                      : () async {
                          setDialogState(() {
                            testing = true;
                            statusMessage = 'Testing connectivity to Sarvam.ai...';
                            isSuccess = false;
                          });
                          final ok = await SarvamService.testApiKey(controller.text.trim());
                          setDialogState(() {
                            testing = false;
                            isSuccess = ok;
                            statusMessage = ok
                                ? 'Key verified! Connected to Sarvam.ai'
                                : 'Invalid key or quota exceeded. Check key.';
                          });
                        },
                  child: testing
                      ? const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Test Key'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryGreen),
                  onPressed: () async {
                    final messenger = ScaffoldMessenger.of(context);
                    final nav = Navigator.of(ctx);
                    await EnvConfig.setCustomSarvamApiKey(controller.text.trim());
                    if (!mounted) return;
                    nav.pop();
                    setState(() {});
                    messenger.showSnackBar(
                      const SnackBar(content: Text('Sarvam AI configuration updated!')),
                    );
                  },
                  child: const Text('Save', style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasKey = EnvConfig.hasSarvamApiKey;

    return Scaffold(
      appBar: widget.isInitialSelection
          ? null
          : AppBar(
              title: Text(
                AppTranslations.text(_selectedLang, 'choose_language'),
                style: TextStyle(color: isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.settings_outlined),
                  tooltip: 'Sarvam AI Config',
                  onPressed: _showApiKeyDialog,
                ),
              ],
            ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sarvam AI Badge & Key indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.primaryGreen.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.auto_awesome, size: 14, color: AppColors.primaryGreen),
                        SizedBox(width: 6),
                        Text(
                          'Powered by Sarvam.ai',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryGreen,
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: _showApiKeyDialog,
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: hasKey ? Colors.green : Colors.orange,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            hasKey ? 'Sarvam Active' : '.env Key Required',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: hasKey ? Colors.green.shade700 : Colors.orange.shade800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Heading
              Text(
                AppTranslations.text(_selectedLang, 'choose_language'),
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal,
                ),
              ),
              const SizedBox(height: 6),
              // Subtitle
              Text(
                AppTranslations.text(_selectedLang, 'choose_language_sub'),
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 20),
              // Language Cards List
              Expanded(
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: SarvamService.supportedLanguages.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final lang = SarvamService.supportedLanguages[index];
                    final isSelected = _selectedLang == lang.code;

                    return InkWell(
                      onTap: () {
                        setState(() {
                          _selectedLang = lang.code;
                        });
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkCard : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primaryGreen
                                : (isDark ? AppColors.darkBorder : AppColors.borderSubtle),
                            width: isSelected ? 2 : 1,
                          ),
                          boxShadow: isSelected && !isDark
                              ? [
                                  BoxShadow(
                                    color: AppColors.primaryGreen.withOpacity(0.12),
                                    blurRadius: 10,
                                    offset: const Offset(0, 3),
                                  ),
                                ]
                              : null,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.primaryGreen
                                      : (isDark ? AppColors.darkTextSecondary : AppColors.textMuted),
                                  width: 2,
                                ),
                                color: isSelected ? AppColors.primaryGreen : Colors.transparent,
                              ),
                              child: isSelected
                                  ? const Icon(
                                      Icons.check,
                                      size: 14,
                                      color: Colors.white,
                                    )
                                  : null,
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        lang.nativeLabel,
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                          color: isSelected
                                              ? (isDark ? const Color(0xFF81C784) : AppColors.primaryGreen)
                                              : (isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        '(${lang.englishLabel})',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    lang.region,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (!AppTranslations.hasStaticTranslations(lang.code))
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'Sarvam Indic',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.blue.shade700,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              // Continue Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _onContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                        )
                      : Text(
                          AppTranslations.text(_selectedLang, 'continue'),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
