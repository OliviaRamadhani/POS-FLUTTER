import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  DateTime? selectedDate;
  bool isLoading = false;
  String error = '';
  List<Transaction> transactions = [];

  @override
  void initState() {
    super.initState();
    // You can call your API here to load transactions
  }

  // Mock data for transactions
  final List<Transaction> allTransactions = [
    Transaction(
      id: 1,
      customerName: 'John Doe',
      items: 'Item A, Item B',
      totalPrice: 50000,
      status: 'Paid',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      created: true,
    ),
    // More mock transactions...
  ];

  void filterByDate(DateTime? date) {
    if (date == null) {
      setState(() {
        transactions = allTransactions;
      });
    } else {
      setState(() {
        transactions = allTransactions
            .where((transaction) =>
                DateFormat('yyyy-MM-dd').format(transaction.createdAt) ==
                DateFormat('yyyy-MM-dd').format(date))
            .toList();
      });
    }
  }

  void printTransaction() {
    // Implement your printing logic here (e.g., generating a PDF or calling a native print plugin)
    print("Printing transactions...");
  }

  void exportTransaction() {
    // Implement your export logic here (e.g., exporting to Excel)
    print("Exporting transactions...");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Orders'),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            onPressed: printTransaction,
            icon: const Icon(Icons.print),
          ),
          IconButton(
            onPressed: exportTransaction,
            icon: const Icon(Icons.file_copy),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text('Filter by Date:'),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (picked != null && picked != selectedDate) {
                      setState(() {
                        selectedDate = picked;
                        filterByDate(selectedDate);
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          if (isLoading)
            const Center(child: CircularProgressIndicator())
          else if (error.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                error,
                style: const TextStyle(color: Colors.red),
              ),
            )
          else if (transactions.isEmpty)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('No transactions for the selected date.'),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  final transaction = transactions[index];
                  return Card(
                    margin: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text(transaction.customerName),
                      subtitle: Text(transaction.items),
                      trailing: Text('${transaction.totalPrice} IDR'),
                      onTap: () {
                        _showTransactionDetails(transaction);
                      },
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  void _showTransactionDetails(Transaction transaction) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Transaction Details'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: ${transaction.id}'),
            Text('Customer: ${transaction.customerName}'),
            Text('Items: ${transaction.items}'),
            Text('Total: ${transaction.totalPrice} IDR'),
            Text('Status: ${transaction.status}'),
            Text(
                'Date: ${DateFormat('yyyy-MM-dd').format(transaction.createdAt)}'),
            Text('Processed: ${transaction.created ? 'Yes' : 'No'}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class Transaction {
  final int id;
  final String customerName;
  final String items;
  final int totalPrice;
  final String status;
  final DateTime createdAt;
  bool created;

  Transaction({
    required this.id,
    required this.customerName,
    required this.items,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
    this.created = false,
  });
}

void main() {
  runApp(const MaterialApp(home: OrdersScreen()));
}
