import 'package:base_code/app/config/app_color.dart';
import 'package:base_code/app/config/router_name.dart';
import 'package:base_code/app/config/text_styles.dart';
import 'package:base_code/features/auth/bloc/auth_bloc.dart';
import 'package:base_code/features/auth/bloc/auth_event.dart';
import 'package:base_code/features/auth/bloc/auth_state.dart';
import 'package:base_code/features/auth/screen/widgets/custom_richtext.dart';
import 'package:base_code/utils/util.dart';
import 'package:base_code/utils/validations.dart';
import 'package:base_code/widgets/auth_base_screen.dart';
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

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _usernameCtr = TextEditingController();
  final _passwordCtr = TextEditingController();
  final _confirmPWCtr = TextEditingController();
  final _usernameFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmPWFocus = FocusNode();
  var validButton = false;

  @override
  void dispose() {
    _usernameCtr.dispose();
    _passwordCtr.dispose();
    _usernameFocus.dispose();
    _passwordFocus.dispose();
    _confirmPWCtr.dispose();
    _confirmPWFocus.dispose();
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

  @override
  Widget build(BuildContext context) {
    return AuthBaseScreen(
      indexScreen: 2,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoading) {
            showLoading();
          } else if (state is AuthSuccess) {
            hideLoading();
            context.go(RouterName.LoginView);
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16)
                      .copyWith(bottom: 200),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'register'.tr(),
                          style: TextStyles.large.copyWith(
                              fontSize: 40, fontWeight: FontWeight.w700),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 8, bottom: 35),
                          width: 100,
                          height: 2,
                          color: AppColor.colorMain,
                        ),
                        CustomTextField(
                          controller: _usernameCtr,
                          focusNode: _usernameFocus,
                          targetFocusNode: _passwordFocus,
                          leadingIcon: Icon(
                            Icons.account_circle,
                            color: AppColor.colorWelcome,
                          ),
                          label: 'username'.tr(),
                          onChanged: (value) => onValidButton(),
                          validator: (value) =>
                              Validations.isValidAccount(value),
                        ),
                        const SizedBox(height: 24),
                        CustomTextField(
                          controller: _passwordCtr,
                          focusNode: _passwordFocus,
                          targetFocusNode: _confirmPWFocus,
                          label: 'password'.tr(),
                          onChanged: (value) => onValidButton(),
                          leadingIcon: Icon(
                            Icons.key,
                            color: AppColor.colorWelcome,
                          ),
                          isPassword: true,
                          validator: (value) =>
                              Validations.isValidPassword(value),
                        ),
                        const SizedBox(height: 24),
                        CustomTextField(
                          controller: _confirmPWCtr,
                          focusNode: _confirmPWFocus,
                          isPassword: true,
                          label: 'confirm_password'.tr(),
                          onChanged: (value) => onValidButton(),
                          leadingIcon: Icon(
                            Icons.key,
                            color: AppColor.colorWelcome,
                          ),
                          onFieldSubmitted: (_) => _passwordFocus.unfocus,
                          validator: (value) => Validations.isValidConfirmPW(
                            value,
                            _passwordCtr.text.trim(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Column(
                    children: [
                      CustomButton(
                        onTap: validButton ? () => _register() : null,
                        label: 'register'.tr(),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: CustomRichText(
                          title: '${'have_account'.tr()} ',
                          subTitle: 'sign_in'.tr(),
                          onTap: () => context.go(RouterName.LoginView),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
