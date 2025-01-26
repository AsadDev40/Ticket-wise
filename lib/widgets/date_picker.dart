import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:ticket_wise/provider/datepicker_provider.dart';
import 'package:ticket_wise/widgets/constants.dart';

class DatePickerWidget extends StatelessWidget {
  const DatePickerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DatePickerProvider>(
      builder: (context, datePickerProvider, child) {
        // Format the selected date if it's not null, otherwise show a hint
        String formattedDate = datePickerProvider.selectedDate != null
            ? DateFormat('yyyy-MM-dd').format(datePickerProvider.selectedDate!)
            : 'Select Date';

        return Container(
          padding: const EdgeInsets.only(right: 20, left: 20),
          height: 70,
          width: 400,
          decoration: BoxDecoration(
            border: Border.all(color: PrimaryColor),
            borderRadius: BorderRadius.circular(30),
          ),
          child: GestureDetector(
            onTap: () async {
              // Trigger the date picker when tapped
              await datePickerProvider.pickDate(context);
            },
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    formattedDate, // Display the selected date or placeholder text
                    style: const TextStyle(
                      fontSize: 16,
                      color: PrimaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(
                  Icons.calendar_today,
                  color: PrimaryColor,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
