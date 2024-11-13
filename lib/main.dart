// lib/main.dart
import 'package:flutter/material.dart';

void main() {
  runApp(const VicobaApp());
}

class VicobaApp extends StatelessWidget {
  const VicobaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VICOBA Manager',
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Roboto',
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Member> members = [];
  final List<Transaction> transactions = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VICOBA Manager'),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () {
              // TODO: Implement language switch (Swahili/English)
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green,
              ),
              child: Text(
                'VICOBA Manager',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.group),
              title: const Text('Wanachama (Members)'),
              onTap: () {
                setState(() {
                  _selectedIndex = 0;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.money),
              title: const Text('Michango (Contributions)'),
              onTap: () {
                setState(() {
                  _selectedIndex = 1;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.account_balance),
              title: const Text('Mikopo (Loans)'),
              onTap: () {
                setState(() {
                  _selectedIndex = 2;
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: _getPage(_selectedIndex),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return _buildMembersPage();
      case 1:
        return _buildContributionsPage();
      case 2:
        return _buildLoansPage();
      default:
        return const Center(child: Text('Page not found'));
    }
  }

  Widget _buildMembersPage() {
    return ListView.builder(
      itemCount: members.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: const CircleAvatar(
            child: Icon(Icons.person),
          ),
          title: Text(members[index].name),
          subtitle: Text('Simu: ${members[index].phone}'),
          trailing: Text('${members[index].shares} shares'),
        );
      },
    );
  }

  Widget _buildContributionsPage() {
    return ListView.builder(
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return ListTile(
          leading: const Icon(Icons.payment),
          title: Text(transaction.memberName),
          subtitle: Text('Tarehe: ${transaction.date}'),
          trailing: Text('TSh ${transaction.amount}'),
        );
      },
    );
  }

  Widget _buildLoansPage() {
    return const Center(
      child: Text('Mikopo (Loans) coming soon...'),
    );
  }

  void _showAddDialog(BuildContext context) {
    if (_selectedIndex == 0) {
      _showAddMemberDialog(context);
    } else if (_selectedIndex == 1) {
      _showAddContributionDialog(context);
    }
  }

  void _showAddMemberDialog(BuildContext context) {
    String name = '';
    String phone = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ongeza Mwanachama (Add Member)'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Jina (Name)'),
                onChanged: (value) => name = value,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Simu (Phone)'),
                keyboardType: TextInputType.phone,
                onChanged: (value) => phone = value,
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                setState(() {
                  members.add(Member(name: name, phone: phone));
                });
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _showAddContributionDialog(BuildContext context) {
    String memberName = '';
    double amount = 0;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ongeza Mchango (Add Contribution)'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Jina (Name)'),
                onChanged: (value) => memberName = value,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Kiasi (Amount)'),
                keyboardType: TextInputType.number,
                onChanged: (value) => amount = double.tryParse(value) ?? 0,
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                setState(() {
                  transactions.add(
                    Transaction(
                      memberName: memberName,
                      amount: amount,
                      date: DateTime.now().toString().split(' ')[0],
                    ),
                  );
                });
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}

class Member {
  final String name;
  final String phone;
  int shares;

  Member({
    required this.name,
    required this.phone,
    this.shares = 0,
  });
}

class Transaction {
  final String memberName;
  final double amount;
  final String date;

  Transaction({
    required this.memberName,
    required this.amount,
    required this.date,
  });
}
