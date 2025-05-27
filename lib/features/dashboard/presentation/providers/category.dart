import 'package:antika_dashcoard/features/dashboard/data/models/category_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'category.g.dart';

@riverpod
class Category extends _$Category {
  @override
  Future<List<CategoryModel>?> build() async {
    try {
      final response = await Supabase.instance.client
          .from("categories")
          .select("*");
      return (response as List)
          .map((item) => CategoryModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return null;
    }
  }

  /// Fetch a single category by its ID from Supabase.
  Future<CategoryModel?> fetchCategoryById(String id) async {
    try {
      final response =
          await Supabase.instance.client
              .from("categories")
              .select()
              .eq("id", id)
              .single();
      return CategoryModel.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  // Create a new category
  Future<void> createCategory(String name) async {
    try {
      await Supabase.instance.client.from("categories").insert({"name": name});
    } catch (e) {
      // Handle error as needed
    }
  }

  // Update an existing category
  Future<void> updateCategory(String id, String name) async {
    try {
      await Supabase.instance.client
          .from("categories")
          .update({"name": name})
          .eq("id", id);
    } catch (e) {
      // Handle error as needed
    }
  }

  // Delete a category
  Future<void> deleteCategory(String id) async {
    try {
      await Supabase.instance.client.from("categories").delete().eq("id", id);
    } catch (e) {
      // Handle error as needed
    }
  }
}
