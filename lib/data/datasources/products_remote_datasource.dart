import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';
import '../../core/constants/app_constants.dart';
import '../../core/errors/failures.dart';

abstract class ProductsRemoteDataSource {
  Future<List<ProductModel>> getProducts({required int limit, required int skip});
}

class ProductsRemoteDataSourceImpl implements ProductsRemoteDataSource {
  final http.Client client;

  ProductsRemoteDataSourceImpl(this.client);

  @override
  Future<List<ProductModel>> getProducts({
    required int limit,
    required int skip,
  }) async {
    try {
      final uri = Uri.parse(
        '${AppConstants.baseUrl}${AppConstants.productsEndpoint}?limit=$limit&skip=$skip',
      );

      final response = await client.get(uri).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final products = data['products'] as List;
        return products.map((p) => ProductModel.fromJson(p)).toList();
      } else {
        throw ServerException(
            message: 'Failed to fetch products.', statusCode: response.statusCode);
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      throw NetworkException(e.toString());
    }
  }
}
