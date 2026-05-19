import 'package:flutter/material.dart';

import 'flutter_floating_keyboard.dart';
import 'flutter_floating_keyboard_controller.dart';
import 'keyboard_config.dart';

/// A convenience widget that overlays the [FlutterFloatingKeyboard] above its child.
///
/// Place this in [MaterialApp.builder] so the keyboard renders above all
/// routes, dialogs, bottom sheets, and overlays.
///
/// ```dart
/// MaterialApp.router(
///   builder: (context, child) {
///     return FlutterFloatingKeyboardOverlay(
///       controller: keyboardController,
///       child: child!,
///     );
///   },
/// )
/// ```
///
/// The keyboard uses [TextFieldTapRegion] internally to prevent focus loss
/// when tapping keys, and [TextInput.updateEditingValue] to route text to
/// the currently active text field — regardless of which overlay it lives in.
class FlutterFloatingKeyboardOverlay extends StatelessWidget {
  const FlutterFloatingKeyboardOverlay({
    super.key,
    required this.controller,
    required this.child,
    this.config = const FlutterFloatingKeyboardConfig(),
  });

  /// The keyboard controller that manages state and input.
  final FlutterFloatingKeyboardController controller;

  /// The app content (typically the Navigator/router child).
  final Widget child;

  /// Visual configuration for the keyboard.
  final FlutterFloatingKeyboardConfig config;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        FlutterFloatingKeyboard(controller: controller, config: config),
      ],
    );
  }
}
