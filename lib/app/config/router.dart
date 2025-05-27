import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/dashboard/presentation/screens/user_management_screen.dart';
import '../../features/dashboard/presentation/screens/seller_approval_screen.dart';
import '../../features/dashboard/presentation/screens/antique_management_screen.dart';
import '../../features/dashboard/presentation/screens/user_control_screen.dart';
import '../../features/dashboard/presentation/screens/category_management_screen.dart';

final rootnavigationKey = GlobalKey<NavigatorState>();
GoRouter goRoute = GoRouter(
  navigatorKey: rootnavigationKey,
  debugLogDiagnostics: true,
  initialLocation: '/',
  routes: [
    // Dashboard Routes (Not in bottom navigation)
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

    // Bottom Navigation Routes
  ],
);
