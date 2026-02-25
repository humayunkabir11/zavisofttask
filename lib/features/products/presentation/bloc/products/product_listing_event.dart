part of 'product_listing_bloc.dart';

abstract class ProductListingEvent {}

/// Load products for ALL tabs simultaneously.
class LoadAllProductsEvent extends ProductListingEvent {}

/// Refresh products for ALL tabs (triggered by pull-to-refresh on any tab).
/// Semantically the same as LoadAllProducts but makes intent explicit.
class RefreshAllProductsEvent extends ProductListingEvent {}
