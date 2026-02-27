import 'package:json_annotation/json_annotation.dart';
part 'main_response.g.dart';


@JsonSerializable()
class MainResponse {
  @JsonKey(name: 'message')
  final String? message;
  @JsonKey(name: 'status_code')
  final int? statusCode;
  @JsonKey(name: 'is_success')
  final bool? isSuccess;
  @JsonKey(name: 'data')
  final dynamic data;

  MainResponse({
    this.message,
    this.statusCode,
    this.isSuccess,
    this.data,
  });

  factory MainResponse.fromJson(Map<String, dynamic> json) =>
      _$MainResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MainResponseToJson(this);
}
