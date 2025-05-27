import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/antique_model.dart';
import '../providers/category.dart';

class AntiqueListTile extends ConsumerWidget {
  final AntiqueModel antique;
  final Function(String) onStatusChanged;

  const AntiqueListTile({
    super.key,
    required this.antique,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
      future: ref
          .read(categoryProvider.notifier)
          .fetchCategoryById(antique.categoryId.toString()),
      builder: (context, snapshot) {
        String categoryName;
        if (snapshot.connectionState == ConnectionState.waiting) {
          categoryName = 'جاري التحميل...';
        } else if (snapshot.hasError) {
          categoryName = 'خطأ';
        } else {
          print('Category fetched: ${snapshot.data}');
          categoryName = snapshot.data?.name ?? '?';
        }
        return _buildTile(context, categoryName);
      },
    );
  }

  Widget _buildTile(BuildContext context, String categoryName) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child:
                      antique.imageUrl != null
                          ? CachedNetworkImage(
                            imageUrl: antique.imageUrl!,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            placeholder:
                                (context, url) => Container(
                                  width: 80,
                                  height: 80,
                                  color: Colors.grey[200],
                                  child: const Icon(
                                    Icons.image,
                                    color: Colors.grey,
                                  ),
                                ),
                            errorWidget:
                                (context, url, error) => Container(
                                  width: 80,
                                  height: 80,
                                  color: Colors.grey[200],
                                  child: const Icon(
                                    Icons.broken_image,
                                    color: Colors.grey,
                                  ),
                                ),
                          )
                          : Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.image,
                              color: Colors.grey,
                              size: 32,
                            ),
                          ),
                ),
                const SizedBox(width: 16),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              antique.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          _buildStatusChip(),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        antique.description,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(
                            Icons.attach_money,
                            size: 16,
                            color: Colors.green[600],
                          ),
                          Text(
                            '\$${antique.price.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.green[600],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Icon(
                            Icons.calendar_today,
                            size: 14,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            antique.year.toString(),
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Additional Details
            Row(
              children: [
                _buildDetailChip(Icons.category, categoryName),
                const SizedBox(width: 8),
                _buildDetailChip(Icons.star, antique.condition),
                const SizedBox(width: 8),
                _buildDetailChip(Icons.inventory, '${antique.quantity}'),
              ],
            ),

            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(antique.place, style: TextStyle(color: Colors.grey[600])),
              ],
            ),

            const SizedBox(height: 16),

            // Action Buttons
            if (antique.status == 2) ...[
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => onStatusChanged('rejected'),
                      icon: const Icon(Icons.close),
                      label: const Text('رفض'), // Reject
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => onStatusChanged('approved'),
                      icon: const Icon(Icons.check),
                      label: const Text('موافقة'), // Approve
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip() {
    Color chipColor;
    Color textColor;
    IconData icon;
    String label;

    switch (antique.status) {
      case 0: // approved
        chipColor = Colors.green.withOpacity(0.1);
        textColor = Colors.green;
        icon = Icons.check_circle;
        label = 'مقبول'; // Approved
        break;
      case 1: // rejected
        chipColor = Colors.red.withOpacity(0.1);
        textColor = Colors.red;
        icon = Icons.cancel;
        label = 'مرفوض'; // Rejected
        break;
      case 2: // pending
        chipColor = Colors.orange.withOpacity(0.1);
        textColor = Colors.orange;
        icon = Icons.pending;
        label = 'قيد الانتظار'; // Pending
        break;
      case 4: // sold
        chipColor = Colors.purple.withOpacity(0.1);
        textColor = Colors.purple;
        icon = Icons.sell;
        label = 'مباع'; // Sold
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

  Widget _buildDetailChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.grey[600]),
          const SizedBox(width: 4),
          Text(text, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ],
      ),
    );
  }
}
