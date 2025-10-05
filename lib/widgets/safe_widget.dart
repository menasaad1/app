import 'package:flutter/material.dart';

/// A safe text widget that handles null values gracefully
class SafeText extends StatelessWidget {
  final String? text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const SafeText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text ?? '',
      style: style,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

/// A safe container widget that handles null values gracefully
class SafeContainer extends StatelessWidget {
  final Widget? child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BoxDecoration? decoration;
  final double? width;
  final double? height;

  const SafeContainer({
    super.key,
    this.child,
    this.padding,
    this.margin,
    this.decoration,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      margin: margin,
      decoration: decoration,
      width: width,
      height: height,
      child: child,
    );
  }
}

/// A safe icon widget that handles null values gracefully
class SafeIcon extends StatelessWidget {
  final IconData? icon;
  final double? size;
  final Color? color;

  const SafeIcon(
    this.icon, {
    super.key,
    this.size,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon ?? Icons.help_outline,
      size: size,
      color: color,
    );
  }
}
