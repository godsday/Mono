import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About"),
        backgroundColor: Theme.of(context).primaryColorDark,
      ),
      body: Stack(children: [
        Container(
          height: 100.h,
          width: 100.w,
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).shadowColor,
              HexColor('#edede9'),
            ],
          )),
          child: Padding(
            padding: const EdgeInsets.only(top: 30, right: 50, left: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                    text: TextSpan(
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 13.sp),
                        children: const [
                      TextSpan(
                          text: "Mono",
                          style: TextStyle(fontFamily: "Merriweather")),
                      TextSpan(text: " 5.1.0.3"),
                    ])),
                SizedBox(
                  height: 2.h,
                ),
                const AutoSizeText(
                  "Mono is a offline money management  Application.Were we can manage our incomes and expenses.",
                  style: TextStyle(fontFamily: "Courgette"),
                ),
                SizedBox(
                  height: 5.h,
                ),
                Row(
                  children: [
                    const Text("Developer",
                        style: TextStyle(fontFamily: "Courgette")),
                    TextButton(
                      onPressed: () async {
                        // ignore_for_file: deprecated_member_use
                        if (!await launch(
                            "https://godsday.github.io/Portfolio/")) {
                          throw 'Try after sometimes';
                        }
                      },
                      child: Text("Muhammed Rafi",
                          style: TextStyle(
                              fontFamily: "Courgette",
                              fontSize: 12.sp,
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
        Positioned(
            right: .01.w,
            bottom: -7.2.h,
            child: Image.asset(
              'assets/images/singhboy.png',
              width: 78.w,
              height: 68.h,
            )),
      ]),
    );
  }
}
