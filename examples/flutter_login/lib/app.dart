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
    print("KEG app.dart build ");
    return RepositoryProvider.value(
      value: _authenticationRepository, // 하위 위젯들이 접근 할 수 있도록 초기화
      /*
        하위 위젯들이 _authenticationRepository에 접근 할 수 있도록 설정.
       */
      child: BlocProvider( //
        lazy: false,  // 생성 시 바로 Bloc를 생성
        create: (_) => AuthenticationBloc(  // AuthentificationBloc 생성 후 AuthentificationSubscriptionRequested 이벤트를 추가
          authenticationRepository: _authenticationRepository,
          userRepository: _userRepository,
        )..add(AuthenticationSubscriptionRequested()),
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
      navigatorKey: _navigatorKey,  // 네비게이션 제어 키 할당
      builder: (context, child) { // 앱 전체에 BlocListener 적용.
        return BlocListener<AuthenticationBloc, AuthenticationState>(
          /*
            상태 변화가 발생하면 listener가 실행.
            _navigator.pushAndRemoveUntil<void>
            새로운 페이지 전환 시 이전 페이지 모두 제거(스택 초기화)

           */
          listener: (context, state) {
            switch (state.status) {
              case AuthenticationStatus.authenticated: // 인증 성공-> HomePage로
                _navigator.pushAndRemoveUntil<void>(
                  HomePage.route(),
                  (route) => false,
                );
              case AuthenticationStatus.unauthenticated: // 인증 실패-> LoginPage
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
      onGenerateRoute: (_) => SplashPage.route(),
    );
  }
}
