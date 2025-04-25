import 'package:base_code/app/config/app_color.dart';
import 'package:base_code/app/config/router_name.dart';
import 'package:base_code/app/config/text_styles.dart';
import 'package:base_code/features/auth/bloc/auth_bloc.dart';
import 'package:base_code/features/auth/bloc/auth_event.dart';
import 'package:base_code/features/auth/bloc/auth_state.dart';
import 'package:base_code/utils/message.dart';
import 'package:base_code/utils/validations.dart';
import 'package:base_code/widgets/auth_base_screen.dart';
import 'package:base_code/widgets/custom_button.dart';
import 'package:base_code/widgets/custom_text_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
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
    return AuthBaseScreen(
      indexScreen: 1,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoading) {
            FlushBarServices.showSuccess('loading'.tr());
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
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextField(
                    controller: _usernameCtr,
                    focusNode: _usernameFocus,
                    targetFocusNode: _passwordFocus,
                    label: 'username'.tr(),
                    onChanged: (value) => onValidButton(),
                    validator: (value) => Validations.isValidAccount(value),
                  ),
                  CustomTextField(
                    controller: _passwordCtr,
                    focusNode: _passwordFocus,
                    label: 'password'.tr(),
                    onChanged: (value) => onValidButton(),
                    onFieldSubmitted: (_) => _passwordFocus.unfocus,
                    validator: (value) => Validations.isValidPassword(value),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.check_box, color: AppColor.colorMain),
                            const SizedBox(width: 8),
                            Text('remember_me'.tr(), style: TextStyles.medium),
                          ],
                        ),
                      ),
                      TextButton(
                        child: Text(
                          'forgot_password'.tr(),
                          style: TextStyles.medium.copyWith(
                            color: AppColor.colorMain,
                            decoration: TextDecoration.underline,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        onPressed: () {},
                      )
                    ],
                  ),
                  const SizedBox(height: 88),
                  CustomButton(
                    onTap: () => context.go(RouterName.LoginView),
                    label: 'register'.tr(),
                  ),
                  const SizedBox(height: 20),
                  _hasAccountWidget(
                    onTap: () => context.go(RouterName.LoginView),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  RichText _hasAccountWidget({required VoidCallback onTap}) {
    return RichText(
      text: TextSpan(
          text: '${'have_account'.tr()} ',
          style: TextStyles.medium,
          children: [
            TextSpan(
              text: 'sign_in'.tr(),
              style: TextStyles.medium.copyWith(color: AppColor.colorMain),
              recognizer: TapGestureRecognizer()..onTap = onTap,
            ),
          ]),
    );
  }
}
