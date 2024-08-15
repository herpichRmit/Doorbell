import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../model/post.dart';

class PostCard extends StatelessWidget {
  final Post post;

  const PostCard({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: CupertinoColors.systemGrey, width: 0.5),
        borderRadius: BorderRadius.circular(8.0), // Optional: Add rounded corners
      ),
      child: Stack(
        children: [
          Positioned(
            left: 6,
            top: 16,
            child: Image.asset(post.avatarUrl, height: 44),),
          Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const SizedBox(width: 36, height: 44,),
                  const SizedBox(width: 8), // Add spacing between avatar and text
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 244,
                            child: Text(
                              post.title,
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                                letterSpacing: -0.23,
                              ),
                            ),
                          ), // Add spacing between title and "new"
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 4.0),
                            decoration: BoxDecoration(
                              color: CupertinoColors.systemBlue.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: Text(
                              "New",
                              style: TextStyle(
                                color: CupertinoColors.systemBlue.withOpacity(0.7), // TODO: read avatar.colour in here
                                fontSize: 14.0,
                                fontWeight: FontWeight.w500,
                                letterSpacing: -0.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            formatTime(post.timestamp),
                            style: TextStyle(
                              fontSize: 12.0,
                              letterSpacing: -0.23,
                              fontWeight: FontWeight.w600,
                              color: CupertinoColors.systemGrey,
                            ),
                          ),
                          const SizedBox(width: 8), // Add spacing between time and icon
                          const Icon(Icons.access_time, size: 16), // Example icon
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8), // Add spacing between sections
              Text(
                post.description,
                style: TextStyle(
                  fontSize: 14.0,
                  letterSpacing: 0.0,
                  height: 1.3,
                ),
                maxLines: 2,
              ),

              // Display images if any
              if (post.images.isNotEmpty)
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: post.images.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.network(post.images[index]),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ]),
    );
  }

  String formatTime(DateTime dateTime) {
  // Get the hour and minute from the DateTime object
  int hour = dateTime.hour;
  int minute = dateTime.minute;

  // Determine AM or PM
  String period = hour >= 12 ? 'PM' : 'AM';

  // Convert hour from 24-hour to 12-hour format
  hour = hour % 12;
  hour = hour == 0 ? 12 : hour; // Handle midnight (0 hour) case

  // Format minute with leading zero if necessary
  String minuteFormatted = minute.toString().padLeft(2, '0');

  // Return formatted time string
  return '$hour:$minuteFormatted $period';
}
}
