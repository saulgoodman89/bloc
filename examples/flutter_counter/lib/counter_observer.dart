import 'package:bloc/bloc.dart';

/// {@template counter_observer}
/// [BlocObserver] for the counter application which
/// observes all state changes.
/// {@endtemplate}

/*
  state를 체크하는 Observer
 */
class CounterObserver extends BlocObserver {
  /// {@macro counter_observer}
  const CounterObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    // ignore: avoid_print
    print('KEG CounterObserver ${bloc.runtimeType} $change');
  }
}
