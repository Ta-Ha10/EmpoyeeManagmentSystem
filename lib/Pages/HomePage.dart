import 'package:ems/Pages/AddNewEmployee.dart';
import 'package:ems/Pages/EmployeeViewer.dart';
import 'package:ems/Pages/LoginPage.dart'; // Ensure LoginPage is implemented.
import 'package:ems/Pages/OngoingTasks.dart';
import 'package:ems/Pages/TaskCompletionRequests.dart';
import 'package:ems/Pages/TaskManagement.dart';
import 'package:ems/Pages/reportPage.dart';
import 'package:flutter/material.dart';

import '../database/LoginFB.dart';

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
          _userId = userDetails['id'].toString();
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
        backgroundColor: const Color(0xFFB3A4F6), // AppBar color set to #B3A4F6
        title: const Center(child: Text('Home')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.black87, // Box with the specified color #2D2D2D
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.person, size: 30, color: Colors.white),
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
                              '${_userName ?? "Loading..."}',
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
                              '${_userId ?? "Loading..."}',
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
            ),
            const SizedBox(height: 20.0),
            Container(
              padding: const EdgeInsets.all(16.0),
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
                  _buildButton(
                    context,
                    'Ongoing Tasks',
                    () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return OngoingTasks(
                                userName: _userName ?? "",
                                userId: _userId ?? "");
                          },
                        ),
                      );
                    },
                  ),
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
                  _buildButton(context, 'Reports', () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return ReportPage(
                            userName: '',
                            userId: '',
                          );
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF654E91),
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 32.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onPressed: () async {
                await _authService.signOut(); // Perform sign-out action.
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  (route) => false,
                );
              },
              child:
                  const Text('Logout', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(
      BuildContext context, String text, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        width: 332, // Set button width
        height: 70, // Set button height
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor:
                const Color(0xFF211B2D), // Button color set to #211B2D
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          onPressed: onPressed,
          child: Text(text, style: const TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
