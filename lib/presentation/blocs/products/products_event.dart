part of 'products_bloc.dart';

abstract class ProductsEvent extends Equatable {
  const ProductsEvent();

  @override
  List<Object?> get props => [];
}

class FetchProducts extends ProductsEvent {
  const FetchProducts();
}

class FetchMoreProducts extends ProductsEvent {
  const FetchMoreProducts();
}

class RefreshProducts extends ProductsEvent {
  const RefreshProducts();
}
