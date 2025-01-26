import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ticket_wise/models/event_model.dart';
import 'package:ticket_wise/screens/event_detail_screen.dart';
import 'package:ticket_wise/utils/utils.dart';
import 'package:ticket_wise/widgets/constants.dart';

class EventCard extends StatelessWidget {
  final EventModel event;

  const EventCard({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Utils.navigateTo(
          context,
          EventDetailScreen(
            event: event,
          ),
        );
      },
      child: Card(
        color: PrimaryColor,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              Container(
                height: 120,
                width: 130,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: event.eventImageUrls.isNotEmpty
                        ? event.eventImageUrls.first
                        : '',
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Product details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and rating
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            event.title,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // Container(
                        //   padding: const EdgeInsets.symmetric(
                        //       horizontal: 6, vertical: 2),
                        //   decoration: BoxDecoration(
                        //     color: Colors.blue,
                        //     borderRadius: BorderRadius.circular(8),
                        //   ),
                        //   child: Text(
                        //     '9/10', // You may replace with the actual rating
                        //     style: const TextStyle(
                        //       color: Colors.white,
                        //       fontSize: 12,
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // Location and year/mileage/fuelType row
                    Text(
                      event.location, // Replace with actual location
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      event.eventDate, // Replace with actual details
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Price and certification status
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$${event.ticketPrice}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
