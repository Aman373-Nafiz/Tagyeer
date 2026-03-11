import '../entities/product_entity.dart';
import '../repositories/products_repository.dart';
import '../../core/errors/failures.dart';

class GetProductsUseCase {
  final ProductsRepository repository;

  GetProductsUseCase(this.repository);

  Future<(List<ProductEntity>?, Failure?)> call({
    required int limit,
    required int skip,
  }) {
    return repository.getProducts(limit: limit, skip: skip);
  }
}
