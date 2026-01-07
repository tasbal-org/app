import 'package:go_router/go_router.dart';
import 'package:qrino_admin/src/features/auth/presentation/screens/login_screen.dart';

final GoRouter router = GoRouter(
	initialLocation: '/login',
	routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => LoginScreen(),
    ),
	],
);