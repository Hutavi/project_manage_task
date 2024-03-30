import 'package:equatable/equatable.dart';

class AuthenticateState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthenticateLoading extends AuthenticateState {}

class AuthenticateSuccess extends AuthenticateState {}

class AuthenticateFailure extends AuthenticateState {}

class Authenticated extends AuthenticateState {}
