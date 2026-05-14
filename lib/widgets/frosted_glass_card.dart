import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/colors.dart';

class FrostedGlassCard extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry padding;

  const FrostedGlassCard({
    Key? key,
    required this.child,
    this.borderRadius = 24.0,
    this.padding = const EdgeInsets.all(20.0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 25.0, sigmaY: 25.0),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: AppColors.glassBackground,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border(
              top: BorderSide(color: AppColors.glassInnerGlow, width: 1),
              left: BorderSide(color: AppColors.glassInnerGlow, width: 1),
              bottom: BorderSide(color: Colors.transparent, width: 1),
              right: BorderSide(color: Colors.transparent, width: 1),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
