import 'dart:async';

import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../color/color_cubit.dart';

part 'counter_state.dart';

class CounterCubit extends Cubit<CounterState> {
  final ColorCubit colorCubit;
  late final StreamSubscription colorSubscription;
  var incrementSize = 1;

  CounterCubit({
    required this.colorCubit,
  }) : super(CounterState.initial()) {
    colorCubit.stream.listen(_colorHandler);
  }

  @override
  Future<void> close() {
    colorSubscription.cancel();
    return super.close();
  }

  void _colorHandler(ColorState colorState) {
    final color = colorState.color;

    if (color == Colors.red) incrementSize = 1;
    if (color == Colors.green) incrementSize = 10;
    if (color == Colors.blue) incrementSize = 100;
    if (color == Colors.black) {
      incrementSize -= 100;
      emit(state.copyWith(counter: state.counter - 100));
    }
  }

  void incrementCounter() {
    emit(state.copyWith(counter: state.counter + incrementSize));
  }
}
