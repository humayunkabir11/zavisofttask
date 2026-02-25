import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/product_entity.dart';
import '../../../domain/usecases/get_products_usecase.dart';

part 'product_listing_event.dart';
part 'product_listing_state.dart';

/// Manages product data for all three tabs (All, Electronics, Jewelery).
///
/// Design decision: A single BLoC fetches all three category feeds at once.
/// This avoids having three independent BLoCs that would each make separate
/// API calls on tab switch and risk getting out of sync.
///
/// STATE ownership:
///   - ProductListingLoaded holds three lists.
///   - The UI reads the correct list based on the active tab index.
///   - No per-tab state — one refresh re-fetches everything.
class ProductListingBloc
    extends Bloc<ProductListingEvent, ProductListingState> {
  final GetProductsUseCase _getProducts;

  ProductListingBloc({required GetProductsUseCase getProducts})
      : _getProducts = getProducts,
        super(ProductListingInitial()) {
    on<LoadAllProductsEvent>(_onLoad);
    on<RefreshAllProductsEvent>(_onRefresh);
  }

  Future<void> _onLoad(
    LoadAllProductsEvent event,
    Emitter<ProductListingState> emit,
  ) async {
    emit(ProductListingLoading());
    await _fetchAll(emit);
  }

  Future<void> _onRefresh(
    RefreshAllProductsEvent event,
    Emitter<ProductListingState> emit,
  ) async {
    // On refresh: keep existing data visible while re-fetching
    // (no loading spinner so the user sees their scroll position)
    await _fetchAll(emit);
  }

  /// Fetches all three category feeds in parallel via Future.wait.
  Future<void> _fetchAll(Emitter<ProductListingState> emit) async {
    final results = await Future.wait([
      _getProducts(const GetProductsParams()), // all
      _getProducts(const GetProductsParams(category: 'electronics')),
      _getProducts(const GetProductsParams(category: "jewelery")),
    ]);

    // Check for any failures in the results
    for (final result in results) {
      if (result.isLeft()) {
        final failure = result.fold((f) => f, (_) => null);
        emit(ProductListingError(message: failure?.message ?? 'Failed to load products'));
        return;
      }
    }

    emit(ProductListingLoaded(
      allProducts: results[0].getOrElse((_) => []),
      electronicsProducts: results[1].getOrElse((_) => []),
      jeweleryProducts: results[2].getOrElse((_) => []),
    ));
  }
}
