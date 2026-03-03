import 'package:flutter/material.dart';

class SavingsRateIndicator extends StatelessWidget {
  final double rate;

  const SavingsRateIndicator({super.key, required this.rate});

  Color _getColor() {
    if (rate < 10) return Colors.red;
    if (rate < 30) return Colors.orange;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: 120,
              width: 120,
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: rate / 100),
                duration: const Duration(seconds: 1),
                curve: Curves.easeOutCubic,
                builder: (context, value, _) => CircularProgressIndicator(
                  value: value,
                  strokeWidth: 12,
                  backgroundColor: Colors.grey.withValues(alpha: 0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(_getColor()),
                  strokeCap: StrokeCap.round,
                ),
              ),
            ),
            Column(
              children: [
                Text(
                  '${rate.toStringAsFixed(0)}%',
                  style: const TextStyle(
                      fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const Text(
                  'Saved',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            )
          ],
        ),
      ],
    );
  }
}
