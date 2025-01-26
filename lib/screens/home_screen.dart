import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ticket_wise/Pages/category_page.dart';
import 'package:ticket_wise/Pages/city_page.dart';
import 'package:ticket_wise/Pages/event_page.dart';
import 'package:ticket_wise/Pages/search_page.dart';

import 'package:ticket_wise/models/city_model.dart';
import 'package:ticket_wise/models/event_model.dart';
import 'package:ticket_wise/provider/category_provider.dart';
import 'package:ticket_wise/provider/cities_provider.dart';
import 'package:ticket_wise/provider/event_provider.dart';
import 'package:ticket_wise/screens/category_screen.dart';
import 'package:ticket_wise/screens/event_detail_screen.dart';
import 'package:ticket_wise/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:ticket_wise/widgets/constants.dart';
import 'package:ticket_wise/widgets/drawer.dart';
import 'package:ticket_wise/widgets/event_slider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  late Future<List<CityModel>> _cityFuture;
  late Future<List<EventModel>> _eventFuture;

  @override
  void initState() {
    super.initState();
    final cityProvider = Provider.of<CityProvider>(context, listen: false);
    _cityFuture = cityProvider.fetchCities();
    final eventprovider = Provider.of<EventProvider>(context, listen: false);
    _eventFuture = eventprovider.fetchEvents();
  }

  @override
  Widget build(BuildContext context) {
    final eventprovider = Provider.of<EventProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Ticket Wise',
            style: GoogleFonts.fraunces(
              textStyle: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            )),
        backgroundColor: PrimaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Utils.navigateTo(context, SearchPage());
              },
              icon: const Icon(Icons.search))
        ],
      ),
      drawer: const CustomDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 10,
            ),
            FutureBuilder<List<EventModel>>(
              future: _eventFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  // Show an error message if the request fails
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No events available');
                } else {
                  return EventSliderWidget(events: snapshot.data!);
                }
              },
            ),
            FadeInUp(
                duration: const Duration(milliseconds: 1400),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const Text(
                            "Categories",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          InkWell(
                            child: const Text("All"),
                            onTap: () {
                              Utils.navigateTo(context, const CategoryScreen());
                            },
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 150,
                        child: Consumer<CategoryProvider>(
                          builder: (context, categoryProvider, child) {
                            if (categoryProvider.categories.isEmpty) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: categoryProvider.categories.length,
                              itemBuilder: (context, index) {
                                final category =
                                    categoryProvider.categories[index];
                                return makeCategory(
                                    image: category
                                        .categoryImageurl, // Assuming image path
                                    title: category.categoryName,
                                    tag: category.categoryId,
                                    category: category.categoryName);
                              },
                            );
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const Text(
                            "Upcoming Events",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          GestureDetector(
                              onTap: () {
                                Utils.navigateTo(context, const Eventpage());
                              },
                              child: const Text("All"))
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 150,
                        child: FutureBuilder<List<EventModel>>(
                          future: eventprovider
                              .fetchLatestEvents(), // Fetch categories by type directly
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child:
                                      CircularProgressIndicator()); // Show loading spinner
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Text(
                                      'Error: ${snapshot.error}')); // Show error message
                            } else if (snapshot.hasData &&
                                snapshot.data!.isNotEmpty) {
                              final products = snapshot.data!;
                              return ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: products.length,
                                itemBuilder: (context, index) {
                                  final product = products[index];
                                  final EventModel newproduct = EventModel(
                                    id: product.id,
                                    title: product.title,
                                    category: product.category,
                                    description: product.description,
                                    eventImageUrls: product.eventImageUrls,
                                    eventvideourl: product.eventvideourl,
                                    ticketPrice: product.ticketPrice,
                                    eventDate: product.eventDate,
                                    location: product.location,
                                  );

                                  return eventwidget(product: newproduct);
                                },
                              );
                            } else {
                              return const Center(
                                  child: Text('No Event  found.'));
                            }
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const Text(
                            "Events By Cities",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          GestureDetector(
                              onTap: () {
                                Utils.navigateTo(context, const Eventpage());
                              },
                              child: const Text("All"))
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 150,
                        child: FutureBuilder<List<CityModel>>(
                          future: _cityFuture, // Fetch cities data
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              ); // Show loading spinner
                            } else if (snapshot.hasError) {
                              return Center(
                                child: Text('Error: ${snapshot.error}'),
                              ); // Show error message
                            } else if (snapshot.hasData &&
                                snapshot.data!.isNotEmpty) {
                              final cities = snapshot.data!;
                              return ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: cities.length,
                                itemBuilder: (context, index) {
                                  final city = cities[index];
                                  return makeBestcity(city: city);
                                },
                              );
                            } else {
                              return const Center(
                                child: Text('No cities found.'),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }

  Widget makeCategory({image, title, tag, category}) {
    return AspectRatio(
      aspectRatio: 2 / 2.2,
      child: Hero(
        tag: tag,
        child: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CategoryPage(
                          image: image,
                          title: title,
                          tag: tag,
                          category: category,
                        )));
          },
          child: Material(
            child: Container(
              margin: const EdgeInsets.only(right: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Stack(
                children: [
                  // Network Image with loading indicator
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      image,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          return child; // Image is fully loaded
                        } else {
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      (loadingProgress.expectedTotalBytes ?? 1)
                                  : null,
                            ),
                          ); // Show loading indicator
                        }
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(Icons.error, color: Colors.red),
                        ); // Show error icon if image fails to load
                      },
                    ),
                  ),
                  // Gradient overlay and title
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                        begin: Alignment.bottomRight,
                        colors: [
                          Colors.black.withOpacity(.8),
                          Colors.black.withOpacity(.0),
                        ],
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget makeBestcity({required CityModel city}) {
    return AspectRatio(
      aspectRatio: 3 / 2.2,
      child: GestureDetector(
        onTap: () {
          Utils.navigateTo(
            context,
            CityPage(
              city: city,
            ),
          );
        },
        child: Container(
          margin: const EdgeInsets.only(right: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Stack(
            children: [
              // Network Image with loading indicator
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  city.cityImageurl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child; // Image is fully loaded
                    } else {
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  (loadingProgress.expectedTotalBytes ?? 1)
                              : null,
                        ),
                      ); // Show loading indicator
                    }
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(Icons.error, color: Colors.red),
                    ); // Show error icon if image fails to load
                  },
                ),
              ),
              // Gradient overlay and title
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    begin: Alignment.bottomRight,
                    colors: [
                      Colors.black.withOpacity(.8),
                      Colors.black.withOpacity(.0),
                    ],
                  ),
                ),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    city.cityName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget makeBestBrandWidget({required String image, required String title}) {
    return AspectRatio(
      aspectRatio: 3 / 2.2,
      child: GestureDetector(
        onTap: () {
          Utils.navigateTo(
            context,
            CategoryPage(
              image: image,
              title: title,
              tag: title,
              category: title,
            ),
          );
        },
        child: Container(
          margin: const EdgeInsets.only(right: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Stack(
            children: [
              // Network Image with loading indicator
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  image,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child; // Image is fully loaded
                    } else {
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  (loadingProgress.expectedTotalBytes ?? 1)
                              : null,
                        ), // Show loading indicator
                      );
                    }
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(Icons.error, color: Colors.red),
                    ); // Show error icon if image fails to load
                  },
                ),
              ),
              // Gradient overlay and title
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    begin: Alignment.bottomRight,
                    colors: [
                      Colors.black.withOpacity(.8),
                      Colors.black.withOpacity(.0),
                    ],
                  ),
                ),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget eventwidget({required EventModel product}) {
    return AspectRatio(
      aspectRatio: 3 / 2.2,
      child: GestureDetector(
        onTap: () {
          Utils.navigateTo(
              context,
              EventDetailScreen(
                event: product,
              ));
        },
        child: Container(
          margin: const EdgeInsets.only(right: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Stack(
            children: [
              // Network Image with loading indicator
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  product.eventImageUrls.first,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child; // Image is fully loaded
                    } else {
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  (loadingProgress.expectedTotalBytes ?? 1)
                              : null,
                        ),
                      ); // Show loading indicator
                    }
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(Icons.error, color: Colors.red),
                    ); // Show error icon if image fails to load
                  },
                ),
              ),
              // Gradient overlay and title
              Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      begin: Alignment.bottomRight,
                      colors: [
                        Colors.black.withOpacity(.8),
                        Colors.black.withOpacity(.0),
                      ],
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Use Expanded to let the title take up available space
                        Expanded(
                          child: Text(
                            product.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),

                        Text(
                          '\$${product.ticketPrice}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
