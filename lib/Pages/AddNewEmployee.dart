import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddNewEmployee extends StatelessWidget {
  final String userName;
  final String userId;

  const AddNewEmployee({Key? key, required this.userName, required this.userId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Employee Registration',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: EmployeeRegistrationForm(userName: userName, userId: userId),
    );
  }
}

class EmployeeRegistrationForm extends StatefulWidget {
  final String userName;
  final String userId;

  const EmployeeRegistrationForm(
      {required this.userName, required this.userId});

  @override
  _EmployeeRegistrationFormState createState() =>
      _EmployeeRegistrationFormState();
}

class _EmployeeRegistrationFormState extends State<EmployeeRegistrationForm> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _birthdateController = TextEditingController();
  final TextEditingController _salaryController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _ssnController = TextEditingController();

  String? _selectedGender;

  @override
  void initState() {
    super.initState();
    _generateEmployeeId();
  }

  Future<void> _generateEmployeeId() async {
    try {
      // Get the last employee's ID from Firestore
      final snapshot = await FirebaseFirestore.instance
          .collection('employees')
          .orderBy('id', descending: true)
          .limit(1)
          .get();

      int newId = 50001; // Default starting ID
      if (snapshot.docs.isNotEmpty) {
        final lastId = int.tryParse(snapshot.docs.first['id'] ?? '50000');
        if (lastId != null) {
          newId = lastId + 1;
        }
      }

      // Set the new ID to the text controller
      setState(() {
        _idController.text = newId.toString();
      });
    } catch (e) {
      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error generating ID: ${e.toString()}')),
      );
    }
  }

  Future<void> _registerEmployee() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Create user in Firebase Authentication
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        // Save employee data in Firestore
        await FirebaseFirestore.instance.collection('employees').add({
          'name': _nameController.text,
          'id': _idController.text,
          'phone': _phoneController.text,
          'gender': _selectedGender,
          'birthDate': _birthdateController.text,
          'salary': _salaryController.text,
          'email': _emailController.text,
          'ssn': _ssnController.text,
          'userId': userCredential.user!.uid,
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Employee registered successfully!')),
        );

        // Clear the form
        _formKey.currentState!.reset();
        _birthdateController.clear();
        _selectedGender = null;
      } catch (e) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3EAFD),
      appBar: AppBar(
        title: Center(child: Text('Employee Registration')),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  _buildProfileSection(),
                  SizedBox(height: 20),
                  _buildTextField('Name', controller: _nameController),
                  _buildTextField('ID',
                      controller: _idController, readOnly: true),
                  _buildTextField('Phone', controller: _phoneController),
                  _buildGenderDropdown(),
                  _buildDateField(context, 'Birth Date', _birthdateController),
                  _buildTextField('Salary', controller: _salaryController),
                  _buildTextField('Email',
                      inputType: TextInputType.emailAddress,
                      controller: _emailController),
                  _buildTextField('Password',
                      isPassword: true, controller: _passwordController),
                  _buildTextField('SSN', controller: _ssnController),
                  SizedBox(height: 20),
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: _registerEmployee,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          minimumSize: Size(double.infinity, 50),
                        ),
                        child: Text('Submit'),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          minimumSize: Size(double.infinity, 50),
                        ),
                        child: Text('Return'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
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
              _buildChip(widget.userName, Colors.grey[600]!),
              SizedBox(height: 10),
              _buildChip(widget.userId, Color(0xFF222222)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String label, Color color) {
    return Chip(
      label: Text(
        label,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: color,
    );
  }

  Widget _buildTextField(String label,
      {TextInputType inputType = TextInputType.text,
      bool isPassword = false,
      bool readOnly = false,
      required TextEditingController controller}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.black),
          fillColor: Colors.grey[300],
          filled: true,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: Colors.deepPurple),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: Colors.grey),
          ),
        ),
        keyboardType: inputType,
        obscureText: isPassword,
        style: TextStyle(color: Colors.black),
        validator: (value) {
          if (!readOnly && (value == null || value.isEmpty)) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Gender',
          labelStyle: TextStyle(color: Colors.black),
          fillColor: Colors.grey[300],
          filled: true,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: Colors.deepPurple),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: Colors.grey),
          ),
        ),
        value: _selectedGender,
        onChanged: (String? newValue) {
          setState(() {
            _selectedGender = newValue;
          });
        },
        items: <String>['Male', 'Female']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select a gender';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDateField(
      BuildContext context, String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.black),
          fillColor: Colors.grey[300],
          filled: true,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: Colors.deepPurple),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: Colors.grey),
          ),
        ),
        readOnly: true,
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime(2100),
          );

          if (pickedDate != null) {
            String formattedDate =
                "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
            controller.text = formattedDate;
          }
        },
        style: TextStyle(color: Colors.black),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select $label';
          }
          return null;
        },
      ),
    );
  }
}
