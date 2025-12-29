import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';
import 'connect_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const ConnectScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [scheme.primary, scheme.primaryContainer, scheme.surface],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.mouse_outlined, size: 84, color: scheme.onPrimary),
              const SizedBox(height: 14),
              Text('Mobile Mouse', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: scheme.onPrimary)),
              const SizedBox(height: 18),
              SizedBox(
                width: 180,
                child: LinearProgressIndicator(
                  backgroundColor: scheme.onPrimary.withOpacity(0.2),
                ),
              ),
              const SizedBox(height: 10),
              Text('Checking connectivity…', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: scheme.onPrimary.withOpacity(0.9))),
            ],
          ),
        ),
      ),
    );
  }
}
