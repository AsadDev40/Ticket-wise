// ignore_for_file: unused_local_variable, avoid_print, use_build_context_synchronously

import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pay_with_paystack/pay_with_paystack.dart';
import 'package:share_plus/share_plus.dart';
import 'package:ticket_wise/models/ticket_model.dart';
import 'package:ticket_wise/models/event_model.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ticket_wise/models/user_model.dart';
import 'package:ticket_wise/screens/ticket_screen.dart';
import 'package:ticket_wise/utils/utils.dart';
import 'package:ticket_wise/widgets/constants.dart';

class TicketProvider with ChangeNotifier {
  final CollectionReference ticketCollection =
      FirebaseFirestore.instance.collection('tickets');
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // List to hold tickets
  List<TicketModel> _tickets = [];

  // Getter to retrieve the tickets list
  List<TicketModel> get tickets => _tickets;

  // Function to add a new ticket to Firestore and local list
  Future<void> addTicket(TicketModel newOrder) async {
    try {
      DocumentReference docRef = await ticketCollection.add(newOrder.toJson());

      TicketModel updatTicket = newOrder.copyWith(tickeId: docRef.id);

      _tickets.add(updatTicket);

      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  // Function to fetch all ticket from Firestore for a specific user
  Future<void> fetchTickets(String userId) async {
    try {
      QuerySnapshot snapshot = await ticketCollection
          .where('customerId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      _tickets = snapshot.docs
          .map(
              (doc) => TicketModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  // Function to remove an order from Firestore and local list
  Future<void> removeTicket(String orderId) async {
    try {
      await ticketCollection.doc(orderId).delete();
      _tickets.removeWhere((order) => order.ticketId == orderId);
      notifyListeners(); // Notify UI of changes
    } catch (e) {
      rethrow;
    }
  }

  // Function to update the status of an order in Firestore and locally
  Future<void> updateticketStatus(String orderId, String newStatus) async {
    final orderIndex =
        _tickets.indexWhere((order) => order.ticketId == orderId);
    if (orderIndex != -1) {
      try {
        await ticketCollection.doc(orderId).update({'status': newStatus});
        _tickets[orderIndex] = _tickets[orderIndex].copyWith(status: newStatus);
        notifyListeners();
      } catch (e) {
        rethrow;
      }
    }
  }

  Future<void> updateTicketQuantity(
      EventModel event, int purchasedQuantity) async {
    try {
      // Get the reference to the event document
      DocumentReference eventDoc =
          FirebaseFirestore.instance.collection('events').doc(event.id);

      // Fetch the current ticket quantity from Firestore
      DocumentSnapshot eventSnapshot = await eventDoc.get();
      if (eventSnapshot.exists) {
        int currentQuantity = int.parse(eventSnapshot.get('quantity'));

        // Calculate the new ticket quantity
        int updatedQuantity = currentQuantity - purchasedQuantity;

        // Ensure the updated quantity is not negative
        if (updatedQuantity < 0) {
          throw Exception("Insufficient tickets available.");
        }

        // Update the ticket quantity in Firestore
        await eventDoc.update({'quantity': updatedQuantity.toString()});

        print("Ticket quantity updated successfully.");
      } else {
        throw Exception("Event not found.");
      }
    } catch (e) {
      print("Error updating ticket quantity: \$e");
      rethrow;
    }
  }

  // Function to show ticket dialog and handle event ticket creation
  Future<void> showTicketDialog(
      BuildContext context, EventModel event, UserModel user) async {
    int selectedQuantity = 1;
    double totalPrice = double.parse(event.ticketPrice) * selectedQuantity;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: const Text("Select Ticket Quantity"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Total Price: ",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '\$${totalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Quantity: ",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.remove,
                        size: 20,
                      ),
                      onPressed: () {
                        if (selectedQuantity > 1) {
                          setState(() {
                            selectedQuantity--;
                            totalPrice = double.parse(event.ticketPrice) *
                                selectedQuantity;
                          });
                        }
                      },
                    ),
                    Text(
                      "$selectedQuantity",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.add,
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() {
                          selectedQuantity++;
                          totalPrice = double.parse(event.ticketPrice) *
                              selectedQuantity;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(PrimaryColor)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white),
                  )),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(PrimaryColor)),
                onPressed: () async {
                  final isPaymentSuccessful = await processPayment(
                    context,
                    totalPrice,
                    user.email,
                  );

                  if (isPaymentSuccessful) {
                    EasyLoading.show();
                    // Generate ticket after successful payment
                    final ticketPath = await generateTickets(
                        event, selectedQuantity, totalPrice, user);
                    await updateTicketQuantity(event, selectedQuantity);

                    EasyLoading.dismiss();
                    Navigator.of(context).pop();
                    Utils.navigateTo(context, TicketScreen());
                    Utils.showToast('Tickets Purchased Successfully');
                  } else {
                    Utils.showToast('Payment Failed');
                  }
                },
                child: const Text(
                  'Confirm',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<bool> processPayment(
      BuildContext context, double totalPrice, String userEmail) async {
    try {
      int amountInCents = (totalPrice * 100).toInt();

      // Initiate Paystack payment
      final response = await PayWithPayStack().now(
        context: context,
        secretKey: 'sk_test_ab2922dc1705af486b7075544db704ef7d44add3',
        customerEmail: userEmail,
        reference: DateTime.now().millisecondsSinceEpoch.toString(),
        currency: 'ZAR',
        amount: amountInCents.toDouble(),
        callbackUrl: 'https://google.com',
        transactionCompleted: () {
          Utils.showToast('Payment Successful');
        },
        transactionNotCompleted: (String) {
          Utils.showToast('Payment Failed');
        }, // Total amount in cents
      );

      if (response.status == true) {
        print('Payment Successful: ${response.reference}');
        return true;
      } else {
        print('Payment Failed');
        return false;
      }
    } catch (e) {
      print('Error during payment: $e');
      return false;
    }
  }

  Future<String?> generateTickets(EventModel event, int selectedQuantity,
      double totalPrice, UserModel user) async {
    String? ticketPath;

    // Get the first image from event image URLs
    String eventImageUrl = event.eventImageUrls.first;

    for (int i = 0; i < selectedQuantity; i++) {
      final ticketId = DateTime.now().millisecondsSinceEpoch.toString();
      final qrCodeImage = await generateQRCode(ticketId);
      final qrCodeUrl = await uploadFileToFirebaseStorage(
          qrCodeImage, ticketId, "tickets/qrcodes");

      final newTicket = TicketModel(
          ticketId: ticketId,
          eventId: event.id,
          eventTitle: event.title,
          quantity: 1,
          price: double.parse(event.ticketPrice),
          customerId: user.uid,
          status: "open",
          customername: user.userName,
          customeraddress: user.address.toString(),
          customerphone: user.phone.toString(),
          createdAt: DateTime.now(),
          eventimage: eventImageUrl,
          city: event.city,
          location: event.location,
          starttime: event.startTime,
          endtime: event.endTime,
          qrimage: qrCodeUrl);

      // Add ticket to Firestore
      await addTicket(newTicket);

      ticketPath = qrCodeUrl;
    }

    return ticketPath;
  }

  Future<Uint8List> generateQRCode(String ticketId) async {
    final qrPainter = QrPainter(
      data: ticketId,
      version: QrVersions.auto,
      gapless: false,
    );
    final image = await qrPainter.toImage(300);
    final byteData = await image.toByteData(format: ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  Future<String?> uploadFileToFirebaseStorage(
      Uint8List fileBytes, String fileName, String folder) async {
    try {
      final storageRef = _storage.ref().child('$folder/$fileName.png');
      final uploadTask = storageRef.putData(fileBytes);
      final snapshot = await uploadTask.whenComplete(() => null);
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print("Error uploading file: $e");
    }
    return null;
  }

  Future<void> downloadTicket(String ticketPath) async {
    Permission.storage.request();
    final directory = await getExternalStorageDirectory(); // For Android
    final fileName = ticketPath.split('/').last;
    final downloadPath = '${directory?.path}/$fileName';
    final downloadedFile = await File(ticketPath).copy(downloadPath);
  }

  Future<void> shareTicket(String ticketPath) async {
    try {
      final file =
          XFile(ticketPath); // Convert the file path to an XFile object
      await Share.shareXFiles(
        [file], // Pass the XFile object
        text: "Check out my event ticket!",
      );
    } catch (e) {
      // Handle error if share fails
    }
  }
}
