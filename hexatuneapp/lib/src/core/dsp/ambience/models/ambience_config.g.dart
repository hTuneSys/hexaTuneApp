// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ambience_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AmbienceConfig _$AmbienceConfigFromJson(Map<String, dynamic> json) =>
    _AmbienceConfig(
      id: json['id'] as String,
      name: json['name'] as String,
      baseAssetId: json['baseAssetId'] as String?,
      textureAssetIds:
          (json['textureAssetIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      eventAssetIds:
          (json['eventAssetIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      baseGain: (json['baseGain'] as num?)?.toDouble() ?? 0.6,
      textureGain: (json['textureGain'] as num?)?.toDouble() ?? 0.3,
      eventGain: (json['eventGain'] as num?)?.toDouble() ?? 0.4,
      masterGain: (json['masterGain'] as num?)?.toDouble() ?? 1.0,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
    );

Map<String, dynamic> _$AmbienceConfigToJson(_AmbienceConfig instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'baseAssetId': instance.baseAssetId,
      'textureAssetIds': instance.textureAssetIds,
      'eventAssetIds': instance.eventAssetIds,
      'baseGain': instance.baseGain,
      'textureGain': instance.textureGain,
      'eventGain': instance.eventGain,
      'masterGain': instance.masterGain,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
