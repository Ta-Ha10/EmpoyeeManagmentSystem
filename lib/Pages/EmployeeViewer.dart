import 'package:flutter/material.dart';

class EmployeeViewer extends StatefulWidget {
  final String userName;
  final String userId;

  const EmployeeViewer({Key? key, required this.userName, required this.userId})
      : super(key: key);

  @override
  State<EmployeeViewer> createState() => _EmployeeViewerState();
}

class _EmployeeViewerState extends State<EmployeeViewer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3EAFD), // Background color
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFFB3A4F6),
        title: Text(
          'Employee Viewer',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        leading: Icon(Icons.menu, color: Colors.black),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Section
              _buildProfileSection(),

              SizedBox(height: 16),

              // Search Section
              _buildSearchSection(),

              SizedBox(height: 16),

              // Info Fields
              _buildInfoSection("Department"),
              _buildInfoSection("Job satisfaction"),
              _buildInfoSection("Performance"),
              _buildInfoSection("Current Task"),
              _buildInfoSection("ID"),
              _buildInfoSection("Team ID"),

              SizedBox(height: 20),

              // Return Button
              _buildReturnButton(),
            ],
          ),
        ),
      ),
    );
  }

  // Profile Section
  Widget _buildProfileSection() {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.blue,
            child: Icon(Icons.person, size: 30, color: Colors.white),
          ),
          SizedBox(width: 16.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildChip(widget.userName, Colors.grey[600]!),
              SizedBox(height: 10),
              _buildChip(widget.userId, Color(0xFF222222)),
            ],
          ),
        ],
      ),
    );
  }

  // Small chip-like container for user details
  Widget _buildChip(String text, Color backgroundColor) {
    return IntrinsicWidth(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // Search Section
  Widget _buildSearchSection() {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Text(
            "Employee ID",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          SizedBox(width: 8.0),
          Expanded(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
          SizedBox(width: 8.0),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFF0C1C1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: Text(
              "Search",
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  // Info Section for Labels and Fields
  Widget _buildInfoSection(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: Color(0xFFE6E6E6), // Light gray background
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.teal[700],
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Container(
              width: double.infinity, // Full screen width
              height: 50, // Larger height for the info box
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Return Button
  Widget _buildReturnButton() {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFFF0C1C1),
        padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: Text(
        "Return",
        style: TextStyle(
          fontSize: 18,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
