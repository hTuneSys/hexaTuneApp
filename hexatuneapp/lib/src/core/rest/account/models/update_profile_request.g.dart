// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_profile_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UpdateProfileRequest _$UpdateProfileRequestFromJson(
  Map<String, dynamic> json,
) => _UpdateProfileRequest(
  displayName: json['displayName'] as String?,
  avatarUrl: json['avatarUrl'] as String?,
  bio: json['bio'] as String?,
);

Map<String, dynamic> _$UpdateProfileRequestToJson(
  _UpdateProfileRequest instance,
) => <String, dynamic>{
  'displayName': instance.displayName,
  'avatarUrl': instance.avatarUrl,
  'bio': instance.bio,
};
