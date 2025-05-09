import 'package:flutter/material.dart';

class StructureAndComposition extends StatelessWidget {
  final Map<String, dynamic> stoneData; // Define the stoneData parameter

  // Constructor with the required stoneData parameter
  StructureAndComposition(
      {required this.stoneData}); // Correct constructor definition

  // Function to build information rows with title, description, and color
  Widget _buildInfoRow(String title, String description, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.circle, // Circle icon
                size: 8,
                color: color, // Color of the circle icon
              ),
              SizedBox(width: 8), // Spacing between icon and title
              Text(
                title, // Title of the information
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.orange),
              ),
            ],
          ),
          Text(
            description, // Description text
            style: TextStyle(fontSize: 18, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16), // Outer padding for container
      child: Container(
        padding: EdgeInsets.all(16), // Inner padding for container
        decoration: BoxDecoration(
          color: Colors.white, // Background color of the container
          borderRadius:
              BorderRadius.circular(14), // Rounded corners for the container
          boxShadow: [
            BoxShadow(
              color: Colors.black
                  .withOpacity(0.1), // Shadow effect for the container
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main title "Kết cấu và Cấu tạo"
            Row(
              children: [
                // Add custom icon
                Image.asset(
                  'assets/connection.png', // Path to your icon file
                  width: 30,
                  height: 30,
                ),
                SizedBox(width: 8), // Spacing between icon and title
                Text(
                  "Kết cấu và Cấu tạo", // Main title
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF303A53), // Title color
                  ),
                ),
              ],
            ),
            SizedBox(height: 16), // Spacing between title and information rows

            // Information rows
            _buildInfoRow(
              'Về Kiến trúc',
              stoneData['kien_truc'] ??
                  'Tên đá không rõ', // Get data from stoneData map or use default text
              Colors.orange,
            ),
            _buildInfoRow(
              'Về Cấu tạo',
              stoneData['cau_tao'] ??
                  'Tên đá không rõ', // Get data from stoneData map or use default text
              Colors.orange,
            ),
          ],
        ),
      ),
    );
  }
}
