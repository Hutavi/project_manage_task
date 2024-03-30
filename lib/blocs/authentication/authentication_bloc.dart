import 'package:bloc/bloc.dart';
import 'package:management_app/blocs/authentication/authentication_event.dart';

import 'authentication_state.dart';

class AuthenticateBloc extends Bloc<AuthenticateEvent, AuthenticateState> {
  AuthenticateBloc() : super(AuthenticateLoading()) {
    on<CheckAuthenticated>(checkAuthenticated);
  }

  Future<void> checkAuthenticated(
      CheckAuthenticated event, Emitter<AuthenticateState> emit) async {
    emit(AuthenticateLoading());

    await Future.delayed(const Duration(seconds: 2));

    // Thực hiện chuyển trang sau 10 giây.
    // Trong ví dụ này, chúng tôi giả định rằng sau 10 giây, người dùng được xem như đã xác thực.
    // Bạn nên thay đổi phần này để phù hợp với logic xác thực thực tế của bạn.
    emit(Authenticated());
  }
}
