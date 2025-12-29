import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'src/app_state.dart';
import 'src/theme.dart';
import 'src/ui/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()..init()),
      ],
      child: const MobileMouseApp(),
    ),
  );
}

class MobileMouseApp extends StatelessWidget {
  const MobileMouseApp({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mobile Mouse',
      theme: buildTheme(Brightness.light),
      darkTheme: buildTheme(Brightness.dark),
      themeMode: state.settings.themeMode,
      home: const SplashScreen(),
    );
  }
}
