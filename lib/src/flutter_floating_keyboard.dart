import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'flutter_floating_keyboard_controller.dart';
import 'keyboard_config.dart';
import 'keyboard_key_widget.dart';
import 'keyboard_layout.dart';
import 'keyboard_theme.dart';

/// A floating mini keyboard widget that can be positioned anywhere on screen.
///
/// Listens to [FlutterFloatingKeyboardController] for visibility, mode, and shift state.
/// Must be wrapped in a [Stack] and positioned appropriately by the parent.
///
/// Uses [TextFieldTapRegion] to prevent losing focus on the active text field
/// when the keyboard is tapped.
class FlutterFloatingKeyboard extends StatefulWidget {
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
  State<FlutterFloatingKeyboard> createState() =>
      _FlutterFloatingKeyboardState();
}

class _FlutterFloatingKeyboardState extends State<FlutterFloatingKeyboard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 250),
    reverseDuration: const Duration(milliseconds: 180),
    value: widget.controller.visible.value ? 1.0 : 0.0,
  );

  late final CurvedAnimation _curve = CurvedAnimation(
    parent: _animationController,
    curve: Curves.easeOutCubic,
    reverseCurve: Curves.easeInCubic,
  );

  late final Animation<Offset> _slide = Tween<Offset>(
    begin: const Offset(0, 0.15),
    end: Offset.zero,
  ).animate(_curve);

  @override
  void initState() {
    super.initState();
    widget.controller.visible.addListener(_handleVisibleChanged);
  }

  @override
  void didUpdateWidget(FlutterFloatingKeyboard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.visible.removeListener(_handleVisibleChanged);
      widget.controller.visible.addListener(_handleVisibleChanged);
      _handleVisibleChanged();
    }
  }

  @override
  void dispose() {
    widget.controller.visible.removeListener(_handleVisibleChanged);
    _curve.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _handleVisibleChanged() {
    final visible = widget.controller.visible.value;
    if (!widget.config.animateShowHide) {
      _animationController.value = visible ? 1.0 : 0.0;
      return;
    }
    if (visible) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        // Fully hidden — remove from layout and hit testing entirely.
        if (_animationController.isDismissed &&
            !widget.controller.visible.value) {
          return const SizedBox.shrink();
        }
        return ValueListenableBuilder<Offset>(
          valueListenable: widget.controller.position,
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
                  child: SlideTransition(
                    position: _slide,
                    child: FadeTransition(opacity: _curve, child: child),
                  ),
                ),
              ),
            );
          },
        );
      },
      child: _KeyboardBody(
        controller: widget.controller,
        config: widget.config,
      ),
    );
  }
}

class _KeyboardBody extends StatefulWidget {
  const _KeyboardBody({required this.controller, required this.config});

  final FlutterFloatingKeyboardController controller;
  final FlutterFloatingKeyboardConfig config;

  @override
  State<_KeyboardBody> createState() => _KeyboardBodyState();
}

class _KeyboardBodyState extends State<_KeyboardBody> {
  FlutterFloatingKeyboardController get controller => widget.controller;
  FlutterFloatingKeyboardConfig get config => widget.config;

  /// Coordinate space anchor for the key preview bubble.
  final GlobalKey _bodyStackKey = GlobalKey();

  /// Currently active key preview (null when no key is pressed).
  final ValueNotifier<KeyPreviewValue?> _preview =
      ValueNotifier<KeyPreviewValue?>(null);

  @override
  void dispose() {
    _preview.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = config.resolveTheme(Theme.of(context).brightness);
    final showPreview =
        config.showKeyPreview ?? MediaQuery.sizeOf(context).width < 600;

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
              color: theme.backgroundColor,
              child: Stack(
                key: _bodyStackKey,
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: keyboardWidth,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 6,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (config.showDragHandle)
                          _buildDragHandle(context, keyboardWidth, theme),
                        _buildKeyboardRows(theme, showPreview),
                      ],
                    ),
                  ),
                  _KeyPreviewLayer(
                    preview: _preview,
                    theme: theme,
                    config: config,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDragHandle(
    BuildContext context,
    double keyboardWidth,
    FlutterFloatingKeyboardTheme theme,
  ) {
    if (!config.enableDrag) return const SizedBox.shrink();

    return _EagerDragArea(
      onDragUpdate: (details) {
        final delta = Offset(details.delta.dx, -details.delta.dy);
        if (!config.constrainDragBounds) {
          controller.onDragUpdate(delta);
          return;
        }

        final screenSize = MediaQuery.sizeOf(context);
        final viewPadding = MediaQuery.viewPaddingOf(context);
        final candidate = controller.position.value + delta;

        // Horizontal: keep keyboard within screen edges
        final maxDx = (screenSize.width - keyboardWidth) / 2;
        final clampedDx = candidate.dx.clamp(-maxDx, maxDx);

        // Vertical: keep keyboard between bottom safe area and below top safe area
        final minDy = -(viewPadding.bottom + 8);
        final maxDy =
            screenSize.height -
            config.keyboardHeight -
            viewPadding.bottom -
            viewPadding.top -
            8;
        final clampedDy = candidate.dy.clamp(minDy, maxDy);

        controller.position.value = Offset(clampedDx, clampedDy);
      },
      child: Container(
        width: double.infinity,
        height: 24,
        alignment: Alignment.center,
        child: Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: theme.dragHandleColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }

  Widget _buildKeyboardRows(
    FlutterFloatingKeyboardTheme theme,
    bool showPreview,
  ) {
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
                            theme,
                            showPreview,
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
    final List<List<KeyData>> rows;
    switch (mode) {
      case KeyboardMode.letters:
        rows = KeyboardLayout.letterRows;
        break;
      case KeyboardMode.numbers:
        rows = KeyboardLayout.numberRows;
        break;
      case KeyboardMode.symbols:
        rows = KeyboardLayout.symbolRows;
        break;
    }
    return _filterDisabledModeKeys(rows);
  }

  /// Removes mode-switch keys whose target mode is disabled in the config.
  List<List<KeyData>> _filterDisabledModeKeys(List<List<KeyData>> rows) {
    if (config.enableNumberMode && config.enableSymbolMode) return rows;
    return rows
        .map(
          (row) => row.where((key) {
            if (key.action != KeyAction.modeSwitch) return true;
            switch (key.modeTarget) {
              case KeyboardMode.numbers:
                // The "123" key still acts as a gateway to symbols when
                // only symbols are enabled.
                return config.enableNumberMode || config.enableSymbolMode;
              case KeyboardMode.symbols:
                return config.enableSymbolMode;
              case KeyboardMode.letters:
              case null:
                return true;
            }
          }).toList(),
        )
        .toList();
  }

  Widget _buildKey(
    KeyData keyData,
    bool isUppercase,
    bool isCapsLock,
    FlutterFloatingKeyboardTheme theme,
    bool showPreview,
  ) {
    final label = _getKeyLabel(keyData, isUppercase);

    switch (keyData.action) {
      case KeyAction.character:
        return KeyboardKeyWidget(
          label: label,
          flex: keyData.flex,
          config: config,
          theme: theme,
          showPreview: showPreview,
          previewNotifier: _preview,
          previewCoordinateKey: _bodyStackKey,
          onPressed: () => controller.onKey(keyData.value),
        );

      case KeyAction.backspace:
        return KeyboardKeyWidget(
          label: label,
          flex: keyData.flex,
          isSpecial: true,
          enableRepeat: true,
          config: config,
          theme: theme,
          semanticLabel: 'Backspace',
          onPressed: controller.onBackspace,
        );

      case KeyAction.shift:
        return KeyboardKeyWidget(
          label: isCapsLock ? '⇪' : label,
          flex: keyData.flex,
          isSpecial: true,
          isActive: isUppercase,
          config: config,
          theme: theme,
          semanticLabel: isCapsLock ? 'Caps lock on' : 'Shift',
          onPressed: controller.onShift,
        );

      case KeyAction.space:
        return KeyboardKeyWidget(
          label: label,
          flex: keyData.flex,
          config: config,
          theme: theme,
          semanticLabel: 'Space',
          onPressed: controller.onSpace,
        );

      case KeyAction.enter:
        return _buildEnterKey(keyData, theme);

      case KeyAction.modeSwitch:
        return _buildModeSwitchKey(keyData, label, theme);

      case KeyAction.dismiss:
        return KeyboardKeyWidget(
          label: label,
          flex: keyData.flex,
          isSpecial: true,
          config: config,
          theme: theme,
          semanticLabel: 'Dismiss keyboard',
          onPressed: controller.onDismiss,
        );
    }
  }

  /// Enter key whose label follows the focused field's [TextInputAction].
  Widget _buildEnterKey(KeyData keyData, FlutterFloatingKeyboardTheme theme) {
    return ValueListenableBuilder<TextInputAction?>(
      valueListenable: controller.currentInputAction,
      builder: (context, action, _) {
        final label = _enterLabelForAction(action) ?? keyData.label;
        return KeyboardKeyWidget(
          label: label,
          flex: keyData.flex,
          isSpecial: true,
          config: config,
          theme: theme,
          semanticLabel: label == keyData.label ? 'Enter' : label,
          onPressed: controller.onEnter,
        );
      },
    );
  }

  String? _enterLabelForAction(TextInputAction? action) {
    switch (action) {
      case TextInputAction.done:
        return 'done';
      case TextInputAction.go:
        return 'go';
      case TextInputAction.search:
        return 'search';
      case TextInputAction.next:
        return 'next';
      case TextInputAction.send:
        return 'send';
      case TextInputAction.join:
        return 'join';
      case TextInputAction.continueAction:
        return 'continue';
      default:
        return null; // newline / unspecified → default ⏎ glyph
    }
  }

  Widget _buildModeSwitchKey(
    KeyData keyData,
    String label,
    FlutterFloatingKeyboardTheme theme,
  ) {
    var target = keyData.modeTarget;
    var effectiveLabel = label;
    // When numbers are disabled but symbols are enabled, the letters-mode
    // "123" key becomes a symbols key.
    if (target == KeyboardMode.numbers &&
        !config.enableNumberMode &&
        config.enableSymbolMode) {
      target = KeyboardMode.symbols;
      effectiveLabel = '#+=';
    }
    final semanticTarget = switch (target) {
      KeyboardMode.numbers => 'numbers',
      KeyboardMode.symbols => 'symbols',
      KeyboardMode.letters || null => 'letters',
    };
    return KeyboardKeyWidget(
      label: effectiveLabel,
      flex: keyData.flex,
      isSpecial: true,
      config: config,
      theme: theme,
      semanticLabel: 'Switch to $semanticTarget',
      onPressed: () => controller.onModeSwitch(target),
    );
  }

  String _getKeyLabel(KeyData keyData, bool isUppercase) {
    if (keyData.display != null) return keyData.display!;
    if (isUppercase && keyData.action == KeyAction.character) {
      return keyData.value.toUpperCase();
    }
    return keyData.value;
  }
}

/// Renders the magnified key preview bubble above the pressed key.
class _KeyPreviewLayer extends StatelessWidget {
  const _KeyPreviewLayer({
    required this.preview,
    required this.theme,
    required this.config,
  });

  final ValueNotifier<KeyPreviewValue?> preview;
  final FlutterFloatingKeyboardTheme theme;
  final FlutterFloatingKeyboardConfig config;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<KeyPreviewValue?>(
      valueListenable: preview,
      builder: (context, value, _) {
        if (value == null) return const SizedBox.shrink();

        final keyRect = value.keyRect;
        final bubbleWidth = (keyRect.width * 1.45).clamp(44.0, 96.0);
        final bubbleHeight = config.keyHeight * 1.25;

        return Positioned(
          left: keyRect.center.dx - bubbleWidth / 2,
          top: keyRect.top - bubbleHeight - 6,
          child: IgnorePointer(
            child: Container(
              width: bubbleWidth,
              height: bubbleHeight,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: theme.keyColor,
                borderRadius: BorderRadius.circular(config.keyBorderRadius + 4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    offset: const Offset(0, 2),
                    blurRadius: 8,
                  ),
                  BoxShadow(
                    color: theme.keyShadowColor,
                    offset: const Offset(0, 1),
                    blurRadius: 0,
                  ),
                ],
              ),
              child: Text(
                value.label,
                style: TextStyle(
                  color: theme.keyTextColor,
                  fontSize: 30,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        );
      },
    );
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
