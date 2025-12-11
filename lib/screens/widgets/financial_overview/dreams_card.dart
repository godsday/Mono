import 'package:flutter/material.dart';
import 'package:mono/constants/colors/app_color.dart';
import 'package:mono/constants/utils/app_texttheme.dart';

class DreamsCard extends StatelessWidget {
  const DreamsCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        gradient: const LinearGradient(
          colors: [
            Color(0xFFF9F5FF),
            Colors.white,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: InkWell(
        onTap: () {
          // Handle tap
        },
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Dreams & Goals',
                style: AppTextTheme.montserrart(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColor.mainHexcolor,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Plan big. Track smart.',
                style: AppTextTheme.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                height: 200,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: const [
                    _DreamCard(
                      icon: Icons.directions_bike,
                      title: 'Buy a Bike',
                      goalAmount: '₹2,50,000',
                      savedAmount: '₹85,000',
                      progress: 0.34,
                    ),
                    _DreamCard(
                      icon: Icons.beach_access,
                      title: 'Go to Maldives',
                      goalAmount: '₹1,80,000',
                      savedAmount: '₹45,000',
                      progress: 0.25,
                    ),
                    _DreamCard(
                      icon: Icons.savings,
                      title: 'Emergency Fund',
                      goalAmount: '₹5,00,000',
                      savedAmount: '₹2,10,000',
                      progress: 0.42,
                    ),
                    _DreamCard(
                      icon: Icons.directions_car,
                      title: 'BMW M3 Dream Car',
                      goalAmount: '₹1,20,00,000',
                      savedAmount: '₹15,00,000',
                      progress: 0.125,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Create new dream action
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.mainHexcolor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 12,
                    ),
                  ),
                  child: Text('Create New Dream',
                  style: AppTextTheme.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DreamCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String goalAmount;
  final String savedAmount;
  final double progress;

  const _DreamCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.goalAmount,
    required this.savedAmount,
    required this.progress,
  }) : super(key: key);

  @override
  State<_DreamCard> createState() => _DreamCardState();
}

class _DreamCardState extends State<_DreamCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: 150,
          margin: const EdgeInsets.only(right: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(15),
          child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    widget.icon,
                    color: AppColor.mainHexcolor,
                    size: 28,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.title,
                    style: AppTextTheme.montserrart(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColor.mainHexcolor,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'Goal: ${widget.goalAmount}',
                    style: AppTextTheme.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Saved: ${widget.savedAmount}',
                    style: AppTextTheme.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: widget.progress,
                      backgroundColor: AppColor.accentHexColor.withOpacity(0.3),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColor.mainHexcolor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      // Track goal action
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.mainHexcolor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      textStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    child: Text('Track Goal',
                    style: AppTextTheme.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),),
                  ),
                ],
              ),
            ),
        ),
      ),
    );
  }
}