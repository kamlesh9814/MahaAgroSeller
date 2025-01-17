import 'package:flutter/material.dart';
import 'package:maidc_seller/provider/transaction_provider.dart';
import 'package:maidc_seller/view/screens/transaction/widget/transaction_widget.dart';

class WalletTransactionListView extends StatelessWidget {
  final TransactionProvider? transactionProvider;
  const WalletTransactionListView({Key? key, this.transactionProvider})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: transactionProvider!.transactionList!.length,
      itemBuilder: (context, index) => TransactionWidget(
          transactionModel: transactionProvider!.transactionList![index]),
    );
  }
}
