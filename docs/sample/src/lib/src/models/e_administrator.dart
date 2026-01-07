import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:qrino_admin/src/core/utils/json_helper.dart';
import 'package:qrino_app_schemas/schema/m_administrator.dart';

part 'e_administrator.g.dart';

@HiveType(typeId: 0)
@JsonSerializable(explicitToJson: true)
class EAdministrator extends MAdministrator {

  EAdministrator({
    BigInt? id,
    String? email,
    String? password,
    String? lastName,
    String? firstName,
    DateTime? birthDate,
    String? tel,
    DateTime? emailVerifiedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    super.id = id;
    super.email = email;
    super.password = password;
    super.lastName = lastName;
    super.firstName = firstName;
    super.birthDate = birthDate;
    super.tel = tel;
    super.emailVerifiedAt = emailVerifiedAt;
    super.createdAt = createdAt;
    super.updatedAt = updatedAt;
  }

  @HiveField(0)
  @JsonKey(fromJson: JsonHelper.bigIntFromJson, toJson: JsonHelper.bigIntToJson)
  @override
  BigInt? get id => super.id;

  @HiveField(1)
  @override
  String? get email => super.email;

  @HiveField(2)
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  String? get password => super.password;

  @HiveField(3)
  @override
  String? get lastName => super.lastName;

  @HiveField(4)
  @override
  String? get firstName => super.firstName;

  @HiveField(5)
  @JsonKey(fromJson: JsonHelper.dateTimeFromJson, toJson: JsonHelper.dateTimeToJson)
  @override
  DateTime? get birthDate => super.birthDate;

  @HiveField(6)
  @override
  String? get tel => super.tel;

  @HiveField(7)
  @JsonKey(fromJson: JsonHelper.dateTimeFromJson, toJson: JsonHelper.dateTimeToJson)
  @override
  DateTime? get emailVerifiedAt => super.emailVerifiedAt;

  @HiveField(8)
  @JsonKey(fromJson: JsonHelper.dateTimeFromJson, toJson: JsonHelper.dateTimeToJson)
  @override
  DateTime? get createdAt => super.createdAt;

  @HiveField(9)
  @JsonKey(fromJson: JsonHelper.dateTimeFromJson, toJson: JsonHelper.dateTimeToJson)
  @override
  DateTime? get updatedAt => super.updatedAt;

  factory EAdministrator.fromJson(Map<String, dynamic> json) => _$EAdministratorFromJson(json);
  Map<String, dynamic> toJson() => _$EAdministratorToJson(this);
}