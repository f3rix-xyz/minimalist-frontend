// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: (json['ID'] as num).toInt(),
      name: json['Name'] as String,
      phone: json['Phone'] as String,
      subscriptionValidTill:
          DateTime.parse(json['SubscriptionValidTill'] as String),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'ID': instance.id,
      'Name': instance.name,
      'Phone': instance.phone,
      'SubscriptionValidTill': instance.subscriptionValidTill.toIso8601String(),
    };
