part of 'profile_wizard_bloc.dart';

sealed class ProfileWizardEvent extends Equatable {
  const ProfileWizardEvent();

  @override
  List<Object?> get props => [];
}

/*
  이름을 입력받는 이벤트
 */
final class ProfileWizardNameSubmitted extends ProfileWizardEvent {
  const ProfileWizardNameSubmitted(this.name);

  final String name;

  @override
  List<Object> get props => [name];
}

/*
  이름을 입력받는 이벤트
 */
final class ProfileWizardAgeSubmitted extends ProfileWizardEvent {
  const ProfileWizardAgeSubmitted(this.age);

  final int? age;

  @override
  List<Object?> get props => [age];
}
