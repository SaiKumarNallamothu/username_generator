import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'services/storage_service.dart';
import 'services/ad_service.dart';
import 'theme/custom_theme.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize storage (Hive + SharedPreferences)
  await StorageService.init();
  
  // Initialize AdMob Ad Service
  await AdService.instance.init();

  runApp(
    const ProviderScope(
      child: UserNameGeneratorApp(),
    ),
  );
}

class UserNameGeneratorApp extends StatelessWidget {
  const UserNameGeneratorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gaming Username Studio',
      debugShowCheckedModeBanner: false,
      theme: CustomTheme.darkTheme,
      home: const SplashScreen(),
    );
  }
}
