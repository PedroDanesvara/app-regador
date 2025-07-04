import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:projeto_alex_flutter/providers/device_provider.dart';
import 'package:projeto_alex_flutter/screens/splash_screen.dart';
import 'package:projeto_alex_flutter/utils/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DeviceProvider()),
      ],
      child: MaterialApp(
        title: 'Sistema de Monitoramento ESP32',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const SplashScreen(),
      ),
    );
  }
} 