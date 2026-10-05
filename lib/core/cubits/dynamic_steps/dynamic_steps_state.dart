import 'package:flutter/material.dart';

class DynamicStepsState {
  /// List of lazy builders for each step
  final List<Widget Function()> builders;

  /// List of titles for each step
  final List<String> titles;

  const DynamicStepsState({required this.builders, required this.titles});

  int get totalSteps => builders.length;
}
