import 'package:flutter/material.dart';
import '../theme/colors.dart';

class LuminousButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isPrimary;
  final double width;

  const LuminousButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isPrimary = true,
    this.width = double.infinity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: isPrimary
            ? const LinearGradient(
                colors: [AppColors.tertiary, AppColors.primaryLight],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: isPrimary ? null : AppColors.glassBackground,
        border: Border(
          top: BorderSide(
              color: isPrimary ? Colors.white.withOpacity(0.5) : AppColors.glassInnerGlow,
              width: 1),
        ),
        boxShadow: isPrimary
            ? [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.2),
                  blurRadius: 12,
                  spreadRadius: -1,
                  offset: const Offset(0, 4),
                )
              ]
            : [],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(vertical: 18),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
        ),
      ),
    );
  }
}
