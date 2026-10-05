import 'package:assab/core/models/media_file_model.dart';

class QuickCashExpenseData {
  final String expenseDate;
  final String expenseTitle;
  final String totalAmount;
  final List<ExpenseItemData> listItems;
  final List<MediaFile> files;
  final String paymentMethod;
  final String? paymentSupplierId;

  QuickCashExpenseData({
    required this.expenseDate,
    required this.expenseTitle,
    required this.totalAmount,
    required this.listItems,
    required this.files,
    required this.paymentMethod,
    this.paymentSupplierId,
  });
}

class ExpenseItemData {
  final String itemTitle;
  final String itemAmount;

  ExpenseItemData({required this.itemTitle, required this.itemAmount});
}
