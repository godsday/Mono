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
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 80.h,
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
                        style: AppTextStyles.roboto24BoldGreen(context)),
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
                        style: TextStyle(fontSize: 16.sp)),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Flexible(
                    child: Image(
                        image: AssetImage(
                      'assets/images/OO.png',
                    )),
                  ),
                ],
              ),
            ),
          ),
          /*     Column(children: [
            SizedBox(
              height: 3.h,
            ),
            SizedBox(
              height: 1.5.h,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 100, right: 100),
              child: TextField(
                keyboardType: TextInputType.text,
                controller: namecontroller,
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    isDense: true,
                    filled: true,
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: HexColor('#429690')),
                        borderRadius: BorderRadius.circular(30)),
                    fillColor: HexColor('#F4F5F5'),
                    hintText: 'Please Enter Your name',
                    hintStyle: TextStyle(fontSize: 8.5.sp),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: HexColor("#438883")),
                        borderRadius: BorderRadius.circular(30))),
              ),
            ),
            SizedBox(
              height: 4.h,
            ),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(HexColor('#3E7C78')),
                  shape: MaterialStateProperty.all(const StadiumBorder()),
                  minimumSize:
                      MaterialStateProperty.all(const Size(320, 55))),
              onPressed: () {
                gotohome(context);
              },
              child: Text(
                "Get Started",
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 4.h,
            ),
          ]),
             */
        ],
      ),
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
