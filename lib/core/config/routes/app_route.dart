import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../features/login/domain/entities/user_entity.dart';
import '../../../features/login/presentation/pages/login_page.dart';
import '../../../features/products/presentation/pages/product_listing_page.dart';
import '../../../features/profile/presentation/pages/profile_page.dart';
import 'route_path.dart';

class AppRoute {
  static final rootNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter _routerX = GoRouter(
    initialLocation: RoutePath.loginPagePath,
    navigatorKey: rootNavigatorKey,
    debugLogDiagnostics: true,
    routes: [
      // ── Login ─────────────────────────────────────────────────────────
      GoRoute(
        name: RoutePath.loginPage,
        path: RoutePath.loginPagePath,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: LoginPage()),
      ),

      // ── Product Listing (after login) ─────────────────────────────────
      GoRoute(
        name: RoutePath.productListingPage,
        path: RoutePath.productListingPagePath,
        pageBuilder: (context, state) {
          final user = state.extra as UserEntity;
          return NoTransitionPage(child: ProductListingPage(user: user));
        },
      ),

      // ── Profile ───────────────────────────────────────────────────────
      GoRoute(
        name: RoutePath.profilePage,
        path: RoutePath.profilePagePath,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: ProfilePage()),
      ),
    ],
    errorBuilder: (context, state) =>
        const Scaffold(body: Center(child: Text("Something went wrong"))),
  );

  static GoRouter get router => _routerX;
}
