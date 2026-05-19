/// A custom floating mini keyboard for Flutter tablet apps.
///
/// Replaces the system keyboard using Flutter's TextInputControl API.
/// Works with ALL text widgets (TextField, QuillEditor, etc.) without
/// requiring any modification to existing widgets.
///
/// ## Quick Start
///
/// ```dart
/// import 'package:flutter_floating_keyboard/flutter_floating_keyboard.dart';
///
/// // 1. Create controller
/// final controller = FlutterFloatingKeyboardController();
///
/// // 2. Install (suppresses system keyboard)
/// controller.install();
///
/// // 3. Wrap your app content with the overlay
/// FlutterFloatingKeyboardOverlay(
///   controller: controller,
///   child: child,
/// )
///
/// // 4. Uninstall when done
/// controller.uninstall();
/// controller.dispose();
/// ```
library;

export 'src/flutter_floating_keyboard.dart' show FlutterFloatingKeyboard;
export 'src/flutter_floating_keyboard_controller.dart'
    show FlutterFloatingKeyboardController, KeyboardMode;
export 'src/flutter_floating_keyboard_overlay.dart'
    show FlutterFloatingKeyboardOverlay;
export 'src/keyboard_config.dart' show FlutterFloatingKeyboardConfig;
