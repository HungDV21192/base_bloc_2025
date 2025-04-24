import 'package:base_code/app/config/router_name.dart';
import 'package:base_code/features/auth/screen/login_screen.dart';
import 'package:base_code/features/auth/screen/register_screen.dart';
import 'package:base_code/features/home/screen/home_screen.dart';
import 'package:base_code/features/slash_screen/screen/slash_screen.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: RouterName.SplashScreen,
    routes: [
      GoRoute(
          path: RouterName.SplashScreen,
          builder: (_, __) => const SlashScreen()),
      GoRoute(
          path: RouterName.RegisterView,
          builder: (_, __) => const RegisterScreen()),
      GoRoute(
          path: RouterName.LoginView, builder: (_, __) => const LoginScreen()),
      GoRoute(
          path: RouterName.HomeView, builder: (_, __) => const HomeScreen()),
    ],
  );
}
