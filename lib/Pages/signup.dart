// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ticket_wise/Pages/login.dart';
import 'package:ticket_wise/homepage_transition/homepage.dart';
import 'package:ticket_wise/models/user_model.dart';
import 'package:ticket_wise/provider/auth_provider.dart';
import 'package:ticket_wise/provider/file_upload_provider.dart';
import 'package:ticket_wise/provider/image_picker.dart';
import 'package:ticket_wise/utils/utils.dart';
import 'package:ticket_wise/widgets/custom_textfield.dart';

class SignupPage extends HookWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final imageProvider = Provider.of<ImagePickerProvider>(context);
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final usernameController = useTextEditingController();
    final addressController = useTextEditingController();
    final phoneController = useTextEditingController();

    final showPassword = useState(true);

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: const Color(0xFF152534),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: const Color(0xFF152534),
              height: 100,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Create Your',
                      style: GoogleFonts.roboto(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Account',
                      style: GoogleFonts.roboto(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Text(
                      'Sign up to get started',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Center(
                          child: Container(
                            height: 130,
                            width: 130,
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: const Color(0xFF152534)),
                              borderRadius: BorderRadius.circular(65),
                            ),
                            child: imageProvider.selectedImage != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(65),
                                    child: Image.file(
                                      imageProvider.selectedImage!,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : const Icon(
                                    Icons.person,
                                    size: 80,
                                    color: Color(0xFF152534),
                                  ),
                          ),
                        ),
                        Positioned(
                          bottom: -10,
                          left: 200,
                          child: IconButton(
                            onPressed: () async {
                              await showModalBottomSheet(
                                context: context,
                                builder: (context) => Container(
                                  height: 100,
                                  width: MediaQuery.of(context).size.width,
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 20,
                                  ),
                                  child: Column(
                                    children: [
                                      const Text(
                                        'Choose Profile Photo',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      const SizedBox(height: 20),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          TextButton.icon(
                                            onPressed: () async {
                                              await imageProvider
                                                  .pickImageFromCamera();
                                              Utils.back(context);
                                            },
                                            icon: const Icon(
                                              Icons.camera,
                                              color: Color(0xFF152534),
                                              size: 30,
                                            ),
                                            label: const Text(
                                              'Camera',
                                              style: TextStyle(
                                                  color: Color(0xFF152534)),
                                            ),
                                          ),
                                          TextButton.icon(
                                            onPressed: () async {
                                              await imageProvider
                                                  .pickImageFromGallery();
                                              Utils.back(context);
                                            },
                                            icon: const Icon(
                                              Icons.image,
                                              color: Color(0xFF152534),
                                            ),
                                            label: const Text(
                                              'Gallery',
                                              style: TextStyle(
                                                  color: Color(0xFF152534)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.add_a_photo,
                              color: Colors.lightGreen,
                              size: 30,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Text(
                              'Username',
                              style: TextStyle(
                                  fontSize: 16, color: Colors.grey[700]),
                            ),
                          ),
                          const SizedBox(
                            height: 7,
                          ),
                          CustomTextField(
                            controller: usernameController,
                            hintText: 'Username',
                            hintStyle: const TextStyle(
                              fontSize: 15,
                              color: Colors.black54,
                            ),
                            textAlign: TextAlign.left,
                            textStyle: const TextStyle(color: Colors.black),
                            enableBorder: true,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Text(
                              'Email',
                              style: TextStyle(
                                  fontSize: 16, color: Colors.grey[700]),
                            ),
                          ),
                          const SizedBox(
                            height: 7,
                          ),
                          CustomTextField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            hintText: 'Email',
                            hintStyle: const TextStyle(
                              fontSize: 15,
                              color: Colors.black54,
                            ),
                            textAlign: TextAlign.left,
                            textStyle: const TextStyle(color: Colors.black),
                            enableBorder: true,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Text(
                              'Address',
                              style: TextStyle(
                                  fontSize: 16, color: Colors.grey[700]),
                            ),
                          ),
                          const SizedBox(
                            height: 7,
                          ),
                          CustomTextField(
                            controller: addressController,
                            keyboardType: TextInputType.emailAddress,
                            hintText: 'Address',
                            hintStyle: const TextStyle(
                              fontSize: 15,
                              color: Colors.black54,
                            ),
                            textAlign: TextAlign.left,
                            textStyle: const TextStyle(color: Colors.black),
                            enableBorder: true,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Text(
                              'Phone Number',
                              style: TextStyle(
                                  fontSize: 16, color: Colors.grey[700]),
                            ),
                          ),
                          const SizedBox(
                            height: 7,
                          ),
                          CustomTextField(
                            controller: phoneController,
                            keyboardType: TextInputType.number,
                            hintText: 'Phone Number',
                            hintStyle: const TextStyle(
                              fontSize: 15,
                              color: Colors.black54,
                            ),
                            textAlign: TextAlign.left,
                            textStyle: const TextStyle(color: Colors.black),
                            enableBorder: true,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Text(
                              'Password',
                              style: TextStyle(
                                  fontSize: 16, color: Colors.grey[700]),
                            ),
                          ),
                          const SizedBox(
                            height: 7,
                          ),
                          CustomTextField(
                            isPassword: showPassword.value,
                            controller: passwordController,
                            hintText: 'Password',
                            hintStyle: const TextStyle(
                              fontSize: 15,
                              color: Colors.black54,
                            ),
                            textAlign: TextAlign.left,
                            textStyle: const TextStyle(color: Colors.black),
                            enableBorder: true,
                            suffixWidget: InkWell(
                              onTap: () {
                                showPassword.value = !showPassword.value;
                              },
                              child: Icon(
                                showPassword.value
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),
                    Center(
                      child: SizedBox(
                        width: 170,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (emailController.text.isEmpty) {
                              Utils.showToast('Enter a valid email');
                              return;
                            } else if (passwordController.text.isEmpty) {
                              Utils.showToast('Enter a valid password');
                              return;
                            } else if (usernameController.text.isEmpty) {
                              Utils.showToast('Enter a valid username');
                              return;
                            } else if (addressController.text.isEmpty) {
                              Utils.showToast('Enter Address');
                              return;
                            } else if (imageProvider.selectedImage == null) {
                              Utils.showToast('Select a Profile Image');
                            }

                            EasyLoading.show(status: 'loading...');

                            try {
                              final firestore = FirebaseFirestore.instance;
                              final emailQuery = await firestore
                                  .collection('users')
                                  .where('email',
                                      isEqualTo: emailController.text)
                                  .get();
                              if (emailQuery.docs.isNotEmpty) {
                                EasyLoading.dismiss();
                                Utils.showToast('This Email Already Exists');
                              }
                              final authProvider = Provider.of<AuthProvider>(
                                  context,
                                  listen: false);
                              final res = await authProvider
                                  .registerWithEmailAndPassword(
                                emailController.text,
                                passwordController.text,
                              );
                              String? imageUrl;
                              if (imageProvider.selectedImage != null) {
                                final imageUploadProvider =
                                    Provider.of<FileUploadProvider>(context,
                                        listen: false);
                                imageUrl = await imageUploadProvider.fileUpload(
                                  file: imageProvider.selectedImage!,
                                  fileName: 'user-image-${res.user?.uid}',
                                  folder: 'profile',
                                );
                              }

                              EasyLoading.dismiss();

                              if (res.user != null) {
                                
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Verify Your Email'),
                                    content: const Text(
                                      'A verification email has been sent to your email address. Please click the link in the email to verify your account.',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Utils.pushAndRemovePrevious(
                                              context, const LoginPage());
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  ),
                                );

                                await authProvider.addUserToFirestore(
                                  UserModel(
                                    uid: res.user!.uid,
                                    email: emailController.text,
                                    userName: usernameController.text,
                                    createdAt: res.user!.metadata.creationTime!,
                                    profileImage: imageUrl,
                                    phone: phoneController.text,
                                    address: addressController.text,
                                  ),
                                );

                                // Utils.navigateTo(context, const Mainscreen());
                              }
                            } catch (e) {
                              EasyLoading.dismiss();
                              Utils.showToast(
                                  'Network error. Please try again.');
                              debugPrint('Error: $e');
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.lightGreen,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 15, right: 15, top: 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 0.7, // Height of the line
                                color: Colors.black54, // Color of the line
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                'Or Singup with',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: 0.7,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () async {
                            Provider.of<AuthProvider>(context, listen: false);
                            EasyLoading.show();

                            try {
                              // await authProvider.signUpWithGoogle();
                              EasyLoading.dismiss();
                              Utils.pushAndRemovePrevious(
                                  context, const HomePage());
                            } catch (e) {
                              EasyLoading.dismiss();
                              Utils.showToast(
                                  'An error occurred. Failed to login');
                            }
                          },
                          child: Container(
                            height: 50,
                            width: 150,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black26),
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 10,
                                right: 30,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 50,
                                    height: 90,
                                    child: Image.asset(
                                      'assets/images/google.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Text(
                                      'Google',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        InkWell(
                          onTap: () async {
                            Provider.of<AuthProvider>(context, listen: false);

                            EasyLoading.show();

                            try {
                              // await authProvider.signUpWithApple();

                              EasyLoading.dismiss();
                              Utils.pushAndRemovePrevious(
                                  context, const HomePage());
                            } catch (e) {
                              EasyLoading.dismiss();
                              Utils.showToast(
                                  'an error occured. failed to login');
                            }
                          },
                          child: Container(
                            height: 50,
                            width: 150,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black26),
                                borderRadius: BorderRadius.circular(10)),
                            child: const Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Icon(
                                    FontAwesomeIcons.apple,
                                    size: 30,
                                    color: Colors.grey,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 5, right: 15),
                                    child: Text(
                                      'Apple',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account? ',
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Utils.pushAndRemovePrevious(
                                  context, const LoginPage());
                            },
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                  color: Colors.lightGreen,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
