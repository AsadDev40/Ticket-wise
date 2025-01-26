import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ticket_wise/models/event_model.dart';
import 'package:ticket_wise/provider/event_provider.dart';
import 'package:searchable_listview/searchable_listview.dart';
import 'package:ticket_wise/screens/event_detail_screen.dart';
import 'package:ticket_wise/utils/utils.dart';
import 'package:ticket_wise/widgets/constants.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<EventModel> _events = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    final eventProvider = Provider.of<EventProvider>(context, listen: false);
    List<EventModel> events = await eventProvider.fetchEvents();
    setState(() {
      _events = events;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Search Events',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: PrimaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(12.0),
              child: SearchableList<EventModel>(
                searchFieldPadding: EdgeInsets.only(top: 20, bottom: 20),
                initialList: _events,
                itemBuilder: (EventModel event) => Card(
                  color: PrimaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        event.eventImageUrls.first,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      event.title,
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      event.location,
                      style: const TextStyle(color: Colors.white70),
                    ),
                    onTap: () {
                      Utils.navigateTo(
                          context, EventDetailScreen(event: event));
                    },
                  ),
                ),
                filter: (query) => _events
                    .where((event) =>
                        event.title.toLowerCase().contains(query.toLowerCase()))
                    .toList(),
                emptyWidget: const Center(child: Text('No events found')),
                inputDecoration: InputDecoration(
                  labelText: "Search Events",
                  labelStyle: TextStyle(color: PrimaryColor),
                  fillColor: Colors.white,
                  filled: true,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: PrimaryColor, width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  ),
                ),
              ),
            ),
    );
  }
}
