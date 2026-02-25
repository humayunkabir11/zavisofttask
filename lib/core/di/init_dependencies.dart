import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import '../../features/login/login_injector.dart';
import '../../features/products/products_injector.dart';
import '../../features/profile/profile_injector.dart';
import '../config/strings/api_endpoint.dart';
import '../network/api_client.dart';
import '../network/connection_checker.dart';
import '../storage/secure_keys.dart';
import '../storage/secure_storage_service.dart';
import '../storage/shared_pref_service.dart';

part 'injector.dart';