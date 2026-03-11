import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';
import '../../core/errors/failures.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<(UserEntity?, Failure?)> call(String username, String password) {
    return repository.login(username, password);
  }
}
