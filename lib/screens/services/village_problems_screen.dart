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
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
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
              const Text('Report Village Grievance', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              const Text('Your issue will be forwarded to the Palghar Gram Panchayat and district authorities.', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
              const SizedBox(height: 16),
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Issue Title',
                  hintText: 'e.g. Broken Handpump or Road Potholes',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _descController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Explain the issue and exact landmark...',
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedCategory,
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
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        title: const Text('Village Grievances', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
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
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.borderSubtle),
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
                              color: AppColors.lightMint,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              prob.category.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryGreen,
                              ),
                            ),
                          ),
                          _buildStatusBadge(prob.status),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        prob.title,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textCharcoal),
                      ),
                      if (prob.description != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          prob.description!,
                          style: const TextStyle(fontSize: 13, color: AppColors.textMuted, height: 1.3),
                        ),
                      ],
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined, size: 14, color: AppColors.textMuted),
                          const SizedBox(width: 4),
                          Text('${prob.village ?? 'Palghar'}, ${prob.district ?? 'Palghar'}', style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                          const Spacer(),
                          Text('Priority: ${prob.priority.toUpperCase()}', style: const TextStyle(fontSize: 11, color: AppColors.terracottaAccent, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bg;
    Color fg;
    String label;

    switch (status) {
      case 'resolved':
        bg = const Color(0xFFE8F5E9);
        fg = AppColors.statusSuccess;
        label = 'Resolved';
        break;
      case 'in_progress':
        bg = const Color(0xFFE0F7FA);
        fg = AppColors.statusInfo;
        label = 'In Progress';
        break;
      case 'under_review':
        bg = const Color(0xFFFFF3E0);
        fg = AppColors.statusWarning;
        label = 'Under Review';
        break;
      default:
        bg = const Color(0xFFF5F5F5);
        fg = AppColors.textMuted;
        label = 'Reported';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(6)),
      child: Text(label, style: TextStyle(color: fg, fontSize: 11, fontWeight: FontWeight.bold)),
    );
  }
}
