import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:pdf/widgets.dart' as pw;

class Task {
  final String id;
  final String name;
  final String status;
  final String employeeId;

  Task({
    required this.id,
    required this.name,
    required this.status,
    required this.employeeId,
  });
}

class Employee {
  final String id;
  final String name;
  final List<Task> tasks;

  Employee({required this.id, required this.name, required this.tasks});

  int get completedTasksCount => tasks
      .where((task) => task.status.toLowerCase().trim() == 'completed')
      .length;

  int get pendingTasksCount => tasks
      .where((task) => task.status.toLowerCase().trim() == 'pending')
      .length;

  int get totalTasksCount => tasks.length;

  double get completedPercentage {
    if (totalTasksCount == 0) return 0.0;
    return (completedTasksCount / totalTasksCount) * 100;
  }
}

class ReportPage extends StatefulWidget {
  final String userName;
  final String userId;

  const ReportPage({Key? key, required this.userName, required this.userId})
      : super(key: key);

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  @override
  void initState() {
    super.initState();
    _initializePDFPreview();
  }

  Future<void> _initializePDFPreview() async {
    final firestore = FirebaseFirestore.instance;
    final employees = await fetchEmployeesAndTasks(firestore);
    final pdfBytes = await generatePDF(employees);
    if (pdfBytes != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PDFPreviewScreen(pdfBytes: pdfBytes),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Firebase PDF Report"),
        toolbarHeight: 50, // Reduced AppBar height
      ),
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Future<List<Employee>> fetchEmployeesAndTasks(
      FirebaseFirestore firestore) async {
    final employeeSnapshot = await firestore.collection('employees').get();
    final taskSnapshot = await firestore.collection('tasks').get();

    final tasks = taskSnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      final status = data['status']?.toString().trim() ?? 'Pending';
      final employeeDetails = data['employeeDetails']?.split(' - ') ?? [];
      return Task(
        id: doc.id,
        name: data['taskTitle'] ?? '',
        status: status,
        employeeId: employeeDetails.isNotEmpty ? employeeDetails[0] : '',
      );
    }).toList();

    return employeeSnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      final employeeTasks =
          tasks.where((task) => task.employeeId == data['id']).toList();
      return Employee(
        id: data['id'] ?? '',
        name: data['name'] ?? '',
        tasks: employeeTasks,
      );
    }).toList();
  }

  Future<Uint8List?> generatePDF(List<Employee> employees) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        margin: const pw.EdgeInsets.all(8), // Reduced margin
        build: (context) => employees.map((employee) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                employee.name,
                style: pw.TextStyle(
                  fontSize: 16, // Slightly smaller font
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 6), // Reduced space between sections
              pw.Table.fromTextArray(
                headers: ['Task Name', 'Status'],
                data: employee.tasks.map((task) {
                  return [
                    task.name,
                    task.status,
                  ];
                }).toList(),
              ),
              pw.SizedBox(height: 6),
              pw.Text(
                "Completed: ${employee.completedTasksCount}, Pending: ${employee.pendingTasksCount}",
                style: pw.TextStyle(fontSize: 12), // Smaller font
              ),
              pw.Text(
                "Average Completed: ${employee.completedPercentage.toStringAsFixed(2)}%",
                style: pw.TextStyle(fontSize: 12), // Smaller font
              ),
              pw.Divider(),
            ],
          );
        }).toList(),
      ),
    );

    try {
      return await pdf.save();
    } catch (e) {
      debugPrint("Error generating PDF: $e");
      return null;
    }
  }
}

class PDFPreviewScreen extends StatelessWidget {
  final Uint8List pdfBytes;

  const PDFPreviewScreen({Key? key, required this.pdfBytes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PDF Preview"),
        toolbarHeight: 50, // Reduced AppBar height
      ),
      body: Padding(
        padding: const EdgeInsets.all(4), // Reduced padding around the PDF view
        child: PDFView(
          pdfData: pdfBytes,
          swipeHorizontal: true,
          enableSwipe: true,
          autoSpacing: false,
        ),
      ),
    );
  }
}
