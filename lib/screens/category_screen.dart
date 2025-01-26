import 'package:flutter/material.dart';
import 'package:ticket_wise/Pages/category_page.dart';
import 'package:ticket_wise/Pages/search_category.dart';
import 'package:ticket_wise/models/category_model.dart';
import 'package:ticket_wise/provider/category_provider.dart';
import 'package:provider/provider.dart';
import 'package:ticket_wise/utils/utils.dart';
import 'package:ticket_wise/widgets/constants.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  CategoryScreenState createState() => CategoryScreenState();
}

class CategoryScreenState extends State<CategoryScreen> {
  @override
  Widget build(BuildContext context) {
    final categoryProvider =
        Provider.of<CategoryProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Categories',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: PrimaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            color: Colors.white,
            onPressed: () {
              Utils.navigateTo(context, const SearchCategoryPage());
            },
          ),
        ],
      ),
      body: FutureBuilder<List<CategoryModel>>(
        future: categoryProvider
            .fetchCategories(), // Fetch categories from Firebase
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While waiting for data, show a loading indicator
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // If there's an error, show an error message
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // If no data is available, show a message
            return const Center(child: Text('No categories found.'));
          }

          // If data is available, show it in a GridView
          final categories = snapshot.data!;

          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Number of columns
              crossAxisSpacing: 5, // Space between items horizontally
              mainAxisSpacing: 5, // Space between items vertically
              childAspectRatio: 1 / 1, // Aspect ratio of the tiles
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              CategoryModel category = categories[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: makeCategory(
                  image: category.categoryImageurl,
                  title: category.categoryName,
                  tag: category.categoryName,
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget makeCategory({
    required String image,
    required String title,
    required String tag,
  }) {
    return AspectRatio(
      aspectRatio: 2 / 2,
      child: Hero(
        tag: tag,
        child: GestureDetector(
          onTap: () {
            Utils.navigateTo(
                context,
                CategoryPage(
                  tag: tag,
                  image: image,
                  title: title,
                  category: title,
                ));
          },
          child: Material(
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                      image: NetworkImage(
                          image), // Use NetworkImage for Firebase URLs
                      fit: BoxFit.cover)),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient:
                        LinearGradient(begin: Alignment.bottomRight, colors: [
                      Colors.black.withOpacity(.8),
                      Colors.black.withOpacity(.0),
                    ])),
                child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      title,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    )),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
