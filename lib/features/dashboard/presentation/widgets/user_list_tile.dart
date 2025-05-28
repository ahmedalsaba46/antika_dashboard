import 'package:flutter/material.dart';
import '../../data/models/user_model.dart';

class UserListTile extends StatelessWidget {
  final UserModel user;
  final Function(String) onStatusChanged;
  final VoidCallback onDelete;
  final VoidCallback? onUpdate;
  final VoidCallback? onShowPassword;

  const UserListTile({
    super.key,
    required this.user,
    required this.onStatusChanged,
    required this.onDelete,
    this.onUpdate,
    this.onShowPassword,
  });

  @override
  Widget build(BuildContext context) {
    // Convert int status to string for UI logic
    String statusString =
        (() {
          switch (user.status) {
            case 0:
              return 'active';
            case 1:
              return 'blocked';
            default:
              return 'unknown';
          }
        })();
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: _getRoleColor(user.appRole),
                  child: Text(
                    user.userName.isNotEmpty
                        ? user.userName[0].toUpperCase()
                        : 'U',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.userName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        user.email,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                _buildStatusChip(statusString),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.phone, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  user.phoneNumber ?? 'N/A',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(width: 16),
                Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  user.city ?? 'N/A',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const Spacer(),
                _buildRoleChip(),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (user.appRole != 'admin' && statusString == 'active')
                  TextButton.icon(
                    onPressed: () => onStatusChanged('blocked'),
                    icon: const Icon(Icons.block, size: 16),
                    label: const Text('حظر'), // Block
                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                  ),
                if (user.appRole != 'admin' && statusString == 'blocked')
                  TextButton.icon(
                    onPressed: () => onStatusChanged('active'),
                    icon: const Icon(Icons.check_circle, size: 16),
                    label: const Text('إلغاء الحظر'), // Unblock
                    style: TextButton.styleFrom(foregroundColor: Colors.green),
                  ),
                if (onUpdate != null)
                  TextButton.icon(
                    onPressed: onUpdate,
                    icon: const Icon(Icons.edit, size: 16),
                    label: const Text('تحديث'), // Update
                  ),
                if (onShowPassword != null)
                  TextButton.icon(
                    onPressed: onShowPassword,
                    icon: const Icon(Icons.visibility, size: 16),
                    label: const Text('عرض كلمة المرور'), // Show Password
                  ),
                const SizedBox(width: 8),
                if (statusString == 'active')
                  IconButton(
                    onPressed: () async {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder:
                            (ctx) => AlertDialog(
                              title: const Text(
                                'إلغاء تفعيل المستخدم',
                              ), // Deactivate User
                              content: const Text(
                                'هل أنت متأكد أنك تريد إلغاء تفعيل هذا المستخدم؟',
                              ), // Are you sure you want to deactivate this user?
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(ctx).pop(false),
                                  child: const Text('إلغاء'), // Cancel
                                ),
                                TextButton(
                                  onPressed: () => Navigator.of(ctx).pop(true),
                                  child: const Text(
                                    'إلغاء التفعيل',
                                  ), // Deactivate
                                ),
                              ],
                            ),
                      );
                      if (confirmed == true) {
                        onDelete();
                      }
                    },
                    icon: const Icon(Icons.person_off_outlined),
                    color: Colors.orange,
                    tooltip: 'إلغاء تفعيل المستخدم', // Deactivate User
                  ),
                if (statusString == 'blocked')
                  IconButton(
                    onPressed: () async {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder:
                            (ctx) => AlertDialog(
                              title: const Text(
                                'تفعيل المستخدم',
                              ), // Activate User
                              content: const Text(
                                'هل أنت متأكد أنك تريد تفعيل هذا المستخدم؟',
                              ), // Are you sure you want to activate this user?
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(ctx).pop(false),
                                  child: const Text('إلغاء'), // Cancel
                                ),
                                TextButton(
                                  onPressed: () => Navigator.of(ctx).pop(true),
                                  child: const Text('تفعيل'), // Activate
                                ),
                              ],
                            ),
                      );
                      if (confirmed == true) {
                        onStatusChanged('active');
                      }
                    },
                    icon: const Icon(Icons.restore),
                    color: Colors.green,
                    tooltip: 'تفعيل المستخدم', // Activate User
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String statusString) {
    Color chipColor;
    Color textColor;
    IconData icon;
    String label;
    switch (statusString) {
      case 'active':
        chipColor = Colors.green.withOpacity(0.1);
        textColor = Colors.green;
        icon = Icons.check_circle;
        label = 'نشط'; // Active
        break;
      case 'blocked':
        chipColor = Colors.red.withOpacity(0.1);
        textColor = Colors.red;
        icon = Icons.block;
        label = 'محظور'; // Blocked
        break;
      default:
        chipColor = Colors.grey.withOpacity(0.1);
        textColor = Colors.grey;
        icon = Icons.help;
        label = 'غير معروف'; // Unknown
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getRoleColor(user.appRole).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        user.appRole == 'admin'
            ? 'مدير'
            : user.appRole == 'seller'
            ? 'بائع'
            : 'مستخدم', // Admin/Seller/User
        style: TextStyle(
          color: _getRoleColor(user.appRole),
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'admin':
        return Colors.purple;
      case 'seller':
        return Colors.blue;
      case 'user':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
