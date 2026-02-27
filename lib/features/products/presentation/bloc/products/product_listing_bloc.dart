import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:zavi_soft_task/core/error/failures.dart';
import 'package:zavi_soft_task/core/usecase/usecase.dart';
import '../../../domain/entities/product_entity.dart';
import '../../../domain/usecases/get_products_usecase.dart';
import '../../../domain/usecases/get_categories_usecase.dart';

part 'product_listing_event.dart';
part 'product_listing_state.dart';

class ProductListingBloc
    extends Bloc<ProductListingEvent, ProductListingState> {
  final GetProductsUseCase _getProducts;
  final GetCategoriesUseCase _getCategories;

  ProductListingBloc({
    required GetProductsUseCase getProducts,
    required GetCategoriesUseCase getCategories,
  })  : _getProducts = getProducts,
        _getCategories = getCategories,
        super(ProductListingInitial()) {
    on<LoadAllProductsEvent>(_onLoad);
    on<RefreshAllProductsEvent>(_onRefresh);
    on<SearchProductsEvent>(_onSearch);
  }

  Future<void> _onLoad(
    LoadAllProductsEvent event,
    Emitter<ProductListingState> emit,
  ) async {
    print('DEBUG: ProductListingBloc _onLoad');
    emit(ProductListingLoading());
    await _fetchAll(emit);
  }

  Future<void> _onRefresh(
    RefreshAllProductsEvent event,
    Emitter<ProductListingState> emit,
  ) async {
    print('DEBUG: ProductListingBloc _onRefresh');
    await _fetchAll(emit);
  }

  void _onSearch(SearchProductsEvent event, Emitter<ProductListingState> emit) {
    print('DEBUG: ProductListingBloc _onSearch query: ${event.query}');
    if (state is ProductListingLoaded) {
      final currentState = state as ProductListingLoaded;
      final query = event.query.toLowerCase();
      
      if (query.isEmpty) {
        emit(currentState.copyWith(searchQuery: '', searchResults: []));
        return;
      }

      final filtered = currentState.allProducts.where((p) {
        return p.title.toLowerCase().contains(query) ||
            p.description.toLowerCase().contains(query) ||
            p.category.toLowerCase().contains(query);
      }).toList();

      emit(currentState.copyWith(
        searchQuery: event.query,
        searchResults: filtered,
      ));
    }
  }

  Future<void> _fetchAll(Emitter<ProductListingState> emit) async {
    print('DEBUG: ProductListingBloc _fetchAll start');
    // 1. Fetch categories
    final categoriesResult = await _getCategories(const NoParams());
    
    List<String> categories = [];
    String? categoryError;

    categoriesResult.fold(
      (failure) {
        print('DEBUG: ProductListingBloc categories failure: ${failure.message}');
        categoryError = failure.message;
      },
      (data) {
        print('DEBUG: ProductListingBloc categories success: ${data.length}');
        categories = data;
      },
    );

    if (categoryError != null) {
      emit(ProductListingError(message: categoryError!));
      return;
    }

    // 2. Fetch all products and products for each category in parallel
    print('DEBUG: ProductListingBloc fetching products for ${categories.length + 1} categories');
    final List<Future<dynamic>> fetchFutures = [
      _getProducts(const GetProductsParams()), // All
    ];

    for (final cat in categories) {
      fetchFutures.add(_getProducts(GetProductsParams(category: cat)));
    }

    try {
      final results = await Future.wait(fetchFutures);
      print('DEBUG: ProductListingBloc products fetched successfully');

      // Check for failures
      for (final result in results) {
        final eitherResult = result as Either<Failure, List<Product>>;
        if (eitherResult.isLeft()) {
          final failure = eitherResult.fold((f) => f, (_) => null);
          print('DEBUG: ProductListingBloc individual fetch failure: ${failure?.message}');
          emit(ProductListingError(message: failure?.message ?? 'Failed to load products'));
          return;
        }
      }

      final allProducts = (results[0] as Either<Failure, List<Product>>).getOrElse((_) => <Product>[]);
      final Map<String, List<Product>> productsByCategory = {};

      for (int i = 0; i < categories.length; i++) {
        productsByCategory[categories[i]] = 
            (results[i + 1] as Either<Failure, List<Product>>).getOrElse((_) => <Product>[]);
      }

      print('DEBUG: ProductListingBloc emitting LoadedState with ${allProducts.length} products');
      emit(ProductListingLoaded(
        allProducts: allProducts,
        categories: categories,
        productsByCategory: productsByCategory,
      ));
    } catch (e) {
      print('DEBUG: ProductListingBloc global fetch error: $e');
      emit(ProductListingError(message: e.toString()));
    }
  }
}
