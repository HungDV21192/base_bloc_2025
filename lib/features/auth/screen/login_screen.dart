import 'dart:async';

import 'package:base_code/app/config/app_color.dart';
import 'package:base_code/app/config/constant.dart';
import 'package:base_code/app/config/router_name.dart';
import 'package:base_code/app/config/text_styles.dart';
import 'package:base_code/app/env/env_controller.dart';
import 'package:base_code/features/auth/bloc/auth_bloc.dart';
import 'package:base_code/features/auth/bloc/auth_event.dart';
import 'package:base_code/features/auth/bloc/auth_state.dart';
import 'package:base_code/features/auth/bloc/remember_me_cubit.dart';
import 'package:base_code/features/auth/screen/widgets/custom_richtext.dart';
import 'package:base_code/utils/message.dart';
import 'package:base_code/utils/util.dart';
import 'package:base_code/utils/validations.dart';
import 'package:base_code/widgets/auth_base_screen.dart';
import 'package:base_code/widgets/custom_button.dart';
import 'package:base_code/widgets/custom_text_field.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameCtr = TextEditingController();
  final _passwordCtr = TextEditingController();
  final _usernameFocus = FocusNode();
  final _passwordFocus = FocusNode();
  var validButton = ValueNotifier<bool>(false);
  final _formKey = GlobalKey<FormState>();
  var isSaveAccount = false;
  final envController = EnvController();

  Future<void> _loadUserData() async {
    const storage = FlutterSecureStorage();
    final userName = await storage.read(key: StorageKey.USERNAME);
    final password = await storage.read(key: StorageKey.PASSWORD);
    isSaveAccount = (userName ?? '').isNotEmpty && (password ?? '').isNotEmpty;
  }

  @override
  void dispose() {
    _usernameCtr.dispose();
    _passwordCtr.dispose();
    _usernameFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  void onValidButton() {
    validButton.value = _formKey.currentState?.validate() ?? false;
  }

  void _login() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
            LoginEvent(_usernameCtr.text, _passwordCtr.text, isSaveAccount),
          );
    }
  }

  @override
  void initState() {
    StreamSubscription<List<ConnectivityResult>> subscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      if (result.contains(ConnectivityResult.none)) {
        FlushBarServices.showWarning('no_internet'.tr());
      }
    });
    _loadUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AuthBaseScreen(
      indexScreen: 2,
      body: BlocProvider(
        create: (_) => RememberMeCubit(),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthLoading) {
              showLoading();
            } else if (state is AuthSuccess) {
              hideLoading();
              context.go(RouterName.homeView);
            }
          },
          builder: (context, state) {
            return Stack(
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
                        CustomTextField(
                          controller: _passwordCtr,
                          focusNode: _passwordFocus,
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
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            BlocBuilder<RememberMeCubit, bool>(
                              builder: (context, isChecked) {
                                isSaveAccount = isChecked;
                                return TextButton(
                                  onPressed: () =>
                                      context.read<RememberMeCubit>().toggle(),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        isChecked
                                            ? Icons.check_box
                                            : Icons.check_box_outline_blank,
                                        color: AppColor.colorMain,
                                      ),
                                      const SizedBox(width: 8),
                                      Text('remember_me'.tr(),
                                          style: TextStyles.medium),
                                    ],
                                  ),
                                );
                              },
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
                      ValueListenableBuilder<bool>(
                          valueListenable: validButton,
                          builder: (context, isValid, _) {
                            return CustomButton(
                              onTap: validButton.value ? () => _login() : null,
                              label: 'sign_in'.tr(),
                            );
                          }),
                      const SizedBox(height: 20),
                      Center(
                        child: CustomRichText(
                          title: '${'no_account'.tr()} ',
                          subTitle: 'register'.tr(),
                          onTap: () => context.go(RouterName.registerView),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
      floatACBT: InkWell(
        onLongPress: () => envController.toggleEnvironment(),
        child: Image.asset(
          ImageAssets.lg_cpn,
          width: 50,
          height: 50,
        ),
      ),
    );

    // CustomScreen(
    //   titleAppBar: 'sign_in'.tr(),
    //   body: BlocConsumer<AuthBloc, AuthState>(
    //     listener: (context, state) {
    //       if (state is AuthSuccess) context.go('/home');
    //     },
    //     builder: (context, state) {
    //       return Padding(
    //         padding: const EdgeInsets.all(16),
    //         child: Column(
    //           children: [
    //             TextField(
    //                 controller: _usernameCtr,
    //                 decoration: InputDecoration(labelText: "username".tr())),
    //             TextField(
    //                 controller: _passwordCtr,
    //                 decoration: InputDecoration(labelText: "password".tr()),
    //                 obscureText: true),
    //             const SizedBox(height: 20),
    //             CustomButton(
    //               label: 'sign_in'.tr(),
    //               onTap: () {
    //                 context.read<AuthBloc>().add(
    //                       LoginEvent(_usernameCtr.text, _passwordCtr.text),
    //                     );
    //               },
    //             )
    //           ],
    //         ),
    //       );
    //     },
    //   ),
    // );
  }
}
