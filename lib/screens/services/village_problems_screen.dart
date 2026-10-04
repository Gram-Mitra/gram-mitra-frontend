import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../models/village_problem.dart';
import '../../services/problem_service.dart';

class VillageProblemsScreen extends StatefulWidget {
  const VillageProblemsScreen({super.key});

  @override
  State<VillageProblemsScreen> createState() => _VillageProblemsScreenState();
}

class _VillageProblemsScreenState extends State<VillageProblemsScreen> {
  List<VillageProblem> _problems = [];
  bool _isLoading = true;

  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  String _selectedCategory = 'water';
  String _selectedPriority = 'high';

  @override
  void initState() {
    super.initState();
    _loadProblems();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _loadProblems() async {
    setState(() => _isLoading = true);
    final data = await ProblemService.getProblems();
    if (mounted) {
      setState(() {
        _problems = data;
        _isLoading = false;
      });
    }
  }

  void _showReportDialog() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? AppColors.darkCard : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Report Village Grievance',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Your issue will be forwarded to the Palghar Gram Panchayat and district authorities.',
                style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _titleController,
                style: TextStyle(color: isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal),
                decoration: InputDecoration(
                  labelText: 'Issue Title',
                  hintText: 'e.g. Broken Handpump or Road Potholes',
                  hintStyle: TextStyle(color: isDark ? AppColors.darkTextSecondary : null),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _descController,
                maxLines: 3,
                style: TextStyle(color: isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal),
                decoration: InputDecoration(
                  labelText: 'Description',
                  hintText: 'Explain the issue and exact landmark...',
                  hintStyle: TextStyle(color: isDark ? AppColors.darkTextSecondary : null),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      dropdownColor: isDark ? AppColors.darkCard : Colors.white,
                      style: TextStyle(color: isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal),
                      decoration: const InputDecoration(labelText: 'Category'),
                      items: const [
                        DropdownMenuItem(value: 'water', child: Text('Water Supply')),
                        DropdownMenuItem(value: 'road', child: Text('Roads')),
                        DropdownMenuItem(value: 'electricity', child: Text('Electricity')),
                        DropdownMenuItem(value: 'sanitation', child: Text('Sanitation')),
                        DropdownMenuItem(value: 'animal', child: Text('Animal Care')),
                      ],
                      onChanged: (v) => setModalState(() => _selectedCategory = v ?? 'water'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedPriority,
                      dropdownColor: isDark ? AppColors.darkCard : Colors.white,
                      style: TextStyle(color: isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal),
                      decoration: const InputDecoration(labelText: 'Priority'),
                      items: const [
                        DropdownMenuItem(value: 'low', child: Text('Low')),
                        DropdownMenuItem(value: 'medium', child: Text('Medium')),
                        DropdownMenuItem(value: 'high', child: Text('High')),
                        DropdownMenuItem(value: 'urgent', child: Text('Urgent')),
                      ],
                      onChanged: (v) => setModalState(() => _selectedPriority = v ?? 'high'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryGreen),
                  onPressed: () async {
                    if (_titleController.text.trim().isEmpty) return;
                    Navigator.pop(ctx);
                    await ProblemService.reportProblem(
                      title: _titleController.text.trim(),
                      description: _descController.text.trim(),
                      category: _selectedCategory,
                      priority: _selectedPriority,
                    );
                    _titleController.clear();
                    _descController.clear();
                    _loadProblems();
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Village problem reported successfully! Status: Under Review'),
                        backgroundColor: AppColors.primaryGreen,
                      ),
                    );
                  },
                  child: const Text('Submit Grievance', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Village Grievances',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primaryGreen,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Report Issue', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        onPressed: _showReportDialog,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primaryGreen))
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 80),
              itemCount: _problems.length,
              separatorBuilder: (_, __) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                final prob = _problems[index];
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkCard : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.borderSubtle),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.primaryGreen.withOpacity(0.2) : AppColors.lightMint,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              prob.category.toUpperCase(),
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: isDark ? const Color(0xFF81C784) : AppColors.primaryGreen,
                              ),
                            ),
                          ),
                          _buildStatusBadge(prob.status, isDark),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        prob.title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal,
                        ),
                      ),
                      if (prob.description != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          prob.description!,
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                            height: 1.3,
                          ),
                        ),
                      ],
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.location_on_outlined, size: 14, color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted),
                          const SizedBox(width: 4),
                          Text(
                            '${prob.village ?? 'Palghar'}, ${prob.district ?? 'Palghar'}',
                            style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted),
                          ),
                          const Spacer(),
                          Text(
                            'Priority: ${prob.priority.toUpperCase()}',
                            style: const TextStyle(fontSize: 11, color: AppColors.terracottaAccent, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Widget _buildStatusBadge(String status, bool isDark) {
    Color bg;
    Color fg;
    String label;

    switch (status) {
      case 'resolved':
        bg = isDark ? AppColors.statusSuccess.withOpacity(0.2) : const Color(0xFFE8F5E9);
        fg = isDark ? const Color(0xFF81C784) : AppColors.statusSuccess;
        label = 'Resolved';
        break;
      case 'in_progress':
        bg = isDark ? AppColors.statusInfo.withOpacity(0.2) : const Color(0xFFE0F7FA);
        fg = isDark ? const Color(0xFF4FC3F7) : AppColors.statusInfo;
        label = 'In Progress';
        break;
      case 'under_review':
        bg = isDark ? AppColors.statusWarning.withOpacity(0.2) : const Color(0xFFFFF3E0);
        fg = isDark ? const Color(0xFFFFB74D) : AppColors.statusWarning;
        label = 'Under Review';
        break;
      default:
        bg = isDark ? AppColors.darkSurface : const Color(0xFFF5F5F5);
        fg = isDark ? AppColors.darkTextSecondary : AppColors.textMuted;
        label = 'Reported';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(6)),
      child: Text(label, style: TextStyle(color: fg, fontSize: 11, fontWeight: FontWeight.bold)),
    );
  }
}
