import '../../core/di/init_dependencies.dart';
import '../../core/network/api_client.dart';
import '../../core/network/connection_checker.dart';
import 'data/datasources/product_remote_data_source.dart';
import 'data/repositories/product_repository_impl.dart';
import 'domain/repositories/product_repository.dart';
import 'domain/usecases/get_products_usecase.dart';
import 'domain/usecases/get_categories_usecase.dart';
import 'presentation/bloc/products/product_listing_bloc.dart';
import '../../../../core/usecase/usecase.dart';

class ProductsInjector {
  /// Initialize Products feature dependencies
  static Future<void> init() async {
    // ── Data Source ──────────────────────────────────────────────────────
    sl.registerLazySingleton<ProductRemoteDataSource>(
      () => ProductRemoteDataSourceImpl(
        apiClient: sl<ApiClient>(),
      ),
    );

    // ── Repository ───────────────────────────────────────────────────────
    sl.registerLazySingleton<ProductRepository>(
      () => ProductRepositoryImpl(
        remoteSource: sl<ProductRemoteDataSource>(),
        connectionChecker: sl<ConnectionChecker>(),
      ),
    );

    // ── Use Cases ────────────────────────────────────────────────────────
    sl.registerLazySingleton(
      () => GetProductsUseCase(sl<ProductRepository>()),
    );
    sl.registerLazySingleton(
      () => GetCategoriesUseCase(sl<ProductRepository>()),
    );

    // ── BLoCs (factory = new instance per page) ──────────────────────────
    sl.registerFactory(
      () => ProductListingBloc(
        getProducts: sl(),
        getCategories: sl(),
      ),
    );
  }
}
