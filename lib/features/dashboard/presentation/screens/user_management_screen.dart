import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/user_model.dart';
import '../providers/user.dart';
import '../widgets/user_list_tile.dart';

class UserManagementScreen extends ConsumerStatefulWidget {
  const UserManagementScreen({super.key});

  @override
  ConsumerState<UserManagementScreen> createState() =>
      _UserManagementScreenState();
}

class _UserManagementScreenState extends ConsumerState<UserManagementScreen> {
  String? selectedRole;
  String searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(userProvider);
    final userNotifier = ref.read(userProvider.notifier);

    return userAsync.when(
      data: (users) {
        // Only show admins
        final admins = (users ?? []).where((u) => u.appRole == 0).toList();
        print('Admins: ${admins.length}'); // Debugging line
        if (admins.isEmpty) {
          return const Center(child: Text('لا يوجد مدراء.'));
        }
        return Scaffold(
          backgroundColor: Colors.grey[50],
          appBar: AppBar(
            title: const Text(
              'إدارة المدراء', // Admin Management
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            backgroundColor: const Color(0xFF2C3E50),
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.white),
            actions: [
              IconButton(
                onPressed: () {
                  ref.invalidate(userProvider);
                },
                icon: const Icon(Icons.refresh, color: Colors.white),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                ...admins.map(
                  (user) => UserListTile(
                    user: user,
                    onStatusChanged: (newStatus) async {
                      // Only allow status 0 (active) for admins
                      await userNotifier.updateUser(user.id, {'status': 0});
                    },
                    onDelete: () async {
                      // Toggle status: if 0 then set to 1, if 1 then set to 0
                      final newStatus = user.status == 0 ? 1 : 0;
                      await userNotifier.updateUser(user.id, {
                        'status': newStatus,
                      });
                    },
                    // Add update and show password actions
                    onUpdate: () async {
                      _showUpdateAdminDialog(context, userNotifier, user);
                    },
                    onShowPassword: () async {
                      _showPasswordDialog(context, user.password);
                    },
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('إضافة مدير'), // Add Admin
                  onPressed:
                      () => _showCreateAdminDialog(context, userNotifier),
                ),
              ],
            ),
          ),
        );
      },
      error:
          (error, stack) => Center(
            child: Text('حدث خطأ أثناء تحميل معلومات المستخدم: $error'),
          ),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }

  void _showCreateAdminDialog(BuildContext context, dynamic userNotifier) {
    final formKey = GlobalKey<FormState>();
    final userNameController = TextEditingController();
    final emailController = TextEditingController();
    final phoneController = TextEditingController();
    final cityController = TextEditingController();
    final passwordController = TextEditingController();
    // No role or status input, always admin and status 0
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('إضافة مدير'), // Add Admin
            content: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: userNameController,
                      decoration: const InputDecoration(
                        labelText: 'اسم المستخدم',
                      ), // Username
                      validator: (v) => v == null || v.isEmpty ? 'مطلوب' : null,
                    ),
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: 'البريد الإلكتروني',
                      ), // Email
                      validator: (v) => v == null || v.isEmpty ? 'مطلوب' : null,
                    ),
                    TextFormField(
                      controller: phoneController,
                      decoration: const InputDecoration(
                        labelText: 'رقم الهاتف',
                      ), // Phone
                    ),
                    TextFormField(
                      controller: cityController,
                      decoration: const InputDecoration(
                        labelText: 'المدينة',
                      ), // City
                    ),
                    TextFormField(
                      controller: passwordController,
                      decoration: const InputDecoration(
                        labelText: 'كلمة المرور',
                      ), // Password
                      obscureText: true,
                      validator: (v) => v == null || v.isEmpty ? 'مطلوب' : null,
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('إلغاء'), // Cancel
              ),
              ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    await userNotifier.createUser(
                      UserModel(
                        id: '', // Remove id from toJson if empty, let Supabase generate
                        userName: userNameController.text,
                        email: emailController.text,
                        phoneNumber: phoneController.text,
                        city: cityController.text,
                        appRole: 0,
                        status: 0,
                        password: passwordController.text,
                      ),
                    );
                    Navigator.of(ctx).pop();
                  }
                },
                child: const Text('إضافة'), // Add
              ),
            ],
          ),
    );
  }

  void _showUpdateAdminDialog(
    BuildContext context,
    dynamic userNotifier,
    UserModel user,
  ) {
    final formKey = GlobalKey<FormState>();
    final userNameController = TextEditingController(text: user.userName);
    final emailController = TextEditingController(text: user.email);
    final phoneController = TextEditingController(text: user.phoneNumber ?? '');
    final cityController = TextEditingController(text: user.city ?? '');
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('تحديث المدير'), // Update Admin
            content: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: userNameController,
                      decoration: const InputDecoration(
                        labelText: 'اسم المستخدم',
                      ), // Username
                      validator: (v) => v == null || v.isEmpty ? 'مطلوب' : null,
                    ),
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: 'البريد الإلكتروني',
                      ), // Email
                      validator: (v) => v == null || v.isEmpty ? 'مطلوب' : null,
                    ),
                    TextFormField(
                      controller: phoneController,
                      decoration: const InputDecoration(
                        labelText: 'رقم الهاتف',
                      ), // Phone
                    ),
                    TextFormField(
                      controller: cityController,
                      decoration: const InputDecoration(
                        labelText: 'المدينة',
                      ), // City
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('إلغاء'), // Cancel
              ),
              ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    await userNotifier.updateUser(user.id, {
                      'user_name': userNameController.text,
                      'email': emailController.text,
                      'phone_number': phoneController.text,
                      'city': cityController.text,
                    });
                    Navigator.of(ctx).pop();
                  }
                },
                child: const Text('تحديث'), // Update
              ),
            ],
          ),
    );
  }

  void _showPasswordDialog(BuildContext context, String? password) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('كلمة مرور المدير'), // Admin Password
            content: Text(password ?? 'لا توجد كلمة مرور.'), // No password set
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('إغلاق'), // Close
              ),
            ],
          ),
    );
  }
}
