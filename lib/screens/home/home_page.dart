import 'package:flutter/material.dart';
import '../../services/home_data_loader.dart';
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
  final HomeDataLoader _dataLoader = HomeDataLoader();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await _dataLoader.loadHomeData();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _loadData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            const HeaderSection(),
            const BalanceCard(),
            const QuickActions(),
            const RecentTransactions(),
          ],
        ),
      ),
    );
  }
}
