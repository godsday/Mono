// import 'package:flutter/material.dart'; // These are the Viewport values of your Figma Design.

// // These are used in the code as a reference to create your UI Responsively.
// const num FIGMA_DESIGN_WIDTH = 375;
// const num FIGMA_DESIGN_HEIGHT = 667;
// const num FIGMA_DESIGN_STATUS_BAR = 0;

// extension ResponsiveExtension on num {
//   double get _width => SizeUtils.width;

//   double get h => ((this * _width) / FIGMA_DESIGN_WIDTH);

//   double get fSize => ((this * _width) / FIGMA_DESIGN_WIDTH);
// }

// extension FormatExtension on double {
//   double toDoubleValue({int fractionDigits = 2}) {
//     return double.parse(this.toStringAsFixed(fractionDigits));
//   }

//   double isNonZero({num defaultValue = 0.0}) {
//     return this > 0 ? this : defaultValue.toDouble();
//   }
// }

// enum DeviceType { mobile, tablet, desktop }

// typedef ResponsiveBuild = Widget Function(
//   BuildContext context,
//   Orientation orientation,
//   DeviceType deviceType,
// );

// class Sizer extends StatelessWidget {
//   const Sizer({Key? key, required this.builder}) : super(key: key);

//   /// Builds the widget whenever the orientation changes.
//   final ResponsiveBuild builder;

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         return OrientationBuilder(
//           builder: (context, orientation) {
//             SizeUtils.setScreenSize(constraints, orientation);
//             return builder(context, orientation, SizeUtils.deviceType);
//           },
//         );
//       },
//     );
//   }
// }

// // ignore_for_file: must_be_immutable
// class SizeUtils {
//   /// Device's BoxConstraints
//   static late BoxConstraints boxConstraints;

//   /// Device's Orientation
//   static late Orientation orientation;

//   /// Type of Device
//   ///
//   /// This can either be mobile or tablet
//   static late DeviceType deviceType;

//   /// Device's Height
//   static late double height;

//   /// Device's Width
//   static late double width=100;

//   static void setScreenSize(
//     BoxConstraints constraints,
//     Orientation currentOrientation,
//   ) {
//     boxConstraints = constraints;
//     orientation = currentOrientation;
//     if (orientation == Orientation.portrait) {
//       width = boxConstraints.maxWidth.isNonZero(
//         defaultValue: FIGMA_DESIGN_WIDTH,
//       );
//       height = boxConstraints.maxHeight.isNonZero();
//     } else {
//       width = boxConstraints.maxHeight.isNonZero(
//         defaultValue: FIGMA_DESIGN_WIDTH,
//       );
//       height = boxConstraints.maxWidth.isNonZero();
//     }
//     deviceType = DeviceType.mobile;
//   }
// }
