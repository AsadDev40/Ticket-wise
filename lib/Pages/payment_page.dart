// // ignore_for_file: avoid_print

// import 'package:flutter/material.dart';
// import 'package:will_haben_auto/models/card_model.dart';
// import 'package:will_haben_auto/models/product_model.dart';
// import 'package:will_haben_auto/payment/body.dart';
// import 'package:will_haben_auto/payment/res.dart';

// class PaymentPage extends StatelessWidget {
//   final double totalPayment; // Dynamic total payment
//   final List<ProductModel> product;

//   const PaymentPage(
//       {super.key, required this.totalPayment, required this.product});

//   @override
//   Widget build(BuildContext context) {
//     List<PayCard> payments = Res.getPaymentTypes();
//     for (var element in payments) {
//       print(element.title);
//     }
//     return Scaffold(
//       appBar: payActionbar(),
//       body: Column(
//         children: [
//           creditcardImage(),
//           choosePaymentType(totalPayment: totalPayment, product: product),
//         ],
//       ),
//     );
//   }
// }
