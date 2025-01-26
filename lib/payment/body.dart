// // ignore_for_file: prefer_const_constructors, use_build_context_synchronously

// import 'package:firebase_auth/firebase_auth.dart' as firebaseauth;
// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';

// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:get/get.dart';
// import 'package:will_haben_auto/models/order_model.dart';
// import 'package:will_haben_auto/models/product_model.dart';
// import 'package:will_haben_auto/models/user_model.dart';
// import 'package:will_haben_auto/payment/close_activity.dart';
// import 'package:will_haben_auto/provider/auth_provider.dart';
// import 'package:will_haben_auto/provider/order_provider.dart';
// import 'package:will_haben_auto/provider/product_provider.dart';
// import 'package:will_haben_auto/screens/home_screen.dart';
// import 'package:will_haben_auto/utils/utils.dart';

// import 'package:provider/provider.dart';

// Container choosePaymentType({
//   required double totalPayment,
//   required List<ProductModel> product,
// }) {
//   return Container(
//     padding: const EdgeInsets.symmetric(horizontal: 30),
//     child: Consumer<OrderProvider>(
//       builder: (context, orderProvider, child) {
//         return Consumer<AuthProvider>(
//           // Add another Consumer for AuthProvider
//           builder: (context, authProvider, child) {
//             final currentUser = firebaseauth.FirebaseAuth.instance.currentUser;

//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'Choose payment method',
//                   style: TextStyle(
//                       color: Colors.black,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 16),
//                 ),
//                 const SizedBox(height: 20),
//                 paymenOptions(),
//                 const SizedBox(height: 30),
//                 const Text(
//                   'Promo Code',
//                   style: TextStyle(
//                       color: Colors.black,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 16),
//                 ),
//                 const SizedBox(height: 20),
//                 promoCodeWidget(),
//                 const SizedBox(height: 120),
//                 Row(
//                   children: [
//                     const Text(
//                       'Total payment',
//                       style: TextStyle(color: Colors.black, fontSize: 16),
//                     ),
//                     const Spacer(),
//                     Text(
//                       '\$$totalPayment', // Display total payment dynamically
//                       style: const TextStyle(
//                           color: Colors.black,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 18),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 30),
//                 SizedBox(
//                   height: 45,
//                   width: double.infinity,
//                   child: OutlinedButton(
//                     style: OutlinedButton.styleFrom(
//                       backgroundColor: Colors.black,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(25.0),
//                       ),
//                       side: BorderSide(width: 2, color: Colors.grey.shade500),
//                     ),
//                     onPressed: () async {
//                       final cartprovider =
//                           Provider.of<ProductProvider>(context, listen: false);
//                       EasyLoading.show();
//                       if (currentUser == null) {
//                         Get.snackbar(
//                           "Error",
//                           'User not logged in',
//                           animationDuration: const Duration(seconds: 2),
//                         );
//                         return;
//                       }

//                       final userid =
//                           currentUser.uid; // Use the current user's ID

//                       // Fetch user details from Firestore
//                       UserModel userModel =
//                           await authProvider.getUserFromFirestore(userid);

//                       for (int i = 0; i < product.length; i++) {
//                         final ProductModel currentProduct = product[i];

//                         // Extract product details
//                         String productId = currentProduct.id;
//                         String productTitle = currentProduct.title;
//                         List<String> imagesurl =
//                             currentProduct.productImageUrls;
//                         double price =
//                             double.parse(currentProduct.originalPrice);

//                         String customerId = userid;
//                         String status = 'pending';
//                         DateTime orderDate = DateTime.now();
//                         DateTime deliveryDate =
//                             orderDate.add(const Duration(days: 7));

//                         final OrderModel newOrder = OrderModel(
//                           orderId: '',
//                           productId: productId,
//                           images: imagesurl,
//                           productTitle: productTitle,
//                           quantity: quantity,
//                           price: price,
//                           customerId: customerId,
//                           status: status,
//                           orderDate: orderDate,
//                           deliveryDate: deliveryDate,
//                           customername:
//                               userModel.userName, // Use fetched user name
//                           customeraddress: userModel.address
//                               .toString(), // Use fetched user address
//                           customerphone: userModel.phone
//                               .toString(), // Use fetched user phone number
//                         );

//                         // Add the order to the provider
//                         orderProvider.addOrder(newOrder);
//                         cartprovider.clearCart();
//                       }
//                       Utils.pushAndRemovePrevious(context, HomeScreen());

//                       EasyLoading.dismiss();
//                     },
//                     child: const Text(
//                       'PAY',
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   ),
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     ),
//   );
// }

// Row paymenOptions() {
//   return const Row(
//     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//     children: [
//       CircleAvatar(
//           maxRadius: 25, child: FaIcon(FontAwesomeIcons.amazonPay, size: 35)),
//       FaIcon(FontAwesomeIcons.ccVisa, size: 35),
//       FaIcon(FontAwesomeIcons.paypal, size: 35),
//       FaIcon(FontAwesomeIcons.apple, size: 35),
//       // ignore: deprecated_member_use
//       FaIcon(FontAwesomeIcons.donate, size: 35),
//     ],
//   );
// }

// Padding creditcardImage() {
//   return Padding(
//     padding: const EdgeInsets.all(30),
//     child: Container(
//       padding: const EdgeInsets.all(20),
//       height: 200,
//       width: double.infinity,
//       decoration: creditcardDecoration(),
//       child: creditCardView(),
//     ),
//   );
// }

// AppBar payActionbar() {
//   return AppBar(
//     elevation: 0,
//     backgroundColor: Colors.white,
//     leading: closeActivity(),
//   );
// }

// Container promoCodeWidget() {
//   return Container(
//     width: double.infinity,
//     height: 40,
//     clipBehavior: Clip.none,
//     decoration: BoxDecoration(
//         color: Colors.grey.shade300,
//         borderRadius: const BorderRadius.all(Radius.circular(20))),
//     child: Align(
//       alignment: Alignment.centerRight,
//       child: OutlinedButton(
//         style: OutlinedButton.styleFrom(
//           backgroundColor: Colors.black,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(18.0),
//           ),
//           side: const BorderSide(width: 2, color: Colors.black),
//         ),
//         onPressed: () {},
//         child: const Text(
//           'Apply',
//           style: TextStyle(color: Colors.white),
//         ),
//       ),
//     ),
//   );
// }

// Column creditCardView() {
//   return const Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Text(
//         'Credit Card',
//         style: TextStyle(
//           color: Colors.white,
//         ),
//       ),
//       Spacer(),
//       Text(
//         '3709 4378 5546 8899',
//         style: TextStyle(
//           color: Colors.white,
//           fontSize: 18,
//         ),
//       ),
//       SizedBox(height: 10),
//       Row(
//         children: [
//           Text(
//             'Muhammad Asad',
//             style: TextStyle(
//               color: Colors.white,
//             ),
//           ),
//           Spacer(),
//           Icon(
//             Icons.ac_unit_outlined,
//           )
//         ],
//       )
//     ],
//   );
// }

// BoxDecoration creditcardDecoration() {
//   return BoxDecoration(
//       color: Colors.grey.shade800,
//       borderRadius: const BorderRadius.all(
//         Radius.circular(20),
//       ));
// }
