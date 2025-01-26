import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ticket_wise/models/user_model.dart';
import 'package:ticket_wise/provider/auth_provider.dart' as auth;
import 'package:ticket_wise/screens/profile_screen.dart';
import 'package:ticket_wise/utils/utils.dart';
import 'package:ticket_wise/widgets/constants.dart';
import 'package:provider/provider.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<auth.AuthProvider>(context);
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          FutureBuilder<UserModel>(
            future: authProvider.getUserFromFirestore(currentUserId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return DrawerHeader(
                  decoration: BoxDecoration(
                    color: PrimaryColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Center(child: CircularProgressIndicator()),
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                final user = snapshot.data!;
                return DrawerHeader(
                  decoration: BoxDecoration(
                    color: PrimaryColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(user.profileImage ??
                            'https://via.placeholder.com/300'),
                        radius: 40,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Hello ${user.userName}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
          ListTile(
            title: const Text('Profile'),
            onTap: () {
              Utils.navigateTo(context, const ProfileScreen());
            },
          ),
          ListTile(
            title: const Text('Delete Account'),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Delete Account'),
                    content: const Text(
                        'Are you sure you want to delete your account?'),
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
                          context
                              .read<auth.AuthProvider>()
                              .deleteUserDatatoFirestore();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
          ListTile(
            title: const Text('Logout'),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Logout'),
                    content: const Text('Are you sure you want to logout?'),
                    actions: [
                      TextButton(
                        child: const Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: const Text('Logout'),
                        onPressed: () {
                          context.read<auth.AuthProvider>().logout();
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
