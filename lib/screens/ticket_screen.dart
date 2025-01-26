// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:cached_network_image/cached_network_image.dart'; // For better image loading
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ticket_wise/provider/ticket_provider.dart';
import 'package:ticket_wise/screens/ticket_detail_screen.dart';
import 'package:ticket_wise/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:ticket_wise/models/ticket_model.dart';
import 'package:intl/intl.dart';
import 'package:ticket_wise/widgets/constants.dart';

class TicketScreen extends StatefulWidget {
  @override
  _TicketScreenState createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> {
  Future<void>? _fetchTicketsFuture;

  @override
  void initState() {
    super.initState();
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      final ticketProvider =
          Provider.of<TicketProvider>(context, listen: false);
      _fetchTicketsFuture = ticketProvider.fetchTickets(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      return const Center(child: Text('User not logged in'));
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: PrimaryColor,
        title: const Text(
          'Your tickets',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: _fetchTicketsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final ticketProvider = Provider.of<TicketProvider>(context);
            return ticketProvider.tickets.isNotEmpty
                ? ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: ticketProvider.tickets.length,
                    itemBuilder: (context, index) {
                      final order = ticketProvider.tickets[index];
                      return buildTicketCard(order, context);
                    },
                  )
                : Center(
                    child: Text('No tickets Availiable'),
                  );
          }
        },
      ),
    );
  }
}

Widget buildTicketCard(TicketModel order, BuildContext context) {
  return Card(
    color: PrimaryColor,
    margin: const EdgeInsets.only(bottom: 16.0),
    elevation: 6.0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15.0),
    ),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage:
                    CachedNetworkImageProvider(order.eventimage.toString()),
                backgroundColor: Colors.grey[200],
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.eventTitle,
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('yyyy-MM-dd').format(order.createdAt),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
            ],
          ),
          const SizedBox(height: 12),
          Divider(color: Colors.grey[300]),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total: \$${order.price}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                width: 128, // Fixed width for button
                height: 35, // Fixed height for button
                child: ElevatedButton(
                  onPressed: () {
                    Utils.navigateTo(
                        context, TicketDetailScreen(ticket: order));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // Custom color for button
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'View Details',
                    style: TextStyle(
                        fontSize: 14,
                        color: PrimaryColor), // Consistent font size
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
