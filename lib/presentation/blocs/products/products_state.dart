part of 'products_bloc.dart';

abstract class ProductsState extends Equatable {
  const ProductsState();

  @override
  List<Object?> get props => [];
}

class ProductsInitial extends ProductsState {
  const ProductsInitial();
}

class ProductsLoading extends ProductsState {
  const ProductsLoading();
}

class ProductsLoaded extends ProductsState {
  final List<ProductEntity> products;
  final bool hasMore;
  final bool isLoadingMore;

  const ProductsLoaded({
    required this.products,
    required this.hasMore,
    this.isLoadingMore = false,
  });

  ProductsLoaded copyWith({
    List<ProductEntity>? products,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return ProductsLoaded(
      products: products ?? this.products,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [products, hasMore, isLoadingMore];
}

class ProductsError extends ProductsState {
  final String message;
  const ProductsError(this.message);

  @override
  List<Object?> get props => [message];
}

class ProductsEmpty extends ProductsState {
  const ProductsEmpty();
}

class ProductsPaginationError extends ProductsState {
  final List<ProductEntity> products;
  final String message;
  const ProductsPaginationError({required this.products, required this.message});

  @override
  List<Object?> get props => [products, message];
}
