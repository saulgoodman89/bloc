import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_counter/app.dart';
import 'package:flutter_counter/counter_observer.dart';

void main() {
  Bloc.observer = const CounterObserver();  // bloc 옵저버 추가
  runApp(const CounterApp()); // CounterApp 실행
}
