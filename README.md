# flutter_floating_keyboard

A custom floating mini keyboard for Flutter tablet apps. Replaces the system keyboard using Flutter's `TextInputControl` API — works with **all** text widgets (`TextField`, `TextFormField`, `QuillEditor`, etc.) without any modification.

[![pub package](https://img.shields.io/pub/v/flutter_floating_keyboard.svg)](https://pub.dev/packages/flutter_floating_keyboard)

## Screenshots

| iPad | iPhone | Dark Theme | Landscape |
|------|--------|------------|-----------|
| ![iPad](https://raw.githubusercontent.com/Sreeraj9764/flutter_floating_keyboard/main/screenshots/ipad-keyboad-center.png) | ![iPhone](https://raw.githubusercontent.com/Sreeraj9764/flutter_floating_keyboard/main/screenshots/iphone-keyboard-center.png) | ![Dark](https://raw.githubusercontent.com/Sreeraj9764/flutter_floating_keyboard/main/screenshots/iphone-dakmode.png) | ![Landscape](https://raw.githubusercontent.com/Sreeraj9764/flutter_floating_keyboard/main/screenshots/iphone-lanscape.png) |

## Features

- **Drop-in replacement** for the system keyboard — no changes needed to existing text widgets
- **Draggable** — reposition the keyboard anywhere on screen
- **QWERTY layout** with letters, numbers, and symbols modes
- **Shift & Caps Lock** support
- **Long-press repeat** for backspace
- **Haptic feedback** on key press
- **Fully customizable** appearance (colors, spacing, border radius, elevation)
- **Dismiss button** to hide the keyboard on demand
- **Lightweight** — no native code, pure Dart/Flutter

## Getting Started

```bash
flutter pub add flutter_floating_keyboard
```

## Usage

```dart
import 'package:flutter_floating_keyboard/flutter_floating_keyboard.dart';

// 1. Create the controller
final keyboardController = FlutterFloatingKeyboardController();

// 2. Install to suppress the system keyboard
keyboardController.install();

// 3. Wrap your app content with the overlay (typically in MaterialApp.builder)
MaterialApp.router(
  builder: (context, child) {
    return FlutterFloatingKeyboardOverlay(
      controller: keyboardController,
      child: child!,
    );
  },
);

// 4. When done, uninstall and dispose
keyboardController.uninstall();
keyboardController.dispose();
```

That's it! Every `TextField`, `TextFormField`, or any widget using Flutter's text input system will now use the floating keyboard automatically.

## Configuration

Customize the keyboard appearance using `FlutterFloatingKeyboardConfig`:

```dart
FlutterFloatingKeyboardOverlay(
  controller: keyboardController,
  config: FlutterFloatingKeyboardConfig(
    backgroundColor: Color(0xF0E8E8E8),
    keyColor: Colors.white,
    specialKeyColor: Color(0xFFB8B8B8),
    keyTextColor: Color(0xFF1A1A1A),
    keyBorderRadius: 6.0,
    keySpacing: 4.0,
    rowSpacing: 6.0,
    elevation: 8.0,
    borderRadius: 12.0,
    enableHaptics: true,
    enableDrag: true,
    enableNumberMode: true,
    enableSymbolMode: true,
    showDragHandle: true,
  ),
  child: child,
);
```

## API Reference

### FlutterFloatingKeyboardController

| Method / Property | Description |
|---|---|
| `install()` | Suppresses the system keyboard and activates the floating keyboard |
| `uninstall()` | Restores the system keyboard |
| `dispose()` | Cleans up all resources |
| `visible` | `ValueNotifier<bool>` — keyboard visibility state |
| `keyboardMode` | `ValueNotifier<KeyboardMode>` — current mode (letters/numbers/symbols) |
| `isShiftActive` | `ValueNotifier<bool>` — shift state |
| `isCapsLock` | `ValueNotifier<bool>` — caps lock state |
| `position` | `ValueNotifier<Offset>` — current drag offset |

### FlutterFloatingKeyboardConfig

All properties have sensible defaults. See the [Configuration](#configuration) section above for available options.

## Platform Support

Works on any platform where Flutter renders its own text fields (iOS, Android, macOS, Windows, Linux, Web). Most useful on **tablets** and **desktop** where a smaller, repositionable keyboard improves UX.

## Requirements

- Flutter ≥ 3.3.0
- Dart SDK ≥ 3.10.0

## License

MIT
