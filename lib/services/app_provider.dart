import 'package:flutter/material.dart';
import 'package:ticket_wise/provider/auth_provider.dart';
import 'package:ticket_wise/provider/brand_provider.dart';
import 'package:ticket_wise/provider/category_provider.dart';
import 'package:ticket_wise/provider/cities_provider.dart';
import 'package:ticket_wise/provider/datepicker_provider.dart';
import 'package:ticket_wise/provider/file_upload_provider.dart';
import 'package:ticket_wise/provider/image_picker.dart';
import 'package:ticket_wise/provider/event_provider.dart';

import 'package:provider/provider.dart';
import 'package:ticket_wise/provider/theme_provider.dart';
import 'package:ticket_wise/provider/ticket_provider.dart';
import 'package:ticket_wise/provider/video_picker_provider.dart';

class AppProvider extends StatelessWidget {
  const AppProvider({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => ImagePickerProvider()),
          ChangeNotifierProvider(create: (context) => AuthProvider()),
          ChangeNotifierProvider(create: (context) => FileUploadProvider()),
          ChangeNotifierProvider(create: (context) => EventProvider()),
          ChangeNotifierProvider(create: (context) => CategoryProvider()),
          ChangeNotifierProvider(create: (context) => VideoPickerProvider()),
          ChangeNotifierProvider(create: (context) => CityProvider()),
          ChangeNotifierProvider(create: (context) => BrandProvider()),
          ChangeNotifierProvider(create: (context) => ThemeProvider()),
          ChangeNotifierProvider(create: (context) => DatePickerProvider()),
          ChangeNotifierProvider(create: (context) => TicketProvider()),
        ],
        child: child,
      );
}
