import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class MyAddressPage extends StatefulWidget {
  const MyAddressPage({super.key});

  @override
  State<MyAddressPage> createState() => _MyAddressPageState();
}

class _MyAddressPageState extends State<MyAddressPage> {
  final TextEditingController _regencyController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  List<Map<String, dynamic>> addresses = [];
  bool _isPrimaryAddress = false;
  bool _isFormVisible = false;

  Future<void> _getCurrentAddress() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _addressController.text =
          "Lat: ${position.latitude}, Long: ${position.longitude}";
    });
  }

  void _addNewAddress() {
    if (_addressController.text.isNotEmpty &&
        _regencyController.text.isNotEmpty &&
        _districtController.text.isNotEmpty &&
        _postalCodeController.text.isNotEmpty) {
      setState(() {
        addresses.add({
          "regency": _regencyController.text,
          "district": _districtController.text,
          "address": _addressController.text,
          "postalCode": _postalCodeController.text,
          "isPrimary": _isPrimaryAddress,
        });

        // Clear form for new entry
        _regencyController.clear();
        _districtController.clear();
        _addressController.clear();
        _postalCodeController.clear();
        _isPrimaryAddress = false;
        _isFormVisible = false; // Hide form after adding the address
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Find the primary address, if it exists
    final primaryAddress = addresses.firstWhere(
      (address) => address["isPrimary"],
      orElse: () => {}, // Return an empty map if no primary address is found
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Address"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Display primary address at the top if available
            if (primaryAddress.isNotEmpty) ...[
              Text(
                "Current Primary Address:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              ListTile(
                title: Text(primaryAddress['address']),
                subtitle: Text(
                  "${primaryAddress['regency']}, ${primaryAddress['district']} - ${primaryAddress['postalCode']}",
                ),
              ),
              Divider(),
            ],
            SizedBox(height: 10),
            // Form to add new address, visible only when _isFormVisible is true
            if (_isFormVisible) ...[
              Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.grey[300],
                  image: DecorationImage(
                    image: NetworkImage(
                      'https://maps.googleapis.com/maps/api/staticmap?center=-6.2088,106.8456&zoom=15&size=600x300&maptype=roadmap'
                      '&key=YOUR_GOOGLE_MAPS_API_KEY',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    icon: Icon(Icons.my_location, color: Colors.blue),
                    onPressed: _getCurrentAddress,
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _regencyController,
                decoration: InputDecoration(
                  labelText: "Regency/City",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _districtController,
                decoration: InputDecoration(
                  labelText: "District",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: "Complete Address",
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              SizedBox(height: 10),
              TextField(
                controller: _postalCodeController,
                decoration: InputDecoration(
                  labelText: "Postal Code",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Checkbox(
                    value: _isPrimaryAddress,
                    onChanged: (bool? value) {
                      setState(() {
                        _isPrimaryAddress = value ?? false;
                      });
                    },
                  ),
                  Text("Set as Primary Address"),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addNewAddress,
                child: Text("Save New Address"),
              ),
              Divider(),
            ],
            // Button to toggle form visibility
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isFormVisible = !_isFormVisible;
                });
              },
              child: Text(_isFormVisible ? "Cancel" : "Add New Address"),
            ),
            SizedBox(height: 20),
            // List of saved addresses
            Expanded(
              child: ListView.builder(
                itemCount: addresses.length,
                itemBuilder: (context, index) {
                  final address = addresses[index];
                  return ListTile(
                    title: Text(address['address']),
                    subtitle: Text(
                      "${address['regency']}, ${address['district']} - ${address['postalCode']}\n${address['isPrimary'] ? "Primary Address" : "Secondary Address"}",
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          addresses.removeAt(index);
                        });
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
