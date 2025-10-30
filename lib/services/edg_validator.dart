class EdgValidator {
  static bool isValidPrepaidNumber(String number) {
    final digits = number.replaceAll(RegExp(r'[^0-9]'), '');
    return digits.length == 11;
  }

  static bool isValidPostpaidReference(String reference) {
    final digits = reference.replaceAll(RegExp(r'[^0-9]'), '');
    return digits.length == 13;
  }

  static bool isValidPhoneNumber(String phone) {
    if (phone.isEmpty) return false;
    final digits = phone.replaceAll(RegExp(r'[^0-9]'), '');
    return digits.length == 9 && RegExp(r'^[678]').hasMatch(digits);
  }

  static bool isValidAmount(int? amount, {int? minAmount}) {
    if (amount == null) return false;
    if (minAmount != null && amount < minAmount) return false;
    return amount > 0;
  }

  static String? validateReference(String? reference, bool isPrepaid) {
    if (reference == null || reference.trim().isEmpty) {
      return 'La référence est requise';
    }
    final digits = reference.replaceAll(RegExp(r'[^0-9]'), '');
    if (isPrepaid && digits.length != 11) {
      return 'Le numéro doit contenir 11 chiffres';
    }
    if (!isPrepaid && digits.length != 13) {
      return 'La référence doit contenir 13 chiffres';
    }
    return null;
  }

  static String? validatePhone(String? phone) {
    if (phone == null || phone.trim().isEmpty) {
      return 'Le numéro de téléphone est requis';
    }
    if (!isValidPhoneNumber(phone)) {
      return 'Le numéro doit avoir 9 chiffres et commencer par 6, 7, ou 8';
    }
    return null;
  }

  static String? validateAmount(int? amount, {int? maxAmount, int minAmount = 1000}) {
    if (amount == null) {
      return 'Le montant est requis';
    }
    if (amount < minAmount) {
      return 'Le montant minimum est $minAmount GNF';
    }
    if (maxAmount != null && amount > maxAmount) {
      return 'Le montant ne peut pas dépasser ${maxAmount.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]} ')} GNF';
    }
    return null;
  }
}

