import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../../../../core/constants/colors/app_colors.dart';
import '../../../../../core/theme/app_texttheme.dart';
import '../../domain/entities/goal_entity.dart';
import '../providers/goals_provider.dart';

class AddGoalScreen extends StatefulWidget {
  const AddGoalScreen({super.key});

  @override
  State<AddGoalScreen> createState() => _AddGoalScreenState();
}

class _AddGoalScreenState extends State<AddGoalScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _targetAmountController = TextEditingController();

  // Optional: Deadline controller, saved initially controller?
  // User asked for: "title, targetAmount, savedAmount, deadline"
  // Let's add savedAmount (for initial existing savings towards this goal)
  final _savedAmountController = TextEditingController(text: '0');

  // Simplifying deadline for now to "Optional" or just not enforcing date picker complexity unless needed
  DateTime? _selectedDeadline;

  bool _isSaving = false;

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
    final deadline = _selectedDeadline ??
        DateTime.now().add(const Duration(days: 365)); // Default 1 year

    final newGoal = GoalEntity(
      id: const Uuid().v4(),
      title: title,
      targetAmount: targetAmount,
      savedAmount: savedAmount,
      deadline: deadline,
    );

    await context.read<GoalsProvider>().addGoal(newGoal);

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
      backgroundColor: Colors.grey[50], // Light background
      appBar: AppBar(
        title: Text(
          "Add Dream / Goal",
          style: AppTextTheme.montserrart(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Goal Details',
                style: AppTextTheme.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColor.mainHexcolor,
                ),
              ),
              const SizedBox(height: 20),

              // Title Field
              TextFormField(
                controller: _titleController,
                style: AppTextTheme.poppins(color: Colors.black),
                decoration: InputDecoration(
                  labelText: 'Goal Title',
                  hintText: 'e.g. New Car, World Tour',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter a title'
                    : null,
              ),
              const SizedBox(height: 20),

              // Target Amount
              TextFormField(
                controller: _targetAmountController,
                keyboardType: TextInputType.number,
                style: AppTextTheme.poppins(color: Colors.black),
                decoration: InputDecoration(
                  labelText: 'Target Amount (₹)',
                  hintText: '0.00',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Please enter target amount';
                  if (double.tryParse(value) == null) return 'Invalid number';
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Saved Amount (Optional / Initial)
              TextFormField(
                controller: _savedAmountController,
                keyboardType: TextInputType.number,
                style: AppTextTheme.poppins(color: Colors.black),
                decoration: InputDecoration(
                  labelText: 'Already Saved (Optional)',
                  hintText: '0.00',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 20),

              // Deadline Picker
              InkWell(
                onTap: _pickDate,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedDeadline == null
                            ? 'Select Target Date'
                            : '${_selectedDeadline!.day}/${_selectedDeadline!.month}/${_selectedDeadline!.year}',
                        style: AppTextTheme.poppins(
                            fontSize: 16,
                            color: _selectedDeadline == null
                                ? Colors.grey[700]
                                : Colors.black),
                      ),
                      const Icon(Icons.calendar_today, color: Colors.grey),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveGoal,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.mainHexcolor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: _isSaving
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          'Start This Dream',
                          style: AppTextTheme.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
