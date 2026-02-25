part of 'product_listing_bloc.dart';

abstract class ProductListingState {}

class ProductListingInitial extends ProductListingState {}

class ProductListingLoading extends ProductListingState {}

class ProductListingLoaded extends ProductListingState {
  final List<Product> allProducts;
  final List<Product> electronicsProducts;
  final List<Product> jeweleryProducts;

  ProductListingLoaded({
    required this.allProducts,
    required this.electronicsProducts,
    required this.jeweleryProducts,
  });

  /// Helper: return products for a specific tab index
  List<Product> forTab(int tabIndex) {
    switch (tabIndex) {
      case 0:
        return allProducts;
      case 1:
        return electronicsProducts;
      case 2:
        return jeweleryProducts;
      default:
        return allProducts;
    }
  }
}

class ProductListingError extends ProductListingState {
  final String message;
  ProductListingError({required this.message});
}
