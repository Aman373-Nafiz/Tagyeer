import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../core/errors/failures.dart';
import '../../core/network/network_info.dart';
import '../datasources/auth_remote_datasource.dart';
import '../datasources/auth_local_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<(UserEntity?, Failure?)> login(String username, String password) async {
    final isConnected = await networkInfo.isConnected;
    if (!isConnected) {
      return (null, const NetworkFailure());
    }

    try {
      final user = await remoteDataSource.login(username, password);
      await localDataSource.cacheUser(user);
      return (user, null);
    } on AuthException catch (e) {
      return (null, AuthFailure(e.message));
    } on ServerException catch (e) {
      return (null, ServerFailure(e.message));
    } on NetworkException catch (e) {
      return (null, NetworkFailure(e.message));
    } catch (e) {
      return (null, UnknownFailure(e.toString()));
    }
  }

  @override
  Future<UserEntity?> getCachedUser() async {
    return localDataSource.getCachedUser();
  }

  @override
  Future<void> logout() async {
    await localDataSource.clearUser();
  }
}
