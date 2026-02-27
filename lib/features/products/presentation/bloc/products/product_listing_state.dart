part of 'product_listing_bloc.dart';

abstract class ProductListingState {
  const ProductListingState();
}

class ProductListingInitial extends ProductListingState {}

class ProductListingLoading extends ProductListingState {}

class ProductListingLoaded extends ProductListingState {
  final List<Product> allProducts;
  final List<String> categories;
  final Map<String, List<Product>> productsByCategory;
  final String searchQuery;
  final List<Product> searchResults;

  const ProductListingLoaded({
    required this.allProducts,
    required this.categories,
    required this.productsByCategory,
    this.searchQuery = '',
    this.searchResults = const [],
  });

  /// Helper: return products for a specific tab index
  /// index 0 is always 'All'
  List<Product> forTab(int tabIndex) {
    if (searchQuery.isNotEmpty) {
      return searchResults;
    }

    if (tabIndex == 0) {
      return allProducts;
    }

    if (tabIndex - 1 < categories.length) {
      final category = categories[tabIndex - 1];
      return productsByCategory[category] ?? [];
    }

    return allProducts;
  }

  ProductListingLoaded copyWith({
    List<Product>? allProducts,
    List<String>? categories,
    Map<String, List<Product>>? productsByCategory,
    String? searchQuery,
    List<Product>? searchResults,
  }) {
    return ProductListingLoaded(
      allProducts: allProducts ?? this.allProducts,
      categories: categories ?? this.categories,
      productsByCategory: productsByCategory ?? this.productsByCategory,
      searchQuery: searchQuery ?? this.searchQuery,
      searchResults: searchResults ?? this.searchResults,
    );
  }
}

class ProductListingError extends ProductListingState {
  final String message;
  const ProductListingError({required this.message});
}
