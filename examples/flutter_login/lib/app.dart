import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login/authentication/authentication.dart';
import 'package:flutter_login/home/home.dart';
import 'package:flutter_login/login/login.dart';
import 'package:flutter_login/splash/splash.dart';
import 'package:user_repository/user_repository.dart';

/*
  앱 전체 상태관리 루트 위젯
 */
class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  /*
    앱 시작 시 아래 두 라인을 초기화
   */
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
    /*
      앱 종료 시 AuthentificationRepository의 자원을 해제
     */
    _authenticationRepository.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
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
=======
    print("KEG app.dart build ");
    return RepositoryProvider.value(
      value: _authenticationRepository, // 하위 위젯들이 접근 할 수 있도록 초기화
      /*
        하위 위젯들이 _authenticationRepository에 접근 할 수 있도록 설정.
       */
      child: BlocProvider( //
        lazy: false,  // 생성 시 바로 Bloc를 생성
        create: (_) => AuthenticationBloc(  // AuthentificationBloc 생성 후 AuthentificationSubscriptionRequested 이벤트를 추가
>>>>>>> 402702ffb5bc687c08804177b3f075c64ff8485a
          authenticationRepository: _authenticationRepository,
          userRepository: _userRepository,
        )..add(AuthenticationSubscriptionRequested()),// 인증 상태 구독을 위한 이벤트 추가
        child: const AppView(),
      ),
    );
  }
}

/*
  navigationKey를 가지고 네비게이션을 직접 제어한다.
 */
class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  /*
    _navigatorKey를 생성하여 MaterialApp에 navigationKey를 전달.
   */
  final _navigatorKey = GlobalKey<NavigatorState>();

  // _navigator getter를 통해 Navigator 상태에 쉽게 접근.
  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
<<<<<<< HEAD
      navigatorKey: _navigatorKey,   // navigation 관리위한 globalKey
      builder: (context, child) {
        /*
          BLoC 상태 변화를 감지, 상태에 따라 특정 작업을 수행.
          상태가 변경 될 때 마다 listener zhfqordl tngod.
          ui를 업데이트 하지 않고 side effect를 처리.
         */
=======
      navigatorKey: _navigatorKey,  // 네비게이션 제어 키 할당
      builder: (context, child) { // 앱 전체에 BlocListener 적용.
>>>>>>> 402702ffb5bc687c08804177b3f075c64ff8485a
        return BlocListener<AuthenticationBloc, AuthenticationState>(
          /*
            상태 변화가 발생하면 listener가 실행.
            _navigator.pushAndRemoveUntil<void>
            새로운 페이지 전환 시 이전 페이지 모두 제거(스택 초기화)

           */
          listener: (context, state) {
            switch (state.status) {
<<<<<<< HEAD
              case AuthenticationStatus.authenticated: //인증된 상태면 Homepage로  이동
=======
              case AuthenticationStatus.authenticated: // 인증 성공-> HomePage로
>>>>>>> 402702ffb5bc687c08804177b3f075c64ff8485a
                _navigator.pushAndRemoveUntil<void>(
                  HomePage.route(),
                  (route) => false,
                );
<<<<<<< HEAD
              case AuthenticationStatus.unauthenticated:  // 인증되지 않은 상태면 LoginPage로 이동
=======
              case AuthenticationStatus.unauthenticated: // 인증 실패-> LoginPage
>>>>>>> 402702ffb5bc687c08804177b3f075c64ff8485a
                _navigator.pushAndRemoveUntil<void>(
                  LoginPage.route(),
                  (route) => false,
                );
              case AuthenticationStatus.unknown: // 별도 처리 없이 유지
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
