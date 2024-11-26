import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Menu2(),
    );
  }
}

class Menu2 extends StatefulWidget {
  const Menu2({super.key});

  @override
  _Menu2State createState() => _Menu2State();
}

class _Menu2State extends State<Menu2> {
  final List<Map<String, dynamic>> menus = [
    {
      "name": "Pizza",
      "price": "\$12.00",
      "status": "Available",
      "description": "A delicious cheese pizza with fresh toppings.",
      "category": "Food"
    },
    {
      "name": "Burger",
      "price": "\$8.50",
      "status": "Out of Stock",
      "description": "A tasty beef burger with lettuce and cheese.",
      "category": "Food"
    },
    {
      "name": "Pasta",
      "price": "\$10.00",
      "status": "Available",
      "description": "Spaghetti with a rich tomato sauce.",
      "category": "Food"
    },
    {
      "name": "Coke",
      "price": "\$2.50",
      "status": "Available",
      "description": "A refreshing soda.",
      "category": "Drink"
    },
    {
      "name": "Ice Cream",
      "price": "\$5.00",
      "status": "Available",
      "description": "A sweet and creamy vanilla ice cream.",
      "category": "Dessert"
    },
  ];

  // Controllers for the new menu form
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  String selectedCategory = 'Food'; // Default category

  void _addMenu() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Add New Menu",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          content: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: "Menu Name",
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                  ),
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: priceController,
                  decoration: const InputDecoration(
                    labelText: "Price",
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                  ),
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: "Description",
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                  ),
                  style: const TextStyle(fontSize: 16),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                DropdownButton<String>(
                  value: selectedCategory,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedCategory = newValue!;
                    });
                  },
                  items: <String>['Food', 'Drink', 'Dessert']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  menus.add({
                    "name": nameController.text,
                    "price": priceController.text,
                    "status": "Available",
                    "description": descriptionController.text,
                    "category": selectedCategory,
                  });
                });
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                foregroundColor:
                    Colors.white, // Use 'foregroundColor' instead of 'primary'
                backgroundColor: Colors.blue,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text(
                "Add Menu",
                style: TextStyle(fontSize: 16),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                foregroundColor:
                    Colors.black, // Use 'foregroundColor' instead of 'primary'
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text(
                "Cancel",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        );
      },
    );
  }

  void _deleteMenu(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text('Do you want to delete this menu item?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  menus.removeAt(index); // Delete the menu item
                });
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _viewMenu(int index) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                menus[index]['name'],
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                "Price: ${menus[index]['price']}",
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(
                "Status: ${menus[index]['status']}",
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(
                "Category: ${menus[index]['category']}",
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(
                "Description: ${menus[index]['description']}",
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _editMenu(index); // Open the Edit dialog
                },
                child: const Text("Edit Menu"),
              ),
            ],
          ),
        );
      },
    );
  }

  void _editMenu(int index) {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController nameController =
            TextEditingController(text: menus[index]['name']);
        final TextEditingController priceController =
            TextEditingController(text: menus[index]['price']);
        final TextEditingController descriptionController =
            TextEditingController(text: menus[index]['description']);

        String category = menus[index]['category'];

        return AlertDialog(
          title: const Text(
            "Edit Menu",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          content: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: "Menu Name",
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                  ),
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: priceController,
                  decoration: const InputDecoration(
                    labelText: "Price",
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                  ),
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: "Description",
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                  ),
                  style: const TextStyle(fontSize: 16),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                DropdownButton<String>(
                  value: category,
                  onChanged: (String? newValue) {
                    setState(() {
                      category = newValue!;
                    });
                  },
                  items: <String>['Food', 'Drink', 'Dessert']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  menus[index] = {
                    "name": nameController.text,
                    "price": priceController.text,
                    "status": menus[index]['status'],
                    "description": descriptionController.text,
                    "category": category,
                  };
                });
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                foregroundColor:
                    Colors.white, // Use 'foregroundColor' instead of 'primary'
                backgroundColor: Colors.blue,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text(
                "Save Changes",
                style: TextStyle(fontSize: 16),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                foregroundColor:
                    Colors.black, // Use 'foregroundColor' instead of 'primary'
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text(
                "Cancel",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu List'),
      ),
      body: ListView.builder(
        itemCount: menus.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              title: Text(
                menus[index]['name'],
                style: const TextStyle(fontSize: 18),
              ),
              subtitle: Text(menus[index]['price']),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {
                      _viewMenu(index);
                    },
                    icon: const Icon(Icons.visibility),
                  ),
                  IconButton(
                    onPressed: () {
                      _deleteMenu(index);
                    },
                    icon: const Icon(Icons.delete),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addMenu,
        child: const Icon(Icons.add),
      ),
    );
  }
}
