// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors_in_immutables, use_build_context_synchronously

import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
// import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ticket_wise/models/ticket_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ticket_wise/widgets/constants.dart';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class TicketDetailScreen extends StatefulWidget {
  final TicketModel ticket;

  TicketDetailScreen({super.key, required this.ticket});

  @override
  _TicketDetailScreenState createState() => _TicketDetailScreenState();
}

class _TicketDetailScreenState extends State<TicketDetailScreen> {
  final GlobalKey _captureKey = GlobalKey();
  // double _userRating = 0.0;
  // bool _isRatingSubmitted = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    // _checkRatingStatus();
  }

  Future<void> _saveAsImage() async {
    var status =
        await Permission.storage.request(); // Request storage permission
    print('status: $status');
    try {
      RenderRepaintBoundary boundary = _captureKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);

      // Create an image with a white background
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(
          recorder,
          Rect.fromPoints(const Offset(0, 0),
              Offset(image.width.toDouble(), image.height.toDouble())));
      canvas.drawColor(
          Colors.white, BlendMode.srcOver); // Draw white background

      // Draw the captured image on top of the white background
      canvas.drawImage(image, const Offset(0, 0), Paint());
      final picture = recorder.endRecording();
      final img = await picture.toImage(image.width, image.height);

      ByteData? byteData = await img.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      // Get directory path to save the image (use external storage for gallery visibility)
      final directory = await getExternalStorageDirectory();
      final imagePath = File('${directory!.path}/ticket_image.png');

      // Save the image as a PNG file to the path
      await imagePath.writeAsBytes(pngBytes);

      // Save the image to gallery
      final result = await ImageGallerySaverPlus.saveFile(
          imagePath.path); // Save to gallery

      if (result != null) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Ticket saved to gallery!')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to save ticket to gallery')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to save ticket: $e')));
    }
  }

  // Method to share the widget as an image on WhatsApp
  Future<void> _shareOnWhatsApp(
      BuildContext context, GlobalKey _captureKey) async {
    try {
      RenderRepaintBoundary boundary = _captureKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);

      // Create an image with a white background
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(
          recorder,
          Rect.fromPoints(const Offset(0, 0),
              Offset(image.width.toDouble(), image.height.toDouble())));
      canvas.drawColor(
          Colors.white, BlendMode.srcOver); // Draw white background

      // Draw the captured image on top of the white background
      canvas.drawImage(image, const Offset(0, 0), Paint());
      final picture = recorder.endRecording();
      final img = await picture.toImage(image.width, image.height);

      ByteData? byteData = await img.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      // Get a temporary directory to save the image
      final directory = await getTemporaryDirectory();
      final imagePath = File('${directory.path}/ticket_image.png');

      // Save the image as a PNG file to the path
      await imagePath.writeAsBytes(pngBytes);

      // Convert the file path to an XFile
      XFile xFile = XFile(imagePath.path);

      // Share the image via WhatsApp
      await Share.shareXFiles([xFile], text: 'Check out my ticket!');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to share ticket: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: PrimaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Ticket Details',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              RepaintBoundary(
                key: _captureKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    CachedNetworkImage(
                      imageUrl: widget.ticket.qrimage.toString(),
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) => const Center(
                          child: Text(
                              'Network Error Please Check your Internet Connection')),
                    ),

                    const SizedBox(height: 16.0),

                    buildInfoCard(
                      Icons.person,
                      'Name',
                      widget.ticket.customername,
                    ),
                    buildInfoCard(
                      Icons.title,
                      'Event Title',
                      widget.ticket.eventTitle,
                    ),
                    buildInfoCard(
                      Icons.call,
                      'Phone Number',
                      widget.ticket.customerphone,
                    ),
                    buildInfoCard(
                      Icons.badge,
                      'Ticket Id',
                      widget.ticket.ticketId,
                    ),
                    buildInfoCard(
                      Icons.calendar_today,
                      'Ticket Purchase Date',
                      DateFormat('yyyy-MM-dd').format(widget.ticket.createdAt),
                    ),
                    buildInfoCard(
                      Icons.alarm,
                      'Event Start Time',
                      widget.ticket.starttime.toString(),
                    ),
                    buildInfoCard(
                      Icons.alarm,
                      'Event End Time',
                      widget.ticket.endtime.toString(),
                    ),
                    buildInfoCard(
                      Icons.location_city,
                      'City',
                      widget.ticket.city.toString(),
                    ),
                    buildInfoCard(
                      Icons.location_on,
                      'Location',
                      widget.ticket.location.toString(),
                    ),
                    buildInfoCard(
                      Icons.attach_money,
                      'Total Price',
                      '\$${widget.ticket.price}',
                    ),

                    const SizedBox(height: 16.0),

                    // Rating Section (only if not submitted and order is delivered)
                    // if (!_isRatingSubmitted &&
                    //     widget.ticket.status == 'Delivered')
                    //   buildRatingSection(),
                  ],
                ),
              ),
              SizedBox(
                height: 60,
                width: 210,
                child: ElevatedButton(
                    style: const ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(PrimaryColor)),
                    onPressed: () {
                      _saveAsImage();
                    },
                    child: const Row(
                      children: [
                        Icon(
                          Icons.download,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Download Ticket',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    )),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 60,
                width: 210,
                child: ElevatedButton(
                    style: const ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(PrimaryColor)),
                    onPressed: () {
                      _shareOnWhatsApp(context, _captureKey);
                    },
                    child: const Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.whatsapp,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Share on Whatsapp',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build info cards
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
              fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white),
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
}
