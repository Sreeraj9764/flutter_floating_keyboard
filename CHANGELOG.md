## 0.2.0

- **Breaking:** Remove fixed `minWidth: 400` constraint that caused overflow on narrow screens
- Responsive keyboard width using `LayoutBuilder` breakpoints (<500dp: 95%, 500–900dp: 75%, >900dp: 60%)
- Move width computation to `FlutterFloatingKeyboardConfig.computeKeyboardWidth()`
- Respect system safe area (home indicator, navigation bar) via `viewPadding`
- Add single-controller assertion to prevent multiple simultaneous installs
- `dispose()` now calls `uninstall()` automatically
- Restructure example as a standalone Flutter project with path dependency

## 0.1.1

- Add example files demonstrating default, custom, global, and screen-wise setup

## 0.1.0

- Initial release
- TextInputControl-based keyboard replacement
- QWERTY layout with numbers/symbols modes
- Draggable floating keyboard widget
- Haptic feedback support
- Auto-detect number input fields
