import 'package:flutter/material.dart';
import 'package:mono/core/constants/colors/app_colors.dart';
import 'package:mono/core/theme/app_texttheme.dart';

class AssetsCard extends StatelessWidget {
  const AssetsCard({super.key});

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
              Row(
                children: [
                  Icon(
                    Icons.account_balance_outlined,
                    color: AppColor.mainHexcolor,
                    size: 24,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Your Assets',
                    style: AppTextTheme.montserrart(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColor.mainHexcolor,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      // Add asset action
                    },
                    child: Text(
                      'Add Asset',
                      style: AppTextTheme.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColor.accentHexColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const _AssetsGrid(),
            ],
          ),
        ),
      ),
    );
  }
}

class _AssetsGrid extends StatelessWidget {
  const _AssetsGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 15,
      mainAxisSpacing: 15,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: const [
        _AssetTile(
          icon: Icons.currency_rupee,
          title: 'Cash',
          value: '₹12,500',
          growth: '+2.5%',
        ),
        _AssetTile(
          icon: Icons.account_balance,
          title: 'Bank Accounts',
          value: '₹85,000',
          growth: '+1.2%',
        ),
        _AssetTile(
          icon: Icons.currency_bitcoin,
          title: 'Crypto',
          value: '₹42,300',
          growth: '+5.7%',
        ),
        _AssetTile(
          icon: Icons.trending_up,
          title: 'Investments',
          value: '₹1,25,000',
          growth: '+3.8%',
        ),
        _AssetTile(
          icon: Icons.savings,
          title: 'Gold',
          value: '₹32,000',
          growth: '+0.9%',
        ),
        _AssetTile(
          icon: Icons.real_estate_agent,
          title: 'Property',
          value: '₹45,00,000',
          growth: '+2.1%',
        ),
      ],
    );
  }
}

class _AssetTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String growth;

  const _AssetTile({
    Key? key,
    required this.icon,
    required this.title,
    required this.value,
    required this.growth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: AppColor.mainHexcolor,
            size: 24,
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: AppTextTheme.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: AppTextTheme.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColor.mainHexcolor,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            growth,
            style: AppTextTheme.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: growth.startsWith('+') ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
