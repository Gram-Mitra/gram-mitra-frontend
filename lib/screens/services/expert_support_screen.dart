import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/app_state_provider.dart';
import '../../services/voice_service.dart';

class ExpertSupportScreen extends StatefulWidget {
  const ExpertSupportScreen({super.key});

  @override
  State<ExpertSupportScreen> createState() => _ExpertSupportScreenState();
}

class _ExpertSupportScreenState extends State<ExpertSupportScreen> {
  String _selectedExpertId = 'agriculture';
  final _queryController = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _isConsulting = false;

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  void _sendQuery() async {
    final query = _queryController.text.trim();
    if (query.isEmpty) return;

    setState(() {
      _messages.add({'sender': 'user', 'text': query});
      _isConsulting = true;
    });
    _queryController.clear();

    final currentLang = Provider.of<AppStateProvider>(context, listen: false).currentLanguage;
    final response = await VoiceService.askExpert(_selectedExpertId, query, targetLanguage: currentLang);

    if (mounted) {
      setState(() {
        _messages.add({'sender': 'expert', 'text': response});
        _isConsulting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final currentExpert = VoiceService.experts.firstWhere(
      (e) => e.id == _selectedExpertId,
      orElse: () => VoiceService.experts[0],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Expert Voice Support',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal,
          ),
        ),
      ),
      body: Column(
        children: [
          // Expert Selector Horizontal Bar
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            color: isDark ? AppColors.darkCard : Colors.white,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: VoiceService.experts.map((exp) {
                  final isSelected = exp.id == _selectedExpertId;
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: ChoiceChip(
                      label: Row(
                        children: [
                          Icon(
                            exp.id == 'agriculture'
                                ? Icons.grass_rounded
                                : (exp.id == 'apiculture' ? Icons.hive_rounded : Icons.water_rounded),
                            size: 16,
                            color: isSelected ? Colors.white : (isDark ? const Color(0xFF81C784) : AppColors.primaryGreen),
                          ),
                          const SizedBox(width: 6),
                          Text(exp.name),
                        ],
                      ),
                      selected: isSelected,
                      selectedColor: AppColors.primaryGreen,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : (isDark ? AppColors.darkTextSecondary : AppColors.textCharcoal),
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                      backgroundColor: isDark ? AppColors.darkSurface : const Color(0xFFF7F5EE),
                      onSelected: (_) {
                        setState(() {
                          _selectedExpertId = exp.id;
                          _messages.clear();
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // Expert Role Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            decoration: BoxDecoration(
              color: isDark ? AppColors.primaryGreen.withOpacity(0.18) : AppColors.lightMint,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.primaryGreen.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  currentExpert.role,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: isDark ? const Color(0xFF81C784) : AppColors.primaryGreen,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  currentExpert.description,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? const Color(0xFFA5D6A7) : AppColors.sageText,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),

          // Chat / Dialogue Messages List
          Expanded(
            child: _messages.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.mic_none_rounded,
                            size: 48,
                            color: AppColors.terracottaAccent.withOpacity(0.5),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Ask ${currentExpert.name}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Specialties: ${currentExpert.specializations.take(3).join(', ')}...',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final msg = _messages[index];
                      final isUser = msg['sender'] == 'user';
                      return Align(
                        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
                          decoration: BoxDecoration(
                            color: isUser
                                ? AppColors.primaryGreen
                                : (isDark ? AppColors.darkCard : Colors.white),
                            borderRadius: BorderRadius.circular(16),
                            border: (!isUser && isDark) ? Border.all(color: AppColors.darkBorder) : null,
                            boxShadow: [
                              BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6),
                            ],
                          ),
                          child: Text(
                            msg['text'] ?? '',
                            style: TextStyle(
                              color: isUser
                                  ? Colors.white
                                  : (isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal),
                              fontSize: 14,
                              height: 1.3,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),

          if (_isConsulting)
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primaryGreen)),
                  const SizedBox(width: 10),
                  Text(
                    'Consulting rural knowledge base...',
                    style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted),
                  ),
                ],
              ),
            ),

          // Input Bar with Mic & Send Action
          Container(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
            color: isDark ? AppColors.darkCard : Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _queryController,
                    style: TextStyle(color: isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal),
                    decoration: InputDecoration(
                      hintText: 'Type your question for ${currentExpert.name}...',
                      hintStyle: TextStyle(
                        fontSize: 13,
                        color: isDark ? AppColors.darkTextSecondary : const Color(0xFF9E9E9E),
                      ),
                      filled: true,
                      fillColor: isDark ? AppColors.darkSurface : const Color(0xFFF7F5EE),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    onSubmitted: (_) => _sendQuery(),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: _sendQuery,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      color: AppColors.terracottaDark,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
