import '../../../../core/config/strings/api_endpoint.dart';
import '../../../../core/error/server_exception.dart';
import '../../../../core/network/api_client.dart';
import '../models/product_model.dart';



abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts({String? category});
  Future<List<String>> getCategories();
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final ApiClient apiClient;

  ProductRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<ProductModel>> getProducts({String? category}) async {
    try {
      final url = category != null
          ? '${ApiEndpoint.products}/category/$category'
          : ApiEndpoint.products;

      final result = await apiClient.get(api: url);
      final List<dynamic> data = result.data as List<dynamic>;
      return data
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<String>> getCategories() async {
    try {
      final url = '${ApiEndpoint.baseUrl}/products/categories';
      final result = await apiClient.get(api: url);
      final List<dynamic> data = result.data as List<dynamic>;
      return data.map((e) => e.toString()).toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
