class CategoryModel {
  String categoryId;
  String categoryImageurl;
  String categoryName;
  String type;

  CategoryModel({
    required this.categoryId,
    required this.categoryImageurl,
    required this.categoryName,
    required this.type,
  });

  // from json
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      categoryId:
          json['categoryid'] ?? '', // Provide default empty string if null
      categoryImageurl: json['categoryimageurl'] ?? '', // Provide default value
      categoryName: json['categoryname'] ?? '', // Provide default value
      type: json['type'] ?? '', // Provide default value
    );
  }

  // to json
  Map<String, dynamic> toJson() => {
        'categoryid': categoryId,
        'categoryimageurl': categoryImageurl,
        'categoryname': categoryName,
        'type': type,
      };
}
