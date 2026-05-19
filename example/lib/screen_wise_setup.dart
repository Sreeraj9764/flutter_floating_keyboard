import 'package:flutter/material.dart';
import 'package:flutter_floating_keyboard/flutter_floating_keyboard.dart';

// =============================================================================
// SCREEN-WISE SETUP – Keyboard scoped to specific screens only
//
// Use this pattern when only certain screens need the floating keyboard
// (e.g. a data entry form) while other screens use the system keyboard.
// =============================================================================

void main() => runApp(const ScreenWiseApp());

class ScreenWiseApp extends StatelessWidget {
  const ScreenWiseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Screen-wise Keyboard',
      theme: ThemeData(useMaterial3: true),
      home: const NormalScreen(),
    );
  }
}

/// This screen uses the normal system keyboard.
class NormalScreen extends StatelessWidget {
  const NormalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Normal Screen (System Keyboard)')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const TextField(
              decoration: InputDecoration(
                labelText: 'Uses system keyboard',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const FloatingKeyboardScreen(),
                  ),
                );
              },
              child: const Text('Go to Floating Keyboard Screen'),
            ),
          ],
        ),
      ),
    );
  }
}

/// This screen installs the floating keyboard on entry and restores
/// the system keyboard on exit.
class FloatingKeyboardScreen extends StatefulWidget {
  const FloatingKeyboardScreen({super.key});

  @override
  State<FloatingKeyboardScreen> createState() => _FloatingKeyboardScreenState();
}

class _FloatingKeyboardScreenState extends State<FloatingKeyboardScreen> {
  final _controller = FlutterFloatingKeyboardController();

  @override
  void initState() {
    super.initState();
    _controller.install(); // Enable floating keyboard for this screen
  }

  @override
  void dispose() {
    _controller.dispose(); // Also restores system keyboard
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterFloatingKeyboardOverlay(
      controller: _controller,
      child: Scaffold(
        appBar: AppBar(title: const Text('Floating Keyboard Screen')),
        body: const Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Notes',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
