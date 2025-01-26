import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ticket_wise/provider/datepicker_provider.dart';
import 'package:ticket_wise/widgets/constants.dart';

class TimePickerWidget extends StatelessWidget {
  final String hint;
  final bool isStartTime;

  const TimePickerWidget({
    super.key,
    required this.hint,
    required this.isStartTime,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<DatePickerProvider>(
      builder: (context, datePickerProvider, child) {
        // Display appropriate time based on isStartTime
        String formattedTime = isStartTime
            ? (datePickerProvider.startTime != null
                ? datePickerProvider.startTime!
                : hint)
            : (datePickerProvider.endTime != null
                ? datePickerProvider.endTime!
                : hint);

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
              await datePickerProvider.pickTime(context,
                  isStartTime: isStartTime);
            },
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    formattedTime,
                    style: const TextStyle(
                      fontSize: 16,
                      color: PrimaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(
                  Icons.access_time,
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
