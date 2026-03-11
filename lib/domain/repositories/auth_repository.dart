import '../entities/user_entity.dart';
import '../../core/errors/failures.dart';

abstract class AuthRepository {
  Future<(UserEntity?, Failure?)> login(String username, String password);
  Future<UserEntity?> getCachedUser();
  Future<void> logout();
}
