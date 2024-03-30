import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/authentication/authentication_bloc.dart';
import '../../blocs/authentication/authentication_event.dart';
import '../../blocs/authentication/authentication_state.dart';
import 'package:management_app/navigation/navigation.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: MultiBlocProvider(
          providers: [
            BlocProvider<AuthenticateBloc>(
              create: (BuildContext context) =>
                  AuthenticateBloc()..add(CheckAuthenticated()),
            ),
          ],
          child: BlocBuilder<AuthenticateBloc, AuthenticateState>(
            builder: (context, state) {
              if (state is Authenticated) {
                return const NavigationBottom();
              } else {
                return Center(
                  child: Image.asset(
                    'lib/assets/images/splash/splashpage.png',
                    fit: BoxFit.fitWidth,
                  ),
                );
              }
            },
          )),
    );
  }
}
