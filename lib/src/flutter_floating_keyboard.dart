import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'flutter_floating_keyboard_controller.dart';
import 'keyboard_config.dart';
import 'keyboard_key_widget.dart';
import 'keyboard_layout.dart';

/// A floating mini keyboard widget that can be positioned anywhere on screen.
///
/// Listens to [FlutterFloatingKeyboardController] for visibility, mode, and shift state.
/// Must be wrapped in a [Stack] and positioned appropriately by the parent.
///
/// Uses [TextFieldTapRegion] to prevent losing focus on the active text field
/// when the keyboard is tapped.
class FlutterFloatingKeyboard extends StatelessWidget {
  const FlutterFloatingKeyboard({
    super.key,
    required this.controller,
    this.config = const FlutterFloatingKeyboardConfig(),
  });

  /// The keyboard controller that manages state and input.
  final FlutterFloatingKeyboardController controller;

  /// Visual configuration for the keyboard.
  final FlutterFloatingKeyboardConfig config;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: controller.visible,
      builder: (context, visible, child) {
        if (!visible) return const SizedBox.shrink();
        return child!;
      },
      child: ValueListenableBuilder<Offset>(
        valueListenable: controller.position,
        builder: (context, position, _) {
          // Account for system bottom inset (home indicator, nav bar)
          final bottomInset = MediaQuery.viewPaddingOf(context).bottom;
          return Positioned(
            bottom: bottomInset + 8 + position.dy,
            left: 0,
            right: 0,
            child: Center(
              child: Transform.translate(
                offset: Offset(position.dx, 0),
                child: _KeyboardBody(controller: controller, config: config),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _KeyboardBody extends StatelessWidget {
  const _KeyboardBody({required this.controller, required this.config});

  final FlutterFloatingKeyboardController controller;
  final FlutterFloatingKeyboardConfig config;

  @override
  Widget build(BuildContext context) {
    return TextFieldTapRegion(
      child: FocusScope(
        canRequestFocus: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final availableWidth = constraints.maxWidth.isFinite
                ? constraints.maxWidth
                : MediaQuery.sizeOf(context).width;

            final keyboardWidth = config.computeKeyboardWidth(availableWidth);

            return Material(
              elevation: config.elevation,
              borderRadius: BorderRadius.circular(config.borderRadius),
              color: config.backgroundColor,
              child: Container(
                width: keyboardWidth,
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (config.showDragHandle) _buildDragHandle(context),
                    _buildKeyboardRows(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDragHandle(BuildContext context) {
    if (!config.enableDrag) return const SizedBox.shrink();

    return _EagerDragArea(
      onDragUpdate: (details) {
        controller.onDragUpdate(Offset(details.delta.dx, -details.delta.dy));
      },
      child: Container(
        width: double.infinity,
        height: 24,
        alignment: Alignment.center,
        child: Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: Colors.grey[500],
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }

  Widget _buildKeyboardRows() {
    return ValueListenableBuilder<KeyboardMode>(
      valueListenable: controller.keyboardMode,
      builder: (context, mode, _) {
        return ValueListenableBuilder<bool>(
          valueListenable: controller.isShiftActive,
          builder: (context, shiftActive, _) {
            return ValueListenableBuilder<bool>(
              valueListenable: controller.isCapsLock,
              builder: (context, capsLock, _) {
                final rows = _getRowsForMode(mode);
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: rows.map((row) {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: config.rowSpacing / 2,
                      ),
                      child: Row(
                        children: row.map((keyData) {
                          return _buildKey(
                            keyData,
                            shiftActive || capsLock,
                            capsLock,
                          );
                        }).toList(),
                      ),
                    );
                  }).toList(),
                );
              },
            );
          },
        );
      },
    );
  }

  List<List<KeyData>> _getRowsForMode(KeyboardMode mode) {
    switch (mode) {
      case KeyboardMode.letters:
        return KeyboardLayout.letterRows;
      case KeyboardMode.numbers:
        return KeyboardLayout.numberRows;
      case KeyboardMode.symbols:
        return KeyboardLayout.symbolRows;
    }
  }

  Widget _buildKey(KeyData keyData, bool isUppercase, bool isCapsLock) {
    final label = _getKeyLabel(keyData, isUppercase);

    switch (keyData.action) {
      case KeyAction.character:
        return KeyboardKeyWidget(
          label: label,
          flex: keyData.flex,
          config: config,
          onPressed: () => controller.onKey(keyData.value),
        );

      case KeyAction.backspace:
        return KeyboardKeyWidget(
          label: label,
          flex: keyData.flex,
          isSpecial: true,
          enableRepeat: true,
          config: config,
          onPressed: controller.onBackspace,
        );

      case KeyAction.shift:
        return KeyboardKeyWidget(
          label: isCapsLock ? '⇪' : label,
          flex: keyData.flex,
          isSpecial: true,
          isActive: isUppercase,
          config: config,
          onPressed: controller.onShift,
        );

      case KeyAction.space:
        return KeyboardKeyWidget(
          label: label,
          flex: keyData.flex,
          config: config,
          onPressed: controller.onSpace,
        );

      case KeyAction.enter:
        return KeyboardKeyWidget(
          label: label,
          flex: keyData.flex,
          isSpecial: true,
          config: config,
          onPressed: controller.onEnter,
        );

      case KeyAction.modeSwitch:
        return KeyboardKeyWidget(
          label: label,
          flex: keyData.flex,
          isSpecial: true,
          config: config,
          onPressed: controller.onModeSwitch,
        );

      case KeyAction.dismiss:
        return KeyboardKeyWidget(
          label: label,
          flex: keyData.flex,
          isSpecial: true,
          config: config,
          onPressed: controller.onDismiss,
        );
    }
  }

  String _getKeyLabel(KeyData keyData, bool isUppercase) {
    if (keyData.display != null) return keyData.display!;
    if (isUppercase && keyData.action == KeyAction.character) {
      return keyData.value.toUpperCase();
    }
    return keyData.value;
  }
}

/// A drag area that wins the gesture arena immediately on pointer down.
///
/// This prevents [TextFieldTapRegion] or parent gesture detectors from
/// stealing the drag gesture away from the keyboard handle.
class _EagerDragArea extends StatelessWidget {
  const _EagerDragArea({required this.onDragUpdate, required this.child});

  final GestureDragUpdateCallback onDragUpdate;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return RawGestureDetector(
      behavior: HitTestBehavior.opaque,
      gestures: <Type, GestureRecognizerFactory>{
        _EagerPanGestureRecognizer:
            GestureRecognizerFactoryWithHandlers<_EagerPanGestureRecognizer>(
              () => _EagerPanGestureRecognizer(),
              (_EagerPanGestureRecognizer recognizer) {
                recognizer.onUpdate = onDragUpdate;
              },
            ),
      },
      child: child,
    );
  }
}

/// A [PanGestureRecognizer] that immediately wins the gesture arena.
///
/// By resolving as accepted on the first allowed pointer, this recognizer
/// guarantees the drag handle always captures the gesture before competing
/// recognizers (e.g. from TextFieldTapRegion or parent Scrollable).
class _EagerPanGestureRecognizer extends PanGestureRecognizer {
  @override
  void addAllowedPointer(PointerDownEvent event) {
    super.addAllowedPointer(event);
    resolve(GestureDisposition.accepted);
  }
}
