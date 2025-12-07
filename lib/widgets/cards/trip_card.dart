import 'package:flutter/material.dart';
import 'package:mob_project/screens/trips/ticket_screen.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_constants.dart';
import '../../constants/app_text_styles.dart';

class TripCard extends StatelessWidget {
  final String image;
  final String status;
  final String location;
  final String dateRange;
  final String people;
  final String buttonText;
  final Color? buttonColor;
  final Color? textColor;
  final VoidCallback? onButtonPressed;

  const TripCard({
    Key? key,
    required this.image,
    required this.status,
    required this.location,
    required this.dateRange,
    required this.people,
    required this.buttonText,
    this.buttonColor,
    this.textColor,
    this.onButtonPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
      ),
      elevation: AppConstants.elevationLow,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(AppConstants.radiusMedium),
              topRight: Radius.circular(AppConstants.radiusMedium),
            ),
            child: Image.asset(
              image,
              height: screenHeight * 0.17,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: screenHeight * 0.17,
                  width: double.infinity,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image, size: 50, color: Colors.grey),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppConstants.paddingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  status,
                  style: status == 'UPCOMING'
                      ? AppTextStyles.statusUpcoming
                      : AppTextStyles.statusCompleted,
                ),
                const SizedBox(height: 4),
                Text(
                  location,
                  style: AppTextStyles.heading3.copyWith(fontSize: 16),
                ),
                const SizedBox(height: AppConstants.paddingSmall),
                Row(
                  children: [
                    const Icon(
                      Icons.date_range,
                      size: AppConstants.iconSmall,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(dateRange, style: AppTextStyles.caption),
                    const Spacer(),
                    const Icon(
                      Icons.people,
                      size: AppConstants.iconSmall,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(people, style: AppTextStyles.caption),
                  ],
                ),
                const SizedBox(height: AppConstants.paddingMedium),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor ?? AppColors.info,
                      foregroundColor: textColor ?? Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppConstants.radiusSmall,
                        ),
                      ),
                    ),
                    onPressed:
                        onButtonPressed ??
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TicketPage(bookingId: '1'),
                            ),
                          );
                        },
                    child: Text(buttonText),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
