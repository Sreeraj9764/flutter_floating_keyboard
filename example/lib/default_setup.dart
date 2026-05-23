import 'package:flutter/material.dart';
import 'package:flutter_floating_keyboard/flutter_floating_keyboard.dart';

// =============================================================================
// DEFAULT SETUP – Minimal configuration, everything out-of-the-box
// =============================================================================

void main() => runApp(const DefaultSetupApp());

class DefaultSetupApp extends StatelessWidget {
  const DefaultSetupApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Default Setup',
      theme: ThemeData(useMaterial3: true),
      home: const DefaultSetupExample(),
    );
  }
}

/// The simplest way to use the package.
/// The keyboard uses all default settings (light theme, all modes enabled).
class DefaultSetupExample extends StatefulWidget {
  const DefaultSetupExample({super.key});

  @override
  State<DefaultSetupExample> createState() => _DefaultSetupExampleState();
}

class _DefaultSetupExampleState extends State<DefaultSetupExample> {
  final _controller = FlutterFloatingKeyboardController();

  @override
  void initState() {
    super.initState();
    _controller.install(); // Suppresses the system keyboard
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterFloatingKeyboardOverlay(
      controller: _controller,
      child: Scaffold(
        appBar: AppBar(title: const Text('Default Setup')),
        body: Padding(
          padding: EdgeInsets.all(24),
          child: TextField(
            maxLines: 5,
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
            decoration: InputDecoration(
              labelText: 'Tap here to open keyboard',
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ),
    );
  }
}
