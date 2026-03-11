import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/product_entity.dart';
import '../../../domain/usecases/get_products_usecase.dart';
import '../../../core/constants/app_constants.dart';

part 'products_event.dart';
part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final GetProductsUseCase getProductsUseCase;
  int _currentSkip = 0;

  ProductsBloc({required this.getProductsUseCase}) : super(const ProductsInitial()) {
    on<FetchProducts>(_onFetchProducts);
    on<FetchMoreProducts>(_onFetchMoreProducts);
    on<RefreshProducts>(_onRefreshProducts);
  }

  Future<void> _onFetchProducts(
    FetchProducts event,
    Emitter<ProductsState> emit,
  ) async {
    emit(const ProductsLoading());
    _currentSkip = 0;

    final (products, failure) = await getProductsUseCase(
      limit: AppConstants.pageLimit,
      skip: _currentSkip,
    );

    if (failure != null) {
      emit(ProductsError(failure.message));
    } else if (products == null || products.isEmpty) {
      emit(const ProductsEmpty());
    } else {
      _currentSkip += products.length;
      emit(ProductsLoaded(
        products: products,
        hasMore: products.length == AppConstants.pageLimit,
      ));
    }
  }

  Future<void> _onFetchMoreProducts(
    FetchMoreProducts event,
    Emitter<ProductsState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ProductsLoaded || !currentState.hasMore) return;

    emit(currentState.copyWith(isLoadingMore: true));

    final (newProducts, failure) = await getProductsUseCase(
      limit: AppConstants.pageLimit,
      skip: _currentSkip,
    );

    if (failure != null) {
      emit(ProductsPaginationError(
        products: currentState.products,
        message: failure.message,
      ));
    } else if (newProducts != null) {
      _currentSkip += newProducts.length;
      final allProducts = [...currentState.products, ...newProducts];
      emit(ProductsLoaded(
        products: allProducts,
        hasMore: newProducts.length == AppConstants.pageLimit,
      ));
    }
  }

  Future<void> _onRefreshProducts(
    RefreshProducts event,
    Emitter<ProductsState> emit,
  ) async {
    add(const FetchProducts());
  }
}
