import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;

  const AppScaffold({super.key, required this.child, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(bottom: false, child: child),
    );
  }
}
