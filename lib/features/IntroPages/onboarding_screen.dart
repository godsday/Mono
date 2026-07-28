import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mono/core/constants/colors/app_colors.dart';
import 'package:mono/core/theme/app_theme.dart';
import 'package:mono/core/utils/extension/app_extension.dart';
import 'package:mono/l10n/app_localizations.dart';
import 'package:mono/providers/locale_provider.dart';

import 'package:mono/routes/route_names.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:mono/core/constants/app_textstyle/app_textstyle.dart';
import 'package:mono/core/notifications/notification_service.dart';
import 'package:provider/provider.dart';

class OnboardScreen extends StatelessWidget {
  OnboardScreen({super.key});

  final namecontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          height: 65.h,
                          alignment: Alignment.topCenter,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/onboardbg.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(40, 60, 40, 20),
                            child: Column(
                              children: [
                                SizedBox(height: 1.h),
                                FittedBox(
                                  child: Text(
                                    l10n.onboarding_title,
                                    textAlign: TextAlign.center,
                                    style: AppTextStyles.roboto22w800Green(
                                        context),
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                SizedBox(
                                  width: 65.w,
                                  child: Text(
                                    l10n.onboarding_subtitle,
                                    textAlign: TextAlign.center,
                                    style: AppTextStyles.poppins15w400(context)!
                                        .copyWith(
                                            color: AppColor.textGrey,
                                            fontSize: 15.sp),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 25.h,
                          child: SizedBox(
                            height: 44.h,
                            width: 80.w,
                            child: Image.asset(
                              'assets/images/OO.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 40),
                      child: Column(
                        children: [
                          NameTextfieldWidget(
                            namecontroller: namecontroller,
                            hintText: l10n.enter_name_hint,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: OnboardButton(
                              onTap: () {
                                gotohome(context);
                              },
                              text: l10n.get_started,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              //  Positioned(
              //   top: 10,
              //   right: 20,
              //   child: _LanguageSelector(),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  gotohome(context) async {
    final namecontrol = namecontroller.text;
    final sharedprefer = await SharedPreferences.getInstance();
    sharedprefer.setString('namekey', namecontrol);

    // Prompt for notification permissions after onboarding
    await NotificationService().requestPermissions();

    if (!context.mounted) return;

    Navigator.pushNamedAndRemoveUntil(
        context, RouteNames.bottomNav, (route) => false);
  }
}

class OnboardButton extends StatefulWidget {
  final VoidCallback onTap;
  final String text;

  const OnboardButton({
    super.key,
    required this.onTap,
    required this.text,
  });

  @override
  State<OnboardButton> createState() => _OnboardButtonState();
}

class _OnboardButtonState extends State<OnboardButton> {
  bool pressed = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: Ink(
        decoration: BoxDecoration(
          gradient:
              Theme.of(context).extension<AppGradients>()!.primaryGradient,
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: widget.onTap,
          onHighlightChanged: (value) {
            setState(() => pressed = value);
          },
          child: AnimatedScale(
            scale: pressed ? .96 : 1,
            duration: const Duration(milliseconds: 100),
            child: SizedBox(
              width: double.infinity,
              height: 6.h,
              child: Center(
                child: Text(widget.text),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ignore: unused_element
class _LanguageSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleProvider>(
      builder: (context, provider, child) {
        return PopupMenuButton<Locale>(
          initialValue: provider.locale,
          icon: Row(
            children: [
              const Icon(Icons.language),
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.8),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Text(
                  L10n.getFlag(provider.locale?.countryCode ?? 'en'),
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
          onSelected: (locale) {
            provider.setLocale(locale);
          },
          itemBuilder: (context) => L10n.all
              .map(
                (locale) => PopupMenuItem<Locale>(
                  value: locale,
                  child: Row(
                    children: [
                      Text(L10n.getFlag(locale.languageCode),
                          style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: 10),
                      Text(L10n.getLanguageName(locale.languageCode)),
                    ],
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }
}

class NameTextfieldWidget extends StatefulWidget {
  const NameTextfieldWidget({
    super.key,
    required this.namecontroller,
    required this.hintText,
  });

  final TextEditingController namecontroller;
  final String hintText;

  @override
  State<NameTextfieldWidget> createState() => _NameTextfieldWidgetState();
}

class _NameTextfieldWidgetState extends State<NameTextfieldWidget> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (mounted) {
        setState(() {
          _isFocused = _focusNode.hasFocus;
        });
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 20),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your name';
          }
          final wordCount =
              value.trim().split(' ').where((word) => word.isNotEmpty).length;
          if (wordCount > 3) {
            return 'Only 3 words accepted';
          }
          return null;
        },
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
          LengthLimitingTextInputFormatter(50),
        ],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.text,
        controller: widget.namecontroller,
        focusNode: _focusNode,
        onChanged: (value) {
          // Count words
          final wordCount =
              value.trim().split(' ').where((word) => word.isNotEmpty).length;

          // If more than 2 words, restrict and show warning
          if (wordCount > 3) {
            // Show warning message
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Only 3 words accepted'),
                duration: Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
              ),
            );

            // Keep only first 3 words
            final words = value
                .trim()
                .split(' ')
                .where((word) => word.isNotEmpty)
                .toList();
            final newValue = words.take(3).join(' ');

            // Update controller without triggering onChanged again
            widget.namecontroller.value = TextEditingValue(
              text: newValue.capitalizeFirstLetter(),
              selection: TextSelection.fromPosition(
                TextPosition(offset: newValue.length),
              ),
            );
          } else {
            // Normal capitalization
            widget.namecontroller.value = TextEditingValue(
              text: value.capitalizeFirstLetter(),
              selection: TextSelection.fromPosition(
                TextPosition(offset: value.length),
              ),
            );
          }
        },
        decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            isDense: true,
            filled: true,
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: HexColor('#DADADA')),
                borderRadius: BorderRadius.circular(12)),
            fillColor: HexColor('#FBF3F3'),
            hintText: _isFocused ? null : widget.hintText,
            hintStyle: AppTextStyles.poppins16w400
                .copyWith(fontSize: 15.sp, color: AppColor.grey),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: HexColor("#DADADA")),
                borderRadius: BorderRadius.circular(12))),
      ),
    );
  }
}
