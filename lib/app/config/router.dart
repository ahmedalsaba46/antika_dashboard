import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/dashboard/presentation/screens/user_management_screen.dart';
import '../../features/dashboard/presentation/screens/seller_approval_screen.dart';
import '../../features/dashboard/presentation/screens/antique_management_screen.dart';
import '../../features/dashboard/presentation/screens/user_control_screen.dart';
import '../../features/dashboard/presentation/screens/category_management_screen.dart';
import '../../features/dashboard/authentication/presentation/pages/login_page.dart';
import '../../features/dashboard/authentication/providers/auth_provider.dart';

final rootnavigationKey = GlobalKey<NavigatorState>();

// Router configuration with authentication
GoRouter createRouter(WidgetRef ref) {
  return GoRouter(
    navigatorKey: rootnavigationKey,
    debugLogDiagnostics: true,
    initialLocation: '/',
    redirect: (context, state) {
      final isAuthenticated = ref.watch(isAuthenticatedProvider);
      final isLoggingIn = state.uri.path == '/login';

      // If not authenticated and not already on login page, redirect to login
      if (!isAuthenticated && !isLoggingIn) {
        return '/login';
      }

      // If authenticated and on login page, redirect to dashboard
      if (isAuthenticated && isLoggingIn) {
        return '/';
      }

      // No redirect needed
      return null;
    },
    routes: [
      // Authentication Route
      GoRoute(
        path: '/login',
        name: 'login',
        pageBuilder:
            (context, state) => const NoTransitionPage(child: LoginPage()),
      ),

      // Dashboard Routes (Protected)
      GoRoute(
        path: '/',
        name: 'dashboard',
        pageBuilder:
            (context, state) =>
                const NoTransitionPage(child: DashboardScreen()),
      ),
      GoRoute(
        path: '/dashboard/users',
        name: 'user-management',
        pageBuilder:
            (context, state) =>
                const NoTransitionPage(child: UserManagementScreen()),
      ),
      GoRoute(
        path: '/dashboard/sellers',
        name: 'seller-approval',
        pageBuilder:
            (context, state) =>
                const NoTransitionPage(child: SellerApprovalScreen()),
      ),
      GoRoute(
        path: '/dashboard/antiques',
        name: 'antique-management',
        pageBuilder:
            (context, state) =>
                const NoTransitionPage(child: AntiqueManagementScreen()),
      ),
      GoRoute(
        path: '/dashboard/user-control',
        name: 'user-control',
        pageBuilder:
            (context, state) =>
                const NoTransitionPage(child: UserControlScreen()),
      ),
      GoRoute(
        path: '/dashboard/categories',
        name: 'category-management',
        pageBuilder:
            (context, state) =>
                const NoTransitionPage(child: CategoryManagementScreen()),
      ),
    ],
  );
}

// Simple router with authentication logic
final goRoute = GoRouter(
  navigatorKey: rootnavigationKey,
  debugLogDiagnostics: true,
  initialLocation: '/login',
  routes: [
    // Authentication Route
    GoRoute(
      path: '/login',
      name: 'login',
      pageBuilder:
          (context, state) => const NoTransitionPage(child: LoginPage()),
    ),

    // Dashboard Routes
    GoRoute(
      path: '/',
      name: 'dashboard',
      pageBuilder:
          (context, state) => const NoTransitionPage(child: DashboardScreen()),
    ),
    GoRoute(
      path: '/dashboard/users',
      name: 'user-management',
      pageBuilder:
          (context, state) =>
              const NoTransitionPage(child: UserManagementScreen()),
    ),
    GoRoute(
      path: '/dashboard/sellers',
      name: 'seller-approval',
      pageBuilder:
          (context, state) =>
              const NoTransitionPage(child: SellerApprovalScreen()),
    ),
    GoRoute(
      path: '/dashboard/antiques',
      name: 'antique-management',
      pageBuilder:
          (context, state) =>
              const NoTransitionPage(child: AntiqueManagementScreen()),
    ),
    GoRoute(
      path: '/dashboard/user-control',
      name: 'user-control',
      pageBuilder:
          (context, state) =>
              const NoTransitionPage(child: UserControlScreen()),
    ),
    GoRoute(
      path: '/dashboard/categories',
      name: 'category-management',
      pageBuilder:
          (context, state) =>
              const NoTransitionPage(child: CategoryManagementScreen()),
    ),
  ],
);
