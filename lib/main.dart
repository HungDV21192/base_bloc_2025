import 'package:base_code/app/config/app_config.dart';
import 'package:base_code/app/config/app_router.dart';
import 'package:base_code/app/config/app_themes.dart';
import 'package:base_code/di/injection.dart';
import 'package:base_code/features/auth/bloc/auth_bloc.dart';
import 'package:base_code/features/home/bloc/home_bloc.dart';
import 'package:base_code/features/settings/settings_cubit.dart';
import 'package:base_code/widgets/custom_animation.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  Future.delayed(const Duration(milliseconds: 500), () async {
    FlutterNativeSplash.remove();
  });
  await EasyLocalization.ensureInitialized();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc(authRepo)),
        BlocProvider(create: (_) => HomeBloc(homeRepo)),
        BlocProvider(create: (_) => SettingsCubit()),
      ],
      child: EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('vi')],
        path: 'lib/l10n',
        fallbackLocale: const Locale('vi'),
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.config});

  final AppConfig? config;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(builder: (context, state) {
      return MaterialApp.router(
        key: ValueKey("${state.locale.languageCode}_${state.themeMode.name}"),
        debugShowCheckedModeBanner: false,
        theme: AppThemes.lightTheme,
        darkTheme: AppThemes.darkTheme,
        themeMode: state.themeMode,
        routerConfig: AppRouter.router,
        locale: state.locale,
        supportedLocales: context.supportedLocales,
        localizationsDelegates: context.localizationDelegates,
      );
    });
  }
}

void configLoading({required String branch}) {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.ring
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.transparent
    // ..indicatorColor = (branch == 'VNI') ? AppColors.mainColorVNI : AppColors.mainColorBSH
    ..textColor = Colors.yellow
    ..maskType = EasyLoadingMaskType.black
    ..userInteractions = false
    ..dismissOnTap = false
    ..boxShadow = <BoxShadow>[]
    ..customAnimation = CustomAnimation();
}
