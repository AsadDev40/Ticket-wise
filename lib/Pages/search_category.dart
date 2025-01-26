// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ticket_wise/Pages/category_page.dart';
import 'package:ticket_wise/models/category_model.dart';
import 'package:ticket_wise/provider/category_provider.dart';
import 'package:searchable_listview/searchable_listview.dart';
import 'package:ticket_wise/utils/utils.dart';
import 'package:ticket_wise/widgets/constants.dart';

class SearchCategoryPage extends StatefulWidget {
  const SearchCategoryPage({super.key});

  @override
  _SearchCategoryPageState createState() => _SearchCategoryPageState();
}

class _SearchCategoryPageState extends State<SearchCategoryPage> {
  List<CategoryModel> _categories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final categoryProvider =
        Provider.of<CategoryProvider>(context, listen: false);
    List<CategoryModel> categories = await categoryProvider.fetchCategories();
    setState(() {
      _categories = categories;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Search Categories',
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
              child: SearchableList<CategoryModel>(
                searchFieldPadding: EdgeInsets.only(top: 20, bottom: 20),
                initialList: _categories,
                itemBuilder: (CategoryModel category) => Card(
                  color: PrimaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        category
                            .categoryImageurl, // Assuming each category has an image URL
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      category.categoryName, // Assuming the category has a name
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      category.type, // Assuming the category has a description
                      style: const TextStyle(color: Colors.white70),
                    ),
                    onTap: () {
                      Utils.navigateTo(
                          context,
                          CategoryPage(
                            category: category.categoryName,
                            title: category.categoryName,
                            tag: category.type,
                            image: category.categoryImageurl,
                          ));
                    },
                  ),
                ),
                filter: (query) => _categories
                    .where((category) => category.categoryName
                        .toLowerCase()
                        .contains(query.toLowerCase()))
                    .toList(),
                emptyWidget: const Center(child: Text('No categories found')),
                inputDecoration: InputDecoration(
                  labelText: "Search Categories",
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
