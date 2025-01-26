// ignore_for_file: library_private_types_in_public_api

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:ticket_wise/models/event_model.dart';
import 'package:ticket_wise/provider/event_provider.dart';
import 'package:ticket_wise/widgets/constants.dart';
import 'package:ticket_wise/widgets/event_listview.dart';

class YourEventsScreen extends StatefulWidget {
  const YourEventsScreen({super.key});

  @override
  _YourEventsScreenState createState() => _YourEventsScreenState();
}

class _YourEventsScreenState extends State<YourEventsScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> _refreshProducts() async {
    await Provider.of<EventProvider>(context, listen: false).fetchEvents();
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        // ignore: prefer_const_constructors
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: PrimaryColor,
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              // scaffoldKey.currentState!
              // .showBottomSheet((context) => const ShopSearch());
            },
          )
        ],
        title: const Text(
          'My Events',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: FutureBuilder<List<EventModel>>(
        future: Provider.of<EventProvider>(context, listen: false)
            .fetchEventsByUserId(userId),
        builder:
            (BuildContext context, AsyncSnapshot<List<EventModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading Events'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No Tickets available'));
          } else {
            return RefreshIndicator(
              onRefresh: _refreshProducts,
              child: EventListView(events: snapshot.data!),
            );
          }
        },
      ),
    );
  }
}
