// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:will_haben_auto/models/product_model.dart';
// import 'package:will_haben_auto/provider/product_provider.dart';
// import 'package:will_haben_auto/screens/product_detail_screen.dart';
// import 'package:will_haben_auto/utils/utils.dart';
// import 'package:provider/provider.dart';
// import 'package:flutter_rating_stars/flutter_rating_stars.dart';

// class WishList extends StatefulWidget {
//   const WishList({super.key});

//   @override
//   WishlistState createState() => WishlistState();
// }

// class WishlistState extends State<WishList> {
//   late Future<List<ProductModel>> _wishlistFuture;

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     final productProvider = Provider.of<ProductProvider>(context);
//     final userId = FirebaseAuth.instance.currentUser!
//         .uid; // Get this dynamically from your auth system

//     _wishlistFuture = productProvider
//         .fetchWishlist(userId)
//         .then((wishlist) => wishlist.products);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Wishlist'),
//       ),
//       body: FutureBuilder<List<ProductModel>>(
//         future: _wishlistFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }
//           if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const Center(child: Text('No items in wishlist'));
//           }

//           final products = snapshot.data!;

//           return ListView.builder(
//             itemCount: products.length,
//             itemBuilder: (context, index) {
//               final item = products[index];
//               return Dismissible(
//                 key: Key(item.id),
//                 onDismissed: (direction) {
//                   final productProvider =
//                       Provider.of<ProductProvider>(context, listen: false);
//                   if (direction == DismissDirection.endToStart) {
//                     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                         content: Text("${item.title} removed from wishlist"),
//                         duration: const Duration(seconds: 1)));
//                     productProvider.deleteFromWishlist(
//                         item.id, FirebaseAuth.instance.currentUser!.uid);
//                   } else {
//                     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                         content: Text("${item.title} added to cart"),
//                         duration: const Duration(seconds: 1)));
//                     productProvider.addToCart(item);
//                   }
//                 },
//                 background: Container(
//                   decoration: const BoxDecoration(color: Colors.green),
//                   padding: const EdgeInsets.all(5.0),
//                   child: const Row(
//                     children: <Widget>[
//                       Padding(
//                         padding: EdgeInsets.only(left: 20.0),
//                         child:
//                             Icon(Icons.add_shopping_cart, color: Colors.white),
//                       ),
//                     ],
//                   ),
//                 ),
//                 secondaryBackground: Container(
//                   decoration: const BoxDecoration(color: Colors.red),
//                   padding: const EdgeInsets.all(5.0),
//                   child: const Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: <Widget>[
//                       Padding(
//                         padding: EdgeInsets.only(right: 20.0),
//                         child: Icon(Icons.delete, color: Colors.white),
//                       ),
//                     ],
//                   ),
//                 ),
//                 child: InkWell(
//                   onTap: () {
//                     Utils.navigateTo(
//                         context,
//                         ProductDetailScreen(
//                             imageUrl: item.productImageUrls,
//                             videoUrl: item.productvideourl,
//                             title: item.title,
//                             originalPrice: item.originalPrice,
//                             price: item.discountprice,
//                             rating: item.rating,
//                             id: item.id,
//                             category: item.category,
//                             color: item.color,
//                             description: item.description));
//                   },
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: <Widget>[
//                       const Divider(height: 0),
//                       Padding(
//                         padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
//                         child: ListTile(
//                           trailing: const Icon(Icons.swap_horiz),
//                           leading: ClipRRect(
//                             borderRadius: BorderRadius.circular(5.0),
//                             child: Container(
//                               width: 56.0,
//                               height: 56.0,
//                               decoration:
//                                   const BoxDecoration(color: Colors.blue),
//                               child: Image.network(
//                                 item.productImageUrls.first,
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           ),
//                           title: Text(
//                             item.title,
//                             style: const TextStyle(fontSize: 14),
//                           ),
//                           subtitle: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: <Widget>[
//                               Row(
//                                 children: <Widget>[
//                                   Padding(
//                                     padding: const EdgeInsets.only(
//                                         top: 2.0, bottom: 1),
//                                     child: Text(
//                                         '\$${item.discountprice}', // Adjust according to your model
//                                         style: TextStyle(
//                                           color: Theme.of(context)
//                                               .colorScheme
//                                               .secondary,
//                                           fontWeight: FontWeight.w700,
//                                         )),
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.only(left: 6.0),
//                                     child: Text(
//                                         '(\$${item.originalPrice})', // Adjust according to your model
//                                         style: const TextStyle(
//                                             fontWeight: FontWeight.w700,
//                                             fontStyle: FontStyle.italic,
//                                             color: Colors.grey,
//                                             decoration:
//                                                 TextDecoration.lineThrough)),
//                                   )
//                                 ],
//                               ),
//                               Row(
//                                 children: <Widget>[
//                                   RatingStars(
//                                     value: item.rating,
//                                     starSize: 16,
//                                     valueLabelColor: Colors.amber,
//                                     starColor: Colors.amber,
//                                   )
//                                 ],
//                               )
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
