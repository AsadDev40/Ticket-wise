// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  // Constructor
  EventModel({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.eventImageUrls,
    required this.eventvideourl,
    required this.eventDate,
    required this.ticketPrice,
    required this.location,
    this.startTime,
    this.endTime,
    this.createdAt,
    this.city,
    this.quantity,
  });

  final String id;
  final String title;
  final String category;
  final String description;
  final List<String> eventImageUrls;
  final String eventvideourl;
  final String ticketPrice;
  final String eventDate;
  final String location;
  final String? startTime;
  final String? endTime;
  final DateTime? createdAt;
  final String? city;
  final String? quantity;

  // from json
  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
        id: json['id'],
        title: json['title'],
        category: json['category'],
        description: json['description'],
        eventvideourl: json['productvideourl'],
        ticketPrice: json['ticketprice'],
        eventDate: json['eventdate'],
        location: json['location'],
        startTime: json['startTime'],
        endTime: json['endTime'],
        createdAt: (json['createdAt'] as Timestamp?)?.toDate(),
        city: json['city'],
        quantity: json['quantity'],
        eventImageUrls: List<String>.from(json['productImageUrls']));
  }

  // to json
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'productvideourl': eventvideourl,
        'category': category,
        'description': description,
        'productImageUrls': eventImageUrls,
        'eventdate': eventDate,
        'ticketprice': ticketPrice,
        'location': location,
        'startTime': startTime,
        'endTime': endTime,
        'createdAt': createdAt,
        'city': city,
        'quantity': quantity,
      };
}
