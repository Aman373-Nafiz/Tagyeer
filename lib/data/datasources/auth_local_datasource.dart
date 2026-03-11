import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../../core/constants/app_constants.dart';
import '../../core/errors/failures.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUser(UserModel user);
  Future<UserModel?> getCachedUser();
  Future<void> clearUser();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<void> cacheUser(UserModel user) async {
    await sharedPreferences.setString(AppConstants.userKey, user.toJsonString());
  }

  @override
  Future<UserModel?> getCachedUser() async {
    final jsonString = sharedPreferences.getString(AppConstants.userKey);
    if (jsonString == null) return null;
    try {
      return UserModel.fromJsonString(jsonString);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> clearUser() async {
    await sharedPreferences.remove(AppConstants.userKey);
  }
}
