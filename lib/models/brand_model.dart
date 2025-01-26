class BrandModel {
  String brandId;
  String brandImageurl;
  String brandName;

  BrandModel({
    required this.brandId,
    required this.brandImageurl,
    required this.brandName,
  });

  // from json
  factory BrandModel.fromJson(Map<String, dynamic> json) {
    return BrandModel(
      brandId: json['brandid'] ?? '', // Provide default empty string if null
      brandImageurl: json['brandimageurl'] ?? '', // Provide default value
      brandName: json['brandname'] ?? '', // Provide default value
    );
  }

  // to json
  Map<String, dynamic> toJson() => {
        'brandid': brandId,
        'brandimageurl': brandImageurl,
        'brandname': brandName,
      };
}
