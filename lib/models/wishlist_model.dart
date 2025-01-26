import 'package:ticket_wise/models/event_model.dart';

class WishlistModel {
  final String id;
  final List<EventModel> products;

  WishlistModel({
    required this.id,
    required this.products,
  });

  // Convert WishlistModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'products': products.map((product) => product.toJson()).toList(),
    };
  }

  // Create WishlistModel from JSON
  static WishlistModel fromJson(Map<String, dynamic> json) {
    return WishlistModel(
      id: json['id'] as String,
      products: (json['products'] as List<dynamic>)
          .map((item) => EventModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
