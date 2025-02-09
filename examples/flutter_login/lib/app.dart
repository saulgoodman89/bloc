import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login/authentication/authentication.dart';
import 'package:flutter_login/home/home.dart';
import 'package:flutter_login/login/login.dart';
import 'package:flutter_login/splash/splash.dart';
import 'package:user_repository/user_repository.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final AuthenticationRepository _authenticationRepository;
  late final UserRepository _userRepository;

  @override
  void initState() {
    super.initState();
    print("KEG _AppState initState");
    /*
      인증 , 유저 repo 초기화
     */
    _authenticationRepository = AuthenticationRepository();
    _userRepository = UserRepository();
  }

  @override
  void dispose() {
    _authenticationRepository.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("_AppState build");
    return RepositoryProvider.value(  // RepositoryProvider.value : _authenticationRepository를 하위 위젯 트리에서 사용할 수 있도록 제공.
      value: _authenticationRepository,
      /*
        BlocProvider
        BLoC를 생성하고 하위 위젯 트리에 사용 할 수 있도록 제공.
        하위 위젯에서 BlocProvider.of(context)를 사용해 BLoC에 접근 할 수 있다.
       */
      child: BlocProvider( // AuthenticationBloc을 생성하고 하위 위젯 트리에서 사용 하도록 제공.
        lazy: false,
        create: (_) => AuthenticationBloc(
          authenticationRepository: _authenticationRepository,
          userRepository: _userRepository,
        )..add(AuthenticationSubscriptionRequested()),// 인증 상태 구독을 위한 이벤트 추가
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,   // navigation 관리위한 globalKey
      builder: (context, child) {
        /*
          BLoC 상태 변화를 감지, 상태에 따라 특정 작업을 수행.
          상태가 변경 될 때 마다 listener zhfqordl tngod.
          ui를 업데이트 하지 않고 side effect를 처리.
         */
        return BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            switch (state.status) {
              case AuthenticationStatus.authenticated: //인증된 상태면 Homepage로  이동
                _navigator.pushAndRemoveUntil<void>(
                  HomePage.route(),
                  (route) => false,
                );
              case AuthenticationStatus.unauthenticated:  // 인증되지 않은 상태면 LoginPage로 이동
                _navigator.pushAndRemoveUntil<void>(
                  LoginPage.route(),
                  (route) => false,
                );
              case AuthenticationStatus.unknown:
                break;
            }
          },
          child: child,
        );
      },
      onGenerateRoute: (_) => SplashPage.route(),   // 초기화면으로 SplashPage 설정
    );
  }
}
