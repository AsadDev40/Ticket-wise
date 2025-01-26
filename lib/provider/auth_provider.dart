// ignore_for_file: unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ticket_wise/models/user_model.dart';
import 'package:ticket_wise/services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  User? get currentuser => FirebaseAuth.instance.currentUser;

  final userCollection = FirebaseFirestore.instance.collection('users');

  final _authService = AuthService();

  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    return await _authService.signInWithEmailAndPassword(email, password);
  }

  Future<UserCredential> registerWithEmailAndPassword(
      String email, String password) async {
    return await _authService.registerWithEmailAndPassword(email, password);
  }

  Future<bool> checkEmailVerified(User user) async {
    await user.reload(); // Reloads user data from Firebase
    return user.emailVerified;
  }
  // add user to firestore

  Future<void> addUserToFirestore(UserModel userModel) async {
    await userCollection.doc(userModel.uid).set(userModel.toJson());
  }

  Future<void> deleteUserDatatoFirestore() async {
    await userCollection.doc(currentuser!.uid).delete();
  }

  // get user from firestore
  Future<UserModel> getUserFromFirestore(String uid) async {
    final user = await userCollection.doc(uid).get();
    return UserModel.fromJson(user.data()!);
  }

  Future<void> updateUserImage(String uid, String imageUrl) async {
    await userCollection.doc(uid).update({'profileImage': imageUrl});
  }

  Future<void> updateUserProfile(
      String username, String email, String address, String phone) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await userCollection.doc(user.uid).update({
        'userName': username,
        'email': email,
        'address': address,
        'phone': phone,
      });
    }
    notifyListeners();
  }

  Future<void> logout() async {
    await _authService.signOut();
  }

  Future<UserCredential> signInWithGoogle() async {
    final res = await _authService.signInWithGoogle();
    final userModel = UserModel(
        uid: res.user!.uid,
        profileImage: res.user!.photoURL,
        email: res.user!.email!,
        userName: res.user!.displayName!,
        createdAt: res.user!.metadata.creationTime!);

    addUserToFirestore(userModel);

    return res;

    // debugPrint('Profile Info: ${res.additionalUserInfo?.profile}');
  }

  @override
  notifyListeners();
}
