import 'package:base_code/features/auth/bloc/auth_bloc.dart';
import 'package:base_code/features/auth/bloc/auth_event.dart';
import 'package:base_code/features/auth/bloc/auth_state.dart';
import 'package:base_code/widgets/custom_button.dart';
import 'package:base_code/widgets/custom_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameCtr = TextEditingController();

  final _passwordCtr = TextEditingController();

  @override
  void dispose() {
    _usernameCtr.dispose();
    _passwordCtr.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // StreamSubscription<List<ConnectivityResult>> subscription = Connectivity()
    //     .onConnectivityChanged
    //     .listen((List<ConnectivityResult> result) {
    //   if (result.contains(ConnectivityResult.none)) {
    //     FlushBarServices.showWarning('Không có kết nối mạng');
    //   }
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScreen(
      titleAppBar: 'sign_in'.tr(),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) context.go('/home');
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                    controller: _usernameCtr,
                    decoration: InputDecoration(labelText: "username".tr())),
                TextField(
                    controller: _passwordCtr,
                    decoration: InputDecoration(labelText: "password".tr()),
                    obscureText: true),
                const SizedBox(height: 20),
                CustomButton(
                  label: 'sign_in'.tr(),
                  onTap: () {
                    context.read<AuthBloc>().add(
                          LoginEvent(_usernameCtr.text, _passwordCtr.text),
                        );
                  },
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
