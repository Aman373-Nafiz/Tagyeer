import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/products_repository.dart';
import '../../core/errors/failures.dart';
import '../../core/network/network_info.dart';
import '../datasources/products_remote_datasource.dart';

class ProductsRepositoryImpl implements ProductsRepository {
  final ProductsRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ProductsRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<(List<ProductEntity>?, Failure?)> getProducts({
    required int limit,
    required int skip,
  }) async {
    final isConnected = await networkInfo.isConnected;
    if (!isConnected) {
      return (null, const NetworkFailure());
    }

    try {
      final products = await remoteDataSource.getProducts(limit: limit, skip: skip);
      return (products as List<ProductEntity>, null);
    } on ServerException catch (e) {
      return (null, ServerFailure(e.message));
    } on NetworkException catch (e) {
      return (null, NetworkFailure(e.message));
    } catch (e) {
      return (null, UnknownFailure(e.toString()));
    }
  }
}
