// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pagination_meta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PaginationMeta _$PaginationMetaFromJson(Map<String, dynamic> json) =>
    _PaginationMeta(
      hasMore: json['has_more'] as bool,
      limit: (json['limit'] as num).toInt(),
      nextCursor: json['next_cursor'] as String?,
    );

Map<String, dynamic> _$PaginationMetaToJson(_PaginationMeta instance) =>
    <String, dynamic>{
      'has_more': instance.hasMore,
      'limit': instance.limit,
      'next_cursor': instance.nextCursor,
    };
