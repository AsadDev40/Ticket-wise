import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ticket_wise/models/city_model.dart';

class CityProvider extends ChangeNotifier {
  String? _selectedValue;
  String? _selectedCondition;
  final List<CityModel> _cities = [];

  final CollectionReference cityCollection =
      FirebaseFirestore.instance.collection('cities');

  CityProvider() {
    fetchCities();
  }

  List<CityModel> get cities => _cities;

  List<String> get cityNames => _cities.map((city) => city.cityName).toList();

  String? get selectedValue => _selectedValue;

  String? get selectedCondition => _selectedCondition;

  void updateSelectedValue(String value) {
    _selectedValue = value;
    notifyListeners();
  }

  void updateConditionValue(String value) {
    _selectedCondition = value;
    notifyListeners();
  }

  Future<List<CityModel>> fetchCities() async {
    final querySnapshot = await cityCollection.get();
    _cities.clear();
    for (var doc in querySnapshot.docs) {
      _cities.add(CityModel.fromJson(doc.data() as Map<String, dynamic>));
    }
    notifyListeners();
    return _cities;
  }

  Future<void> addCity(CityModel city) async {
    DocumentReference docRef = await cityCollection.add(city.toJson());
    String cityId = docRef.id;
    await cityCollection.doc(cityId).update({'cityid': cityId});
    fetchCities(); // Refresh local list of cities
    notifyListeners();
  }

  Future<void> updateCity(CityModel city) async {
    try {
      await cityCollection.doc(city.cityId).update(city.toJson());
      fetchCities(); // Update local city list
    } catch (e) {
      print('Error updating city: $e');
    }
  }

  Future<void> deleteCity(String cityId) async {
    try {
      await cityCollection.doc(cityId).delete();
      _cities.removeWhere((city) => city.cityId == cityId);
      notifyListeners(); // Notify listeners to rebuild UI
    } catch (e) {
      print('Error deleting city: $e');
    }
  }
}
