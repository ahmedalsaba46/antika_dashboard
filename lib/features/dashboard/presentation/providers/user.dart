import 'package:antika_dashcoard/features/dashboard/data/models/user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
part 'user.g.dart';

@riverpod
class User extends _$User {
  @override
  Future<List<UserModel>?> build() async {
    try {
      final response = await Supabase.instance.client.from("users").select("*");
      // Supabase returns a List<dynamic> of maps
      return (response as List)
          .map((item) => UserModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (e is PostgrestException && e.code == "PGRST116") {
        return null;
      }
      throw Exception("Error fetching user: $e");
    }
  }

  // CREATE
  Future<UserModel?> createUser(UserModel user) async {
    try {
      final response =
          await Supabase.instance.client
              .from("users")
              .insert(user.toJson())
              .select()
              .single();
      final newUser = UserModel.fromJson(response);
      state = AsyncValue.data([
        if (state.value != null) ...state.value!,
        newUser,
      ]);
      return newUser;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return null;
    }
  }

  // UPDATE
  Future<UserModel?> updateUser(String id, Map<String, dynamic> updates) async {
    try {
      final response =
          await Supabase.instance.client
              .from("users")
              .update(updates)
              .eq('id', id)
              .select()
              .single();
      final updatedUser = UserModel.fromJson(response);
      if (state.value != null) {
        final updatedList =
            state.value!.map((u) => u.id == id ? updatedUser : u).toList();
        state = AsyncValue.data(updatedList);
      }
      return updatedUser;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return null;
    }
  }

  // DELETE
  Future<bool> deleteUser(String id) async {
    try {
      await Supabase.instance.client.from("users").delete().eq('id', id);
      if (state.value != null) {
        final updatedList = state.value!.where((u) => u.id != id).toList();
        state = AsyncValue.data(updatedList);
      }
      return true;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return false;
    }
  }
}
