
import 'package:zavi_soft_task/core/extensions/custom_extentions.dart';

class ApiEndpoint {
  static const String stagingBAseUrl = "https://2bff192a87ed.ngrok-free.app/";
  static const String productionBAseUrl = "https://api.example.com/v1/";

  static const String prefix = 'api/v1/';

  static const String baseUrl = "$stagingBAseUrl$prefix";
  static const String imageBaseUrl = "";


  ///--------------------------auth apis
  static String login = "auth/login".baseUrl;

  ///--------------------------chat apis
  static String conversations = "chat/conversations".baseUrl;
}
