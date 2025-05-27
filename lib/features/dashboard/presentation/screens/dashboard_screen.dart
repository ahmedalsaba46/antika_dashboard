import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/user.dart';
import '../providers/antique.dart';
import '../widgets/dashboard_stats_card.dart';
import '../widgets/dashboard_navigation_card.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider);
    final antiqueAsync = ref.watch(antiqueProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'لوحة تحكم المدير', // Admin Dashboard
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF2C3E50),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              ref.invalidate(userProvider);
            },
            icon: const Icon(Icons.refresh, color: Colors.white),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(userProvider);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'نظرة عامة على اللوحة', // Dashboard Overview
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E50),
                ),
              ),
              const SizedBox(height: 20),

              userAsync.when(
                data: (users) {
                  if (users == null || users.isEmpty) {
                    return const Center(
                      child: Text('لا يوجد مستخدمون.'),
                    ); // No users found
                  }
                  final totalUsers = users.length;
                  final activeUsers = users.where((u) => u.status == 0).length;
                  final blockedUsers = users.where((u) => u.status == 1).length;
                  final pendingUsers = users.where((u) => u.status == 2).length;
                  return antiqueAsync.when(
                    data: (antiques) {
                      final pendingAntiques =
                          (antiques ?? []).where((a) => a.status == 2).length;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildStatsGrid({
                            'totalUsers': totalUsers,
                            'activeUsers': activeUsers,
                            'blockedUsers': blockedUsers,
                            'pendingUsers': pendingUsers,
                            'pendingAntiques': pendingAntiques,
                          }),
                          const SizedBox(height: 20),
                        ],
                      );
                    },
                    loading:
                        () => const Center(child: CircularProgressIndicator()),
                    error:
                        (error, stack) => Center(
                          child: Text(
                            'حدث خطأ أثناء تحميل التحف: $error',
                          ), // Error loading antiques
                        ),
                  );
                },
                error:
                    (error, stack) => Center(
                      child: Text(
                        'حدث خطأ أثناء تحميل معلومات المستخدم: $error',
                      ),
                    ), // Error loading user info
                loading: () => const Center(child: CircularProgressIndicator()),
              ),

              const Text(
                'إجراءات سريعة', // Quick Actions
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E50),
                ),
              ),
              const SizedBox(height: 16),

              // Navigation Cards
              _buildNavigationGrid(context),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                icon: const Icon(Icons.category),
                label: const Text('إدارة التصنيفات'), // Manage Categories
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () => context.push('/dashboard/categories'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsGrid(Map<String, int?> stats) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 1.2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        DashboardStatsCard(
          title: 'إجمالي المستخدمين', // Total Users
          value: stats['totalUsers']?.toString() ?? '0',
          icon: Icons.people,
          color: Colors.blue,
        ),
        DashboardStatsCard(
          title: 'المستخدمون النشطون', // Active Users
          value: stats['activeUsers']?.toString() ?? '0',
          icon: Icons.check_circle,
          color: Colors.green,
        ),
        DashboardStatsCard(
          title: 'البائعون قيد الانتظار', // Pending Sellers
          value: stats['pendingUsers']?.toString() ?? '0',
          icon: Icons.pending_actions,
          color: Colors.orange,
        ),
        DashboardStatsCard(
          title: 'التحف قيد الانتظار', // Pending Antiques
          value: stats['pendingAntiques']?.toString() ?? '0',
          icon: Icons.pending,
          color: Colors.purple,
        ),
      ],
    );
  }

  Widget _buildNavigationGrid(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 0.9,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        DashboardNavigationCard(
          title: 'إدارة الموظفين', // User Management
          description:
              'إدارة جميع المدراء', // Manage all users, admins and sellers
          icon: Icons.manage_accounts,
          color: Colors.blue,
          onTap: () => context.push('/dashboard/users'),
        ),
        DashboardNavigationCard(
          title: 'موافقة البائعين', // Seller Approval
          description:
              'مراجعة والموافقة على حسابات البائعين', // Review and approve seller accounts
          icon: Icons.person_add,
          color: Colors.green,
          onTap: () => context.push('/dashboard/sellers'),
        ),
        DashboardNavigationCard(
          title: 'إدارة التحف', // Antique Management
          description:
              'مراجعة وإدارة قوائم التحف', // Review and manage antique listings
          icon: Icons.inventory,
          color: Colors.purple,
          onTap: () => context.push('/dashboard/antiques'),
        ),
        DashboardNavigationCard(
          title: 'التحكم بالمستخدمين', // User Control
          description:
              'حظر/إلغاء حظر المستخدمين والبحث', // Block/unblock users and search
          icon: Icons.security,
          color: Colors.red,
          onTap: () => context.push('/dashboard/user-control'),
        ),
      ],
    );
  }
}
