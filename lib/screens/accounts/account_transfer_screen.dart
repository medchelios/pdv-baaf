import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../services/uv_order_service.dart';
import '../../widgets/common/custom_card.dart';

class AccountTransferScreen extends StatefulWidget {
  const AccountTransferScreen({super.key});

  @override
  State<AccountTransferScreen> createState() => _AccountTransferScreenState();
}

class _AccountTransferScreenState extends State<AccountTransferScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final UVOrderService _uvOrderService = UVOrderService();
  bool _isSubmitting = false;
  List<Map<String, dynamic>> _transfers = [];
  bool _loadingTransfers = true;

  @override
  void initState() {
    super.initState();
    _loadTransfers();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _loadTransfers() async {
    setState(() => _loadingTransfers = true);
    final transfers = await _uvOrderService.getTransferHistory(limit: 50);
    if (mounted) {
      final grouped = _groupTransfersByReference(transfers ?? []);
      setState(() {
        _transfers = grouped;
        _loadingTransfers = false;
      });
    }
  }

  List<Map<String, dynamic>> _groupTransfersByReference(
    List<Map<String, dynamic>> transfers,
  ) {
    final Map<String, List<Map<String, dynamic>>> grouped = {};

    for (final transfer in transfers) {
      final reference = transfer['reference'] ?? '';
      if (!grouped.containsKey(reference)) {
        grouped[reference] = [];
      }
      grouped[reference]!.add(transfer);
    }

    return grouped.values.map((group) {
      final debit = group.firstWhere(
        (t) => t['type'] == 'debit',
        orElse: () => group.first,
      );
      final credit = group.firstWhere(
        (t) => t['type'] == 'credit',
        orElse: () => group.first,
      );

      final debitAmount = double.tryParse(debit['amount']?.toString() ?? '0') ?? 0.0;
      final creditBalanceAfter = double.tryParse(credit['balance_after']?.toString() ?? '0') ?? 0.0;
      final creditBalanceBefore = double.tryParse(credit['balance_before']?.toString() ?? '0') ?? 
          (creditBalanceAfter - debitAmount);

      return {
        'reference': debit['reference'],
        'date': debit['formatted_date'],
        'description': debit['description'] ?? credit['description'] ?? '',
        'amount': debit['formatted_amount'],
        'debit_account': debit['account_type'],
        'debit_balance_before': debit['balance_before'],
        'debit_balance_after': debit['balance_after'],
        'credit_account': credit['account_type'],
        'credit_balance_before': creditBalanceBefore,
        'credit_balance_after': credit['balance_after'],
      };
    }).toList();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    final amount =
        double.tryParse(_amountController.text.replaceAll(',', '.')) ?? 0.0;

    final result = await _uvOrderService.transferBetweenAccounts(
      amount: amount,
      fromType: 'commission',
      toType: 'principal',
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
    );

    if (!mounted) return;

    setState(() {
      _isSubmitting = false;
    });

    if (result != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Transfert effectué avec succès'),
          backgroundColor: Colors.green,
        ),
      );
      _amountController.clear();
      _descriptionController.clear();
      _loadTransfers();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Échec du transfert, réessayez.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transfert de comptes'),
        backgroundColor: AppConstants.brandOrange,
        foregroundColor: AppConstants.brandWhite,
      ),
      backgroundColor: AppConstants.backgroundColor,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppConstants.paddingM),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _TransferHeader(),
                    const SizedBox(height: AppConstants.paddingM),
                    CustomCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.account_balance_wallet,
                                color: AppConstants.brandBlue,
                                size: 24,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Nouveau transfert',
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(
                                        color: AppConstants.brandBlue,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppConstants.paddingM),
                          TextFormField(
                            controller: _amountController,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Montant',
                              hintText: 'Ex: 500000',
                              prefixIcon: const Icon(Icons.currency_exchange),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                              validator: (v) {
                                final val =
                                    double.tryParse(
                                      (v ?? '').replaceAll(',', '.'),
                                    ) ??
                                    0.0;
                                if (val <= 0) {
                                  return 'Veuillez saisir un montant valide';
                                }
                                return null;
                              },
                          ),
                          const SizedBox(height: AppConstants.paddingM),
                          TextFormField(
                            controller: _descriptionController,
                            maxLines: 2,
                            decoration: InputDecoration(
                              labelText: 'Description (optionnelle)',
                              hintText: 'Motif du transfert',
                              prefixIcon: const Icon(Icons.description),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          const SizedBox(height: AppConstants.paddingM),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isSubmitting ? null : _submit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppConstants.brandOrange,
                                foregroundColor: AppConstants.brandWhite,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: _isSubmitting
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Text(
                                      _isSubmitting
                                          ? 'Transfert en cours...'
                                          : 'Effectuer le transfert',
                                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                        color: AppConstants.brandWhite,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppConstants.paddingM),
                    _buildTransfersList(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransfersList() {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.history, color: AppConstants.brandBlue, size: 24),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Historique des transferts',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppConstants.brandBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _loadTransfers,
                tooltip: 'Actualiser',
              ),
            ],
          ),
          const SizedBox(height: AppConstants.paddingM),
          if (_loadingTransfers)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: CircularProgressIndicator(),
              ),
            )
          else if (_transfers.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Icon(
                      Icons.history,
                      size: 48,
                      color: AppConstants.textSecondary.withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Aucun transfert effectué',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppConstants.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _transfers.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final transfer = _transfers[index];
                return _TransferItem(transfer: transfer);
              },
            ),
        ],
      ),
    );
  }
}

class _TransferHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.paddingM),
      decoration: BoxDecoration(
        color: AppConstants.brandWhite,
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        border: Border.all(
          color: AppConstants.brandBlue.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _AccountChip(
              title: 'Commission',
              color: AppConstants.brandOrange,
              icon: Icons.trending_up_rounded,
            ),
          ),
          const SizedBox(width: 12),
          Icon(Icons.arrow_forward_rounded, color: AppConstants.textSecondary),
          const SizedBox(width: 12),
          Expanded(
            child: _AccountChip(
              title: 'Principal',
              color: AppConstants.brandBlue,
              icon: Icons.account_balance_wallet_rounded,
            ),
          ),
        ],
      ),
    );
  }
}

class _AccountChip extends StatelessWidget {
  final String title;
  final Color color;
  final IconData icon;

  const _AccountChip({
    required this.title,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Text(
            title,
            style: AppConstants.bodyMedium.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _TransferItem extends StatelessWidget {
  final Map<String, dynamic> transfer;

  const _TransferItem({required this.transfer});

  String _formatBalance(dynamic balance) {
    if (balance == null) return '0 GNF';
    final num = double.tryParse(balance.toString())?.toInt() ?? 0;
    return '${num.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]} ')} GNF';
  }

  @override
  Widget build(BuildContext context) {
    final amount = transfer['amount'] ?? '0 GNF';
    final date = transfer['date'] ?? '';
    final description = transfer['description'] ?? '';
    final debitBalanceBefore = _formatBalance(transfer['debit_balance_before']);
    final debitBalanceAfter = _formatBalance(transfer['debit_balance_after']);
    final creditBalanceBefore = _formatBalance(
      transfer['credit_balance_before'],
    );
    final creditBalanceAfter = _formatBalance(transfer['credit_balance_after']);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppConstants.cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border(
          bottom: BorderSide(
            color: AppConstants.brandBlue.withValues(alpha: 0.1),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  description.isNotEmpty
                      ? description
                      : 'Transfert',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  date,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppConstants.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'C: $debitBalanceBefore → $debitBalanceAfter',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppConstants.textSecondary,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'P: $creditBalanceBefore → $creditBalanceAfter',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppConstants.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            amount,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppConstants.brandOrange,
            ),
          ),
        ],
      ),
    );
  }
}
