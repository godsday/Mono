import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import 'package:mono/database/Transctions_DB/transcations_db.dart';
import 'package:mono/providers/app_state.dart';
import 'package:mono/screens/add_screen/add_screen.dart';
import 'package:mono/screens/transcation_screen/transcation_screen.dart';
import 'package:mono/screens/widgets/navigator_animation.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String enteredname = '';

  @override
  void initState() {
    super.initState();
    Provider.of<AppState>(context, listen: false).refresh();

    getnamedata();
  }

  getnamedata() async {
    final sharedprefer = await SharedPreferences.getInstance();
    enteredname = sharedprefer.getString('namekey')!;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.topCenter,
              clipBehavior: Clip.none,
              children: [
                ClipPath(
                  clipper: CurveClipper(),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(70.0),
                          bottomRight: Radius.circular(35.0)),
                      color: Theme.of(context).dividerColor,
                    ),
                    height: 59.h,
                  ),
                ),
                Positioned(
                  top: 5.h,
                  left: 10.w,
                  child: Text("Hi, $enteredname ",
                      style: TextStyle(
                        fontFamily: "DancingScript",
                        color: Colors.white,
                        fontSize: 23.sp,
                      )),
                ),
                Positioned(
                  top: 11.h,
                  left: 10.w,
                  child: Text(
                    "Welcome back !",
                    style: TextStyle(
                        fontFamily: "DancingScript",
                        color: Colors.white,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Positioned(
                  top: 18.h,
                  left: 10.w,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        height: 24.h,
                        width: 80.w,
                        decoration: BoxDecoration(
                            color: HexColor("#37474F"),
                            borderRadius: BorderRadius.circular(20.0)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: .5.h,
                              ),
                              const Text(
                                "Available balance",
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(
                                height: 1.99.h,
                              ),
                              Consumer<AppState>(
                                  builder: (context, provider, child) {
                                return AutoSizeText(
                                  provider.totalBalance.toStringAsFixed(1),
                                  maxLines: 1,
                                  minFontSize: 23,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 30.0.sp,
                                      fontWeight: FontWeight.bold),
                                );
                              }),
                              const Spacer(),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: ((context) =>
                                              const TranscationScreen())));
                                },
                                child: const Text(
                                  "See details",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                          bottom: -11.h,
                          right: -10.w,
                          child: Image(
                            image:
                                const AssetImage("assets/images/piggybank.png"),
                            width: 24.0.h,
                            height: 24.h,
                          )),
                    ],
                  ),
                ),
                Positioned(
                  left: -11.w,
                  bottom: -20.h,
                  child: Image(
                    image: const AssetImage("assets/images/monotree.png"),
                    width: 41.h,
                    height: 41.h,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  "Cash",
                  style:
                      TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 2.h),
                Stack(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: 39.w,
                        height: 22.h,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Theme.of(context).indicatorColor),
                        child: Padding(
                          padding: const EdgeInsets.all(13.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  width: 6.h,
                                  height: 6.h,
                                  decoration: BoxDecoration(
                                      color: HexColor('#42887C'),
                                      borderRadius: BorderRadius.circular(30)),
                                  child: const Icon(
                                    Icons.house_siding,
                                    color: Colors.white,
                                  )),
                              SizedBox(
                                height: 5.h,
                              ),
                              Consumer<AppState>(
                                  builder: (context, provider, child) {
                                return AutoSizeText(
                                  provider.totalIncome.toStringAsFixed(1),
                                  minFontSize: 13,
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontSize: 18.0.sp,
                                      fontWeight: FontWeight.bold),
                                );
                              }),
                              Text(
                                "Income",
                                style: TextStyle(
                                    fontFamily: "Merriweather",
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).focusColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: 39.w,
                        height: 22.h,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Theme.of(context).hoverColor),
                        child: Padding(
                          padding: const EdgeInsets.all(13.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                  width: 6.h,
                                  height: 6.h,
                                  decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          255, 230, 146, 21),
                                      borderRadius: BorderRadius.circular(30)),
                                  child: const Icon(
                                    Icons.account_balance_wallet,
                                    color: Colors.white,
                                  )),
                              SizedBox(
                                height: 5.h,
                              ),
                              Consumer<AppState>(
                                  builder: (context, provider, child) {
                                return AutoSizeText(
                                  provider.totalExpense.toStringAsFixed(1),
                                  minFontSize: 13,
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontSize: 18.0.sp,
                                      fontWeight: FontWeight.bold),
                                );
                              }),
                              Text("Expense",
                                  style: TextStyle(
                                      fontFamily: "Merriweather",
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).focusColor)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 5.5.h,
                    left: 40.w,
                    child: SizedBox(
                      width: 10.h,
                      height: 10.h,
                      child: FloatingActionButton(
                        onPressed: () {
                          // TranscationDB.instance.refresh();
                          Navigator.push(context,
                              CustomPageRoute(child: const AddScreen()));
                        },
                        backgroundColor: HexColor('#FFC727'),
                        child: Icon(
                          Icons.add,
                          color: Colors.black,
                          size: 28.sp,
                        ),
                      ),
                    ),
                  )
                ]),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class CurveClipper extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height / 1.17);
    path.quadraticBezierTo(size.width, size.height, size.width, size.height);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) {
    return true;
  }
}
