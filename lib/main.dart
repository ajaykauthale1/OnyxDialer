import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'ui/home_screen.dart';
import 'theme/app_theme.dart';
import 'providers/god_mode_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const ProviderScope(child: OnyxDialerApp()));
}

class OnyxDialerApp extends ConsumerStatefulWidget {
  const OnyxDialerApp({super.key});

  @override
  ConsumerState<OnyxDialerApp> createState() => _OnyxDialerAppState();
}

class _OnyxDialerAppState extends ConsumerState<OnyxDialerApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.detached) {
      // Lock God Mode when app goes to background
      ref.read(godModeProvider.notifier).lock();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Onyx Dialer',
      theme: AppTheme.darkTheme, // Use our custom Grizzly theme
      home: const HomeScreen(),
    );
  }
}
