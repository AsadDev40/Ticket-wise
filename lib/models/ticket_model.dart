import 'package:cloud_firestore/cloud_firestore.dart';

class TicketModel {
  final String ticketId;
  final String eventId;
  final String eventTitle;
  final int quantity;
  final double price;
  final String customerId;
  final String status;
  final String customername;
  final String customeraddress;
  final String customerphone;
  final DateTime createdAt;
  final String? eventimage;
  final String? qrimage;
  final String? starttime;
  final String? endtime;
  final String? location;
  final String? city;

  TicketModel(
      {required this.ticketId,
      required this.eventId,
      required this.eventTitle,
      required this.quantity,
      required this.price,
      required this.customerId,
      required this.status,
      required this.customername,
      required this.customeraddress,
      required this.customerphone,
      required this.createdAt,
      this.eventimage,
      this.qrimage,
      this.city,
      this.endtime,
      this.location,
      this.starttime});

  factory TicketModel.fromJson(Map<String, dynamic> json) {
    try {
      return TicketModel(
        ticketId: json['ticketId'] ?? '',
        eventId: json['eventId'],
        eventTitle: json['eventTitle'],
        quantity: json['quantity'],
        price: json['price'].toDouble(),
        customerId: json['customerId'],
        status: json['status'],
        customername: json['customername'],
        customeraddress: json['customeraddress'],
        customerphone: json['customerphone'],
        eventimage: json['eventImage'],
        qrimage: json['qrImage'],
        starttime: json['startTime'],
        endtime: json['endTime'],
        location: json['location'],
        city: json['city'],
        createdAt: (json['createdAt'] as Timestamp).toDate(),
      );
    } catch (e) {
      throw Exception('Error parsing order data: $e');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'ticketId': ticketId,
      'eventId': eventId,
      'eventTitle': eventTitle,
      'quantity': quantity,
      'price': price,
      'customerId': customerId,
      'status': status,
      'customername': customername,
      'customeraddress': customeraddress,
      'customerphone': customerphone,
      'createdAt': createdAt,
      'eventImage': eventimage,
      'qrImage': qrimage,
      'city': city,
      'startTime': starttime,
      'endTime': endtime,
      'location': location,
    };
  }

  TicketModel copyWith({
    String? tickeId,
    String? productId,
    String? productTitle,
    int? quantity,
    double? price,
    String? customerId,
    String? status,
    String? customername,
    String? customeraddress,
    String? customerphone,
    DateTime? orderDate,
    DateTime? deliveryDate,
    String? eventimage,
    String? qrimage,
    String? city,
    String? location,
    String? starttime,
    String? endtime,
  }) {
    return TicketModel(
      ticketId: tickeId ?? ticketId,
      eventId: eventId,
      eventTitle: eventTitle,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      customerId: customerId ?? this.customerId,
      status: status ?? this.status,
      customername: customername ?? this.customername,
      customeraddress: customeraddress ?? this.customeraddress,
      customerphone: customerphone ?? this.customerphone,
      createdAt: createdAt,
      eventimage: eventimage ?? this.eventimage,
      qrimage: qrimage ?? this.qrimage,
      location: location,
      city: city,
      starttime: starttime,
      endtime: endtime,
    );
  }
}
