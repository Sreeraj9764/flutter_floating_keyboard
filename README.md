# flutter_floating_keyboard

A custom floating mini keyboard for Flutter apps. Replaces the system keyboard using Flutter's `TextInputControl` API — works with **all** text widgets (`TextField`, `TextFormField`, `QuillEditor`, etc.) without any modification. Responsive across phones, tablets, and desktop.

[![Pub Version](https://img.shields.io/pub/v/flutter_floating_keyboard.svg)](https://pub.dev/packages/flutter_floating_keyboard)
[![Pub Points](https://img.shields.io/pub/points/flutter_floating_keyboard)](https://pub.dev/packages/flutter_floating_keyboard/score)
[![GitHub License](https://img.shields.io/github/license/Sreeraj9764/flutter_floating_keyboard)](https://github.com/Sreeraj9764/flutter_floating_keyboard/blob/main/LICENSE)
[![GitHub Repo](https://img.shields.io/badge/GitHub-Sreeraj9764/flutter__floating__keyboard-blue?logo=github)](https://github.com/Sreeraj9764/flutter_floating_keyboard)
[![melos](https://img.shields.io/badge/maintained%20with-melos-f700ff.svg)](https://github.com/invertase/melos)

## Screenshots

| iPad | iPhone | Dark Theme | Landscape |
|------|--------|------------|-----------|
| ![iPad](https://raw.githubusercontent.com/Sreeraj9764/flutter_floating_keyboard/main/screenshots/ipad-keyboad-center.png) | ![iPhone](https://raw.githubusercontent.com/Sreeraj9764/flutter_floating_keyboard/main/screenshots/iphone-keyboard-center.png) | ![Dark](https://raw.githubusercontent.com/Sreeraj9764/flutter_floating_keyboard/main/screenshots/iphone-dakmode.png) | ![Landscape](https://raw.githubusercontent.com/Sreeraj9764/flutter_floating_keyboard/main/screenshots/iphone-lanscape.png) |

## Features

- **Drop-in replacement** for the system keyboard — no changes needed to existing text widgets
- **Responsive** — adapts width automatically across phones, tablets, and desktop
- **Draggable** — reposition the keyboard anywhere on screen
- **Safe area aware** — respects system UI (home indicator, navigation bar)
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

// 4. When done dispose
keyboardController.dispose();
```

That's it! Every `TextField`, `TextFormField`, or any widget using Flutter's text input system will now use the floating keyboard automatically.

## Setup Patterns

| Pattern | Description |
|---|---|
| **Global** | Keyboard available across all screens via `MaterialApp.builder` |
| **Screen-wise** | Keyboard scoped to specific screens only — others use the system keyboard |
| **Custom Theme** | Fully themed keyboard with custom colors, spacing, and behavior |

> See the [example/](example/lib/) directory for complete working samples of each pattern.

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
    widthFactor: 0.85,        // fixed width as fraction of available space (0.0–1.0)
    maxKeyboardWidth: 600.0,  // upper bound in logical pixels
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

| Property | Type | Default | Description |
|---|---|---|---|
| `widthFactor` | `double?` | `null` | When set, overrides responsive breakpoints and uses this fraction (0.0–1.0) of available width |
| `maxKeyboardWidth` | `double` | `700.0` | Maximum keyboard width in logical pixels |

> **Note:** When `widthFactor` is `null` (default), the keyboard automatically adapts:  
> - < 500dp → 95% width  
> - 500–900dp → 75% width  
> - \> 900dp → 60% width

## Platform Support

Works on any platform where Flutter renders its own text fields (iOS, Android, macOS, Windows, Linux, Web). Most useful on **tablets** and **desktop** where a smaller, repositionable keyboard improves UX.

## Requirements

- Flutter ≥ 3.3.0
- Dart SDK ≥ 3.10.0

## License

MIT
