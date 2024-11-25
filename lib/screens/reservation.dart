import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For jsonDecode

class Reservation extends StatefulWidget {
  @override
  _ReservationState createState() => _ReservationState();
}

class _ReservationState extends State<Reservation> {
  // Controllers for text input fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _guestsController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();

  // List for menu items and selected menu
  List<Map<String, dynamic>> _menuItems = [];
  List<Map<String, dynamic>> _selectedMenus = [];
  int _selectedQuantity = 1;

  // DateTime for validation
  DateTime? _selectedDate;
  TimeOfDay? _selectedStartTime;
  TimeOfDay? _selectedEndTime;

  // Validation flag
  bool _showMenuError = false;

  // Helper method to format the date
  String _formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  // Helper method to format the time
  String _formatTime(TimeOfDay time) {
    return time.format(context);
  }

  // Method to add a selected menu to the list
  void _addMenu() {
    setState(() {
      _selectedMenus.add({
        'name': _menuItems.firstWhere((item) => item['id'] == _selectedQuantity)['name'],
        'price': _menuItems.firstWhere((item) => item['id'] == _selectedQuantity)['price'],
        'quantity': _selectedQuantity,
      });
    });
  }

  // Method to calculate total price
  int get _totalPrice {
    return _selectedMenus.fold(0, (int total, menu) {
      int price = menu['price'] is int ? menu['price'] : menu['price'].toInt();
      int quantity = menu['quantity'] is int ? menu['quantity'] : menu['quantity'].toInt();
      return total + (price * quantity);
    });
  }

  // Fetch menu items from the API
  Future<void> _fetchMenuItems() async {
    final response = await http.get(Uri.parse('http://192.168.2.139:8000/api/inventori/produk'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      setState(() {
        _menuItems = data.map((item) => {
          'id': item['id'],
          'name': item['name'],
          'price': item['price'],
        }).toList();
      });
    } else {
      throw Exception('Failed to load menu items');
    }
  }

  // Method to submit reservation data to the API
  Future<void> _submitReservation() async {
    final response = await http.post(
      Uri.parse('http://192.168.2.139:8000/api/reservations'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'name': _nameController.text,
        'phone': _phoneController.text,
        'guests': int.parse(_guestsController.text),
        'date': _dateController.text,
        'start_time': _startTimeController.text,
        'end_time': _endTimeController.text,
        'menus': _selectedMenus,
      }),
    );

    if (response.statusCode == 201) {
      // Successfully submitted
      print("Reservation submitted successfully");
      // Optionally, clear the form or show a success message
    } else {
      // Handle error
      print("Failed to submit reservation: ${response.body}");
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchMenuItems(); // Fetch menu items when the widget is initialized
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Make a Reservation")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Name"),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(hintText: "Enter your name"),
              ),
              SizedBox(height: 10),
              Text("Phone"),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(hintText: "Enter your phone number"),
              ),
              SizedBox(height: 10),
              Text("Date"),
              TextField(
                controller: _dateController,
                decoration: InputDecoration(hintText: "Select a date"),
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _selectedDate = pickedDate;
                      _dateController.text = _formatDate(pickedDate);
                    });
                  }
                },
              ),
              SizedBox(height: 10),
              Text("Start Time"),
              TextField(
                controller: _startTimeController,
                decoration: InputDecoration(hintText: "Select start time"),
                readOnly: true,
                onTap: () async {
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (pickedTime != null) {
                    setState(() {
                      _selectedStartTime = pickedTime;
                      _startTimeController.text = _formatTime(pickedTime);
                    });
                  }
                },
              ),
              SizedBox(height: 10),
              Text("End Time"),
              TextField(
                controller: _endTimeController,
                decoration: InputDecoration(hintText: "Select end time"),
                readOnly: true,
                onTap: () async {
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (pickedTime != null) {
                    setState(() {
                      _selectedEndTime = pickedTime;
                      _endTimeController.text = _formatTime(pickedTime);
                    });
                  }
                },
              ),
              SizedBox(height: 10),
              Text("Guests"),
              TextField(
                controller: _guestsController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(hintText: "Enter number of guests"),
              ),
              SizedBox(height: 10),
              Text("Menu"),
              DropdownButton<int>(
                value: _selectedQuantity,
                onChanged: (int? newValue) {
                  setState(() {
                    _selectedQuantity = newValue!;
                  });
                },
                items: _menuItems.map((menu) {
                  return DropdownMenuItem<int>(
                    value: menu['id'],
                    child: Text("${menu['name']} - \$${menu['price']}"),
                  );
                }).toList(),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: TextEditingController(text: _selectedQuantity.toString()),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(hintText: "Quantity"),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: _addMenu,
                  ),
                ],
              ),
              SizedBox(height: 10),
              if (_selectedMenus.isNotEmpty) ...[
                Text("Selected Menus"),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: _selectedMenus.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text("${_selectedMenus[index]['name']} x ${_selectedMenus[index]['quantity']}"),
                      trailing: Text("\$${_selectedMenus[index]['price'] * _selectedMenus[index]['quantity']}"),
                    );
                  },
                ),
              ],
              SizedBox(height: 10),
              Text("Total Price: \$$_totalPrice"),
              if (_showMenuError) ...[
                Text("Please add at least one menu before submitting.", style: TextStyle(color: Colors.red)),
              ],
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Submit the reservation
                  if (_selectedMenus.isEmpty) {
                    setState(() {
                      _showMenuError = true;
                    });
                  } else {
                    setState(() {
                      _showMenuError = false;
                    });
                    _submitReservation(); // Call the method to submit reservation
                  }
                },
                child: Text("Reserve"),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 