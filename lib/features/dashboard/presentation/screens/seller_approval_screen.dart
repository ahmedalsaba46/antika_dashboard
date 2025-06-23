import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/user.dart';
import '../widgets/seller_approval_card.dart';

class SellerApprovalScreen extends ConsumerWidget {
  const SellerApprovalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider);
    final userNotifier = ref.read(userProvider.notifier);
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'موافقة البائعين', // Seller Approval
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
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
      body: userAsync.when(
        data: (users) {
          final sellers =
              (users ?? [])
                  .where((u) => u.status == 2 && u.appRole == 2)
                  .toList();
          if (sellers.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.approval, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'لا يوجد طلبات بائعين قيد الانتظار', // No pending seller approvals
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'تمت مراجعة جميع حسابات البائعين', // All seller accounts have been reviewed
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: sellers.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final seller = sellers[index];
              return SellerApprovalCard(
                seller: seller,
                onApprove: () async {
                  await userNotifier.updateUser(seller.id, {'status': 0});
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "تمت الموافقة على طلب ${seller.userName}", // application approved
                      ),
                    ),
                  );
                },
                onReject: () async {
                  await userNotifier.deleteUser(seller.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "تم رفض طلب ${seller.userName}", // application rejected
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
        error: (error, stack) => Center(child: Text('حدث خطأ: $error')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
