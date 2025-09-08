import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/api_service.dart';

class PrepaidPaymentScreen extends StatefulWidget {
  const PrepaidPaymentScreen({super.key});

  @override
  State<PrepaidPaymentScreen> createState() => _PrepaidPaymentScreenState();
}

class _PrepaidPaymentScreenState extends State<PrepaidPaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _customerReferenceController = TextEditingController();
  final _customerNameController = TextEditingController();
  final _customerPhoneController = TextEditingController();
  final _amountController = TextEditingController();
  final _apiService = ApiService();
  
  String _selectedPaymentMethod = 'mobile_money';
  bool _isLoading = false;

  final List<Map<String, dynamic>> _paymentMethods = [
    {'value': 'mobile_money', 'label': 'Mobile Money', 'icon': Icons.phone_android},
    {'value': 'card', 'label': 'Carte Bancaire', 'icon': Icons.credit_card},
    {'value': 'cash', 'label': 'Espèces', 'icon': Icons.money},
  ];

  @override
  void dispose() {
    _customerReferenceController.dispose();
    _customerNameController.dispose();
    _customerPhoneController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _processPayment() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _apiService.processPayment(
        customerPhone: _customerPhoneController.text.trim(),
        invoiceReference: 'PREPAID_${DateTime.now().millisecondsSinceEpoch}',
        amount: double.parse(_amountController.text),
        paymentMethod: _selectedPaymentMethod,
        customerName: _customerNameController.text.trim(),
        customerReference: _customerReferenceController.text.trim(),
        customerType: 'prepaid',
      );

      if (result['success'] == true) {
        if (mounted) {
          _showSuccessDialog(result);
        }
      } else {
        if (mounted) {
          _showErrorDialog(result['message'] ?? 'Erreur lors du paiement');
        }
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog('Erreur: $e');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSuccessDialog(Map<String, dynamic> result) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green[600], size: 28),
            const SizedBox(width: 8),
            const Text('Paiement Réussi'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Le paiement prépayé a été traité avec succès.'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Référence: ${result['data']['reference'] ?? 'N/A'}'),
                  Text('Montant: ${_amountController.text} GNF'),
                  Text('Méthode: ${_paymentMethods.firstWhere((m) => m['value'] == _selectedPaymentMethod)['label']}'),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _clearForm();
            },
            child: const Text('Nouveau Paiement'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Retour'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.error, color: Colors.red[600], size: 28),
            const SizedBox(width: 8),
            const Text('Erreur'),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _clearForm() {
    _customerReferenceController.clear();
    _customerNameController.clear();
    _customerPhoneController.clear();
    _amountController.clear();
    setState(() {
      _selectedPaymentMethod = 'mobile_money';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf8f9fa),
      appBar: AppBar(
        title: const Text('Paiement Prépayé'),
        backgroundColor: const Color(0xFFe94d29),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // En-tête
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        // Logo BAAF
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              'assets/images/logo.jpeg',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Paiement Prépayé',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF0e4b5b),
                                ),
                              ),
                              Text(
                                'Achetez des tokens d\'électricité pour vos clients',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: const Color(0xFF6B7280),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Informations client
                Text(
                  'Informations Client',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0e4b5b),
                  ),
                ),
                const SizedBox(height: 16),

                // Référence client
                TextFormField(
                  controller: _customerReferenceController,
                  decoration: InputDecoration(
                    labelText: 'Référence Client *',
                    hintText: 'Ex: REF123456',
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer la référence client';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Nom client
                TextFormField(
                  controller: _customerNameController,
                  decoration: InputDecoration(
                    labelText: 'Nom du Client *',
                    hintText: 'Ex: Jean Dupont',
                    prefixIcon: const Icon(Icons.person_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer le nom du client';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Téléphone client
                TextFormField(
                  controller: _customerPhoneController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(9),
                  ],
                  decoration: InputDecoration(
                    labelText: 'Téléphone Client *',
                    hintText: 'Ex: 620123456',
                    prefixIcon: const Icon(Icons.phone),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer le téléphone du client';
                    }
                    if (value.length != 9) {
                      return 'Le téléphone doit contenir 9 chiffres';
                    }
                    if (!value.startsWith(RegExp(r'[678]'))) {
                      return 'Le téléphone doit commencer par 6, 7 ou 8';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Montant
                Text(
                  'Montant',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0e4b5b),
                  ),
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: InputDecoration(
                    labelText: 'Montant (GNF) *',
                    hintText: 'Ex: 50000',
                    prefixIcon: const Icon(Icons.monetization_on),
                    suffixText: 'GNF',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer le montant';
                    }
                    final amount = double.tryParse(value);
                    if (amount == null || amount <= 0) {
                      return 'Veuillez entrer un montant valide';
                    }
                    if (amount < 1000) {
                      return 'Le montant minimum est 1000 GNF';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Méthode de paiement
                Text(
                  'Méthode de Paiement',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0e4b5b),
                  ),
                ),
                const SizedBox(height: 16),

                ..._paymentMethods.map((method) => Card(
                  elevation: _selectedPaymentMethod == method['value'] ? 4 : 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: _selectedPaymentMethod == method['value']
                          ? const Color(0xFFe94d29)
                          : Colors.grey[300]!,
                      width: _selectedPaymentMethod == method['value'] ? 2 : 1,
                    ),
                  ),
                  child: ListTile(
                    leading: Radio<String>(
                      value: method['value'],
                      groupValue: _selectedPaymentMethod,
                      onChanged: (value) {
                        if (mounted) {
                          setState(() {
                            _selectedPaymentMethod = value!;
                          });
                        }
                      },
                      activeColor: const Color(0xFFe94d29),
                    ),
                    title: Text(method['label']),
                    trailing: Icon(method['icon']),
                    onTap: () {
                      if (mounted) {
                        setState(() {
                          _selectedPaymentMethod = method['value'];
                        });
                      }
                    },
                  ),
                )),
                const SizedBox(height: 32),

                // Bouton de paiement
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _processPayment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFe94d29),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text(
                            'Traiter le Paiement',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
