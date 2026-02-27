import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zavi_soft_task/features/cart.dart';
import 'package:zavi_soft_task/features/chat.dart';
import '../../../features/login/domain/entities/user_entity.dart';
import '../../../features/login/presentation/pages/login_page.dart';
import '../../../features/main/presentation/pages/main_page.dart';
import '../../../features/products/presentation/pages/product_listing_page.dart';
import '../../../features/profile/presentation/pages/profile_page.dart';
import 'route_path.dart';

class AppRoute {
  static final rootNavigatorKey = GlobalKey<NavigatorState>();

  static final _homeNavigatorKey = GlobalKey<NavigatorState>();
  static final _attendanceNavigatorKey = GlobalKey<NavigatorState>();
  static final _chatNavigatorKey = GlobalKey<NavigatorState>();
  static final _profileNavigatorKey = GlobalKey<NavigatorState>();
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


      //
      // // ── Profile ───────────────────────────────────────────────────────
      // GoRoute(
      //   name: RoutePath.profilePage,
      //   path: RoutePath.profilePagePath,
      //   pageBuilder: (context, state) =>
      //       const NoTransitionPage(child: ProfilePage()),
      // ),

      // ///main page route
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          // the UI shell
          return MainPage(navigationShell: navigationShell);
        },
        branches: [
          ///Home branch
          StatefulShellBranch(
            initialLocation: RoutePath.mainPagePath,
            navigatorKey: _homeNavigatorKey,
            routes: [
              // top route inside branch
              // ── Product Listing (after login) ─────────────────────────────────
              GoRoute(
                name: RoutePath.mainPage,
                path: RoutePath.mainPagePath,
                pageBuilder: (context, state) {
                  final user = state.extra as UserEntity;
                  return NoTransitionPage(child: ProductListingPage(user: user));
                },
              ),

            ],
          ),

          ////Chat branch
          StatefulShellBranch(
            initialLocation: RoutePath.attendancePagePath,
            navigatorKey: _attendanceNavigatorKey,
            routes: [
              // top route inside branch
              GoRoute(
                name: RoutePath.attendancePage,
                path: RoutePath.attendancePagePath,
                pageBuilder: (context, state) =>
                    NoTransitionPage(child: Cart()),
              ),
            ],
          ),

          //order
          StatefulShellBranch(
            initialLocation: RoutePath.chatPagePath,
            navigatorKey: _chatNavigatorKey,
            routes: [
              // top route inside branch
              GoRoute(
                name: RoutePath.chatPage,
                path: RoutePath.chatPagePath,
                pageBuilder: (context, state) =>
                    NoTransitionPage(child: Chat()),
              ),
            ],
          ),

          ///Profile branch
          StatefulShellBranch(
            initialLocation: RoutePath.profilePagePath,
            navigatorKey: _profileNavigatorKey,
            routes: [
              // top route inside branch
              GoRoute(
                name: RoutePath.profilePage,
                path: RoutePath.profilePagePath,
                pageBuilder: (context, state) =>
                    NoTransitionPage(child: ProfilePage()),
              ),
            ],
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) =>
        const Scaffold(body: Center(child: Text("Something went wrong"))),
  );

  static GoRouter get router => _routerX;
}
