import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'keyboard_config.dart';
import 'keyboard_theme.dart';

/// Data describing an active key press preview bubble.
@immutable
class KeyPreviewValue {
  const KeyPreviewValue({required this.label, required this.keyRect});

  /// The character shown in the bubble.
  final String label;

  /// The pressed key's rect, in the keyboard body's coordinate space.
  final Rect keyRect;
}

/// A single key widget for the floating keyboard.
///
/// Handles tap, long-press repeat (for backspace), layered haptic/sound
/// feedback, press animation, and the optional preview bubble.
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
    required this.theme,
    this.semanticLabel,
    this.showPreview = false,
    this.previewNotifier,
    this.previewCoordinateKey,
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

  /// Resolved visual theme.
  final FlutterFloatingKeyboardTheme theme;

  /// Accessibility label for screen readers (defaults to [label]).
  final String? semanticLabel;

  /// Whether to show a magnified preview bubble while pressed.
  final bool showPreview;

  /// Notifier used to publish the preview bubble state to the keyboard body.
  final ValueNotifier<KeyPreviewValue?>? previewNotifier;

  /// Key identifying the coordinate space for preview positioning.
  final GlobalKey? previewCoordinateKey;

  @override
  State<KeyboardKeyWidget> createState() => _KeyboardKeyWidgetState();
}

class _KeyboardKeyWidgetState extends State<KeyboardKeyWidget> {
  bool _isPressed = false;
  Timer? _repeatTimer;
  Timer? _pressHoldTimer;
  bool _waitingForHold = false;

  static const _minPressDuration = Duration(milliseconds: 80);
  static const _pressAnimationDuration = Duration(milliseconds: 90);

  @override
  void dispose() {
    _repeatTimer?.cancel();
    _pressHoldTimer?.cancel();
    _clearPreview();
    super.dispose();
  }

  void _playFeedback() {
    if (widget.config.enableHaptics) {
      if (widget.isSpecial) {
        HapticFeedback.mediumImpact();
      } else {
        HapticFeedback.lightImpact();
      }
    }
    if (widget.config.enableSound) {
      SystemSound.play(SystemSoundType.click);
    }
  }

  void _showPreview() {
    if (!widget.showPreview || widget.previewNotifier == null) return;
    final ancestor = widget.previewCoordinateKey?.currentContext
        ?.findRenderObject();
    final box = context.findRenderObject();
    if (ancestor is! RenderBox || box is! RenderBox || !box.attached) return;
    final origin = box.localToGlobal(Offset.zero, ancestor: ancestor);
    widget.previewNotifier!.value = KeyPreviewValue(
      label: widget.label,
      keyRect: origin & box.size,
    );
  }

  void _clearPreview() {
    final notifier = widget.previewNotifier;
    if (notifier != null && notifier.value != null) {
      notifier.value = null;
    }
  }

  void _handleTapDown(TapDownDetails details) {
    _pressHoldTimer?.cancel();
    _waitingForHold = false;
    setState(() => _isPressed = true);
    _playFeedback();
    _showPreview();
  }

  void _handleTapUp(TapUpDetails details) {
    widget.onPressed();
    // Hold pressed state for minimum duration so quick taps are visible
    _waitingForHold = true;
    _pressHoldTimer = Timer(_minPressDuration, () {
      if (mounted && _waitingForHold) {
        setState(() => _isPressed = false);
        _waitingForHold = false;
      }
      _clearPreview();
    });
  }

  void _handleTapCancel() {
    _pressHoldTimer?.cancel();
    _waitingForHold = false;
    setState(() => _isPressed = false);
    _repeatTimer?.cancel();
    _clearPreview();
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
    _clearPreview();
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;

    final Color bgColor;
    if (widget.isActive) {
      bgColor = theme.activeKeyColor;
    } else if (_isPressed) {
      bgColor = widget.isSpecial
          ? theme.specialKeyPressedColor
          : theme.keyPressedColor;
    } else {
      bgColor = widget.isSpecial ? theme.specialKeyColor : theme.keyColor;
    }

    final textColor = widget.isActive
        ? theme.activeKeyTextColor
        : theme.keyTextColor;

    final isSingleChar = widget.label.length == 1;

    return Expanded(
      flex: widget.flex,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: widget.config.keySpacing / 2),
        child: Semantics(
          button: true,
          keyboardKey: true,
          label: widget.semanticLabel ?? widget.label,
          onTap: widget.onPressed,
          child: GestureDetector(
            onTapDown: _handleTapDown,
            onTapUp: _handleTapUp,
            onTapCancel: _handleTapCancel,
            onLongPressStart: _handleLongPressStart,
            onLongPressEnd: _handleLongPressEnd,
            child: AnimatedScale(
              scale: _isPressed ? 0.97 : 1.0,
              duration: _pressAnimationDuration,
              curve: Curves.easeOut,
              child: AnimatedContainer(
                duration: _pressAnimationDuration,
                curve: Curves.easeOut,
                height: widget.config.keyHeight,
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(
                    widget.config.keyBorderRadius,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: theme.keyShadowColor,
                      offset: const Offset(0, 1),
                      blurRadius: 0,
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Text(
                  widget.label,
                  style: TextStyle(
                    color: textColor,
                    fontSize: isSingleChar ? 19 : 13,
                    fontWeight: isSingleChar
                        ? FontWeight.w400
                        : FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
