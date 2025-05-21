import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mono/screens/widgets/bottomnavigationbar.dart';
import 'package:mono/screens/widgets/navigator_animation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:mono/utils/app_textstyle.dart';

class OnboardScreen extends StatelessWidget {
  OnboardScreen({Key? key}) : super(key: key);

  final namecontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior:
          HitTestBehavior.opaque, // Ensures tap is detected on blank space
      onTap: () {
        FocusScope.of(context).unfocus(); // Dismisses the keyboard
      },
      child: Scaffold(
          body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 60.h,
                alignment: Alignment.topCenter,
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage('assets/images/onboardbg.png'),
                  fit: BoxFit.cover,
                )),
                child: Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Column(
                    children: [
                      FittedBox(
                        child: Text("Spend Smarter Save More",
                            textAlign: TextAlign.center,
                            style: AppTextStyles.roboto22w800Green(context)),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      Container(
                          width: 80.w,
                          height: 5.h,
                          child: Text(
                              "Take control of your money with \n powerful tracking and planning tools",
                              textAlign: TextAlign.center,
                              style: AppTextStyles.roboto15w400grey(context))),
                      SizedBox(
                        height: 2.h,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 135.0, left: 85, right: 85),
                child: Image(
                  image: AssetImage(
                    'assets/images/OO.png',
                  ),
                ),
              ),
            ],
          ),
          NameTextfieldWidget(namecontroller: namecontroller),
          Padding(
              padding: EdgeInsets.only(
                left: 40,
                right: 40,
              ),
              child: GestureDetector(
                onTap: () {
                  gotohome(context);
                },
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [HexColor('#69AEA9'), HexColor('#3F8782')],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "Get Started",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )),
        ],
      )),
    );
  }

  gotohome(context) async {
    final namecontrol = namecontroller.text;
    final sharedprefer = await SharedPreferences.getInstance();
    sharedprefer.setString('namekey', namecontrol);

    Navigator.pushAndRemoveUntil(context,
        CustomPageRoute(child: const BottomNavigator()), (route) => false);
  }
}

class NameTextfieldWidget extends StatefulWidget {
  const NameTextfieldWidget({
    Key? key,
    required this.namecontroller,
  }) : super(key: key);

  final TextEditingController namecontroller;

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
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
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
      padding: const EdgeInsets.only(left: 40, right: 40, top: 30, bottom: 20),
      child: TextFormField(
        textAlign: TextAlign.center,
        keyboardType: TextInputType.text,
        controller: widget.namecontroller,
        focusNode: _focusNode,
        decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            isDense: true,
            filled: true,
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: HexColor('#DADADA')),
                borderRadius: BorderRadius.circular(12)),
            fillColor: HexColor('#FBF3F3'),
            hintText: _isFocused ? null : 'Enter name here',
            hintStyle: TextStyle(
                fontSize: 16.sp, color: const Color.fromARGB(255, 59, 59, 58)),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: HexColor("#DADADA")),
                borderRadius: BorderRadius.circular(12))),
      ),
    );
  }
}
/*
class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height / 1.2);
    path.quadraticBezierTo(size.width, size.height, size.width, size.height);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
*/
