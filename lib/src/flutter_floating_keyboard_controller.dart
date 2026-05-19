import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_floating_keyboard/src/flutter_floating_keyboard_input_control.dart';

import 'keyboard_config.dart';

/// The mode of the keyboard layout.
enum KeyboardMode { letters, numbers, symbols }

/// Public controller for the FlutterFloatingKeyboard package.
///
/// Manages the lifecycle of the custom input control and exposes
/// reactive state via [ValueNotifier]s that the keyboard widget listens to.
///
/// Only one controller can be installed at a time. Attempting to install
/// a second controller while another is active will throw an assertion error
/// in debug mode.
///
/// Usage:
/// ```dart
/// final controller = FlutterFloatingKeyboardController();
/// controller.install(); // Replaces system keyboard
/// // ... later ...
/// controller.uninstall(); // Restores system keyboard
/// ```
class FlutterFloatingKeyboardController {
  FlutterFloatingKeyboardController({FlutterFloatingKeyboardConfig? config})
    : _config = config ?? const FlutterFloatingKeyboardConfig();

  static FlutterFloatingKeyboardController? _activeInstance;

  final FlutterFloatingKeyboardConfig _config;

  late final FlutterFloatingKeyboardInputControl _inputControl =
      FlutterFloatingKeyboardInputControl(
        onShow: _handleShow,
        onHide: _handleHide,
        onConfigChanged: _handleConfigChanged,
        onEditingStateChanged: _handleEditingStateChanged,
      );

  // --- Reactive state ---

  /// Whether the keyboard is currently visible.
  final ValueNotifier<bool> visible = ValueNotifier<bool>(false);

  /// Current keyboard mode (letters, numbers, symbols).
  final ValueNotifier<KeyboardMode> keyboardMode = ValueNotifier<KeyboardMode>(
    KeyboardMode.letters,
  );

  /// Whether shift is active (next character uppercase).
  final ValueNotifier<bool> isShiftActive = ValueNotifier<bool>(false);

  /// Whether caps lock is on (all characters uppercase).
  final ValueNotifier<bool> isCapsLock = ValueNotifier<bool>(false);

  /// The current input type from the active text field.
  final ValueNotifier<TextInputType?> currentInputType =
      ValueNotifier<TextInputType?>(null);

  /// Current position offset for dragging.
  final ValueNotifier<Offset> position = ValueNotifier<Offset>(Offset.zero);

  /// Whether the controller has been installed.
  bool _installed = false;

  // --- Public API ---

  /// The keyboard configuration.
  FlutterFloatingKeyboardConfig get config => _config;

  /// Whether the custom input control is currently installed.
  bool get isInstalled => _installed;

  /// The height of the keyboard (from config).
  double get keyboardHeight => _config.keyboardHeight;

  /// Install the custom input control, suppressing the system keyboard.
  ///
  /// Throws an [AssertionError] in debug mode if another controller is
  /// already installed. In release mode, the previous controller is
  /// forcefully uninstalled.
  void install() {
    if (_installed) return;
    if (_activeInstance != null && _activeInstance != this) {
      assert(
        false,
        'Another FlutterFloatingKeyboardController is already installed. '
        'Call uninstall() on the previous controller before installing a new one.',
      );
      // In release mode, gracefully uninstall the previous one
      _activeInstance!.uninstall();
    }
    TextInput.setInputControl(_inputControl);
    _installed = true;
    _activeInstance = this;
  }

  /// Uninstall the custom input control, restoring the system keyboard.
  void uninstall() {
    if (!_installed) return;
    TextInput.restorePlatformInputControl();
    _installed = false;
    visible.value = false;
    if (_activeInstance == this) {
      _activeInstance = null;
    }
  }

  /// Handle a key press from the keyboard UI.
  void onKey(String key) {
    final char = _resolveCase(key);
    _inputControl.insertText(char);

    // Auto-release shift after one character (unless caps lock)
    if (isShiftActive.value && !isCapsLock.value) {
      isShiftActive.value = false;
    }
  }

  /// Handle backspace press.
  void onBackspace() {
    _inputControl.deleteBackward();
  }

  /// Handle enter/return press.
  void onEnter() {
    _inputControl.insertNewline();
  }

  /// Handle space press.
  void onSpace() {
    _inputControl.insertText(' ');
  }

  /// Toggle shift state.
  void onShift() {
    if (isCapsLock.value) {
      // Turn off caps lock
      isCapsLock.value = false;
      isShiftActive.value = false;
    } else if (isShiftActive.value) {
      // Double-tap shift → caps lock
      isCapsLock.value = true;
    } else {
      isShiftActive.value = true;
    }
  }

  /// Toggle keyboard mode between letters and numbers/symbols.
  void onModeSwitch() {
    switch (keyboardMode.value) {
      case KeyboardMode.letters:
        keyboardMode.value = KeyboardMode.numbers;
        break;
      case KeyboardMode.numbers:
        keyboardMode.value = KeyboardMode.symbols;
        break;
      case KeyboardMode.symbols:
        keyboardMode.value = KeyboardMode.letters;
        break;
    }
  }

  /// Dismiss the keyboard.
  void onDismiss() {
    visible.value = false;
    // Also unfocus the current text field
    _inputControl.hide();
  }

  /// Update drag position.
  void onDragUpdate(Offset delta) {
    position.value = position.value + delta;
  }

  /// Dispose all notifiers.
  void dispose() {
    uninstall();
    visible.dispose();
    keyboardMode.dispose();
    isShiftActive.dispose();
    isCapsLock.dispose();
    currentInputType.dispose();
    position.dispose();
  }

  // --- Private handlers ---

  void _handleShow() {
    visible.value = true;
  }

  void _handleHide() {
    visible.value = false;
    // Reset shift state when keyboard hides
    isShiftActive.value = false;
    isCapsLock.value = false;
    keyboardMode.value = KeyboardMode.letters;
  }

  void _handleConfigChanged(TextInputConfiguration config) {
    currentInputType.value = config.inputType;

    // Auto-switch to number mode for number inputs
    if (config.inputType == TextInputType.number ||
        config.inputType == TextInputType.phone) {
      keyboardMode.value = KeyboardMode.numbers;
    } else if (keyboardMode.value != KeyboardMode.letters) {
      // Reset to letters for text inputs
      keyboardMode.value = KeyboardMode.letters;
    }
  }

  void _handleEditingStateChanged(TextEditingValue value) {
    // Could be used for future features like showing cursor position
  }

  String _resolveCase(String key) {
    if (isShiftActive.value || isCapsLock.value) {
      return key.toUpperCase();
    }
    return key.toLowerCase();
  }
}
