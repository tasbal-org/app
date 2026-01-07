class JsonHelper {
  static BigInt? bigIntFromJson(String? value) => value == null ? null : BigInt.parse(value);
  static String? bigIntToJson(BigInt? value) => value?.toString();

  static DateTime? dateTimeFromJson(String? value) => value == null ?  null : DateTime.tryParse(value);
  static String? dateTimeToJson(DateTime? value) => value?.toIso8601String();
}