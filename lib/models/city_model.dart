class CityModel {
  String cityId;
  String cityImageurl;
  String cityName;

  CityModel({
    required this.cityId,
    required this.cityImageurl,
    required this.cityName,
  });

  // from json
  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      cityId: json['cityid'] ?? '', // Provide default empty string if null
      cityImageurl: json['cityimageurl'] ?? '', // Provide default value
      cityName: json['cityname'] ?? '', // Provide default value
    );
  }

  // to json
  Map<String, dynamic> toJson() => {
        'cityid': cityId,
        'cityimageurl': cityImageurl,
        'cityname': cityName,
      };
}
