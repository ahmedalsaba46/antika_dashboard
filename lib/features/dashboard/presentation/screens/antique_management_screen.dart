import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/antique.dart';
import '../widgets/antique_list_tile.dart';

class AntiqueManagementScreen extends ConsumerWidget {
  const AntiqueManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final antiqueAsync = ref.watch(antiqueProvider);
    return antiqueAsync.when(
      data: (antiques) {
        final pendingAntiques =
            (antiques ?? []).where((a) => a.status == 2).toList();
        return Scaffold(
          backgroundColor: Colors.grey[50],
          appBar: AppBar(
            title: const Text(
              'إدارة التحف', // Antique Management
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
                  ref.invalidate(antiqueProvider);
                },
                icon: const Icon(Icons.refresh, color: Colors.white),
              ),
            ],
          ),
          body:
              pendingAntiques.isEmpty
                  ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inventory_outlined,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'لا يوجد تحف قيد الانتظار', // No pending antiques found
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                  : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: pendingAntiques.length,
                    separatorBuilder:
                        (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final antique = pendingAntiques[index];
                      return AntiqueListTile(
                        antique: antique,
                        onStatusChanged: (newStatus) async {
                          // Approve sets status to 0, reject sets status to 1
                          int statusInt = 2;
                          if (newStatus == 'approved') statusInt = 0;
                          if (newStatus == 'rejected') statusInt = 1;

                          ref.read(antiqueProvider.notifier).updateAntiques(
                            antique.id,
                            {'status': statusInt},
                          );
                          ref.invalidate(antiqueProvider);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'تم ${newStatus == 'approved' ? 'الموافقة' : 'الرفض'} على التحفة', // Antique has been approved/rejected
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
        );
      },
      error: (error, stack) => Center(child: Text('حدث خطأ: $error')),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
