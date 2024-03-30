import 'package:equatable/equatable.dart';

class UserInfoState extends Equatable {
  final String username;
  final String isLogin;
  final String access_token;
  UserInfoState({
    required this.username,
    required this.isLogin,
    required this.access_token,
  });

  UserInfoState update({
    String? phone,
    String? email,
    String? isLogin,
    String? access_token,
  }) {
    return UserInfoState(
      username: email ?? this.username,
      isLogin: isLogin ?? this.isLogin,
      access_token: access_token ?? this.access_token,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [username, isLogin, access_token];
}
