import 'package:base_code/app/config/app_color.dart';
import 'package:base_code/app/config/app_router.dart';
import 'package:base_code/app/config/app_themes.dart';
import 'package:base_code/di/injection.dart';
import 'package:base_code/features/auth/bloc/auth_bloc.dart';
import 'package:base_code/features/home/bloc/home_bloc.dart';
import 'package:base_code/features/settings/settings_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  Future.delayed(const Duration(milliseconds: 500), () async {
    FlutterNativeSplash.remove();
  });
  await EasyLocalization.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );
  _configLoading();
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
  const MyApp({super.key});

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
        builder: EasyLoading.init(
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: const TextScaler.linear(1.0)),
              child: child!,
            );
          },
        ),
      );
    });
  }
}

void _configLoading() {
  EasyLoading.instance
    ..maskType = EasyLoadingMaskType.none
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorType = EasyLoadingIndicatorType.circle
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..displayDuration = const Duration(seconds: 2)
    ..backgroundColor = Colors.transparent
    ..progressColor = Colors.transparent
    ..indicatorColor = Colors.transparent
    ..boxShadow = <BoxShadow>[]
    ..contentPadding = EdgeInsets.zero
    ..textColor = Colors.red
    ..maskColor = Colors.red
    ..indicatorWidget = LoadingAnimationWidget.threeArchedCircle(
      color: AppColor.colorMain,
      size: 50,
    );
}
