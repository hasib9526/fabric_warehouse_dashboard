import 'package:flutter/material.dart';

/// Responsive utility class for scaling UI elements based on screen size
/// Designed for TV screens with various resolutions (720p, 1080p, 4K, etc.)
class ResponsiveUtils {
  final BuildContext context;
  late final Size _screenSize;
  late final double _width;
  late final double _height;

  // Base design dimensions (reference screen - typically 1920x1080 for TV)
  static const double baseWidth = 1920.0;
  static const double baseHeight = 1080.0;

  ResponsiveUtils(this.context) {
    _screenSize = MediaQuery.of(context).size;
    _width = _screenSize.width;
    _height = _screenSize.height;
  }

  /// Get responsive width based on design width
  double width(double designWidth) {
    return (_width / baseWidth) * designWidth;
  }

  /// Get responsive height based on design height
  double height(double designHeight) {
    return (_height / baseHeight) * designHeight;
  }

  /// Get responsive font size
  double fontSize(double designSize) {
    // Use width as primary reference for font scaling
    final scale = _width / baseWidth;
    return designSize * scale;
  }

  /// Get responsive spacing/padding
  double spacing(double designSpacing) {
    // Average of width and height scaling for balanced spacing
    final scale = ((_width / baseWidth) + (_height / baseHeight)) / 2;
    return designSpacing * scale;
  }

  /// Get responsive border width
  double borderWidth(double designBorderWidth) {
    final scale = (_width / baseWidth);
    return designBorderWidth * scale;
  }

  /// Get responsive icon size
  double iconSize(double designIconSize) {
    final scale = (_width / baseWidth);
    return designIconSize * scale;
  }

  /// Get responsive chart size (width and height)
  Size chartSize(double designSize) {
    final scale = ((_width / baseWidth) + (_height / baseHeight)) / 2;
    final size = designSize * scale;
    return Size(size, size);
  }

  /// Get screen width
  double get screenWidth => _width;

  /// Get screen height
  double get screenHeight => _height;

  /// Get screen size
  Size get screenSize => _screenSize;

  /// Get horizontal padding
  EdgeInsets horizontalPadding(double designPadding) {
    return EdgeInsets.symmetric(horizontal: width(designPadding));
  }

  /// Get vertical padding
  EdgeInsets verticalPadding(double designPadding) {
    return EdgeInsets.symmetric(vertical: height(designPadding));
  }

  /// Get all-sides padding
  EdgeInsets allPadding(double designPadding) {
    return EdgeInsets.all(spacing(designPadding));
  }

  /// Get custom padding
  EdgeInsets customPadding({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) {
    return EdgeInsets.only(
      left: width(left),
      top: height(top),
      right: width(right),
      bottom: height(bottom),
    );
  }
}

/// Extension method for easy access to ResponsiveUtils
extension ResponsiveContext on BuildContext {
  ResponsiveUtils get responsive => ResponsiveUtils(this);
}
