import 'package:flutter/material.dart';
import '../utils/web_utils.dart';
import '../utils/font_utils.dart';

/// A safe wrapper widget that prevents Flutter Web rendering issues
class SafeWidget extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final bool preventHitTestErrors;

  const SafeWidget({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.preventHitTestErrors = true,
  });

  @override
  Widget build(BuildContext context) {
    Widget safeChild = child;

    // Wrap with error boundary if needed
    if (preventHitTestErrors) {
      safeChild = _SafeHitTestWidget(child: safeChild);
    }

    // Apply safe container if dimensions or spacing are provided
    if (padding != null || margin != null || width != null || height != null) {
      safeChild = Container(
        width: width?.safeSize,
        height: height?.safeSize,
        padding: _safePadding(padding),
        margin: _safePadding(margin),
        child: safeChild,
      );
    }

    return safeChild;
  }

  EdgeInsetsGeometry? _safePadding(EdgeInsetsGeometry? padding) {
    if (padding == null) return null;
    
    if (padding is EdgeInsets) {
      return EdgeInsets.only(
        left: padding.left.safePadding,
        top: padding.top.safePadding,
        right: padding.right.safePadding,
        bottom: padding.bottom.safePadding,
      );
    }
    
    return padding;
  }
}

/// Internal widget to handle hit test errors
class _SafeHitTestWidget extends StatelessWidget {
  final Widget child;

  const _SafeHitTestWidget({required this.child});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Ensure constraints are safe
        final safeConstraints = BoxConstraints(
          minWidth: WebUtils.safeSize(constraints.minWidth),
          maxWidth: WebUtils.safeSize(constraints.maxWidth, defaultValue: double.infinity),
          minHeight: WebUtils.safeSize(constraints.minHeight),
          maxHeight: WebUtils.safeSize(constraints.maxHeight, defaultValue: double.infinity),
        );

        return ConstrainedBox(
          constraints: safeConstraints,
          child: child,
        );
      },
    );
  }
}

/// Safe text widget that prevents rendering issues
class SafeText extends StatelessWidget {
  final String text;
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
    // Use Arabic-optimized style if no style provided
    final baseStyle = style ?? FontUtils.getArabicBodyStyle();
    
    final safeStyle = baseStyle.copyWith(
      fontSize: (baseStyle.fontSize ?? 14.0).safeFontSize,
      fontFamily: baseStyle.fontFamily ?? FontUtils.defaultArabicFont,
    );

    return Text(
      text,
      style: safeStyle,
      textAlign: textAlign ?? (FontUtils.containsArabic(text) ? TextAlign.right : TextAlign.left),
      textDirection: FontUtils.getTextDirection(text),
      maxLines: maxLines,
      overflow: overflow ?? TextOverflow.ellipsis,
    );
  }
}

/// Safe container that prevents dimension issues
class SafeContainer extends StatelessWidget {
  final Widget? child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Decoration? decoration;
  final AlignmentGeometry? alignment;

  const SafeContainer({
    super.key,
    this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.decoration,
    this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width?.safeSize,
      height: height?.safeSize,
      padding: _safePadding(padding),
      margin: _safePadding(margin),
      decoration: decoration,
      alignment: alignment,
      child: child,
    );
  }

  EdgeInsetsGeometry? _safePadding(EdgeInsetsGeometry? padding) {
    if (padding == null) return null;
    
    if (padding is EdgeInsets) {
      return EdgeInsets.only(
        left: padding.left.safePadding,
        top: padding.top.safePadding,
        right: padding.right.safePadding,
        bottom: padding.bottom.safePadding,
      );
    }
    
    return padding;
  }
}
