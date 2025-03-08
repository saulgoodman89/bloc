import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'profile_wizard_event.dart';
part 'profile_wizard_state.dart';

class ProfileWizardBloc extends Bloc<ProfileWizardEvent, ProfileWizardState> {
  ProfileWizardBloc() : super(ProfileWizardState.initial()) {
    /*
        copyWith을 이용해
        기존 프로필 객체에서 name만 event.name 으로 변경한 새로훈 객체를 반환
     */
    on<ProfileWizardNameSubmitted>((event, emit) {
      emit(state.copyWith(profile: state.profile.copyWith(name: event.name)));
    });

    on<ProfileWizardAgeSubmitted>((event, emit) {
      emit(state.copyWith(profile: state.profile.copyWith(age: event.age)));
    });
  }
}
