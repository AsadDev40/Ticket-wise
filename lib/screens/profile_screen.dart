// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ticket_wise/Pages/login.dart';
import 'package:ticket_wise/models/user_model.dart';
import 'package:ticket_wise/provider/auth_provider.dart' as authpro;
import 'package:ticket_wise/screens/edit_profile_screen.dart';
import 'package:ticket_wise/utils/utils.dart';
import 'package:ticket_wise/widgets/constants.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<authpro.AuthProvider>(context);
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: PrimaryColor,
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        // backgroundColor: PrimaryColor, // Custom app color
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
            onPressed: () {
              authProvider.logout();
              Utils.pushAndRemovePrevious(context, const LoginPage());
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder<UserModel>(
        future: authProvider.getUserFromFirestore(currentUserId),
        builder: (BuildContext context, AsyncSnapshot<UserModel> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(fontSize: 18),
              ),
            );
          } else {
            final user = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.white,
                        child: ClipOval(
                          child: Stack(
                            children: [
                              // The actual image from the network
                              Image.network(
                                user.profileImage ??
                                    'https://via.placeholder.com/300',
                                width: 120,
                                height: 120,
                                fit: BoxFit.cover,
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child; // Image has loaded
                                  } else {
                                    return const Center(
                                      child:
                                          CircularProgressIndicator(), // Show progress indicator while loading
                                    );
                                  }
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  // Error placeholder
                                  return Image.network(
                                    'https://via.placeholder.com/300', // Fallback image in case of error
                                    width: 120,
                                    height: 120,
                                    fit: BoxFit.cover,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15), // Space for avatar

                  Text(
                    user.userName,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: PrimaryColor,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Info Cards (Email, Address)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        buildInfoCard(Icons.email, "Email", user.email),
                        const SizedBox(height: 10),
                        buildInfoCard(
                          Icons.location_on,
                          "Address",
                          user.address ?? 'No Address Available',
                        ),
                        const SizedBox(height: 10),
                        buildInfoCard(
                            Icons.phone, 'Phone', user.phone.toString())
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Edit Profile Button
                  buildActionButton(
                    text: 'Edit Profile',
                    onPressed: () {
                      Utils.navigateTo(
                        context,
                        EditProfilePage(
                          imagepath: user.profileImage.toString(),
                          username: user.userName,
                          email: user.email,
                          userid: currentUserId,
                          phonenumber: user.phone.toString(),
                          address: user.address.toString(),
                        ),
                      );
                    },
                    icon: Icons.edit,
                  ),

                  // Delete Account Button
                  buildActionButton(
                    text: 'Delete Account',
                    onPressed: () {
                      showDeleteAccountDialog(context, authProvider);
                    },
                    icon: Icons.delete_forever,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  // Method to build Info Cards for email and address
  Widget buildInfoCard(IconData icon, String label, String value) {
    return Card(
      color: PrimaryColor,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.white, size: 28),
        title: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  // Method to build Action buttons (Edit Profile, Delete Account)
  Widget buildActionButton({
    required String text,
    required VoidCallback onPressed,
    required IconData icon,
    Color color = Colors.white,
    double width = 120, // full width by default
    double height = 55.0, // slightly larger height for better feel
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: 10.0,
          horizontal: 20), // increased padding for better layout
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: PrimaryColor,
          minimumSize: Size(width, height), // Setting the width and height
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
              side: BorderSide(color: Colors.black54)
              // Soft rounded corners
              ),
          elevation: 5, // Elevation for a shadow effect
          shadowColor: Colors.black.withOpacity(0.2), // Subtle shadow
          padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical:
                  15), // Internal padding to make the button content more balanced
        ),
        icon: Icon(
          icon,
          size: 24, // Adjust icon size to match the text better
          color: Colors.white,
        ),
        label: Text(
          text,
          style: const TextStyle(
            fontSize: 18, // Slightly larger text for better readability
            fontWeight: FontWeight.bold, // Use bold to emphasize button text
            color: Colors.white,
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }

  // Method to show delete account confirmation dialog
  void showDeleteAccountDialog(
      BuildContext context, authpro.AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Account'),
          content: const Text('Are you sure you want to delete your account?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                authProvider.deleteUserDatatoFirestore();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
