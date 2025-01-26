import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:ticket_wise/models/event_model.dart';
import 'package:ticket_wise/screens/event_detail_screen.dart';
import 'package:ticket_wise/utils/utils.dart';

class EventSliderWidget extends StatelessWidget {
  final List<EventModel> events;

  const EventSliderWidget({super.key, required this.events});

  @override
  Widget build(BuildContext context) {
    // Limit the number of events to 5
    final limitedEvents = events.length > 5 ? events.sublist(0, 5) : events;

    return CarouselSlider.builder(
      itemCount: limitedEvents.length,
      itemBuilder: (context, index, realIndex) {
        final event = limitedEvents[index];

        return GestureDetector(
          onTap: () {
            Utils.navigateTo(context, EventDetailScreen(event: event));
          },
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 5.0,
            child: Stack(
              children: [
                // Event Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Image.network(
                    event.eventImageUrls.isNotEmpty
                        ? event.eventImageUrls[0]
                        : 'https://via.placeholder.com/150', // Default image if empty
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
                // Black overlay with opacity
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black
                        .withOpacity(0.5), // Black overlay with opacity
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
                // Event Details Text
                Positioned(
                  bottom: 10.0,
                  left: 10.0,
                  right: 10.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Event Title
                      Text(
                        event.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                      // Event Ticket Price
                      Text(
                        'Ticket: \$${event.ticketPrice}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 5),
                      // Event Date
                      Text(
                        'Date: ${event.eventDate}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      options: CarouselOptions(
        height: 250.0,
        autoPlay: true, // Auto-play the carousel
        autoPlayInterval:
            const Duration(seconds: 3), // Change slides every 3 seconds
        enlargeCenterPage: true, // Enlarge the centered item
        aspectRatio: 16 / 9, // Aspect ratio of the slider
        viewportFraction: 0.8, // Fraction of the screen occupied by each item
        enableInfiniteScroll: true, // Infinite scrolling
      ),
    );
  }
}
