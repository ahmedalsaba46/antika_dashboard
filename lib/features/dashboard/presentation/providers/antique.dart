import 'package:antika_dashcoard/features/dashboard/data/models/antique_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'antique.g.dart';

@riverpod
class Antique extends _$Antique {
  @override
  Future<List<AntiqueModel>?> build() async {
    try {
      final response = await Supabase.instance.client
          .from("antiques")
          .select("*");

      return (response as List)
          .map((item) => AntiqueModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (e is PostgrestException && e.code == "PGRST116") {
        return null;
      }
      throw Exception("Error fetching user: $e");
    }
  }

  Future<AntiqueModel?> updateAntiques(
    String id,
    Map<String, dynamic> updates,
  ) async {
    try {
      final response =
          await Supabase.instance.client
              .from("antiques")
              .update(updates)
              .eq('id', id)
              .select()
              .single();

      final updatedUser = AntiqueModel.fromJson(response);
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
}
