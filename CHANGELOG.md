## 0.3.0

> Note: This release has breaking changes.

 - **FEAT**: update package configuration and dependencies, add new packages and improve README. ([e8fdef6c](https://github.com/Sreeraj9764/flutter_floating_keyboard/commit/e8fdef6c1996744ff7c8205619d6143b53b9401d))
 - **FEAT**: enhance key press handling with improved tap and hold feedback. ([ff18798f](https://github.com/Sreeraj9764/flutter_floating_keyboard/commit/ff18798f3484f87e36f1f98dd1e2271f334cf716))
 - **FEAT**: enhance drag functionality and configuration for floating keyboard. ([7567b20f](https://github.com/Sreeraj9764/flutter_floating_keyboard/commit/7567b20f485f8658b633f73a55594f5d5c1b72cf))
 - **FEAT**: update package configuration and dependencies, remove unused files. ([6db85f70](https://github.com/Sreeraj9764/flutter_floating_keyboard/commit/6db85f70728e17b23bc5542d8805f370e2f20631))
 - **FEAT**: add melos configuration for package management and scripts. ([891e9385](https://github.com/Sreeraj9764/flutter_floating_keyboard/commit/891e9385dd9488ce2e03d9db33e3c2c7ddd84787))
 - **FEAT**: bump version to 0.2.2 and update changelog with documentation improvements. ([9739cccb](https://github.com/Sreeraj9764/flutter_floating_keyboard/commit/9739cccbe0af297a09dd8268c38dc4a37f2532ef))
 - **FEAT**: update version to 0.2.1 and add new screenshots for improved README. ([5ee07f8f](https://github.com/Sreeraj9764/flutter_floating_keyboard/commit/5ee07f8f378e2f7b49f7f0b5754bbf5568a453fb))
 - **FEAT**: update README and pubspec description for clarity and responsiveness. ([1de347cf](https://github.com/Sreeraj9764/flutter_floating_keyboard/commit/1de347cf41099aa02c301cf65d8370a9fea506fb))
 - **FEAT**: update to version 0.2.0 with responsive keyboard improvements and new screenshots. ([d320dc3b](https://github.com/Sreeraj9764/flutter_floating_keyboard/commit/d320dc3be86d80dbd7e131bc0361e16db8c9fdad))
 - **FEAT**: responsive keyboard sizing and safe area support. ([92016ded](https://github.com/Sreeraj9764/flutter_floating_keyboard/commit/92016dedf267e7c9c19c48b5824b0b16fe71d334))
 - **FEAT**: add example setups for custom, default, global, and screen-wise keyboard configurations. ([a967ce4d](https://github.com/Sreeraj9764/flutter_floating_keyboard/commit/a967ce4df94934023af2f487355f5a12255b0c75))
 - **FEAT**: add FlutterFloatingKeyboard package with custom input control. ([c53934df](https://github.com/Sreeraj9764/flutter_floating_keyboard/commit/c53934df3e451b1430c0dc0fc2f9050990fb02b8))
 - **BREAKING** **CHANGE**: Premium iOS-style redesign with theming, animations, and richer feedback. ([b729c2df](https://github.com/Sreeraj9764/flutter_floating_keyboard/commit/b729c2dffe47ae13bf96094ce1041052739ab500))

## 0.2.3

 - **FEAT**: enhance key press handling with improved tap and hold feedback. ([ff18798f](https://github.com/Sreeraj9764/flutter_floating_keyboard/commit/ff18798f3484f87e36f1f98dd1e2271f334cf716))
 - **FEAT**: enhance drag functionality and configuration for floating keyboard. ([7567b20f](https://github.com/Sreeraj9764/flutter_floating_keyboard/commit/7567b20f485f8658b633f73a55594f5d5c1b72cf))
 - **FEAT**: update package configuration and dependencies, remove unused files. ([6db85f70](https://github.com/Sreeraj9764/flutter_floating_keyboard/commit/6db85f70728e17b23bc5542d8805f370e2f20631))
 - **FEAT**: add melos configuration for package management and scripts. ([891e9385](https://github.com/Sreeraj9764/flutter_floating_keyboard/commit/891e9385dd9488ce2e03d9db33e3c2c7ddd84787))
 - **FEAT**: bump version to 0.2.2 and update changelog with documentation improvements. ([9739cccb](https://github.com/Sreeraj9764/flutter_floating_keyboard/commit/9739cccbe0af297a09dd8268c38dc4a37f2532ef))
 - **FEAT**: update version to 0.2.1 and add new screenshots for improved README. ([5ee07f8f](https://github.com/Sreeraj9764/flutter_floating_keyboard/commit/5ee07f8f378e2f7b49f7f0b5754bbf5568a453fb))
 - **FEAT**: update README and pubspec description for clarity and responsiveness. ([1de347cf](https://github.com/Sreeraj9764/flutter_floating_keyboard/commit/1de347cf41099aa02c301cf65d8370a9fea506fb))
 - **FEAT**: update to version 0.2.0 with responsive keyboard improvements and new screenshots. ([d320dc3b](https://github.com/Sreeraj9764/flutter_floating_keyboard/commit/d320dc3be86d80dbd7e131bc0361e16db8c9fdad))
 - **FEAT**: responsive keyboard sizing and safe area support. ([92016ded](https://github.com/Sreeraj9764/flutter_floating_keyboard/commit/92016dedf267e7c9c19c48b5824b0b16fe71d334))
 - **FEAT**: add example setups for custom, default, global, and screen-wise keyboard configurations. ([a967ce4d](https://github.com/Sreeraj9764/flutter_floating_keyboard/commit/a967ce4df94934023af2f487355f5a12255b0c75))
 - **FEAT**: add FlutterFloatingKeyboard package with custom input control. ([c53934df](https://github.com/Sreeraj9764/flutter_floating_keyboard/commit/c53934df3e451b1430c0dc0fc2f9050990fb02b8))

## 0.2.2

- Documentation improvements and small updates

## 0.2.1

- Add screenshots for iPad, iPhone, dark theme, and landscape modes
- Update README with screenshots and improved description
- Add `screenshots` field to pubspec for pub.dev carousel

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
