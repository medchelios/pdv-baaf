import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final List<BoxShadow>? shadow;
  final double? borderRadius;
  final VoidCallback? onTap;

  const CustomCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.shadow,
    this.borderRadius,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget card = Container(
      padding: padding ?? const EdgeInsets.all(AppConstants.paddingL),
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppConstants.cardColor,
        borderRadius: BorderRadius.circular(borderRadius ?? AppConstants.radiusL),
        boxShadow: shadow ?? AppConstants.cardShadow,
      ),
      child: child,
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: card,
      );
    }

    return card;
  }
}
