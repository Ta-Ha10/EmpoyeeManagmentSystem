import 'package:flutter/material.dart';

class TaskcompletionRequests extends StatelessWidget {
  final String userName;
  final String userId;

  TaskcompletionRequests({
    Key? key,
    required this.userName,
    required this.userId,
  }) : super(key: key);

  final List<Map<String, String>> tasks = List.generate(
    4,
    (index) => {
      'title': 'Task title ${index + 1}',
      'content': 'Task content ${index + 1}...',
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFFB3A4F6),
        title: const Text(
          'Task Completing Requests',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.purple[50],
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              _buildProfileSection(),
              const SizedBox(height: 16),
              _buildSearchSection(),
              const SizedBox(height: 16),
              _buildTaskList(),
              const SizedBox(height: 16),
              _buildReturnButton(context),
            ],
          ),
        ),
      ),
    );
  }

  // Profile Section
  Widget _buildProfileSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.blue,
            child: const Icon(Icons.person, size: 30, color: Colors.white),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IntrinsicWidth(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[600],
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Text(
                      userName,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                IntrinsicWidth(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[600],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      userId,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Employee Search Section
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

  // Task List
  Widget _buildTaskList() {
    return Expanded(
      child: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return _buildTaskItem(index + 1, tasks[index]);
        },
      ),
    );
  }

  Widget _buildTaskItem(int number, Map<String, String> task) {
    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: 10, vertical: 8), // Reduced horizontal margin
      padding: const EdgeInsets.all(12), // Slightly increased padding
      decoration: BoxDecoration(
        color: const Color(0xFFE6E6E6), // Light gray background
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0, 1),
            blurRadius: 2,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3, // Increase the space allocated to task details
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$number. ${task['title']}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text(task['content']!),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF0C1C1),
                  foregroundColor: Colors.black,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                onPressed: () {},
                child: const Text('View'),
              ),
              const SizedBox(height: 5),
            ],
          ),
        ],
      ),
    );
  }

  // Return Button
  Widget _buildReturnButton(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 500,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,

            padding: const EdgeInsets.symmetric(
                vertical: 10), // Adjust vertical padding if needed
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            'Return',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
      ),
    );
  }
}
