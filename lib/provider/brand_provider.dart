import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ticket_wise/models/brand_model.dart';

class BrandProvider extends ChangeNotifier {
  String? _selectedValue;
  final List<BrandModel> _brands = [];

  final CollectionReference brandCollection =
      FirebaseFirestore.instance.collection('brands');

  BrandProvider() {
    fetchBrands();
  }

  List<BrandModel> get brands => _brands;

  List<String> get brandNames =>
      _brands.map((brand) => brand.brandName).toList();

  String? get selectedValue => _selectedValue;

  void updateSelectedValue(String value) {
    _selectedValue = value;
    notifyListeners();
  }

  Future<List<BrandModel>> fetchBrands() async {
    final querySnapshot = await brandCollection.get();
    _brands.clear();
    for (var doc in querySnapshot.docs) {
      _brands.add(BrandModel.fromJson(doc.data() as Map<String, dynamic>));
    }
    notifyListeners();
    return _brands;
  }

  Future<void> addBrand(BrandModel brand) async {
    DocumentReference docRef = await brandCollection.add(brand.toJson());
    String brandId = docRef.id;
    await brandCollection.doc(brandId).update({'brandId': brandId});
    fetchBrands(); // Refresh local list of brands
    notifyListeners();
  }

  Future<void> updateBrand(BrandModel brand) async {
    try {
      await brandCollection.doc(brand.brandId).update(brand.toJson());
      fetchBrands(); // Update local brand list
    } catch (e) {
      print('Error updating brand: $e');
    }
  }

  Future<void> deleteBrand(String brandId) async {
    try {
      await brandCollection.doc(brandId).delete();
      _brands.removeWhere((brand) => brand.brandId == brandId);
      notifyListeners(); // Notify listeners to rebuild UI
    } catch (e) {
      print('Error deleting brand: $e');
    }
  }
}
