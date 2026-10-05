import 'package:flutter/material.dart';

extension WidgetExtensions on Widget {
  Widget get sliverBoxAdapter => SliverToBoxAdapter(child: this);
}
