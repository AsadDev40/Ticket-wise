import 'package:flutter/material.dart';
import 'package:ticket_wise/widgets/constants.dart';

class DatePickerProvider extends ChangeNotifier {
  DateTime? _selectedDate;
  String? _startTime;
  String? _endTime;

  DateTime? get selectedDate => _selectedDate;
  String? get startTime => _startTime;
  String? get endTime => _endTime;

  /// Helper method to format TimeOfDay to string (hh:mm AM/PM)
  String _formatTime(TimeOfDay time) {
    int hour = time.hour;
    int minute = time.minute;
    String period = hour >= 12 ? 'PM' : 'AM';

    // Convert to 12-hour format
    hour = hour > 12 ? hour - 12 : hour;
    if (hour == 0) hour = 12; // Adjust for 12:00 AM case

    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
  }

  /// Method to pick a date
  Future<void> pickDate(BuildContext context) async {
    DateTime today = DateTime.now();
    DateTime initialDate = (today.isAfter(DateTime(2050, 12, 31)) ||
            today.isBefore(DateTime(2000, 1, 1)))
        ? DateTime(2050, 12, 31)
        : today;

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000, 1, 1),
      lastDate: DateTime(2050, 12, 31),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: PrimaryColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor:
                    PrimaryColor, // Color for buttons like "OK" and "CANCEL"
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      _selectedDate = pickedDate;
      notifyListeners(); // Notify listeners about the change
    }
  }

  /// Method to pick a time for Start or End
  Future<void> pickTime(BuildContext context,
      {required bool isStartTime}) async {
    final TimeOfDay now = TimeOfDay.now();

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: now,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: PrimaryColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime != null) {
      final formattedTime =
          _formatTime(pickedTime); // Convert the time to string with AM/PM

      if (isStartTime) {
        _startTime = formattedTime;
      } else {
        _endTime = formattedTime;
      }
      notifyListeners(); // Notify listeners about the change
    }
  }

  /// Method to clear the selected date
  void clearDate() {
    _selectedDate = null;
    notifyListeners(); // Notify listeners to update the UI
  }

  /// Method to clear the selected start time
  void clearStartTime() {
    _startTime = null;
    notifyListeners(); // Notify listeners to update the UI
  }

  /// Method to clear the selected end time
  void clearEndTime() {
    _endTime = null;
    notifyListeners(); // Notify listeners to update the UI
  }
}
