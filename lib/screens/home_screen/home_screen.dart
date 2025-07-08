import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mono/constants/app_color.dart';
import 'package:mono/main.dart';
import 'package:mono/providers/app_state.dart';
import 'package:mono/screens/add_screen/add_screen.dart';
import 'package:mono/screens/home_screen/widgets/bottom_card_L_shape.dart';
import 'package:mono/screens/home_screen/widgets/shapes/curveshape_L_card.dart';
import 'package:mono/screens/home_screen/widgets/shapes/curve_shape_U_card.dart';
import 'package:mono/screens/home_screen/widgets/total_balance_card.dart';
import 'package:mono/ts/drawer_widget.dart';
import 'package:mono/screens/widgets/navigator_animation.dart';
import 'package:mono/utils/app_textstyle.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  String enteredname = '';
  late AnimationController _animationController;
  late Animation<double> _animation1;
  late Animation<double> _animation2;
  late Animation<double> _animation3;

  bool _bool = true;

  @override
  void initState() {
    super.initState();
    Provider.of<AppState>(context, listen: false).refresh();

    getnamedata();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 600));

    _animation1 = Tween<double>(begin: 0, end: 20).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
      reverseCurve: Curves.easeIn,
    ))
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.dismissed) {
          _bool = true;
        }
      });
    _animation2 = Tween<double>(begin: 0, end: .3).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });
    _animation3 = Tween<double>(begin: .9, end: 1).animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.fastLinearToSlowEaseIn,
        reverseCurve: Curves.ease))
      ..addListener(() {
        setState(() {});
      });
  }

  getnamedata() async {
    final sharedprefer = await SharedPreferences.getInstance();
    enteredname = sharedprefer.getString('namekey')!;
    setState(() {});
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      // appBar: AppBar(
      //     // brightness: Brightness.dark,
      //     elevation: 0,
      //     backgroundColor: Colors.transparent,
      //     actions: [
      //       Padding(
      //         padding: const EdgeInsets.all(8.0),
      //         child: CircleAvatar(
      //           radius: 4.sp,
      //           backgroundColor: const Color.fromARGB(136, 26, 20, 20),
      //           child: IconButton(
      //             icon: Icon(Icons.lightbulb),
      //             splashColor: const Color.fromARGB(0, 84, 43, 43),
      //             onPressed: () {
      //               // if (_bool == true) {
      //               //   _animationController.forward();
      //               // } else {
      //               //   _animationController.reverse();
      //               // }
      //               // _bool = false;
      //             },
      //           ),
      //         ),
      //       ),
      //     ]),
      body: Column(
        children: [
          Stack(
            alignment: Alignment.topCenter,
            clipBehavior: Clip.none,
            children: [
              ClipPath(
                clipper: CurveClipper2(),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).dividerColor,
                  ),
                  height: 55.h,
                ),
              ),
              // Positioned(
              //     top: 3.h,
              //     left: 5.w,
              //     child: InkWell(
              //       onTap: () async {
              //         Navigator.of(context).push(MaterialPageRoute(
              //           builder: (context) => MyCustomUI(),
              //         ));
              //       },
              //       child: CircleAvatar(
              //           radius: 15.sp,
              //           backgroundColor: Colors.amber,
              //           child: Container(
              //             child: Icon(Icons.person),
              //           )),
              //     )),
              Positioned(
                top: 5.h,
                left: 7.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Hi $enteredname,",
                        style: TextStyle(
                          // fontFamily: "DancingScript",
                          color: Colors.white,
                          fontSize: 20.sp,
                        )),
                    Text("Good Morning  ",
                        style: TextStyle(
                          // fontFamily: "DancingScript",
                          color: Colors.white,
                          fontSize: 20.sp,
                        )),
                  ],
                ),
              ),
              Positioned(
                  top: 4.h,
                  right: 7.w,
                  child: Container(
                    width: 7.w,
                    height: 7.h,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color.fromARGB(255, 240, 238, 236)),
                    child: Icon(
                      Icons.lightbulb,
                      color: const Color.fromARGB(255, 60, 104, 125),
                      size: 18,
                    ),
                  )),

              // detail card
              Positioned(
                  top: 30.h,
                  left: 12.w,
                  child: Container(
                    height: 12.h,
                    width: 76.w,
                    decoration: BoxDecoration(
                        color: HexColor("#37474F"),
                        borderRadius: BorderRadius.circular(24.0)),
                  )),

              Positioned(
                top: 14.h,
                left: 7.w,
                right: 7.w,
                child: InkWell(
                  // onTap: () async {
                  //   Navigator.of(context).push(MaterialPageRoute(
                  //     builder: (context) => const TranscationScreen(),
                  //   ));
                  // },
                  // Total Balance Card
                  child: TotalBalanceCard(),
                ),
              ),
              Positioned(
                  top: 20.3.h,
                  child: Image(
                    width: 47.w,
                    image: AssetImage(
                      'assets/images/rings.png',
                    ),
                  )),
              Positioned(
                right: 1.w,
                bottom: -20.h,
                child: ClipRect(
                  child: Align(
                      alignment: Alignment.topCenter,
                      child: SizedBox(
                        width: 24.0.h,
                        height: 24.h,
                        // Height of the visible portion
                        // child: ShaderMask(
                        //   shaderCallback: (Rect bounds) {
                        //     return LinearGradient(
                        //       begin: Alignment.bottomCenter,
                        //       end: Alignment.topCenter,
                        //       colors: [Colors.transparent, Colors.black],
                        //     ).createShader(bounds);
                        //   },
                        // blendMode: BlendMode.dstIn,
                        child: Image.asset(
                          'assets/images/piggybank.png', // Replace 'your_image.jpg' with your image asset
                          fit: BoxFit.cover,
                        ),
                        // ),
                      )),
                ),
              ),
              Positioned(
                left: -11.w,
                bottom: -30.h,
                child: Image(
                  image: const AssetImage("assets/images/monotree.png"),
                  width: 41.h,
                  height: 41.h,
                ),
              ),
            ],
          ),
          Spacer(),
          Column(
            children: [
              Text(
                "Cash",
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 2.h),
              /*  Stack(children: [
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
                                    color:
                                        const Color.fromARGB(255, 230, 146, 21),
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
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(37)),
                      onPressed: () {
                        // TranscationDB.instance.refresh();
                        Navigator.push(
                            context, CustomPageRoute(child: const AddScreen()));
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
           */
              // SizedBox(
              //   width: 12,
              // ),
              // LShapeWidget(orientation: LShapeOrientation.leftLegOnRight)
            ],
          ),
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16),
                child: Row(
                  children: [
                    LShapeWidget(
                      orientation: LShapeOrientation.leftLegOnLeft,
                      color: greenContainer,
                    ),
                    SizedBox(
                      width: 4.w,
                    ),
                    LShapeWidget(
                      orientation: LShapeOrientation.leftLegOnRight,
                      color: redContainer,
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 8.h,
                left: 41.w,
                child: Container(
                  width: 10.h,
                  height: 10.h,
                  decoration: BoxDecoration(
                      border: Border.all(width: 2, color: Colors.white),
                      shape: BoxShape.circle,
                      color: Colors.amber),
                  child: Icon(
                    Icons.add,
                    color: Colors.black,
                    size: 28.sp,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),

      // FloatingActionButtonLocation.miniCenterFloat,
      // floatingActionButton: Container(
      //   width: 15.w,
      //   height: 10.h,
      //   decoration: BoxDecoration(color: Colors.amber),
      // ),
    );
  }
}

class IncomeExpenseCard extends StatelessWidget {
  final String transactionType;
  final double value;

  const IncomeExpenseCard({
    super.key,
    required this.transactionType,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          transactionType,
          style: AppTextStyles.poppins18w500White(context),
        ),
        Text(
          "₹ ${value.toString()}",
          style: AppTextStyles.roboto18w600SemiBoldWhite(context),
        ),
      ],
    );
  }
}
