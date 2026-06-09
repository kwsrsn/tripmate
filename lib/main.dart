import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripmate/core/router/app_router.dart';
import 'package:tripmate/core/theme/app_theme.dart';

void main() {
  runApp(
    const ProviderScope(
      child: TripMateApp(),
    )
  );
}

class TripMateApp extends StatelessWidget {
  const TripMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'TripMate',
      theme: AppTheme.light,
      debugShowCheckedModeBanner: false, //ลบออก
      routerConfig: appRouter,
    );
  }
}
