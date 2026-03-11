import '../entities/product_entity.dart';
import '../../core/errors/failures.dart';

abstract class ProductsRepository {
  Future<(List<ProductEntity>?, Failure?)> getProducts({
    required int limit,
    required int skip,
  });
}
