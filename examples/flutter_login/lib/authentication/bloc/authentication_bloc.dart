import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';
/*
    Authentication 상태를 관리하는 BLoC
    로그인 , 로그아웃을 관리.
 */
class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({
    required AuthenticationRepository authenticationRepository,
    required UserRepository userRepository,
    /*
      의존성 주입을 받아 _authenticationRepo , userRepo 라는 private 변수를 할당.
     */
  })  : _authenticationRepository = authenticationRepository,
        _userRepository = userRepository,
        super(const AuthenticationState.unknown()) { // 초기상태를 unknown 으로 설정.
    on<AuthenticationSubscriptionRequested>(_onSubscriptionRequested);  // AuthenticationSubscriptionRequested 이벤트가 ㅂ라생하면 , _onSubscriptionRequested 메서드를 호출하여 처리.
    on<AuthenticationLogoutPressed>(_onLogoutPressed);  // AuthenticationLogoutPressed 이벤트가 발생하면 , _onLogoutPressed 메서드를 호출하여 처리
  }

  final AuthenticationRepository _authenticationRepository;
  final UserRepository _userRepository;

  /*
    AuthenticationSubscriptionRequested 이벤트가 발생 했을 때 호출.
   */
  Future<void> _onSubscriptionRequested(
    AuthenticationSubscriptionRequested event,
    Emitter<AuthenticationState> emit,
  ) {
    /*
      emit을 통해 새로운 상태로 갱신하고 비동기 작업 수행.

      emit.onEach를 사용해 해당 스트림의 데이터가 변경 될 때 마다 onData 콜백을 통해 새로운 상태를 방출한다.
     */
    return emit.onEach(
      _authenticationRepository.status, // 인증 상태를 나타내는 Stream
      onData: (status) async {
        switch (status) {
          case AuthenticationStatus.unauthenticated:  // status가 unauti 이면 AuthenticationState.unauthenticated() 를 방출하여 사용자 인증 되지 않음을 알림.
            return emit(const AuthenticationState.unauthenticated());
          case AuthenticationStatus.authenticated:  // status가 auti(회원 인증된 상태) 이면 _tryGetUser를 호출해 사용자 정보를 가져온다.
            final user = await _tryGetUser();
            return emit(
              user != null
                  ? AuthenticationState.authenticated(user) // 사용자 정보가 정상적으로 반환되면 AuthenticationState.authenticated(user) 를 방출하여 인증된 상태와 사용자 정보 전달.
                  : const AuthenticationState.unauthenticated(),  // 사용자 정보 조회에 실패하면 unauthenticated 상태로 처리.
            );
          case AuthenticationStatus.unknown:
            return emit(const AuthenticationState.unknown());
        }
      },
      onError: addError,  // 스트림에서 에러가 발생하면 addError를 호출하여 에러 처리.
    );
  }

  /*
    AuthenticationLogoutPressed 이벤트가 발생했을 때 호출하고
    log 아웃 처리를 수행.
    내부에서 상태 스트림을 변경하여 _onSubscriptionRequested 콜백에서 새로운 상태를 반영.
   */
  void _onLogoutPressed(
    AuthenticationLogoutPressed event,
    Emitter<AuthenticationState> emit,
  ) {
    _authenticationRepository.logOut();
  }

  /*
    비동기로 사용자 정보를 가져온다.
    정상적으로 데이터를 받으면 user 객체 반환
    예외 발새앟면 null을 리턴하여 사용자 정보 조회 실패를 나타낸다.
   */
  Future<User?> _tryGetUser() async {
    try {
      final user = await _userRepository.getUser();
      return user;
    } catch (_) {
      return null;
    }
  }
}
