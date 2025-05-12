import 'package:base_code/app/config/router_name.dart';
import 'package:base_code/features/auth/screen/login_screen.dart';
import 'package:base_code/features/auth/screen/register_screen.dart';
import 'package:base_code/features/home/screen/home_screen.dart';
import 'package:base_code/features/settings/settings_screen.dart';
import 'package:base_code/features/splash_screen/screen/splash_screen.dart';
import 'package:base_code/main.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: RouterName.splashScreen,
    navigatorKey: navigatorKey,
    routes: [
      GoRoute(
          path: RouterName.splashScreen,
          builder: (_, __) => const SplashScreen()),
      GoRoute(
          path: RouterName.registerView,
          builder: (_, __) => const RegisterScreen()),
      GoRoute(
          path: RouterName.loginView, builder: (_, __) => const LoginScreen()),
      GoRoute(
          path: RouterName.homeView, builder: (_, __) => const HomeScreen()),
      GoRoute(
          path: RouterName.settings,
          builder: (_, __) => const SettingsScreen()),
      //Todo: Ví dụ cho việc data số qua constructor của màn hình
      // Tại màn hình chuyển gọi context.go('/detail', extra: product); hoặc context.push('/detail', extra: product);
      // GoRoute(
      //   path: '/detail',
      //   builder: (context, state) {
      //     final product = state.extra as Product;
      //     return DetailPage(product: product);
      //   },
      // ),
    ],
  );
}
