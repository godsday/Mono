import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mono/l10n/app_localizations.dart';
import 'package:mono/providers/locale_provider.dart';
import 'package:mono/features/widgets/bottomnavigationbar.dart';
import 'package:mono/core/widgets/navigator_animation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:mono/core/constants/app_textstyle/app_textstyle.dart';
import 'package:provider/provider.dart';

class OnboardScreen extends StatelessWidget {
  OnboardScreen({super.key});

  final namecontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
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
                                  width: 80.w,
                                  child: Text(
                                    l10n.onboarding_subtitle,
                                    textAlign: TextAlign.center,
                                    style:
                                        AppTextStyles.roboto15w400grey(context),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 22.h,
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
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(28),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 20),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: Column(
                        children: [
                          NameTextfieldWidget(
                            namecontroller: namecontroller,
                            hintText: l10n.enter_name_hint,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: _OnboardButton(
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
              Positioned(
                top: 10,
                right: 20,
                child: _LanguageSelector(),
              ),
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

    Navigator.pushAndRemoveUntil(
        context,
        CustomPageRoute(child: const BottomNavigator(index: 1)),
        (route) => false);
  }
}

class _OnboardButton extends StatefulWidget {
  final VoidCallback onTap;
  final String text;

  const _OnboardButton({required this.onTap, required this.text});

  @override
  State<_OnboardButton> createState() => _OnboardButtonState();
}

class _OnboardButtonState extends State<_OnboardButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          width: double.infinity,
          height: 6.h,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [HexColor('#69AEA9'), HexColor('#3F8782')],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: HexColor('#3F8782').withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            widget.text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class _LanguageSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleProvider>(
      builder: (context, provider, child) {
        return PopupMenuButton<Locale>(
          initialValue: provider.locale,
          icon: Container(
            padding: const EdgeInsets.all(8),
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
              L10n.getFlag(provider.locale?.languageCode ?? 'en'),
              style: const TextStyle(fontSize: 20),
            ),
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
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
          LengthLimitingTextInputFormatter(7),
        ],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.text,
        controller: widget.namecontroller,
        focusNode: _focusNode,
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
            hintStyle: TextStyle(
                fontSize: 16.sp, color: const Color.fromARGB(255, 59, 59, 58)),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: HexColor("#DADADA")),
                borderRadius: BorderRadius.circular(12))),
      ),
    );
  }
}
