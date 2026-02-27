// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MainResponse _$MainResponseFromJson(Map<String, dynamic> json) => MainResponse(
  message: json['message'] as String?,
  statusCode: (json['status_code'] as num?)?.toInt(),
  isSuccess: json['is_success'] as bool?,
  data: json['data'],
);

Map<String, dynamic> _$MainResponseToJson(MainResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'status_code': instance.statusCode,
      'is_success': instance.isSuccess,
      'data': instance.data,
    };
