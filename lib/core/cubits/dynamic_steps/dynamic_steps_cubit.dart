import 'package:flutter/widgets.dart';

import '../../helpers/safe_cubit.dart';
import 'dynamic_steps_state.dart';

class DynamicStepsCubit extends SafeCubit<DynamicStepsState> {
  DynamicStepsCubit()
    : super(const DynamicStepsState(builders: [], titles: []));

  /// Build steps dynamically
  void buildSteps(List<Widget Function()> stepBuilders, List<String> titles) {
    emit(DynamicStepsState(builders: stepBuilders, titles: titles));
  }

  /// Add a single step dynamically at the end
  void addStep(Widget Function() builder, String title) {
    final newBuilders = List<Widget Function()>.from(state.builders)
      ..add(builder);
    final newTitles = List<String>.from(state.titles)..add(title);
    emit(DynamicStepsState(builders: newBuilders, titles: newTitles));
  }

  /// Insert step at specific index
  void insertStep(int index, Widget Function() builder, String title) {
    final newBuilders = List<Widget Function()>.from(state.builders)
      ..insert(index, builder);
    final newTitles = List<String>.from(state.titles)..insert(index, title);
    emit(DynamicStepsState(builders: newBuilders, titles: newTitles));
  }

  /// Remove step at index
  void removeStep(int index) {
    if (index < 0 || index >= state.builders.length) return;
    final newBuilders = List<Widget Function()>.from(state.builders)
      ..removeAt(index);
    final newTitles = List<String>.from(state.titles)..removeAt(index);
    emit(DynamicStepsState(builders: newBuilders, titles: newTitles));
  }

  /// Remove steps from index onwards (used when changing document type)
  void removeStepsFrom(int fromIndex) {
    if (fromIndex < 0 || fromIndex > state.builders.length) return;
    final newBuilders = state.builders.sublist(0, fromIndex);
    final newTitles = state.titles.sublist(0, fromIndex);
    emit(DynamicStepsState(builders: newBuilders, titles: newTitles));
  }

  /// Clear all dynamic steps
  void clearSteps() {
    emit(const DynamicStepsState(builders: [], titles: []));
  }
}
