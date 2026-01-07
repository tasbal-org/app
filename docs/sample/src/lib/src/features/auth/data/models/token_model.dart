import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:qrino_admin/src/features/auth/domain/entities/token.dart';

part 'token_model.g.dart';

@HiveType(typeId: 0)
@JsonSerializable(explicitToJson: true)
class TokenModel {
  @HiveField(0)
  @JsonKey()
  final String accessToken;

  @HiveField(1)
  @JsonKey()
  final String refreshToken;

  @HiveField(2)
  @JsonKey()
  final int expiresIn;

  TokenModel({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
  });

  factory TokenModel.fromJson(Map<String, dynamic> json) => _$TokenModelFromJson(json);
  Map<String, dynamic> toJson() => _$TokenModelToJson(this);

  Token toEntity() => Token(
        accessToken: accessToken,
        refreshToken: refreshToken,
        expiresIn: expiresIn,
      );
}