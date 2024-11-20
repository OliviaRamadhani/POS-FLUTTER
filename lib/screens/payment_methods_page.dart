import 'package:flutter/material.dart';

class PaymentMethodsPage extends StatelessWidget {
  const PaymentMethodsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 6, 31, 68),
        title: Text(
          "Payment Methods",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Select your preferred payment method:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  _buildPaymentMethodTile(
                    icon: Icons.credit_card,
                    title: "Credit Card",
                    subtitle: "Visa, MasterCard, etc.",
                    onTap: () {
                      // Handle credit card selection
                    },
                  ),
                  _buildPaymentMethodTile(
                    icon: Icons.account_balance,
                    title: "Bank Transfer",
                    subtitle: "Transfer directly from your bank",
                    onTap: () {
                      // Handle bank transfer selection
                    },
                  ),
                  _buildPaymentMethodTile(
                    icon: Icons.paypal,
                    title: "PayPal",
                    subtitle: "Use your PayPal account",
                    onTap: () {
                      // Handle PayPal selection
                    },
                  ),
                  _buildPaymentMethodTile(
                    icon: Icons.phone_iphone,
                    title: "Mobile Payment",
                    subtitle: "Apple Pay, Google Pay, etc.",
                    onTap: () {
                      // Handle mobile payment selection
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Handle adding a new payment method
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 6, 31, 68),
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                "Add New Payment Method",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 2,
      child: ListTile(
        leading:
            Icon(icon, color: const Color.fromARGB(255, 6, 31, 68), size: 32),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle),
        trailing: Icon(Icons.chevron_right,
            color: const Color.fromARGB(255, 6, 31, 68)),
        onTap: onTap,
      ),
    );
  }
}
