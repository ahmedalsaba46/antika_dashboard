import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../dashboard/data/models/user_model.dart';

class AuthRepository {
  static Future<UserModel?> getUser({required String email}) async {
    try {
      final response =
          await Supabase.instance.client
              .from("users")
              .select("*")
              .eq("email", email)
              .single();
      return UserModel.fromJson(response);
    } catch (e) {
      // Handle error
      if (e is PostgrestException && e.code == "PGRST116") {
        return null;
      }
      throw Exception("Error fetching user: $e");
    }
  }
}
