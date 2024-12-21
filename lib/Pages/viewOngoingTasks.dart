import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TaskDetailsPage extends StatelessWidget {
  final String taskId;

  const TaskDetailsPage({Key? key, required this.taskId}) : super(key: key);

  Future<Map<String, dynamic>> _fetchTaskDetails() async {
    try {
      // Fetch task data from Firestore
      final taskSnapshot = await FirebaseFirestore.instance
          .collection('tasks')
          .doc(taskId)
          .get();

      if (!taskSnapshot.exists) {
        throw Exception("Task not found.");
      }

      return taskSnapshot.data()!;
    } catch (e) {
      throw Exception("Error fetching task: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3EAFD),
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Color(0xFFB3A4F6),
        title: Text(
          'Task Details',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _fetchTaskDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error: ${snapshot.error}",
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return Center(
              child: Text(
                "No task details available.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          final taskData = snapshot.data!;
          return SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader("Task Details"),
                _buildDetailsCard("Task Title", taskData['taskTitle'] ?? "N/A"),
                _buildDetailsCard(
                    "Task Description", taskData['taskDescription'] ?? "N/A"),
                _buildDetailsCard("Start Date", taskData['startDate'] ?? "N/A"),
                _buildDetailsCard("End Date", taskData['endDate'] ?? "N/A"),
                SizedBox(height: 16),
                _buildSectionHeader("Employee Details"),
                _buildDetailsCard(
                    "Employee Name", taskData['employeeDetails'] ?? "N/A"),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildDetailsCard(String label, String value) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label: ",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }
}
