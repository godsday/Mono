import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';



enum LShapeOrientation {
  /// Standard L-shape: vertical leg on the left, horizontal base extends to the right.
  /// ```
  /// ##
  /// ##
  /// ######
  /// ```
  leftLegOnLeft,

  /// Mirrored L-shape: vertical leg on the right, horizontal base extends to the left.
  /// ```
  ///   ##
  ///   ##
  /// ######
  /// ```
  leftLegOnRight,
}

class UnifiedCurvedLShapeClipper extends CustomClipper<Path> {
  /// The width of the vertical part of the L-shape.
  final double verticalLegWidth;

  /// The height of the horizontal part (the base) of the L-shape.
  final double horizontalBaseHeight;

  /// The radius for all outer corners. If `innerCornerRadius` is not specified, this also applies to the inner corner.
  final double cornerRadius;

  /// The radius specifically for the inner corner of the L-shape.
  /// If null, `cornerRadius` will be used for the inner corner.
  final double? innerCornerRadius;

  /// Determines the orientation of the L-shape.
  final LShapeOrientation orientation;

  UnifiedCurvedLShapeClipper({
    required this.verticalLegWidth,
    required this.horizontalBaseHeight,
    required this.cornerRadius,
    this.innerCornerRadius, // Made optional
    required this.orientation,
  });

  @override
  Path getClip(Size size) {
    final path = Path();
    final double totalWidth = size.width;
    final double totalHeight = size.height;

    // Ensure L-shape dimensions are valid within the total size
    if (verticalLegWidth <= 0 ||
        horizontalBaseHeight <= 0 ||
        verticalLegWidth > totalWidth ||
        horizontalBaseHeight > totalHeight) {
      return path; // Empty path for invalid dimensions
    }

    // Adjust outer cornerRadius
    final double maxOuterRadiusForVerticalLeg = math.min(
        verticalLegWidth / 2, (totalHeight - horizontalBaseHeight) / 2);
    final double maxOuterRadiusForHorizontalBase =
        math.min(horizontalBaseHeight / 2, (totalWidth - verticalLegWidth) / 2);

    final double adjustedOuterRadius = cornerRadius
        .clamp(0.0, maxOuterRadiusForVerticalLeg)
        .clamp(0.0, maxOuterRadiusForHorizontalBase);

    // Determine the effective inner radius
    // Use provided innerCornerRadius, or fallback to the (adjusted) outer cornerRadius
    final double effectiveInnerRadiusValue =
        innerCornerRadius ?? adjustedOuterRadius;

    // Adjust effectiveInnerRadius to ensure it doesn't cause geometric issues
    // It shouldn't be larger than half the thickness of the arms at the inner corner.
    final double maxInnerRadius =
        math.min(verticalLegWidth / 2, horizontalBaseHeight / 2);
    final double adjustedInnerRadius =
        effectiveInnerRadiusValue.clamp(0.0, maxInnerRadius);

    // --- Draw the path as if it's always LShapeOrientation.leftLegOnLeft ---

    // P1: Start at top-left of the vertical leg, after the curve
    path.moveTo(adjustedOuterRadius, 0);

    // Top edge of the vertical leg
    path.lineTo(verticalLegWidth - adjustedOuterRadius, 0);
    // Top-right corner of the vertical leg
    path.arcToPoint(
      Offset(verticalLegWidth, adjustedOuterRadius),
      radius: Radius.circular(adjustedOuterRadius),
      clockwise: true,
    );

    // Right edge of the vertical leg, down to the inner corner
    path.lineTo(verticalLegWidth,
        totalHeight - horizontalBaseHeight - adjustedInnerRadius);
    // Inner corner (joining vertical leg to horizontal base)
    path.arcToPoint(
      Offset(verticalLegWidth + adjustedInnerRadius,
          totalHeight - horizontalBaseHeight),
      radius:
          Radius.circular(adjustedInnerRadius), // Use adjustedInnerRadius here
      clockwise:
          false, // Counter-clockwise for an inner scoop from this direction
    );

    // Top edge of the horizontal base
    path.lineTo(
        totalWidth - adjustedOuterRadius, totalHeight - horizontalBaseHeight);
    // Top-right corner of the horizontal base (which is an outer corner of the L)
    path.arcToPoint(
      Offset(
          totalWidth, totalHeight - horizontalBaseHeight + adjustedOuterRadius),
      radius: Radius.circular(adjustedOuterRadius),
      clockwise: true,
    );

    // Right edge of the L-shape
    path.lineTo(totalWidth, totalHeight - adjustedOuterRadius);
    // Bottom-right corner of the L-shape
    path.arcToPoint(
      Offset(totalWidth - adjustedOuterRadius, totalHeight),
      radius: Radius.circular(adjustedOuterRadius),
      clockwise: true,
    );

    // Bottom edge of the L-shape
    path.lineTo(adjustedOuterRadius, totalHeight);
    // Bottom-left corner of the L-shape
    path.arcToPoint(
      Offset(0, totalHeight - adjustedOuterRadius),
      radius: Radius.circular(adjustedOuterRadius),
      clockwise: true,
    );

    // Left edge of the L-shape (vertical leg)
    path.lineTo(0, adjustedOuterRadius);
    // Top-left corner of the L-shape (completing the path)
    path.arcToPoint(
      Offset(adjustedOuterRadius, 0),
      radius: Radius.circular(adjustedOuterRadius),
      clockwise: true,
    );

    path.close();

    // If the orientation is for the leg to be on the right, flip the entire path horizontally
    if (orientation == LShapeOrientation.leftLegOnRight) {
      final Matrix4 flipMatrix = Matrix4.identity()
        ..translate(totalWidth / 2, 0.0)
        ..scale(-1.0, 1.0, 1.0)
        ..translate(-totalWidth / 2, 0.0);
      return path.transform(flipMatrix.storage);
    }

    return path;
  }

  @override
  bool shouldReclip(covariant UnifiedCurvedLShapeClipper oldClipper) {
    return oldClipper.verticalLegWidth != verticalLegWidth ||
        oldClipper.horizontalBaseHeight != horizontalBaseHeight ||
        oldClipper.cornerRadius != cornerRadius ||
        oldClipper.innerCornerRadius !=
            innerCornerRadius || // Added check for innerCornerRadius
        oldClipper.orientation != orientation;
  }
}
