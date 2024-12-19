import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TaskManagement extends StatefulWidget {
  final String userName;
  final String userId;

  const TaskManagement({Key? key, required this.userName, required this.userId})
      : super(key: key);

  @override
  _TaskManagementState createState() => _TaskManagementState();
}

class _TaskManagementState extends State<TaskManagement> {
  final TextEditingController employeeIdController = TextEditingController();
  final TextEditingController taskTitleController = TextEditingController();
  final TextEditingController taskDescriptionController =
      TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();

  List<Map<String, dynamic>> filteredEmployees = [];
  bool isDropdownVisible = false;
  bool isLoading = false;

  void filterEmployees(String query) {
    if (query.isEmpty) {
      setState(() {
        isDropdownVisible = false;
        filteredEmployees = [];
      });
      return;
    }

    setState(() => isLoading = true);

    // Fetch by name
    FirebaseFirestore.instance
        .collection('employees')
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThanOrEqualTo: query + '\uf8ff')
        .get()
        .then((nameSnapshot) {
      // Fetch by ID
      FirebaseFirestore.instance
          .collection('employees')
          .where('id', isEqualTo: query)
          .get()
          .then((idSnapshot) {
        setState(() {
          // Merge both results
          filteredEmployees = [
            ...nameSnapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}),
            ...idSnapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}),
          ];
          isDropdownVisible = filteredEmployees.isNotEmpty;
          isLoading = false;
        });
      });
    });
  }

  Future<void> selectDate(
      BuildContext context, TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        controller.text =
            "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
      });
    }
  }

  Future<void> addTask() async {
    String employeeDetails = employeeIdController.text.trim();
    String taskTitle = taskTitleController.text.trim();
    String taskDescription = taskDescriptionController.text.trim();
    String startDate = startDateController.text.trim();
    String endDate = endDateController.text.trim();

    if (employeeDetails.isEmpty ||
        taskTitle.isEmpty ||
        taskDescription.isEmpty ||
        startDate.isEmpty ||
        endDate.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill in all fields"),
        ),
      );
      return;
    }

    try {
      // Save task to Firestore
      await FirebaseFirestore.instance.collection('tasks').add({
        'employeeDetails': employeeDetails,
        'taskTitle': taskTitle,
        'taskDescription': taskDescription,
        'startDate': startDate,
        'endDate': endDate,
        'createdBy': {
          'userName': widget.userName,
          'userId': widget.userId,
        },
        'createdAt': DateTime.now(),
      });

      // Clear fields after successful submission
      employeeIdController.clear();
      taskTitleController.clear();
      taskDescriptionController.clear();
      startDateController.clear();
      endDateController.clear();

      setState(() {
        isDropdownVisible = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Task added successfully"),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
        ),
      );
    }
  }

  Widget _buildChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 14),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.black87,
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildChip(widget.userName, Colors.grey[600]!),
              const SizedBox(height: 10),
              _buildChip(widget.userId, const Color(0xFF222222)),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3EAFD),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFFB3A4F6),
        elevation: 0,
        title: const Center(
          child: Text(
            'Tasks Management',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildProfileSection(),
              const SizedBox(height: 20),

              // Search Section with Dropdown
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          "Employee ID",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        const SizedBox(width: 8.0),
                        Expanded(
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: TextField(
                              controller: employeeIdController,
                              style: const TextStyle(color: Colors.black),
                              decoration: const InputDecoration(
                                hintText: "Search Employee by ID or Name",
                                hintStyle: TextStyle(color: Colors.black54),
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 10.0),
                                border: InputBorder.none,
                              ),
                              onChanged: filterEmployees,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (isDropdownVisible || isLoading)
                      const SizedBox(height: 10),
                    if (isDropdownVisible)
                      Container(
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: ListView.builder(
                          padding: const EdgeInsets.all(10),
                          itemCount: filteredEmployees.length,
                          itemBuilder: (context, index) {
                            final employee = filteredEmployees[index];
                            return ListTile(
                              title: Text(
                                "${employee['id']} - ${employee['name']}",
                                style: const TextStyle(color: Colors.black),
                              ),
                              onTap: () {
                                setState(() {
                                  employeeIdController.text =
                                      "${employee['id']} - ${employee['name']}";
                                  isDropdownVisible = false;
                                });
                              },
                            );
                          },
                        ),
                      ),
                    if (isLoading)
                      const Center(child: CircularProgressIndicator()),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Task Title Field
              const Text(
                "Task Title",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Container(
                height: 50,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF2F2F2F),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: taskTitleController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(border: InputBorder.none),
                ),
              ),
              const SizedBox(height: 15),

              // Task Description Field
              const Text(
                "Task Description",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Container(
                height: 150,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF2F2F2F),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: taskDescriptionController,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(border: InputBorder.none),
                ),
              ),
              const SizedBox(height: 15),

              // Start and End Date Fields
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => selectDate(context, startDateController),
                      child: AbsorbPointer(
                        child: TextField(
                          controller: startDateController,
                          decoration: InputDecoration(
                            hintText: "Start Date",
                            hintStyle: const TextStyle(color: Colors.white54),
                            fillColor: const Color(0xFF2F2F2F),
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => selectDate(context, endDateController),
                      child: AbsorbPointer(
                        child: TextField(
                          controller: endDateController,
                          decoration: InputDecoration(
                            hintText: "End Date",
                            hintStyle: const TextStyle(color: Colors.white54),
                            fillColor: const Color(0xFF2F2F2F),
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Submit Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFBBE0A5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: addTask,
                child: const Text(
                  "Submit",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
