import '../../../../core/error/server_exception.dart';
import '../../../../core/network/api_client.dart';
import '../models/product_model.dart';

/// FakeStore base URL — all endpoints are relative to this.
const _kBase = 'https://fakestoreapi.com';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts({String? category});
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final ApiClient apiClient;

  ProductRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<ProductModel>> getProducts({String? category}) async {
    try {
      final url = category != null
          ? '$_kBase/products/category/$category'
          : '$_kBase/products';

      final result = await apiClient.get(api: url);
      final List<dynamic> data = result.data as List<dynamic>;
      return data
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
