import 'package:flutter/material.dart';
import 'package:flutter_floating_keyboard/flutter_floating_keyboard.dart';

// =============================================================================
// GLOBAL SETUP – Keyboard available across all screens (recommended)
//
// Uses MaterialApp.builder so the keyboard persists across all routes.
// See also:
//   - default_setup.dart    → minimal out-of-the-box usage
//   - custom_config.dart    → themed keyboard with custom colors/behavior
//   - screen_wise_setup.dart → keyboard scoped to specific screens only
// =============================================================================

void main() => runApp(const ExampleApp());

class ExampleApp extends StatefulWidget {
  const ExampleApp({super.key});

  @override
  State<ExampleApp> createState() => _ExampleAppState();
}

class _ExampleAppState extends State<ExampleApp> {
  final _keyboardController = FlutterFloatingKeyboardController();

  @override
  void initState() {
    super.initState();
    _keyboardController.install();
  }

  @override
  void dispose() {
    _keyboardController.uninstall();
    _keyboardController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Floating Keyboard Example',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
      // The builder wraps ALL routes with the keyboard overlay
      builder: (context, child) {
        return FlutterFloatingKeyboardOverlay(
          controller: _keyboardController,
          child: child!,
        );
      },
      home: const HomeScreen(),
    );
  }
}

/// Home screen with navigation to demonstrate global keyboard persistence.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Global Setup Example')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const TextField(
              decoration: InputDecoration(
                labelText: 'Home screen text field',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SecondScreen()),
                );
              },
              child: const Text('Go to Second Screen'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Second screen – keyboard still works because of global setup.
class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Second Screen')),
      body: const Padding(
        padding: EdgeInsets.all(24),
        child: TextField(
          decoration: InputDecoration(
            labelText: 'Keyboard works here too!',
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }
}
