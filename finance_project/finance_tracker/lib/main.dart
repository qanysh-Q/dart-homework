import 'package:flutter/material.dart';

void main() {
  runApp(const FinanceWebApp());
}

class FinanceWebApp extends StatelessWidget {
  const FinanceWebApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finance Web Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
        scaffoldBackgroundColor: const Color(0xFFF5F6FA),
      ),
      home: const WebDashboardScreen(),
    );
  }
}

class WebDashboardScreen extends StatefulWidget {
  const WebDashboardScreen({super.key});

  @override
  State<WebDashboardScreen> createState() => _WebDashboardScreenState();
}

class _WebDashboardScreenState extends State<WebDashboardScreen> {
  int _selectedIndex = 0;

  // Dynamic transaction list
  final List<Map<String, dynamic>> _transactions = [
    {'title': 'Apple Store', 'category': 'Electronics', 'amount': -1200.00, 'date': '10 Oct 2026', 'status': 'Completed'},
    {'title': 'Upwork Salary', 'category': 'Income', 'amount': 3400.00, 'date': '08 Oct 2026', 'status': 'Completed'},
    {'title': 'Starbucks', 'category': 'Food & Drink', 'amount': -12.50, 'date': '07 Oct 2026', 'status': 'Pending'},
    {'title': 'AWS Cloud', 'category': 'Services', 'amount': -45.00, 'date': '05 Oct 2026', 'status': 'Completed'},
  ];

  final List<String> _categories = [
    'Income',
    'Food & Drink',
    'Electronics',
    'Services',
    'Shopping',
    'Transport',
    'Misc'
  ];

  // Automatic stats calculation
  double get _totalIncome => _transactions
      .where((tx) => tx['amount'] > 0)
      .fold(0.0, (sum, tx) => sum + tx['amount']);

  double get _totalExpense => _transactions
      .where((tx) => tx['amount'] < 0)
      .fold(0.0, (sum, tx) => sum + (tx['amount'] * -1));

  double get _balance => 10307.50 + _totalIncome - _totalExpense; // Base starting balance

  void _deleteTransaction(int index) {
    setState(() {
      _transactions.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Transaction deleted'), duration: Duration(seconds: 2)),
    );
  }

  void _showAddTransactionDialog() {
    final titleController = TextEditingController();
    final amountController = TextEditingController();
    bool isIncome = false;
    String selectedCategory = 'Misc';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('New Transaction'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText: 'Title (e.g., Coffee)'),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: amountController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(labelText: 'Amount'),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedCategory,
                    decoration: const InputDecoration(labelText: 'Category'),
                    items: _categories.map((String category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setDialogState(() {
                        selectedCategory = newValue!;
                        if (selectedCategory == 'Income') {
                          isIncome = true;
                        }
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: Text(isIncome ? 'Income' : 'Expense'),
                    value: isIncome,
                    onChanged: (value) => setDialogState(() => isIncome = value),
                    activeColor: Colors.green,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final title = titleController.text;
                    final amountText = amountController.text.replaceAll(',', '.');
                    final amount = double.tryParse(amountText);

                    if (title.isNotEmpty && amount != null) {
                      setState(() {
                        _transactions.insert(0, {
                          'title': title,
                          'category': selectedCategory,
                          'amount': isIncome ? amount : -amount,
                          'date': 'Just now',
                          'status': 'Completed',
                        });
                      });
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple, foregroundColor: Colors.white),
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() => _selectedIndex = index);
            },
            extended: true,
            minExtendedWidth: 200,
            backgroundColor: Colors.white,
            leading: const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'FinTrack.',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.deepPurple),
              ),
            ),
            destinations: const [
              NavigationRailDestination(icon: Icon(Icons.dashboard), label: Text('Dashboard')),
              NavigationRailDestination(icon: Icon(Icons.wallet), label: Text('Transactions')),
              NavigationRailDestination(icon: Icon(Icons.bar_chart), label: Text('Analytics')),
              NavigationRailDestination(icon: Icon(Icons.settings), label: Text('Settings')),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: _selectedIndex == 0 
                ? _buildDashboardContent() 
                : Center(
                    child: Text(
                      'Section under development', 
                      style: TextStyle(fontSize: 24, color: Colors.grey.shade600)
                    )
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardContent() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Overview',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                ),
                onPressed: _showAddTransactionDialog,
                icon: const Icon(Icons.add),
                label: const Text('Add Transaction'),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              _buildStatCard('Total Balance', '\$${_balance.toStringAsFixed(2)}', Icons.account_balance_wallet, Colors.blue),
              const SizedBox(width: 24),
              _buildStatCard('Total Income', '+\$${_totalIncome.toStringAsFixed(2)}', Icons.arrow_upward, Colors.green),
              const SizedBox(width: 24),
              _buildStatCard('Total Expense', '-\$${_totalExpense.toStringAsFixed(2)}', Icons.arrow_downward, Colors.red),
            ],
          ),
          const SizedBox(height: 40),
          const Text('Recent Transactions', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: SingleChildScrollView(
                child: DataTable(
                  headingTextStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                  columns: const [
                    DataColumn(label: Text('TITLE')),
                    DataColumn(label: Text('CATEGORY')),
                    DataColumn(label: Text('DATE')),
                    DataColumn(label: Text('STATUS')),
                    DataColumn(label: Text('AMOUNT')),
                    DataColumn(label: Text('ACTION')),
                  ],
                  rows: _transactions.asMap().entries.map((entry) {
                    final index = entry.key;
                    final tx = entry.value;
                    final isNegative = tx['amount'] < 0;
                    
                    return DataRow(cells: [
                      DataCell(Text(tx['title'], style: const TextStyle(fontWeight: FontWeight.bold))),
                      DataCell(Text(tx['category'])),
                      DataCell(Text(tx['date'])),
                      DataCell(
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: tx['status'] == 'Completed' ? Colors.green.shade50 : Colors.orange.shade50,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            tx['status'], 
                            style: TextStyle(color: tx['status'] == 'Completed' ? Colors.green : Colors.orange),
                          ),
                        ),
                      ),
                      DataCell(
                        Text(
                          isNegative ? '-\$${(tx['amount'] * -1).toStringAsFixed(2)}' : '+\$${tx['amount'].toStringAsFixed(2)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold, 
                            color: isNegative ? Colors.red : Colors.green,
                          ),
                        ),
                      ),
                      DataCell(
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.red),
                          onPressed: () => _deleteTransaction(index),
                          tooltip: 'Delete transaction',
                        ),
                      ),
                    ]);
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String amount, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: const TextStyle(color: Colors.grey, fontSize: 16)),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
                  child: Icon(icon, color: color, size: 24),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(amount, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}