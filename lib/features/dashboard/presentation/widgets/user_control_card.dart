import 'package:flutter/material.dart';
import '../../data/models/user_model.dart';

class UserControlCard extends StatelessWidget {
  final UserModel user;
  final VoidCallback onBlock;
  final VoidCallback onUnblock;

  const UserControlCard({
    super.key,
    required this.user,
    required this.onBlock,
    required this.onUnblock,
  });

  @override
  Widget build(BuildContext context) {
    final isBlocked = user.status == 1;

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
                  backgroundColor:
                      isBlocked ? Colors.red : _getRoleColor(user.appRole),
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
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isBlocked ? Colors.red : null,
                        ),
                      ),
                      Text(
                        user.email,
                        style: TextStyle(
                          fontSize: 14,
                          color: isBlocked ? Colors.red[300] : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                _buildStatusIndicator(isBlocked),
              ],
            ),
            const SizedBox(height: 12),

            // User Details
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
            const SizedBox(height: 16),

            // Action Button
            SizedBox(
              width: double.infinity,
              child:
                  isBlocked
                      ? ElevatedButton.icon(
                        onPressed: onUnblock,
                        icon: const Icon(Icons.check_circle),
                        label: const Text('إلغاء الحظر'), // Unblock User
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      )
                      : ElevatedButton.icon(
                        onPressed: onBlock,
                        icon: const Icon(Icons.block),
                        label: const Text('حظر المستخدم'), // Block User
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIndicator(bool isBlocked) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color:
            isBlocked
                ? Colors.red.withOpacity(0.1)
                : Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isBlocked ? Icons.block : Icons.check_circle,
            size: 14,
            color: isBlocked ? Colors.red : Colors.green,
          ),
          const SizedBox(width: 4),
          Text(
            isBlocked ? 'محظور' : 'نشط', // BLOCKED/ACTIVE
            style: TextStyle(
              color: isBlocked ? Colors.red : Colors.green,
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
