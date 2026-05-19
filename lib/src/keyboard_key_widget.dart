import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'keyboard_config.dart';

/// A single key widget for the floating keyboard.
///
/// Handles tap, long-press repeat (for backspace), and visual feedback.
class KeyboardKeyWidget extends StatefulWidget {
  const KeyboardKeyWidget({
    super.key,
    required this.label,
    required this.onPressed,
    this.flex = 1,
    this.isSpecial = false,
    this.isActive = false,
    this.enableRepeat = false,
    required this.config,
  });

  /// Text displayed on the key.
  final String label;

  /// Callback when the key is pressed.
  final VoidCallback onPressed;

  /// Flex weight for sizing.
  final int flex;

  /// Whether this is a special key (shift, backspace, etc.) — uses different color.
  final bool isSpecial;

  /// Whether this key is in an active state (e.g., shift active).
  final bool isActive;

  /// Whether long-press should repeat the action (for backspace).
  final bool enableRepeat;

  /// Keyboard configuration for styling.
  final FlutterFloatingKeyboardConfig config;

  @override
  State<KeyboardKeyWidget> createState() => _KeyboardKeyWidgetState();
}

class _KeyboardKeyWidgetState extends State<KeyboardKeyWidget> {
  bool _isPressed = false;
  Timer? _repeatTimer;

  @override
  void dispose() {
    _repeatTimer?.cancel();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    if (widget.config.enableHaptics) {
      HapticFeedback.lightImpact();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    widget.onPressed();
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
    _repeatTimer?.cancel();
  }

  void _handleLongPressStart(LongPressStartDetails details) {
    if (!widget.enableRepeat) return;
    widget.onPressed();
    _repeatTimer = Timer.periodic(const Duration(milliseconds: 80), (_) {
      widget.onPressed();
      if (widget.config.enableHaptics) {
        HapticFeedback.selectionClick();
      }
    });
  }

  void _handleLongPressEnd(LongPressEndDetails details) {
    setState(() => _isPressed = false);
    _repeatTimer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = widget.isActive
        ? widget.config.keyTextColor
        : widget.isSpecial
        ? widget.config.specialKeyColor
        : widget.config.keyColor;

    final textColor = widget.isActive
        ? widget.config.keyColor
        : widget.config.keyTextColor;

    return Expanded(
      flex: widget.flex,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: widget.config.keySpacing / 2),
        child: GestureDetector(
          onTapDown: _handleTapDown,
          onTapUp: _handleTapUp,
          onTapCancel: _handleTapCancel,
          onLongPressStart: _handleLongPressStart,
          onLongPressEnd: _handleLongPressEnd,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 50),
            height: 42,
            decoration: BoxDecoration(
              color: _isPressed ? bgColor.withOpacity(0.7) : bgColor,
              borderRadius: BorderRadius.circular(
                widget.config.keyBorderRadius,
              ),
              boxShadow: _isPressed
                  ? null
                  : [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        offset: const Offset(0, 1),
                        blurRadius: 1,
                      ),
                    ],
            ),
            alignment: Alignment.center,
            child: Text(
              widget.label,
              style: TextStyle(
                color: textColor,
                fontSize: widget.label.length > 1 ? 13 : 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
