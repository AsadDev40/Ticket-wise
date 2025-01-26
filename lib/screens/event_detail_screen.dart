// ignore_for_file: deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ticket_wise/models/event_model.dart';
import 'package:ticket_wise/models/user_model.dart';
import 'package:ticket_wise/provider/ticket_provider.dart';
import 'package:provider/provider.dart';
import 'package:ticket_wise/widgets/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

class EventDetailScreen extends StatefulWidget {
  final EventModel event;

  const EventDetailScreen({Key? key, required this.event}) : super(key: key);

  @override
  _EventDetailScreenState createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  late VideoPlayerController _videoController;
  int selectedQuantity = 1;
  double totalPrice = 0.0;
  UserModel? currentUser;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.network(widget.event.eventvideourl)
      ..initialize().then((_) {
        setState(() {}); // Ensure the first frame is shown
      });
    _loadUserData();
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    // Fetch current user UID
    String uid = FirebaseAuth.instance.currentUser!.uid;

    // Fetch the user data from Firestore
    UserModel user = await getUserFromFirestore(uid);
    setState(() {
      currentUser = user;
    });
  }

  Future<UserModel> getUserFromFirestore(String uid) async {
    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (userDoc.exists) {
      return UserModel.fromJson(userDoc.data()!);
    } else {
      throw Exception("User not found");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: PrimaryColor,
        title: Text(
          widget.event.title,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CarouselSlider.builder(
                  itemCount: widget.event.eventImageUrls.length +
                      1, // Include the video
                  itemBuilder: (context, index, realIndex) {
                    if (index < widget.event.eventImageUrls.length) {
                      // Display image
                      return CachedNetworkImage(
                        imageUrl: widget.event.eventImageUrls[index],
                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      );
                    } else {
                      return _videoController.value.isInitialized
                          ? GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (_videoController.value.isPlaying) {
                                    _videoController.pause();
                                  } else {
                                    _videoController.play();
                                  }
                                });
                              },
                              child: AspectRatio(
                                aspectRatio: _videoController.value.aspectRatio,
                                child: VideoPlayer(_videoController),
                              ),
                            )
                          : const Center(child: CircularProgressIndicator());
                    }
                  },
                  options: CarouselOptions(
                    height: 300,
                    enlargeCenterPage: true,
                    autoPlay: true,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildInfoCard(
                          Icons.title, 'Event Title', widget.event.title),
                      buildInfoCard(Icons.calendar_today, 'Event Date',
                          '${widget.event.eventDate} '),
                      buildInfoCard(Icons.alarm, 'Event Start Time',
                          '${widget.event.startTime} '),
                      buildInfoCard(Icons.alarm, 'Event End Time',
                          '${widget.event.endTime} '),
                      buildInfoCard(Icons.attach_money, 'Ticket Price',
                          '\$${widget.event.ticketPrice}'),
                      buildInfoCard(Icons.location_city, 'City',
                          widget.event.city.toString()),
                      buildInfoCard(
                          Icons.location_on, 'Location', widget.event.location),
                      buildInfoCard(Icons.description, 'Description',
                          '${widget.event.description} '),
                      const SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: ElevatedButton(
                          onPressed: (currentUser != null &&
                                  DateTime.now().isBefore(
                                      DateTime.parse(widget.event.eventDate)) &&
                                  widget.event.quantity != "0")
                              ? () {
                                  showTicketDialog(context);
                                }
                              : null, // Disable button if conditions are not met
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(150, 50),
                            backgroundColor: (widget.event.quantity == "0" ||
                                    DateTime.now().isAfter(
                                        DateTime.parse(widget.event.eventDate)))
                                ? Colors
                                    .grey // Disable color if no tickets or event date has passed
                                : PrimaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 5,
                          ),
                          child: const Text(
                            'Book Now',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> showTicketDialog(BuildContext context) async {
    final ticketProvider = Provider.of<TicketProvider>(context, listen: false);
    await ticketProvider.showTicketDialog(context, widget.event, currentUser!);
  }
}

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

Widget buildActionIcon(IconData icon, String label, VoidCallback onPressed) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      IconButton(
        icon: Icon(icon, color: Colors.blue),
        onPressed: onPressed,
      ),
      Text(
        label,
        style: const TextStyle(fontSize: 12, color: Colors.blue),
      ),
    ],
  );
}

void launchUrl(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
