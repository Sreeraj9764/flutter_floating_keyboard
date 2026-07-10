/// Defines the QWERTY keyboard layout data for all modes.
library;

/// The mode of the keyboard layout.
enum KeyboardMode { letters, numbers, symbols }

/// The type of action a key performs.
enum KeyAction {
  character,
  backspace,
  shift,
  space,
  enter,
  modeSwitch,
  dismiss,
}

/// Data for a single keyboard key.
class KeyData {
  const KeyData({
    required this.value,
    this.display,
    this.flex = 1,
    this.action = KeyAction.character,
    this.modeTarget,
  });

  /// The value to insert (for character keys).
  final String value;

  /// Display label (defaults to [value] if null).
  final String? display;

  /// Flex weight for sizing within a row.
  final int flex;

  /// The action this key performs.
  final KeyAction action;

  /// The mode this key switches to (for [KeyAction.modeSwitch] keys).
  final KeyboardMode? modeTarget;

  /// The display text shown on the key.
  String get label => display ?? value;
}

/// Static keyboard layout definitions.
class KeyboardLayout {
  KeyboardLayout._();

  // --- Letters Mode (QWERTY) ---

  static const List<List<KeyData>> letterRows = [
    // Row 1
    [
      KeyData(value: 'q'),
      KeyData(value: 'w'),
      KeyData(value: 'e'),
      KeyData(value: 'r'),
      KeyData(value: 't'),
      KeyData(value: 'y'),
      KeyData(value: 'u'),
      KeyData(value: 'i'),
      KeyData(value: 'o'),
      KeyData(value: 'p'),
    ],
    // Row 2
    [
      KeyData(value: 'a'),
      KeyData(value: 's'),
      KeyData(value: 'd'),
      KeyData(value: 'f'),
      KeyData(value: 'g'),
      KeyData(value: 'h'),
      KeyData(value: 'j'),
      KeyData(value: 'k'),
      KeyData(value: 'l'),
    ],
    // Row 3 (with shift and backspace)
    [
      KeyData(value: '', display: '⇧', flex: 2, action: KeyAction.shift),
      KeyData(value: 'z'),
      KeyData(value: 'x'),
      KeyData(value: 'c'),
      KeyData(value: 'v'),
      KeyData(value: 'b'),
      KeyData(value: 'n'),
      KeyData(value: 'm'),
      KeyData(value: '', display: '⌫', flex: 2, action: KeyAction.backspace),
    ],
    // Row 4 (bottom)
    [
      KeyData(
        value: '',
        display: '123',
        flex: 2,
        action: KeyAction.modeSwitch,
        modeTarget: KeyboardMode.numbers,
      ),
      KeyData(value: ','),
      KeyData(value: ' ', display: 'space', flex: 5, action: KeyAction.space),
      KeyData(value: '.'),
      KeyData(value: '', display: '⏎', flex: 2, action: KeyAction.enter),
      KeyData(value: '', display: '⌨↓', flex: 2, action: KeyAction.dismiss),
    ],
  ];

  // --- Numbers Mode ---

  static const List<List<KeyData>> numberRows = [
    // Row 1
    [
      KeyData(value: '1'),
      KeyData(value: '2'),
      KeyData(value: '3'),
      KeyData(value: '4'),
      KeyData(value: '5'),
      KeyData(value: '6'),
      KeyData(value: '7'),
      KeyData(value: '8'),
      KeyData(value: '9'),
      KeyData(value: '0'),
    ],
    // Row 2
    [
      KeyData(value: '-'),
      KeyData(value: '/'),
      KeyData(value: ':'),
      KeyData(value: ';'),
      KeyData(value: '('),
      KeyData(value: ')'),
      KeyData(value: '\$'),
      KeyData(value: '&'),
      KeyData(value: '@'),
      KeyData(value: '"'),
    ],
    // Row 3
    [
      KeyData(
        value: '',
        display: '#+=',
        flex: 2,
        action: KeyAction.modeSwitch,
        modeTarget: KeyboardMode.symbols,
      ),
      KeyData(value: '.'),
      KeyData(value: ','),
      KeyData(value: '?'),
      KeyData(value: '!'),
      KeyData(value: "'"),
      KeyData(value: '%'),
      KeyData(value: '', display: '⌫', flex: 2, action: KeyAction.backspace),
    ],
    // Row 4 (bottom)
    [
      KeyData(
        value: '',
        display: 'ABC',
        flex: 2,
        action: KeyAction.modeSwitch,
        modeTarget: KeyboardMode.letters,
      ),
      KeyData(value: ','),
      KeyData(value: ' ', display: 'space', flex: 5, action: KeyAction.space),
      KeyData(value: '.'),
      KeyData(value: '', display: '⏎', flex: 2, action: KeyAction.enter),
      KeyData(value: '', display: '⌨↓', flex: 2, action: KeyAction.dismiss),
    ],
  ];

  // --- Symbols Mode ---

  static const List<List<KeyData>> symbolRows = [
    // Row 1
    [
      KeyData(value: '['),
      KeyData(value: ']'),
      KeyData(value: '{'),
      KeyData(value: '}'),
      KeyData(value: '#'),
      KeyData(value: '%'),
      KeyData(value: '^'),
      KeyData(value: '*'),
      KeyData(value: '+'),
      KeyData(value: '='),
    ],
    // Row 2
    [
      KeyData(value: '_'),
      KeyData(value: '\\'),
      KeyData(value: '|'),
      KeyData(value: '~'),
      KeyData(value: '<'),
      KeyData(value: '>'),
      KeyData(value: '€'),
      KeyData(value: '£'),
      KeyData(value: '¥'),
      KeyData(value: '•'),
    ],
    // Row 3
    [
      KeyData(
        value: '',
        display: '123',
        flex: 2,
        action: KeyAction.modeSwitch,
        modeTarget: KeyboardMode.numbers,
      ),
      KeyData(value: '.'),
      KeyData(value: ','),
      KeyData(value: '?'),
      KeyData(value: '!'),
      KeyData(value: "'"),
      KeyData(value: '`'),
      KeyData(value: '', display: '⌫', flex: 2, action: KeyAction.backspace),
    ],
    // Row 4 (bottom)
    [
      KeyData(
        value: '',
        display: 'ABC',
        flex: 2,
        action: KeyAction.modeSwitch,
        modeTarget: KeyboardMode.letters,
      ),
      KeyData(value: ','),
      KeyData(value: ' ', display: 'space', flex: 5, action: KeyAction.space),
      KeyData(value: '.'),
      KeyData(value: '', display: '⏎', flex: 2, action: KeyAction.enter),
      KeyData(value: '', display: '⌨↓', flex: 2, action: KeyAction.dismiss),
    ],
  ];
}
