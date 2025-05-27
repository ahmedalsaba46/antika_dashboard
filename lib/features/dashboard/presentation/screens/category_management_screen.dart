import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/category.dart';
import '../../data/models/category_model.dart';

class CategoryManagementScreen extends ConsumerWidget {
  const CategoryManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoryProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة التصنيفات'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(categoryProvider),
          ),
        ],
      ),
      body: categoriesAsync.when(
        data: (categories) {
          if (categories == null || categories.isEmpty) {
            return const Center(child: Text('لا توجد تصنيفات.'));
          }
          return ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return ListTile(
                title: Text(category.name),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed:
                          () => _showCategoryDialog(
                            context,
                            ref,
                            category: category,
                          ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed:
                          () => _deleteCategory(
                            context,
                            ref,
                            category.id.toString(),
                          ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCategoryDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showCategoryDialog(
    BuildContext context,
    WidgetRef ref, {
    CategoryModel? category,
  }) {
    final nameController = TextEditingController(text: category?.name ?? '');
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(category == null ? 'إنشاء تصنيف' : 'تعديل التصنيف'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'اسم التصنيف'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () async {
                final name = nameController.text.trim();
                if (name.isEmpty) return;
                if (category == null) {
                  await ref
                      .read(categoryProvider.notifier)
                      .createCategory(name);
                } else {
                  await ref
                      .read(categoryProvider.notifier)
                      .updateCategory(category.id.toString(), name);
                }
                ref.invalidate(categoryProvider);
                Navigator.of(context).pop();
              },
              child: Text(category == null ? 'إنشاء' : 'تحديث'),
            ),
          ],
        );
      },
    );
  }

  void _deleteCategory(BuildContext context, WidgetRef ref, String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('حذف التصنيف'),
            content: const Text('هل أنت متأكد أنك تريد حذف هذا التصنيف؟'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('إلغاء'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('حذف'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              ),
            ],
          ),
    );
    if (confirm == true) {
      await ref.read(categoryProvider.notifier).deleteCategory(id);
      ref.invalidate(categoryProvider);
    }
  }
}
