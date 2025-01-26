import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ticket_wise/models/user_model.dart';
import 'package:ticket_wise/provider/auth_provider.dart';
import 'package:ticket_wise/provider/file_upload_provider.dart';
import 'package:ticket_wise/screens/main_screen.dart';
import 'package:ticket_wise/utils/utils.dart';
import 'package:ticket_wise/widgets/constants.dart';

class OtpVerificationPage extends StatefulWidget {
  final auth.User user;
  final TextEditingController emailController;
  final TextEditingController usernameController;
  final TextEditingController addressController;
  final TextEditingController phoneController;
  final File? selectedImage;

  const OtpVerificationPage({
    Key? key,
    required this.user,
    required this.emailController,
    required this.usernameController,
    required this.addressController,
    required this.phoneController,
    this.selectedImage,
  }) : super(key: key);

  @override
  _OtpVerificationPageState createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _onInputChange(String value, int index) {
    if (value.isNotEmpty) {
      if (index < _controllers.length - 1) {
        FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
      } else {
        _focusNodes[index].unfocus();
      }
    } else {
      if (index > 0) {
        FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF152534),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          'OTP Verification',
          style: GoogleFonts.roboto(color: Colors.white, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          color: Colors.white,
          child: Column(
            mainAxisSize:
                MainAxisSize.min, // Makes the container height dynamic
            children: [
              Column(
                children: [
                  Text(
                    'Verify Your Account',
                    style: GoogleFonts.roboto(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: PrimaryColor,
                    ),
                  ),
                  const Text(
                    'Enter the 6-digit code sent to your email',
                    style: TextStyle(
                      fontSize: 15,
                      color: PrimaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: 50,
                    height: 50,
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF152534),
                      ),
                      decoration: InputDecoration(
                        counterText: "",
                        hintText: "-",
                        hintStyle: const TextStyle(
                          fontSize: 24,
                          color: Colors.grey,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Colors.grey,
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xFF152534),
                            width: 2,
                          ),
                        ),
                        contentPadding: EdgeInsets.zero, // Center alignment
                      ),
                      onChanged: (value) => _onInputChange(value, index),
                      showCursor: false, // Hides the cursor
                    ),
                  );
                }),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    EasyLoading.show(status: 'Verifying OTP...');

                    try {
                      await widget.user.reload();
                      final user = auth.FirebaseAuth.instance.currentUser;

                      if (user != null && user.emailVerified) {
                        String? imageUrl;
                        if (widget.selectedImage != null) {
                          final imageUploadProvider =
                              Provider.of<FileUploadProvider>(context,
                                  listen: false);
                          imageUrl = await imageUploadProvider.fileUpload(
                            folder: 'profile-images',
                            file: widget.selectedImage!,
                            fileName: 'user-image-${user.uid}',
                          );
                        }

                        final authProvider =
                            Provider.of<AuthProvider>(context, listen: false);
                        await authProvider.addUserToFirestore(
                          UserModel(
                            uid: user.uid,
                            email: widget.emailController.text,
                            userName: widget.usernameController.text,
                            createdAt: user.metadata.creationTime!,
                            profileImage: imageUrl,
                            phone: widget.phoneController.text,
                            address: widget.addressController.text,
                          ),
                        );

                        EasyLoading.dismiss();
                        widget.usernameController.clear();
                        widget.emailController.clear();
                        widget.phoneController.clear();
                        widget.addressController.clear();

                        Utils.navigateTo(context, const Mainscreen());
                      } else {
                        EasyLoading.dismiss();
                        Utils.showToast(
                            'Email not verified. Please check your email.');
                      }
                    } catch (e) {
                      EasyLoading.dismiss();
                      Utils.showToast('Verification failed. Please try again.');
                      debugPrint('Error: $e');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF152534),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Verify',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  // Handle resend OTP
                },
                child: const Text(
                  'Resend Code',
                  style: TextStyle(
                    color: SecondaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
