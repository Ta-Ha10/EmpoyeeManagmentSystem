import 'package:flutter/material.dart';

void main() {
  runApp(const TaskCompletionRequests());
}

class TaskCompletionRequests extends StatelessWidget {
  const TaskCompletionRequests({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFFF0E5FF), // Light lavender background
        appBar: AppBar(
          backgroundColor: const Color(0xFFB3A4F6), // Custom AppBar color
          elevation: 0,
          leading: const Icon(
            Icons.menu,
            color: Colors.black,
          ),
          title: const Text(
            'Task completion requests',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            children: [
              // Employee Information Section
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, size: 40, color: Colors.grey),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          EmployeeField(label: "Employee name"),
                          EmployeeField(label: "Employee ID"),
                          EmployeeField(label: "Task ID"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Task Title
              CustomTextBox(label: "Task title", height: 40),

              // Notes Section
              const SizedBox(height: 10),
              CustomTextBox(label: "Notes to be edited", height: 150),

              // Dates Section
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(label: "Starting Date"),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: CustomButton(label: "End Date"),
                  ),
                ],
              ),

              // Remaining Time & Performance
              const SizedBox(height: 10),
              CustomTextField(label: "remaining time"),
              const SizedBox(height: 10),
              CustomTextField(label: "performance"),

              // Action Buttons (pones and Deduct)
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFA9BA8), // Pink
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text(
                        "pones",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFA9BA8), // Pink
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text(
                        "Deduct",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),

              // Return Button
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB3A4F6), // Button color
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text(
                  "Return",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Employee Info Field Widget
class EmployeeField extends StatelessWidget {
  final String label;

  const EmployeeField({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.grey.shade800,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }
}

// Custom Text Box Widget
class CustomTextBox extends StatelessWidget {
  final String label;
  final double height;

  const CustomTextBox({super.key, required this.label, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Center(
        child: Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
      ),
    );
  }
}

// Custom Text Field Widget
class CustomTextField extends StatelessWidget {
  final String label;

  const CustomTextField({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: Container(
            height: 30,
            decoration: BoxDecoration(
              color: Colors.grey.shade800,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
      ],
    );
  }
}

// Custom Button Widget
class CustomButton extends StatelessWidget {
  final String label;

  const CustomButton({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Center(
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
