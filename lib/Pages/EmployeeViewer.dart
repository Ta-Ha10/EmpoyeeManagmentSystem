import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EmployeeViewer extends StatefulWidget {
  final String userName;
  final String userId;

  const EmployeeViewer({Key? key, required this.userName, required this.userId})
      : super(key: key);

  @override
  State<EmployeeViewer> createState() => _EmployeeViewerState();
}

class _EmployeeViewerState extends State<EmployeeViewer> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _birthdateController = TextEditingController();
  final TextEditingController _salaryController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _ssnController = TextEditingController();
  final TextEditingController _managerController = TextEditingController();

  List<Map<String, dynamic>> _filteredEmployees = [];
  bool _isDropdownVisible = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchManagerData(); // Fetch manager data when the widget is initialized
  }

  Future<void> _fetchManagerData() async {
    try {
      final managerDoc = await FirebaseFirestore.instance
          .collection(
              'managers') // Replace with your actual managers collection
          .doc(widget.userId) // Use the userId to fetch manager data
          .get();

      if (managerDoc.exists) {
        setState(() {
          _managerController.text = managerDoc['name'] ?? 'Manager Not Found';
        });
      } else {
        _managerController.text = 'Manager Not Found';
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching manager: ${e.toString()}')),
      );
    }
  }

  void _filterEmployees(String query) async {
    if (query.isEmpty) {
      setState(() {
        _isDropdownVisible = false;
        _filteredEmployees = [];
      });
      return;
    }

    setState(() => _isLoading = true);

    try {
      final nameSnapshot = await FirebaseFirestore.instance
          .collection('employees')
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThanOrEqualTo: query + '\uf8ff')
          .get();

      final idSnapshot = await FirebaseFirestore.instance
          .collection('employees')
          .where('id', isEqualTo: query)
          .get();

      setState(() {
        _filteredEmployees = [
          ...nameSnapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}),
          ...idSnapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}),
        ];
        _isDropdownVisible = _filteredEmployees.isNotEmpty;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isDropdownVisible = false;
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  void _selectEmployee(Map<String, dynamic> employee) {
    setState(() {
      _nameController.text = employee['name'] ?? '';
      _idController.text = employee['id'] ?? '';
      _phoneController.text = employee['phone'] ?? '';
      _genderController.text = employee['gender'] ?? '';
      _birthdateController.text = employee['birthDate'] ?? '';
      _salaryController.text = employee['salary'] ?? '';
      _emailController.text = employee['email'] ?? '';
      _ssnController.text = employee['ssn'] ?? '';
      _managerController.text = employee['manager'] ?? '';
      _isDropdownVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3EAFD),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFFB3A4F6),
        title: Text(
          'Employee Viewer',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildProfileSection(),
              SizedBox(height: 16),
              _buildSearchSection(),
              if (_isDropdownVisible) _buildDropdownList(),
              SizedBox(height: 16),
              _buildTextField('Name', _nameController, true),
              _buildTextField('ID', _idController, true),
              _buildTextField('Phone', _phoneController, true),
              _buildTextField('Gender', _genderController, true),
              _buildTextField('Birthdate', _birthdateController, true),
              _buildTextField('Salary', _salaryController, true),
              _buildTextField('Email', _emailController, true),
              _buildTextField('SSN', _ssnController, true),
              SizedBox(height: 20),
              _buildReturnButton(),
            ],
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

  Widget _buildChip(String text, Color backgroundColor) {
    return IntrinsicWidth(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
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
                hintText: 'Search by Name or ID',
                hintStyle: TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: _filterEmployees,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownList() {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: _filteredEmployees.length,
        itemBuilder: (context, index) {
          final employee = _filteredEmployees[index];
          return ListTile(
            title: Text(
              "${employee['id']} - ${employee['name']}",
              style: TextStyle(color: Colors.black),
            ),
            onTap: () => _selectEmployee(employee),
          );
        },
      ),
    );
  }

  Widget _buildTextField(
      String label, TextEditingController controller, bool readOnly) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
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

  Widget _buildReturnButton() {
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
