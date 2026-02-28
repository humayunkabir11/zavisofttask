
import 'package:zavi_soft_task/core/extensions/custom_extentions.dart';

class ApiEndpoint {

/// FakeStore base URL — all endpoints are relative to this.
  static const String baseUrl = "https://fakestoreapi.com/";
  static const String imageBaseUrl = "";


  ///--------------------------auth apis
  static String login = "auth/login".baseUrl;
  ///--------------------------user apis
  static String users = "users";
  ///--------------------------product apis
  static String products = "products";

  ///--------------------------chat apis
  static String conversations = "chat/conversations".baseUrl;
}
