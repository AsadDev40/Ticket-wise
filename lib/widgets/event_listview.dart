import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:ticket_wise/models/event_model.dart';
import 'package:ticket_wise/provider/event_provider.dart';
import 'package:ticket_wise/screens/edit_event_screen.dart';
import 'package:ticket_wise/screens/event_detail_screen.dart';
import 'package:ticket_wise/utils/utils.dart';

class EventListView extends StatelessWidget {
  final List<EventModel> events;

  const EventListView({super.key, required this.events});

  @override
  Widget build(BuildContext context) {
    final productprovider = Provider.of<EventProvider>(context);
    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return InkWell(
          onTap: () {
            Utils.navigateTo(
              context,
              EventDetailScreen(
                event: event,
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Divider(height: 0),
              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: ListTile(
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.black),
                        onPressed: () {
                          Utils.navigateTo(
                              context,
                              EditEventScreen(
                                event: event,
                              ));
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.black),
                        onPressed: () async {
                          productprovider.deleteEvent(event.id);
                        },
                      ),
                    ],
                  ),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: Container(
                      height: 48,
                      width: 48,
                      decoration: const BoxDecoration(color: Colors.blue),
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: event.eventImageUrls.first,
                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                  ),
                  title: Text(
                    event.title,
                    style: const TextStyle(fontSize: 14),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 2.0, bottom: 1),
                            child: Text(
                              '\$${event.ticketPrice}',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 6.0),
                            child: Text(
                              '(${event.eventDate})',
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.italic,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
