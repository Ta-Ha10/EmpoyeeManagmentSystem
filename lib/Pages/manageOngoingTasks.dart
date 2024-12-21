import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TaskEditPage extends StatefulWidget {
  final String taskId;

  const TaskEditPage({Key? key, required this.taskId}) : super(key: key);

  @override
  State<TaskEditPage> createState() => _TaskEditPageState();
}

class _TaskEditPageState extends State<TaskEditPage> {
  final TextEditingController _taskTitleController = TextEditingController();
  final TextEditingController _taskDescriptionController =
      TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _employeeNameController = TextEditingController();
  final TextEditingController _employeeIdController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadTaskDetails();
  }

  Future<void> _loadTaskDetails() async {
    setState(() => _isLoading = true);

    try {
      final taskSnapshot = await FirebaseFirestore.instance
          .collection('tasks')
          .doc(widget.taskId)
          .get();

      if (taskSnapshot.exists) {
        final taskData = taskSnapshot.data()!;
        _taskTitleController.text = taskData['taskTitle'] ?? '';
        _taskDescriptionController.text = taskData['taskDescription'] ?? '';
        _startDateController.text = taskData['startDate'] ?? '';
        _endDateController.text = taskData['endDate'] ?? '';
        _employeeNameController.text = taskData['employeeDetails'] ?? '';
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading task details: $e')),
      );
    }

    setState(() => _isLoading = false);
  }

  Future<void> _saveTaskDetails() async {
    setState(() => _isLoading = true);

    try {
      await FirebaseFirestore.instance
          .collection('tasks')
          .doc(widget.taskId)
          .update({
        'taskTitle': _taskTitleController.text,
        'taskDescription': _taskDescriptionController.text,
        'startDate': _startDateController.text,
        'endDate': _endDateController.text,
        'employeeName': _employeeNameController.text,
        'employeeId': _employeeIdController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Task updated successfully!')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving task details: $e')),
      );
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3EAFD),
      appBar: AppBar(
        backgroundColor: Color(0xFFB3A4F6),
        title: Text(
          'Edit Task',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildEditableField("Task Title", _taskTitleController),
                  _buildEditableField(
                      "Task Description", _taskDescriptionController),
                  _buildEditableField("Start Date", _startDateController),
                  _buildEditableField("End Date", _endDateController),
                  _buildEditableField("Employee Name", _employeeNameController),
                  _buildEditableField("Employee ID", _employeeIdController),
                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 12,
                        ),
                      ),
                      onPressed: _saveTaskDetails,
                      child: Text(
                        "Save Changes",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildEditableField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    );
  }
}
