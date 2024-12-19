import 'package:ems/Pages/AddNewEmployee.dart';
import 'package:ems/Pages/TaskCompletionRequests.dart';
import 'package:flutter/material.dart';

import '../database/LoginFB.dart';
import 'EmployeeViewer.dart';
import 'TaskManagement.dart';

class HomePage extends StatefulWidget {
  final String userId;

  const HomePage({Key? key, required this.userId}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuthService _authService = FirebaseAuthService();
  String? _userName;
  String? _userId;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final userDetails = await _authService.getUserDetails(widget.userId);
      if (userDetails != null) {
        setState(() {
          _userName = userDetails['name'];
          _userId =
              userDetails['id'].toString(); // Convert ID to string if necessary
        });
      }
    } catch (e) {
      print('Error fetching user details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFFB3A4F6), // AppBar color set to #B3A4F6
        title: Center(child: Text('Home')),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {},
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.black87, // Box with the specified color #2D2D2D
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IntrinsicWidth(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 4.0),
                            decoration: BoxDecoration(
                              color: Colors
                                  .grey[600], // Background color #D9D9D97D
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Text(
                              '${_userName ?? "Loading..."}',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        IntrinsicWidth(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 4.0),
                            decoration: BoxDecoration(
                              color: Colors
                                  .grey[600], // Background color #D9D9D97D
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${_userId ?? "Loading..."}',
                              style: TextStyle(
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
            ),
            SizedBox(height: 20.0),
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey, // Box with grey color for the buttons
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                children: [
                  _buildButton(
                    context,
                    'Task Completion Requests',
                    () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return TaskcompletionRequests(
                                userName: _userName ?? "",
                                userId: _userId ?? "");
                          },
                        ),
                      );
                    },
                  ),
                  _buildButton(context, 'Employee Registration', () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return AddNewEmployee(
                              userName: _userName ?? "", userId: _userId ?? "");
                        },
                      ),
                    );
                  }),
                  _buildButton(
                    context,
                    'Employee Viewer',
                    () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return EmployeeViewer(
                                userName: _userName ?? "",
                                userId: _userId ?? "");
                          },
                        ),
                      );
                    },
                  ),
                  _buildButton(context, 'Ongoing Tasks'),
                  _buildButton(
                    context,
                    'Task Management',
                    () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return TaskManagement(
                                userName: _userName ?? "",
                                userId: _userId ?? "");
                          },
                        ),
                      );
                    },
                  ),
                  _buildButton(context, 'Reports'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String text,
      [VoidCallback? onPressed]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        width: 332, // Set button width
        height: 70, // Set button height
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor:
                Color(0xFF211B2D), // Color of the buttons set to #211B2D
            padding: EdgeInsets.symmetric(vertical: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          onPressed: onPressed,
          child: Text(text, style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
