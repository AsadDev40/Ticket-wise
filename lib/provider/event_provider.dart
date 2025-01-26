import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ticket_wise/models/event_model.dart';

class EventProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Upload product
  Future<String> addEvent(EventModel product) async {
    try {
      DocumentReference docRef =
          await _firestore.collection('events').add(product.toJson());
      await _firestore
          .collection('events')
          .doc(docRef.id)
          .update({'id': docRef.id});

      notifyListeners();
      return docRef.id;
    } catch (e) {
      return '';
    }
  }

  Future<List<EventModel>> fetchEventsByCity(String cityName) async {
    try {
      final eventsSnapshot = await FirebaseFirestore.instance
          .collection('events')
          .where('city', isEqualTo: cityName)
          .get();

      return eventsSnapshot.docs
          .map((doc) => EventModel.fromJson(doc.data()))
          .toList();
    } catch (error) {
      throw error;
    }
  }

  // Fetch products
  Future<List<EventModel>> fetchEvents() async {
    try {
      // Query Firestore to fetch and order events by 'createdAt'
      QuerySnapshot querySnapshot = await _firestore
          .collection('events')
          .orderBy('createdAt',
              descending: true) // Sort by createdAt in descending order
          .get();

      if (querySnapshot.docs.isEmpty) {
        throw Exception('No events found.');
      }

      // Map the documents to EventModel objects
      return querySnapshot.docs
          .map((doc) => EventModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error fetching events: $e');
      rethrow; // Re-throw the error to be handled by the caller
    }
  }

  Future<List<EventModel>> fetchEventsByUserId(String userId) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('events')
        .where('userId', isEqualTo: userId)
        .get();

    return querySnapshot.docs
        .map((doc) => EventModel.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  // Fetch latest products
  Future<List<EventModel>> fetchLatestEvents({int limit = 10}) async {
    final QuerySnapshot querySnapshot = await _firestore
        .collection('events')
        // .orderBy('createdAt', descending: true) // Ensure 'createdAt' exists
        .limit(limit) // Optional: limit the number of products fetched
        .get();

    return querySnapshot.docs
        .map((doc) => EventModel.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  // Update product
  Future<void> updateEvent(String eventId, EventModel updatedProduct) async {
    try {
      await _firestore
          .collection('events')
          .doc(eventId)
          .update(updatedProduct.toJson());
      notifyListeners();
    } catch (e) {
      return;
    }
  }

  // Delete product
  Future<void> deleteEvent(String productId) async {
    try {
      await _firestore.collection('events').doc(productId).delete();
      notifyListeners(); // Notify listeners of the change
    } catch (e) {
      rethrow;
    }
  }

  Future<List<EventModel>> fetchProductsByCategory(String category) async {
    final QuerySnapshot querySnapshot = await _firestore
        .collection('events')
        .where('category', isEqualTo: category)
        .get();

    return querySnapshot.docs
        .map((doc) => EventModel.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }
}
