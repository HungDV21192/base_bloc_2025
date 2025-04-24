import 'package:base_code/app/config/router_name.dart';
import 'package:base_code/app/utils/message.dart';
import 'package:base_code/app/utils/validations.dart';
import 'package:base_code/features/auth/bloc/auth_bloc.dart';
import 'package:base_code/features/auth/bloc/auth_event.dart';
import 'package:base_code/features/auth/bloc/auth_state.dart';
import 'package:base_code/widgets/custom_button.dart';
import 'package:base_code/widgets/custom_text_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameCtr = TextEditingController();
  final _passwordCtr = TextEditingController();
  final _usernameFocus = FocusNode();
  final _passwordFocus = FocusNode();
  var validButton = false;

  @override
  void dispose() {
    _usernameCtr.dispose();
    _passwordCtr.dispose();
    _usernameFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  void onValidButton() {
    setState(() {
      validButton = _formKey.currentState?.validate() ?? false;
    });
  }

  void _register() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
            RegisterEvent(_usernameCtr.text, _passwordCtr.text),
          );
    }
  }

  void hideKeyboard(BuildContext context) {
    final currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      currentFocus.focusedChild!.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;

        // Tùy chọn: hiển thị cảnh báo hoặc xác nhận
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Xác nhận'),
            content: Text('Bạn có chắc muốn thoát không?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(), // Đóng dialog
                child: Text('Không'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context)
                    ..pop() // đóng dialog
                    ..pop(); // thoát màn hình
                },
                child: Text('Có'),
              ),
            ],
          ),
        );
      },
      child: GestureDetector(
        onTap: () => hideKeyboard(context),
        child: Scaffold(
          appBar: AppBar(title: Text('register'.tr())),
          body: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthLoading) {
                FlushBarServices.showSuccess('Loading');
              } else if (state is AuthSuccess) {
                context.go(RouterName.LoginView);
              }
            },
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: _usernameCtr,
                        focusNode: _usernameFocus,
                        targetFocusNode: _passwordFocus,
                        label: 'username'.tr(),
                        onChanged: (value) => onValidButton(),
                        validator: (value) => validateUsername(value),
                      ),
                      CustomTextField(
                        controller: _passwordCtr,
                        focusNode: _passwordFocus,
                        label: 'password'.tr(),
                        onChanged: (value) => onValidButton(),
                        onFieldSubmitted: (_) => _passwordFocus.unfocus,
                        validator: (value) => validatePassword(value),
                      ),
                      const SizedBox(height: 20),
                      CustomButton(
                        onTap: validButton ? _register : null,
                        label: 'register'.tr(),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
