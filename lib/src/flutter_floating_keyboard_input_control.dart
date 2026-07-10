import 'package:flutter/services.dart';

/// Core input control that intercepts Flutter's text input system.
///
/// When installed via [TextInput.setInputControl], this prevents the system
/// keyboard from appearing and routes all text input through the custom
/// keyboard UI.
class FlutterFloatingKeyboardInputControl with TextInputControl {
  FlutterFloatingKeyboardInputControl({
    required this.onShow,
    required this.onHide,
    required this.onConfigChanged,
    required this.onEditingStateChanged,
  });

  /// Called when Flutter wants to show the keyboard (text field focused).
  final VoidCallback onShow;

  /// Called when Flutter wants to hide the keyboard (text field unfocused).
  final VoidCallback onHide;

  /// Called when the input configuration changes (e.g., inputType).
  final void Function(TextInputConfiguration config) onConfigChanged;

  /// Called when the editing state is updated from the framework side.
  final void Function(TextEditingValue value) onEditingStateChanged;

  /// Current editing state tracked from the framework.
  TextEditingValue _editingState = TextEditingValue.empty;

  /// Current input configuration.
  TextInputConfiguration? _currentConfig;

  /// The currently attached text input client (the focused editable).
  TextInputClient? _client;

  /// Whether a text client is currently attached.
  bool _attached = false;

  /// Current editing state.
  TextEditingValue get editingState => _editingState;

  /// Current input configuration.
  TextInputConfiguration? get currentConfig => _currentConfig;

  /// Whether a text client is attached.
  bool get isAttached => _attached;

  @override
  void show() {
    onShow();
  }

  @override
  void hide() {
    onHide();
  }

  @override
  void setEditingState(TextEditingValue value) {
    _editingState = value;
    onEditingStateChanged(value);
  }

  @override
  void attach(TextInputClient client, TextInputConfiguration configuration) {
    _attached = true;
    _client = client;
    _currentConfig = configuration;
    onConfigChanged(configuration);
  }

  @override
  void detach(TextInputClient client) {
    _attached = false;
    _client = null;
    onHide();
  }

  @override
  void updateConfig(TextInputConfiguration configuration) {
    _currentConfig = configuration;
    onConfigChanged(configuration);
  }

  // --- Public methods for keyboard key presses ---

  /// Insert a character at the current cursor position (or replace selection).
  void insertText(String text) {
    final selection = _editingState.selection;
    final currentText = _editingState.text;

    final newText = selection.isValid
        ? currentText.replaceRange(selection.start, selection.end, text)
        : currentText + text;

    final newOffset = selection.isValid
        ? selection.start + text.length
        : newText.length;

    _editingState = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newOffset),
    );

    TextInput.updateEditingValue(_editingState);
  }

  /// Delete the character before the cursor, or delete the selection.
  void deleteBackward() {
    final selection = _editingState.selection;
    final currentText = _editingState.text;

    if (!selection.isValid) return;

    String newText;
    int newOffset;

    if (selection.isCollapsed) {
      // No selection — delete char before cursor
      if (selection.start == 0) return; // Nothing to delete
      newText = currentText.replaceRange(
        selection.start - 1,
        selection.start,
        '',
      );
      newOffset = selection.start - 1;
    } else {
      // Selection exists — delete selection
      newText = currentText.replaceRange(selection.start, selection.end, '');
      newOffset = selection.start;
    }

    _editingState = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newOffset),
    );

    TextInput.updateEditingValue(_editingState);
  }

  /// Insert a newline character.
  void insertNewline() {
    insertText('\n');
  }

  /// Perform a text input action (done, next, go, etc.) on the attached
  /// client.
  ///
  /// This triggers the same framework behavior as the system keyboard's
  /// action key: `onSubmitted`/`onEditingComplete` callbacks, focus
  /// traversal for [TextInputAction.next], and unfocus for
  /// [TextInputAction.done]-like actions.
  void performAction(TextInputAction action) {
    _client?.performAction(action);
  }
}
