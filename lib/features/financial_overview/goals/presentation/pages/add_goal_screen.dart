import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
// ignore: depend_on_referenced_packages
import 'package:uuid/uuid.dart';
import '../../../../../core/constants/colors/app_colors.dart';
import '../../../../../core/theme/app_texttheme.dart';
import '../../domain/entities/goal_entity.dart';
import '../providers/goals_provider.dart';
import 'package:mono/core/utils/extension/context_extension.dart';

class AddGoalScreen extends StatefulWidget {
  final GoalEntity? goal;

  const AddGoalScreen({super.key, this.goal});

  @override
  State<AddGoalScreen> createState() => _AddGoalScreenState();
}

class _AddGoalScreenState extends State<AddGoalScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _targetAmountController = TextEditingController();
  final _savedAmountController = TextEditingController(text: '0');

  DateTime? _selectedDeadline;
  bool _isSaving = false;
  String _selectedChip = '';

  final List<Map<String, dynamic>> _dreamChips = [
    {'title': 'Dream Bike', 'icon': '🏍'},
    {'title': 'Travel', 'icon': '✈️'},
    {'title': 'Home', 'icon': '🏠'},
    {'title': 'Startup', 'icon': '💻'},
    {'title': 'New Phone', 'icon': '📱'},
    {'title': 'Education', 'icon': '🎓'},
  ];

  @override
  void initState() {
    super.initState();
    if (widget.goal != null) {
      _titleController.text = widget.goal!.title;
      _targetAmountController.text =
          widget.goal!.targetAmount.toStringAsFixed(0);
      _savedAmountController.text = widget.goal!.savedAmount.toStringAsFixed(0);
      _selectedDeadline = widget.goal!.deadline;
    }
    _titleController.addListener(() => setState(() {}));
    _targetAmountController.addListener(() => setState(() {}));
    _savedAmountController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _targetAmountController.dispose();
    _savedAmountController.dispose();
    super.dispose();
  }

  void _saveGoal() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final title = _titleController.text.trim();
    final targetAmount =
        double.tryParse(_targetAmountController.text.trim()) ?? 0.0;
    final savedAmount =
        double.tryParse(_savedAmountController.text.trim()) ?? 0.0;
    final deadline =
        _selectedDeadline ?? DateTime.now().add(const Duration(days: 365));

    if (widget.goal != null) {
      final updatedGoal = widget.goal!.copyWith(
        title: title,
        targetAmount: targetAmount,
        savedAmount: savedAmount,
        deadline: deadline,
      );
      await context.read<GoalsProvider>().updateGoal(updatedGoal);
    } else {
      final newGoal = GoalEntity(
        id: const Uuid().v4(),
        title: title,
        targetAmount: targetAmount,
        savedAmount: savedAmount,
        deadline: deadline,
      );
      await context.read<GoalsProvider>().addGoal(newGoal);
    }

    if (mounted) {
      Navigator.pop(context, true);
    }
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 30)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365 * 10)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColor.mainHexcolor,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedDeadline = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // Very soft light background
      body: Stack(
        children: [
          // 6. Soft Background Elements
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColor.mainHexcolor.withValues(alpha: 0.05),
              ),
            ),
          ),
          Positioned(
            bottom: 200,
            left: -150,
            child: Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColor.mainHexcolor.withValues(alpha: 0.03),
              ),
            ),
          ),

          SafeArea(
            bottom: false,
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: _buildHeader(),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 20.0),
                  sliver: SliverToBoxAdapter(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSuggestedChips(),
                          const SizedBox(height: 30),
                          Text(
                            'Dream Details',
                            style: AppTextTheme.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildInputFields(),
                          const SizedBox(height: 30),
                          _buildDreamPreview(),
                          const SizedBox(height: 20),
                          _buildMotivationCard(),
                          const SizedBox(height: 30),
                          _buildSaveButton(),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Back Button Overlay
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 10,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }

  // 1. Premium Gradient Header
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 40, bottom: 40, left: 24, right: 24),
      decoration: BoxDecoration(
        gradient: AppColor.mainGradient,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColor.mainHexcolor.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
              height:
                  20), // Top padding for safe area logic with overlapping button
          Text(
            widget.goal != null
                ? context.l10n.edit_goal_title
                : "Add Dream / Goal",
            style: AppTextTheme.montserrart(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Turn small savings into meaningful milestones ✨",
            style: AppTextTheme.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }

  // 2. Add Suggested Dream Chips
  Widget _buildSuggestedChips() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Suggestions',
          style: AppTextTheme.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: _dreamChips.map((chip) {
            final isSelected = _selectedChip == chip['title'];
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedChip = chip['title'];
                  _titleController.text = chip['title'];
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? LinearGradient(
                          colors: [
                            AppColor.mainHexcolor,
                            AppColor.mainHexcolor.withValues(alpha: 0.8),
                          ],
                        )
                      : null,
                  color: isSelected ? null : Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isSelected
                        ? Colors.transparent
                        : AppColor.mainHexcolor.withValues(alpha: 0.5),
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColor.mainHexcolor.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          )
                        ]
                      : [],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(chip['icon']),
                    const SizedBox(width: 6),
                    Text(
                      chip['title'],
                      style: AppTextTheme.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color:
                            isSelected ? Colors.white : AppColor.mainHexcolor,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // 3. Improve Input Fields
  Widget _buildInputFields() {
    return Column(
      children: [
        _buildCustomTextField(
          controller: _titleController,
          label: 'Goal Title',
          hint: 'e.g. New Car, World Tour',
          icon: Icons.flag_outlined,
          formatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]'))
          ],
          validator: (value) =>
              value == null || value.isEmpty ? 'Please enter a title' : null,
        ),
        const SizedBox(height: 16),
        _buildCustomTextField(
          controller: _targetAmountController,
          label: 'Target Amount (${context.currencySymbol})',
          hint: '0.00',
          icon: Icons.account_balance_wallet_outlined,
          isNumber: true,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter target amount';
            }
            if (double.tryParse(value) == null) return 'Invalid number';
            return null;
          },
        ),
        const SizedBox(height: 16),
        _buildCustomTextField(
          controller: _savedAmountController,
          label: 'Already Saved (Optional)',
          hint: '0.00',
          icon: Icons.savings_outlined,
          isNumber: true,
        ),
        const SizedBox(height: 16),
        InkWell(
          onTap: _pickDate,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey[200]!),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today_outlined,
                    color: AppColor.mainHexcolor, size: 22),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _selectedDeadline == null
                        ? 'Select Target Date'
                        : '${_selectedDeadline!.day}/${_selectedDeadline!.month}/${_selectedDeadline!.year}',
                    style: AppTextTheme.poppins(
                      fontSize: 15,
                      color: _selectedDeadline == null
                          ? Colors.grey[500]
                          : Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCustomTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool isNumber = false,
    List<TextInputFormatter>? formatters,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        style: AppTextTheme.poppins(color: Colors.black87, fontSize: 15),
        decoration: InputDecoration(
          labelText: label,
          labelStyle:
              AppTextTheme.poppins(color: Colors.grey[600], fontSize: 14),
          hintText: hint,
          hintStyle:
              AppTextTheme.poppins(color: Colors.grey[400], fontSize: 14),
          prefixIcon: Icon(icon, color: AppColor.mainHexcolor, size: 22),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.grey[200]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.grey[200]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: AppColor.mainHexcolor, width: 1.5),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        ),
        inputFormatters: formatters ??
            (isNumber
                ? [
                    FilteringTextInputFormatter.allow(RegExp(r'^[0-9]*$')),
                    LengthLimitingTextInputFormatter(10),
                  ]
                : []),
        validator: validator,
      ),
    );
  }

  // 5. Add Dream Preview Card
  Widget _buildDreamPreview() {
    final title =
        _titleController.text.isEmpty ? 'Your Dream' : _titleController.text;
    final target = double.tryParse(_targetAmountController.text) ?? 0.0;
    final saved = double.tryParse(_savedAmountController.text) ?? 0.0;

    double progress = target > 0 ? (saved / target) : 0.0;
    if (progress > 1.0) progress = 1.0;
    if (progress < 0.0) progress = 0.0;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [
            AppColor.mainHexcolor.withValues(alpha: 0.05),
            Colors.white.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: Colors.white, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColor.mainHexcolor.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: AppTextTheme.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColor.mainHexcolor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Preview',
                        style: AppTextTheme.poppins(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: AppColor.mainHexcolor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Saved',
                          style: AppTextTheme.poppins(
                              fontSize: 12, color: Colors.grey[600]),
                        ),
                        Text(
                          '${context.currencySymbol}${saved.toStringAsFixed(0)}',
                          style: AppTextTheme.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColor.mainHexcolor,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Target',
                          style: AppTextTheme.poppins(
                              fontSize: 12, color: Colors.grey[600]),
                        ),
                        Text(
                          '${context.currencySymbol}${target.toStringAsFixed(0)}',
                          style: AppTextTheme.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Stack(
                  children: [
                    Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: 8,
                      width: MediaQuery.of(context).size.width * 0.8 * progress,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColor.mainHexcolor.withValues(alpha: 0.7),
                            AppColor.mainHexcolor,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '${(progress * 100).toStringAsFixed(1)}% completed',
                  style: AppTextTheme.poppins(
                      fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 4. Add Motivation Insight Card
  Widget _buildMotivationCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.mainHexcolor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColor.mainHexcolor.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.auto_awesome, color: AppColor.mainHexcolor, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Small savings today can create big opportunities tomorrow.",
                  style: AppTextTheme.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "₹100/day can become ₹36,500/year",
                  style: AppTextTheme.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 7. Maintain Existing CTA Style
  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColor.mainHexcolor.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: _isSaving ? null : _saveGoal,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.mainHexcolor,
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
          ),
          child: _isSaving
              ? const CircularProgressIndicator(color: Colors.white)
              : Text(
                  widget.goal != null
                      ? context.l10n.update_goal_button
                      : 'Start This Dream',
                  style: AppTextTheme.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
        ),
      ),
    );
  }
}
