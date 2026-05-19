import 'package:flutter/material.dart';
import 'package:flutter_floating_keyboard/flutter_floating_keyboard.dart';

// =============================================================================
// CUSTOM CONFIG – Themed keyboard with custom colors and behavior
// =============================================================================

void main() => runApp(const CustomConfigApp());

class CustomConfigApp extends StatelessWidget {
  const CustomConfigApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Custom Config',
      theme: ThemeData(useMaterial3: true, brightness: Brightness.dark),
      home: const CustomConfigExample(),
    );
  }
}

/// Customized keyboard appearance and behavior.
class CustomConfigExample extends StatefulWidget {
  const CustomConfigExample({super.key});

  @override
  State<CustomConfigExample> createState() => _CustomConfigExampleState();
}

class _CustomConfigExampleState extends State<CustomConfigExample> {
  /// Pass a custom config to the controller
  final _controller = FlutterFloatingKeyboardController(
    config: const FlutterFloatingKeyboardConfig(
      backgroundColor: Color(0xFF1E1E2E),
      keyColor: Color(0xFF313244),
      specialKeyColor: Color(0xFF45475A),
      keyTextColor: Color(0xFFCDD6F4),
      keyBorderRadius: 8.0,
      keySpacing: 5.0,
      rowSpacing: 8.0,
      elevation: 12.0,
      borderRadius: 16.0,
      enableHaptics: true,
      enableDrag: true,
      enableNumberMode: true,
      enableSymbolMode: false, // Disable symbols mode
      showDragHandle: true,
    ),
  );

  @override
  void initState() {
    super.initState();
    _controller.install();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Use the same config for the overlay widget
    return FlutterFloatingKeyboardOverlay(
      controller: _controller,
      config: _controller.config,
      child: Scaffold(
        appBar: AppBar(title: const Text('Custom Config (Dark Theme)')),
        body: const Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
