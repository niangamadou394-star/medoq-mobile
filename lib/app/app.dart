import 'package:flutter/material.dart';
import 'router.dart';
import 'theme.dart';

class MedoqApp extends StatelessWidget {
  const MedoqApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Medoq',
      debugShowCheckedModeBanner: false,
      theme: MedoqTheme.lightTheme,
      routerConfig: appRouter,
    );
  }
}
