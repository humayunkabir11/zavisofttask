part of 'product_listing_bloc.dart';

abstract class ProductListingEvent {}

/// Load products for ALL tabs simultaneously.
class LoadAllProductsEvent extends ProductListingEvent {}

/// Refresh products for ALL tabs (triggered by pull-to-refresh on any tab).
class RefreshAllProductsEvent extends ProductListingEvent {}

/// Search products across all categories.
class SearchProductsEvent extends ProductListingEvent {
  final String query;
  SearchProductsEvent(this.query);
}
