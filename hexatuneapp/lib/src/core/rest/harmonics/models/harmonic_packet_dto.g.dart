// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'harmonic_packet_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HarmonicPacketDto _$HarmonicPacketDtoFromJson(Map<String, dynamic> json) =>
    _HarmonicPacketDto(
      value: (json['value'] as num).toInt(),
      durationMs: (json['durationMs'] as num).toInt(),
      isOneShot: json['isOneShot'] as bool,
    );

Map<String, dynamic> _$HarmonicPacketDtoToJson(_HarmonicPacketDto instance) =>
    <String, dynamic>{
      'value': instance.value,
      'durationMs': instance.durationMs,
      'isOneShot': instance.isOneShot,
    };
