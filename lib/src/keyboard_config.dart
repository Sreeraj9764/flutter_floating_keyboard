import 'package:flutter/material.dart';

/// Configuration for the FlutterFloatingKeyboard widget appearance and behavior.
@immutable
class FlutterFloatingKeyboardConfig {
  const FlutterFloatingKeyboardConfig({
    this.keyboardHeight = 220.0,
    this.backgroundColor = const Color(0xF0E8E8E8),
    this.keyColor = const Color(0xFFFFFFFF),
    this.specialKeyColor = const Color(0xFFB8B8B8),
    this.keyTextColor = const Color(0xFF1A1A1A),
    this.keyBorderRadius = 6.0,
    this.keySpacing = 4.0,
    this.rowSpacing = 6.0,
    this.enableHaptics = true,
    this.enableDrag = true,
    this.enableNumberMode = true,
    this.enableSymbolMode = true,
    this.showDragHandle = true,
    this.elevation = 8.0,
    this.borderRadius = 12.0,
    this.widthFactor,
    this.maxKeyboardWidth = 700.0,
  });

  /// Total height of the keyboard widget.
  final double keyboardHeight;

  /// Background color of the keyboard container.
  final Color backgroundColor;

  /// Color of regular character keys.
  final Color keyColor;

  /// Color of special keys (shift, backspace, enter, mode switch).
  final Color specialKeyColor;

  /// Text color for key labels.
  final Color keyTextColor;

  /// Border radius of individual keys.
  final double keyBorderRadius;

  /// Horizontal spacing between keys.
  final double keySpacing;

  /// Vertical spacing between rows.
  final double rowSpacing;

  /// Whether to enable haptic feedback on key press.
  final bool enableHaptics;

  /// Whether the keyboard can be dragged to reposition.
  final bool enableDrag;

  /// Whether the numbers mode is available.
  final bool enableNumberMode;

  /// Whether the symbols mode is available.
  final bool enableSymbolMode;

  /// Whether to show the drag handle at the top.
  final bool showDragHandle;

  /// Elevation/shadow of the keyboard container.
  final double elevation;

  /// Border radius of the keyboard container.
  final double borderRadius;

  /// Optional fixed width factor (0.0–1.0) for the keyboard.
  ///
  /// When set, overrides the default responsive breakpoint logic and uses
  /// this fraction of available width instead.
  final double? widthFactor;

  /// Maximum keyboard width in logical pixels.
  final double maxKeyboardWidth;

  /// Computes the responsive keyboard width based on available space.
  ///
  /// If [widthFactor] is set, uses that fraction directly.
  /// Otherwise uses breakpoints:
  /// - < 500dp → 95% (phones portrait)
  /// - 500–900dp → 75% (phones landscape, small tablets)
  /// - > 900dp → 60% (large tablets, desktop)
  ///
  /// Clamped to [maxKeyboardWidth].
  double computeKeyboardWidth(double availableWidth) {
    final double widthFraction;
    if (widthFactor != null) {
      widthFraction = widthFactor!.clamp(0.0, 1.0);
    } else if (availableWidth < 500) {
      widthFraction = 0.95;
    } else if (availableWidth < 900) {
      widthFraction = 0.75;
    } else {
      widthFraction = 0.60;
    }
    return (availableWidth * widthFraction).clamp(0.0, maxKeyboardWidth);
  }

  /// Create a copy with modified values.
  FlutterFloatingKeyboardConfig copyWith({
    double? keyboardHeight,
    Color? backgroundColor,
    Color? keyColor,
    Color? specialKeyColor,
    Color? keyTextColor,
    double? keyBorderRadius,
    double? keySpacing,
    double? rowSpacing,
    bool? enableHaptics,
    bool? enableDrag,
    bool? enableNumberMode,
    bool? enableSymbolMode,
    bool? showDragHandle,
    double? elevation,
    double? borderRadius,
    double? widthFactor,
    double? maxKeyboardWidth,
  }) {
    return FlutterFloatingKeyboardConfig(
      keyboardHeight: keyboardHeight ?? this.keyboardHeight,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      keyColor: keyColor ?? this.keyColor,
      specialKeyColor: specialKeyColor ?? this.specialKeyColor,
      keyTextColor: keyTextColor ?? this.keyTextColor,
      keyBorderRadius: keyBorderRadius ?? this.keyBorderRadius,
      keySpacing: keySpacing ?? this.keySpacing,
      rowSpacing: rowSpacing ?? this.rowSpacing,
      enableHaptics: enableHaptics ?? this.enableHaptics,
      enableDrag: enableDrag ?? this.enableDrag,
      enableNumberMode: enableNumberMode ?? this.enableNumberMode,
      enableSymbolMode: enableSymbolMode ?? this.enableSymbolMode,
      showDragHandle: showDragHandle ?? this.showDragHandle,
      elevation: elevation ?? this.elevation,
      borderRadius: borderRadius ?? this.borderRadius,
      widthFactor: widthFactor ?? this.widthFactor,
      maxKeyboardWidth: maxKeyboardWidth ?? this.maxKeyboardWidth,
    );
  }
}
