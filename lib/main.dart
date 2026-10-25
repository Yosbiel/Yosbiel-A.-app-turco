import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/router/app_router.dart';

void main() {
  runApp(const TurcoApp());
}

class TurcoApp extends StatefulWidget {
  const TurcoApp({super.key});

  @override
  State<TurcoApp> createState() => _TurcoAppState();
}

class _TurcoAppState extends State<TurcoApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void cambiarTema(ThemeMode nuevoModo) {
    setState(() {
      _themeMode = nuevoModo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Turco',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF006A60)),
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF006A60),
          brightness: Brightness.dark,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
      ),
      routerConfig: AppRouter.router(cambiarTema),
    );
  }
}