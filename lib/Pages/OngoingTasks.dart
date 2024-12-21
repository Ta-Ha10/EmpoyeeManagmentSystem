import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ems/Pages/viewOngoingTasks.dart';
import 'package:flutter/material.dart';

import 'manageOngoingTasks.dart';

class OngoingTasks extends StatefulWidget {
  final String userName;
  final String userId;

  const OngoingTasks({
    Key? key,
    required this.userName,
    required this.userId,
  }) : super(key: key);

  @override
  State<OngoingTasks> createState() => _OngoingTasksPageState();
}

class _OngoingTasksPageState extends State<OngoingTasks> {
  final TextEditingController _searchController = TextEditingController();
  late Future<List<Map<String, dynamic>>> _tasks;

  @override
  void initState() {
    super.initState();
    _tasks = _fetchTasks();
  }

  Future<List<Map<String, dynamic>>> _fetchTasks() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('tasks')
          .where('status', isEqualTo: 'pending')
          .get();

      return snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3EAFD),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFFB3A4F6),
        title: Text(
          "On going tasks section",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildProfileSection(),
            SizedBox(height: 16),
            _buildSearchSection(),
            SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _tasks,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text("No tasks found."));
                  }

                  final tasks = snapshot.data!;
                  return ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return _buildTaskCard(index + 1, task);
                    },
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            _buildReturnButton(context),
          ],
        ),
      ),
    );
  }

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
              Text(
                widget.userName,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              Text(
                widget.userId,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[400],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchSection() {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Employee ID',
                hintStyle: TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          SizedBox(width: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFDDC5F6),
            ),
            onPressed: () {},
            child: Text(
              "Search",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(int taskNumber, Map<String, dynamic> task) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      padding: EdgeInsets.all(16.0),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$taskNumber. ${task['taskTitle'] ?? 'Task title'}",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 8),
          Text(
            task['taskDescription'] ?? "Task content......",
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 14,
            ),
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFB3A4F6),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TaskDetailsPage(taskId: task['id']),
                    ),
                  );
                },
                child: Text(
                  "View",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFB3A4F6),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TaskEditPage(taskId: task['id']),
                    ),
                  );
                },
                child: Text(
                  "Manage",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReturnButton(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 500,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 10),
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
