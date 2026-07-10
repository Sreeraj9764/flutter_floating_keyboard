import 'package:flutter/material.dart';

/// Visual theme for the floating keyboard, modeled after the iOS/iPadOS
/// system keyboard.
///
/// Use the built-in [light] and [dark] presets, or create a custom theme.
/// Themes are resolved automatically from the ambient [Brightness] via
/// `FlutterFloatingKeyboardConfig.resolveTheme`.
@immutable
class FlutterFloatingKeyboardTheme {
  const FlutterFloatingKeyboardTheme({
    this.backgroundColor = const Color(0xF2D6D9DE),
    this.keyColor = const Color(0xFFFFFFFF),
    this.specialKeyColor = const Color(0xFFADB3BF),
    this.keyTextColor = const Color(0xFF1C1C1E),
    this.keyPressedColor = const Color(0xFFD0D3DA),
    this.specialKeyPressedColor = const Color(0xFFFFFFFF),
    this.activeKeyColor = const Color(0xFFFFFFFF),
    this.activeKeyTextColor = const Color(0xFF1C1C1E),
    this.keyShadowColor = const Color(0x4D000000),
    this.dragHandleColor = const Color(0xFF9BA0A8),
  });

  /// Light preset, matching the iOS light keyboard.
  static const FlutterFloatingKeyboardTheme light =
      FlutterFloatingKeyboardTheme();

  /// Dark preset, matching the iOS dark keyboard.
  static const FlutterFloatingKeyboardTheme dark = FlutterFloatingKeyboardTheme(
    backgroundColor: Color(0xF22A2A2C),
    keyColor: Color(0xFF6B6B6E),
    specialKeyColor: Color(0xFF46464A),
    keyTextColor: Color(0xFFFFFFFF),
    keyPressedColor: Color(0xFF8A8A8E),
    specialKeyPressedColor: Color(0xFF6B6B6E),
    activeKeyColor: Color(0xFFFFFFFF),
    activeKeyTextColor: Color(0xFF1C1C1E),
    keyShadowColor: Color(0x66000000),
    dragHandleColor: Color(0x59FFFFFF),
  );

  /// Background color of the keyboard deck (container).
  final Color backgroundColor;

  /// Fill color of regular character keys.
  final Color keyColor;

  /// Fill color of special keys (shift, backspace, enter, mode switch).
  final Color specialKeyColor;

  /// Text/icon color for key labels.
  final Color keyTextColor;

  /// Fill color of a regular key while pressed.
  final Color keyPressedColor;

  /// Fill color of a special key while pressed.
  final Color specialKeyPressedColor;

  /// Fill color of an active toggle key (e.g. shift when engaged).
  final Color activeKeyColor;

  /// Text/icon color of an active toggle key.
  final Color activeKeyTextColor;

  /// Color of the crisp bottom-edge shadow under each key.
  final Color keyShadowColor;

  /// Color of the drag handle pill.
  final Color dragHandleColor;

  /// Create a copy with modified values.
  FlutterFloatingKeyboardTheme copyWith({
    Color? backgroundColor,
    Color? keyColor,
    Color? specialKeyColor,
    Color? keyTextColor,
    Color? keyPressedColor,
    Color? specialKeyPressedColor,
    Color? activeKeyColor,
    Color? activeKeyTextColor,
    Color? keyShadowColor,
    Color? dragHandleColor,
  }) {
    return FlutterFloatingKeyboardTheme(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      keyColor: keyColor ?? this.keyColor,
      specialKeyColor: specialKeyColor ?? this.specialKeyColor,
      keyTextColor: keyTextColor ?? this.keyTextColor,
      keyPressedColor: keyPressedColor ?? this.keyPressedColor,
      specialKeyPressedColor:
          specialKeyPressedColor ?? this.specialKeyPressedColor,
      activeKeyColor: activeKeyColor ?? this.activeKeyColor,
      activeKeyTextColor: activeKeyTextColor ?? this.activeKeyTextColor,
      keyShadowColor: keyShadowColor ?? this.keyShadowColor,
      dragHandleColor: dragHandleColor ?? this.dragHandleColor,
    );
  }
}
