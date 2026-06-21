import 'package:flutter/material.dart';
import '../theme/colors.dart';

class DynamicBookingInput extends StatefulWidget {
  final String label;
  final String hint;
  final IconData? prefixIcon;
  final TextInputType keyboardType;

  const DynamicBookingInput({
    Key? key,
    required this.label,
    required this.hint,
    this.prefixIcon,
    this.keyboardType = TextInputType.text,
  }) : super(key: key);

  @override
  _DynamicBookingInputState createState() => _DynamicBookingInputState();
}

class _DynamicBookingInputState extends State<DynamicBookingInput> {
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_isFocused)
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 4),
            child: Text(
              widget.label.toUpperCase(),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.primary,
                  ),
            ),
          ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _isFocused ? AppColors.primary : AppColors.outline,
              width: 1.2,
            ),
            boxShadow: _isFocused
                ? [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.08),
                      blurRadius: 8,
                      spreadRadius: 1,
                    )
                  ]
                : [],
          ),
          child: TextField(
            focusNode: _focusNode,
            keyboardType: widget.keyboardType,
            style: Theme.of(context).textTheme.bodyLarge,
            decoration: InputDecoration(
              hintText: _isFocused ? '' : widget.hint,
              hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                  ),
              prefixIcon: widget.prefixIcon != null
                  ? Icon(
                      widget.prefixIcon,
                      color: _isFocused ? AppColors.primary : AppColors.textSecondary,
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
