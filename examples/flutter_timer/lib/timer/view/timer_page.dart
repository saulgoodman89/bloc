import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_timer/ticker.dart';
import 'package:flutter_timer/timer/timer.dart';

class TimerPage extends StatelessWidget {
  const TimerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TimerBloc(ticker: const Ticker()),
      child: const TimerView(),
    );
  }
}

class TimerView extends StatelessWidget {
  const TimerView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Stack(
        children: [
          Background(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(vertical: 100),
                child: Center(child: TimerText()),
              ),
              Actions(),
            ],
          ),
        ],
      ),
    );
  }
}

class TimerText extends StatelessWidget {
  const TimerText({super.key});

  @override
  Widget build(BuildContext context) {
    final duration = context.select((TimerBloc bloc) => bloc.state.duration);
    final minutesStr =
        ((duration / 60) % 60).floor().toString().padLeft(2, '0');
    final secondsStr = (duration % 60).toString().padLeft(2, '0');
    return Text(
      '$minutesStr:$secondsStr',
      style: Theme.of(context)
          .textTheme
          .displayLarge
          ?.copyWith(fontWeight: FontWeight.w500),
    );
  }
}

class Actions extends StatelessWidget {
  const Actions({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>( //BlocBuilder는 Bloc의 상태 변화를 감지하고 상태 변경 때 마다 builder 함수를 호출해 UI를 다시 빌드.
      buildWhen: (prev, state) => prev.runtimeType != state.runtimeType, //state의 type이 변경 되었을 때만 UI를 다시 빌드
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ...switch (state) {
            /*
                state가 TimerInitial 일 때 버튼을 누르면
                1.TimerStarted 이벤트가 발생
                2.타이머 실행 유무를 체크 후 없다면 ticker 스트림을 구독해 타이머를 시작.
                3.tick 마다 TimerTicked 이벤트를 TimerBloc에 추가
                4.TimerBloc은 TimerTicker 이벤트를 처리해 UI를 업데이트
             */
              TimerInitial() => [
                  FloatingActionButton(
                    child: const Icon(Icons.play_arrow),
                    onPressed: () => context
                        .read<TimerBloc>()
                        .add(TimerStarted(duration: state.duration)),
                  ),
                ],
            /*
                TimerRunInProgress 상태 일 때 pause , reset 버튼이 생긴다.
                TimerPaused 이벤트 발생 일 때 pause 버튼을 누르면 TimerPaused 이벤트를 Bloc에 추가
                reset 버튼을 누르면 TimerReset 이벤트를 Bloc에 추가
             */
              TimerRunInProgress() => [
                  FloatingActionButton(
                    child: const Icon(Icons.pause),
                    onPressed: () {
                      context.read<TimerBloc>().add(const TimerPaused());
                    },
                  ),
                  FloatingActionButton(
                    child: const Icon(Icons.replay),
                    onPressed: () {
                      context.read<TimerBloc>().add(const TimerReset());
                    },
                  ),
                ],
              TimerRunPause() => [
                  FloatingActionButton(
                    child: const Icon(Icons.play_arrow),
                    onPressed: () {
                      context.read<TimerBloc>().add(const TimerResumed());
                    },
                  ),
                  FloatingActionButton(
                    child: const Icon(Icons.replay),
                    onPressed: () {
                      context.read<TimerBloc>().add(const TimerReset());
                    },
                  ),
                ],
              TimerRunComplete() => [
                  FloatingActionButton(
                    child: const Icon(Icons.replay),
                    onPressed: () {
                      context.read<TimerBloc>().add(const TimerReset());
                    },
                  ),
                ]
            },
          ],
        );
      },
    );
  }
}

class Background extends StatelessWidget {
  const Background({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade50,
              Colors.blue.shade500,
            ],
          ),
        ),
      ),
    );
  }
}
