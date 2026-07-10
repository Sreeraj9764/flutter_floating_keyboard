import 'package:flutter/material.dart';

import 'keyboard_theme.dart';

/// Configuration for the FlutterFloatingKeyboard widget appearance and behavior.
@immutable
class FlutterFloatingKeyboardConfig {
  const FlutterFloatingKeyboardConfig({
    this.theme,
    this.darkTheme,
    this.keyboardHeight = 240.0,
    this.keyHeight = 44.0,
    this.keyBorderRadius = 7.0,
    this.keySpacing = 5.0,
    this.rowSpacing = 7.0,
    this.enableHaptics = true,
    this.enableSound = true,
    this.enableDrag = true,
    this.enableNumberMode = true,
    this.enableSymbolMode = true,
    this.showDragHandle = true,
    this.showKeyPreview,
    this.animateShowHide = true,
    this.elevation = 8.0,
    this.borderRadius = 14.0,
    this.widthFactor,
    this.maxKeyboardWidth = 700.0,
    this.constrainDragBounds = true,
  });

  /// Visual theme used when the ambient brightness is light.
  ///
  /// If null, [FlutterFloatingKeyboardTheme.light] is used.
  final FlutterFloatingKeyboardTheme? theme;

  /// Visual theme used when the ambient brightness is dark.
  ///
  /// If null, falls back to [theme] if provided, otherwise
  /// [FlutterFloatingKeyboardTheme.dark].
  final FlutterFloatingKeyboardTheme? darkTheme;

  /// Total height of the keyboard widget (used for drag bound clamping).
  final double keyboardHeight;

  /// Height of individual keys.
  final double keyHeight;

  /// Border radius of individual keys.
  final double keyBorderRadius;

  /// Horizontal spacing between keys.
  final double keySpacing;

  /// Vertical spacing between rows.
  final double rowSpacing;

  /// Whether to enable haptic feedback on key press.
  final bool enableHaptics;

  /// Whether to play the system click sound on key press.
  final bool enableSound;

  /// Whether the keyboard can be dragged to reposition.
  final bool enableDrag;

  /// Whether the numbers mode is available.
  final bool enableNumberMode;

  /// Whether the symbols mode is available.
  final bool enableSymbolMode;

  /// Whether to show the drag handle at the top.
  final bool showDragHandle;

  /// Whether to show a magnified character preview bubble on key press.
  ///
  /// When null (default), the preview is shown adaptively: enabled on
  /// narrow screens (< 600dp, phones) and disabled on wider screens
  /// (tablets), matching native platform behavior.
  final bool? showKeyPreview;

  /// Whether to animate the keyboard sliding in/out on show/hide.
  final bool animateShowHide;

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

  /// Whether to constrain dragging so the keyboard stays within screen bounds.
  ///
  /// When `true` (default), the keyboard cannot be dragged off screen.
  /// Set to `false` to allow unrestricted dragging.
  final bool constrainDragBounds;

  /// Resolves the effective theme for the given ambient [brightness].
  FlutterFloatingKeyboardTheme resolveTheme(Brightness brightness) {
    if (brightness == Brightness.dark) {
      return darkTheme ?? theme ?? FlutterFloatingKeyboardTheme.dark;
    }
    return theme ?? FlutterFloatingKeyboardTheme.light;
  }

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
    FlutterFloatingKeyboardTheme? theme,
    FlutterFloatingKeyboardTheme? darkTheme,
    double? keyboardHeight,
    double? keyHeight,
    double? keyBorderRadius,
    double? keySpacing,
    double? rowSpacing,
    bool? enableHaptics,
    bool? enableSound,
    bool? enableDrag,
    bool? enableNumberMode,
    bool? enableSymbolMode,
    bool? showDragHandle,
    bool? showKeyPreview,
    bool? animateShowHide,
    double? elevation,
    double? borderRadius,
    double? widthFactor,
    double? maxKeyboardWidth,
    bool? constrainDragBounds,
  }) {
    return FlutterFloatingKeyboardConfig(
      theme: theme ?? this.theme,
      darkTheme: darkTheme ?? this.darkTheme,
      keyboardHeight: keyboardHeight ?? this.keyboardHeight,
      keyHeight: keyHeight ?? this.keyHeight,
      keyBorderRadius: keyBorderRadius ?? this.keyBorderRadius,
      keySpacing: keySpacing ?? this.keySpacing,
      rowSpacing: rowSpacing ?? this.rowSpacing,
      enableHaptics: enableHaptics ?? this.enableHaptics,
      enableSound: enableSound ?? this.enableSound,
      enableDrag: enableDrag ?? this.enableDrag,
      enableNumberMode: enableNumberMode ?? this.enableNumberMode,
      enableSymbolMode: enableSymbolMode ?? this.enableSymbolMode,
      showDragHandle: showDragHandle ?? this.showDragHandle,
      showKeyPreview: showKeyPreview ?? this.showKeyPreview,
      animateShowHide: animateShowHide ?? this.animateShowHide,
      elevation: elevation ?? this.elevation,
      borderRadius: borderRadius ?? this.borderRadius,
      widthFactor: widthFactor ?? this.widthFactor,
      maxKeyboardWidth: maxKeyboardWidth ?? this.maxKeyboardWidth,
      constrainDragBounds: constrainDragBounds ?? this.constrainDragBounds,
    );
  }
}
