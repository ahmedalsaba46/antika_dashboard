import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/user_model.dart';
import '../providers/user.dart';
import '../widgets/user_control_card.dart';

class UserControlScreen extends ConsumerStatefulWidget {
  const UserControlScreen({super.key});

  @override
  ConsumerState<UserControlScreen> createState() => _UserControlScreenState();
}

class _UserControlScreenState extends ConsumerState<UserControlScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedAction = 'all'; // all, blocked, active

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(userProvider);
    final filteredUsers = userAsync.maybeWhen(
      data:
          (users) => _filterUsersByStatus(
            (users ?? [])
                .where(
                  (u) =>
                      (u.status == 0 || u.status == 1) && u.appRole != 'admin',
                )
                .toList(),
          ),
      orElse: () => <UserModel>[],
    );

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'التحكم بالمستخدمين', // User Control
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF2C3E50),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {});
            },
            icon: const Icon(Icons.refresh, color: Colors.white),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and Filter Section
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Search Bar
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText:
                        'ابحث عن المستخدمين للحظر/إلغاء الحظر...', // Search users to block/unblock
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon:
                        _searchController.text.isNotEmpty
                            ? IconButton(
                              onPressed: () {
                                _searchController.clear();
                                _filterUsers();
                              },
                              icon: const Icon(Icons.clear),
                            )
                            : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF2C3E50)),
                    ),
                  ),
                  onChanged: (value) {
                    _filterUsers();
                  },
                ),
                const SizedBox(height: 16),

                // Status Filter
                Row(
                  children: [
                    const Text(
                      'تصفية حسب الحالة:', // Filter by Status
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: SegmentedButton<String>(
                        segments: const [
                          ButtonSegment(value: 'all', label: Text('الكل')),
                          ButtonSegment(value: 'active', label: Text('نشط')),
                          ButtonSegment(value: 'blocked', label: Text('محظور')),
                        ],
                        selected: {_selectedAction},
                        onSelectionChanged: (value) {
                          setState(() {
                            _selectedAction = value.first;
                          });
                          _filterUsers();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Users List
          Expanded(
            child:
                filteredUsers.isEmpty
                    ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.security, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            'لا يوجد مستخدمون', // No users found
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                    : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: filteredUsers.length,
                      separatorBuilder:
                          (context, index) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final user = filteredUsers[index];
                        return UserControlCard(
                          user: user,
                          onBlock: () => _blockUser(user),
                          onUnblock: () => _unblockUser(user),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }

  List<UserModel> _filterUsersByStatus(List<UserModel> users) {
    // Apply status filter and search
    List<UserModel> filtered = users;
    if (_selectedAction == 'active') {
      filtered = filtered.where((user) => user.status == 0).toList();
    } else if (_selectedAction == 'blocked') {
      filtered = filtered.where((user) => user.status == 1).toList();
    }
    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      filtered =
          filtered
              .where(
                (user) =>
                    user.userName.toLowerCase().contains(query) ||
                    user.email.toLowerCase().contains(query),
              )
              .toList();
    }
    return filtered;
  }

  void _filterUsers() {
    setState(() {}); // Just refresh UI for local data
  }

  void _blockUser(UserModel user) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('حظر المستخدم'), // Block User
            content: Text('هل أنت متأكد أنك تريد حظر ${user.userName}?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('إلغاء'), // Cancel
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  await ref.read(userProvider.notifier).updateUser(user.id, {
                    'status': 1,
                  });
                  ref.invalidate(userProvider); // Refresh users after block
                  showDialog(
                    context: context,
                    builder:
                        (ctx) => AlertDialog(
                          title: const Text('تم حظر المستخدم'), // User Blocked
                          content: Text(
                            '${user.userName} تم حظره.',
                          ), // has been blocked
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(ctx).pop(),
                              child: const Text('حسناً'), // OK
                            ),
                          ],
                        ),
                  );
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('حظر'), // Block
              ),
            ],
          ),
    );
  }

  void _unblockUser(UserModel user) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('إلغاء حظر المستخدم'), // Unblock User
            content: Text('هل أنت متأكد أنك تريد إلغاء حظر ${user.userName}?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text('إلغاء'), // Cancel
              ),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: const Text('إلغاء الحظر'), // Unblock
              ),
            ],
          ),
    );
    if (confirmed == true) {
      await ref.read(userProvider.notifier).updateUser(user.id, {'status': 0});
      ref.invalidate(userProvider); // Refresh users after unblock
      showDialog(
        context: context,
        builder:
            (ctx) => AlertDialog(
              title: const Text('تم إلغاء حظر المستخدم'), // User Unblocked
              content: Text(
                '${user.userName} تم إلغاء حظره.',
              ), // has been unblocked
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('حسناً'), // OK
                ),
              ],
            ),
      );
    }
  }
}
