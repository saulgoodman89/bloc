import 'package:equatable/equatable.dart';

final class Post extends Equatable {
  const Post({required this.id, required this.title, required this.body});

  final int id;
  final String title;
  final String body;

  /*
    클래스 , 인스턴스간 동등성 비교를 위해 id , title , body 속성을 사용.
    두 객체의 id , title , body의 속성값이 모두 같으면 두 객체는 같은 객체로 판단.
    메모리가 아닌 props의 getter 속성 값을 기준으로만 비교.
   */
  @override
  List<Object> get props => [id, title, body];
}
