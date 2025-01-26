// ignore_for_file: library_private_types_in_public_api, unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:ticket_wise/Pages/search_page.dart';
import 'package:ticket_wise/models/event_model.dart';
import 'package:ticket_wise/provider/cities_provider.dart';
import 'package:ticket_wise/provider/event_provider.dart';
import 'package:ticket_wise/provider/category_provider.dart';
import 'package:provider/provider.dart';
import 'package:ticket_wise/widgets/constants.dart';
import 'package:ticket_wise/widgets/event_card_widget.dart';
import 'package:ticket_wise/utils/utils.dart';

class Eventpage extends StatefulWidget {
  const Eventpage({super.key});

  @override
  _EventpageState createState() => _EventpageState();
}

class _EventpageState extends State<Eventpage> {
  late Future<List<EventModel>> _productsFuture;
  String? selectedCity;
  String? selectedCategory;
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    final productProvider = Provider.of<EventProvider>(context, listen: false);
    _productsFuture = productProvider.fetchEvents();
  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: PrimaryColor,
        actions: <Widget>[
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.search, color: Colors.white),
                onPressed: () {
                  Utils.navigateTo(context, SearchPage());
                },
              ),
              // City Filter Icon
              IconButton(
                icon: const Icon(Icons.location_city, color: Colors.white),
                onPressed: () {
                  _selectCity(context);
                },
              ),
              // Category Filter Icon
              IconButton(
                icon: const Icon(Icons.category, color: Colors.white),
                onPressed: () {
                  _selectCategory(context);
                },
              ),
              // Date Filter Icon
              IconButton(
                icon: const Icon(Icons.date_range, color: Colors.white),
                onPressed: () {
                  _selectDate(context);
                },
              ),
            ],
          )
        ],
        title: const Text(
          'Events',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: FutureBuilder<List<EventModel>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No Events found.'));
          }

          List<EventModel> products = snapshot.data!;

          // Apply filters if selected
          if (selectedCity != null) {
            products =
                products.where((event) => event.city == selectedCity).toList();
          }
          if (selectedCategory != null) {
            products = products
                .where((event) => event.category == selectedCategory)
                .toList();
          }
          if (selectedDate != null) {
            products = products
                .where((event) => event.eventDate == selectedDate)
                .toList();
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: products.length,
            itemBuilder: (context, index) {
              EventModel product = products[index];

              return EventCard(
                event: product,
              );
            },
          );
        },
      ),
    );
  }

  // Show City Filter Dropdown
  void _selectCity(BuildContext context) {
    final cityProvider = Provider.of<CityProvider>(context, listen: false);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: PrimaryColor,
          title:
              const Text('Select City', style: TextStyle(color: Colors.white)),
          content: DropdownButton<String>(
            hint: const Text(
              "Select City",
              style: TextStyle(color: Colors.white),
            ),
            value: selectedCity,
            onChanged: (value) {
              setState(() {
                selectedCity = value;
              });
              cityProvider.updateSelectedValue(value ?? "");
              Navigator.pop(context);
            },
            items: cityProvider.cityNames.map((cityName) {
              return DropdownMenuItem<String>(
                value: cityName,
                child: Text(
                  cityName,
                  style: const TextStyle(color: Colors.white),
                ),
              );
            }).toList(),
            dropdownColor: PrimaryColor,
          ),
        );
      },
    );
  }

  // Show Category Filter Dropdown
  void _selectCategory(BuildContext context) {
    final categoryProvider =
        Provider.of<CategoryProvider>(context, listen: false);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: PrimaryColor,
          title: const Text('Select Category',
              style: TextStyle(color: Colors.white)),
          content: DropdownButton<String>(
            hint: const Text(
              "Select Category",
              style: TextStyle(color: Colors.white),
            ),
            value: selectedCategory,
            onChanged: (value) {
              setState(() {
                selectedCategory = value;
              });
              categoryProvider.updateSelectedValue(value ?? "");
              Navigator.pop(context);
            },
            items: categoryProvider.categoryNames.map((categoryName) {
              return DropdownMenuItem<String>(
                value: categoryName,
                child: Text(
                  categoryName,
                  style: const TextStyle(color: Colors.white),
                ),
              );
            }).toList(),
            dropdownColor: PrimaryColor,
          ),
        );
      },
    );
  }

  // Show Date Picker for Date Filter
  void _selectDate(BuildContext context) async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (date != null) {
      setState(() {
        selectedDate = date;
      });
    }
  }
}
