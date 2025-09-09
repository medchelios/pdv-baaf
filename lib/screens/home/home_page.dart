import 'package:flutter/material.dart';
import 'widgets/header_section.dart';
import 'widgets/balance_card.dart';
import 'widgets/quick_actions.dart';
import 'widgets/recent_transactions.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _userName = 'Agent PDV';

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  void _loadUserName() async {
    setState(() {
      _userName = 'Agent PDV';
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          HeaderSection(userName: _userName),
          BalanceCard(),
          QuickActions(),
          RecentTransactions(),
        ],
      ),
    );
  }
}
