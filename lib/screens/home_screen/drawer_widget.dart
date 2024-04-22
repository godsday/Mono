import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants/app_color.dart';
import '../setting_screen/settings_screen.dart';
import '../setting_screen/settings_widgets/about_screen.dart';

Widget customNavigationDrawer(
    context, bool, animation1, animation2, animation3) {
  double height = MediaQuery.of(context).size.height;
  double width = MediaQuery.of(context).size.width;
  return BackdropFilter(
    filter:
        ImageFilter.blur(sigmaY: animation1.value, sigmaX: animation1.value),
    child: Container(
      height: bool ? 0 : height,
      width: bool ? 0 : width,
      decoration: BoxDecoration(
          gradient: LinearGradient(
        colors: [mainHexcolor, Colors.transparent],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      )),
      child: Center(
        child: Transform.scale(
          scale: animation3.value,
          child: Container(
            width: width * .9,
            height: width * 1.3,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(animation2.value),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.black12,
                  radius: 35,
                  child: Icon(
                    Icons.person_outline_rounded,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
                Column(
                  children: [
                    myTile(Icons.settings_outlined, 'Settings', () async {
                      // HapticFeedback.lightImpact();
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const SettingsScreen(),
                      ));
                    }),
                    myTile(Icons.info_outline_rounded, 'About', () {
                      HapticFeedback.lightImpact();
                      // Fluttertoast.showToast(
                      //   msg: 'Button pressed',
                      // );
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AboutScreen()));
                    }),
                    myTile(Icons.feedback_outlined, 'Feedback', () async {
                      HapticFeedback.lightImpact();
                      // Fluttertoast.showToast(
                      //   msg: 'Button pressed',
                      // );
                      if (!await launch(
                          'mailto:rafikkvavoor@gmail.com?subject=Mono-App&body=write your own...')) {
                        throw 'Could not send massage';
                      }
                    }),
                    myTile(Icons.find_in_page_outlined, 'Privacy Policy', () {
                      HapticFeedback.lightImpact();
                      // Fluttertoast.showToast(
                      //   msg: 'Button pressed',
                      // );
                    }),
                  ],
                ),
                // const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

Widget myTile(
  IconData icon,
  String title,
  VoidCallback voidCallback,
) {
  return Column(
    children: [
      ListTile(
        tileColor: Colors.black.withOpacity(.08),
        leading: CircleAvatar(
          backgroundColor: Colors.black12,
          child: Icon(
            icon,
            color: Colors.white,
          ),
        ),
        onTap: voidCallback,
        title: Text(
          title,
          style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 1),
        ),
        trailing: const Icon(
          Icons.arrow_right,
          color: Colors.white,
        ),
      ),
      // divider()
    ],
  );
}
