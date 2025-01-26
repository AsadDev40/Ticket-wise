// // ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:will_haben_auto/Pages/payment_page.dart';
// import 'package:will_haben_auto/models/cart_model.dart';
// import 'package:will_haben_auto/provider/product_provider.dart';
// import 'package:will_haben_auto/utils/utils.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class CartList extends StatefulWidget {
//   const CartList({super.key});

//   @override
//   _CartListState createState() => _CartListState();
// }

// class _CartListState extends State<CartList> {
//   CartModel currentCart = CartModel(products: []);
//   double shippingCost = 2.0;
//   double taxRate = 0.09;

//   @override
//   void initState() {
//     super.initState();
//     loadCart();
//   }

//   Future<void> loadCart() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? cartString = prefs.getString('cart');
//     if (cartString != null) {
//       setState(() {
//         currentCart = CartModel.fromJson(jsonDecode(cartString));
//       });
//     }
//   }

//   double get subtotal => currentCart.products.fold(0, (sum, product) {
//         return sum +
//             (double.tryParse(product.discountprice) ?? 0.0) *
//                 (product.quantity?.toInt() ?? 1);
//       });

//   double get totalTax => subtotal * taxRate;

//   double get total => subtotal + shippingCost + totalTax;

//   void updateQuantity(int index, int delta) {
//     setState(() {
//       currentCart.products[index].quantity =
//           ((currentCart.products[index].quantity ?? 1) + delta);

//       if (currentCart.products[index].quantity! < 1) {
//         currentCart.products[index].quantity =
//             1; // Prevent quantity going below 1
//       }
//     });
//   }

//   Future<void> placeOrder() async {
//     // Check if the cart is empty
//     if (currentCart.products.isEmpty) {
//       // Show a toast message indicating the cart is empty
//       Utils.showToast("Cart is empty! Please add some products.");
//       return;
//     }

//     // Calculate the total payment
//     final double totalPayment = total;

//     // Navigate to PaymentPage with the totalPayment and products
//     Utils.navigateTo(
//       context,
//       PaymentPage(
//         totalPayment: totalPayment, // Pass the calculated totalPayment
//         product: currentCart.products, // Pass the list of products
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final productprovider = Provider.of<ProductProvider>(context);
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Cart'),
//       ),
//       body: Column(
//         children: <Widget>[
//           Padding(
//             padding: const EdgeInsets.symmetric(vertical: 12.0),
//             child: Text(
//               "${currentCart.products.length} ITEMS IN YOUR CART",
//               style: const TextStyle(
//                   color: Colors.black, fontWeight: FontWeight.bold),
//             ),
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: currentCart.products.length,
//               itemBuilder: (context, index) {
//                 final item = currentCart.products[index];
//                 return Dismissible(
//                     key: Key(item.id),
//                     onDismissed: (direction) async {
//                       await productprovider.deleteFromCart(item.id);
//                       setState(() {
//                         currentCart.products.removeAt(index);
//                       });

//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(
//                           content: Text("${item.title} removed from cart"),
//                           duration: const Duration(seconds: 1),
//                         ),
//                       );
//                     },
//                     background: Container(
//                       color: Colors.red,
//                       padding: const EdgeInsets.all(5.0),
//                       alignment: AlignmentDirectional.centerStart,
//                       child: const Padding(
//                         padding: EdgeInsets.only(left: 20.0),
//                         child: Icon(Icons.delete, color: Colors.white),
//                       ),
//                     ),
//                     secondaryBackground: Container(
//                       color: Colors.red,
//                       padding: const EdgeInsets.all(5.0),
//                       alignment: AlignmentDirectional.centerEnd,
//                       child: const Padding(
//                         padding: EdgeInsets.only(right: 20.0),
//                         child: Icon(Icons.delete, color: Colors.white),
//                       ),
//                     ),
//                     child: ListTile(
//                       onTap: () {},
//                       leading: ClipRRect(
//                         borderRadius: BorderRadius.circular(5.0),
//                         child: Container(
//                           width: 56.0,
//                           height: 56.0,
//                           color: Colors.blue,
//                           child: Image.network(
//                             item.productImageUrls.isNotEmpty
//                                 ? item.productImageUrls[0]
//                                 : 'https://via.placeholder.com/56', // Dummy image
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                       ),
//                       title: Row(
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.only(top: 15),
//                             child: Text(
//                               item.title, // Default title
//                               style: const TextStyle(fontSize: 14),
//                             ),
//                           ),
//                           const SizedBox(width: 100),
//                           Padding(
//                             padding: const EdgeInsets.only(top: 15),
//                             child: Text(
//                               '\$${((double.tryParse(item.discountprice) ?? 0.0) * (item.quantity?.toInt() ?? 1)).toStringAsFixed(2)}',
//                               style:
//                                   const TextStyle(fontWeight: FontWeight.bold),
//                             ),
//                           ),
//                         ],
//                       ),
//                       subtitle: Row(
//                         children: [
//                           Text(
//                             'In stock',
//                             style: TextStyle(
//                               color: Theme.of(context).colorScheme.secondary,
//                               fontWeight: FontWeight.w700,
//                             ),
//                           ),
//                           const SizedBox(width: 80),
//                           IconButton(
//                             onPressed: () => updateQuantity(index, -1),
//                             icon: const Icon(Icons.remove, size: 18),
//                             constraints: const BoxConstraints(
//                                 maxHeight: 20, maxWidth: 20),
//                             padding: EdgeInsets.zero,
//                           ),
//                           SizedBox(
//                             width: 5,
//                             child: Center(
//                                 child: Text(
//                                     '${item.quantity ?? 1}')), // Default quantity
//                           ),
//                           IconButton(
//                             onPressed: () => updateQuantity(index, 1),
//                             icon: const Icon(Icons.add, size: 18),
//                             constraints: const BoxConstraints(
//                                 maxHeight: 20, maxWidth: 20),
//                             padding: EdgeInsets.zero,
//                           ),
//                         ],
//                       ),
//                     ));
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20.0),
//             child: Column(
//               children: <Widget>[
//                 Padding(
//                   padding: const EdgeInsets.only(bottom: 30.0),
//                   child: Row(
//                     children: <Widget>[
//                       const Expanded(
//                         child: Text(
//                           "TOTAL",
//                           style: TextStyle(fontSize: 16, color: Colors.grey),
//                         ),
//                       ),
//                       Text(
//                         "\$${total.toStringAsFixed(2)}",
//                         style: const TextStyle(
//                             fontSize: 20, fontWeight: FontWeight.bold),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(bottom: 15.0),
//                   child: Row(
//                     children: <Widget>[
//                       const Expanded(
//                           child:
//                               Text("Subtotal", style: TextStyle(fontSize: 14))),
//                       Text("\$${subtotal.toStringAsFixed(2)}",
//                           style: const TextStyle(
//                               fontSize: 14, color: Colors.grey)),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(bottom: 15.0),
//                   child: Row(
//                     children: <Widget>[
//                       const Expanded(
//                           child:
//                               Text("Shipping", style: TextStyle(fontSize: 14))),
//                       Text("\$${shippingCost.toStringAsFixed(2)}",
//                           style: const TextStyle(
//                               fontSize: 14, color: Colors.grey)),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(bottom: 15.0),
//                   child: Row(
//                     children: <Widget>[
//                       const Expanded(
//                           child: Text("Tax", style: TextStyle(fontSize: 14))),
//                       Text("\$${totalTax.toStringAsFixed(2)}",
//                           style: const TextStyle(
//                               fontSize: 14, color: Colors.grey)),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Padding(
//             padding:
//                 const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
//             child: ElevatedButton(
//               onPressed: () {
//                 placeOrder();
//               },
//               style: ElevatedButton.styleFrom(
//                 minimumSize: const Size(double.infinity, 40.0),
//               ),
//               child: const Text(
//                 "CHECKOUT",
//                 style: TextStyle(color: Colors.purple, fontSize: 16),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
