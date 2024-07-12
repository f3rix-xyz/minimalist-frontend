import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  @JsonKey(name: 'ID')
  final int id;

  @JsonKey(name: 'Name')
  final String name;

  @JsonKey(name: 'Phone')
  final String phone;

  @JsonKey(name: 'SubscriptionValidTill')
  final DateTime subscriptionValidTill;

  User({
    required this.id,
    required this.name,
    required this.phone,
    required this.subscriptionValidTill,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
