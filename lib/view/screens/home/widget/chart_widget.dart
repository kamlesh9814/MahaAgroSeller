import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:maidc_seller/provider/bank_info_provider.dart';
import 'package:maidc_seller/utill/color_resources.dart';
import 'package:maidc_seller/utill/dimensions.dart';
import 'package:maidc_seller/view/screens/home/widget/transaction_chart.dart';

class ChartWidget extends StatelessWidget {
  const ChartWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
              color: ColorResources.getPrimary(context).withOpacity(.05),
              spreadRadius: -3,
              blurRadius: 12,
              offset: Offset.fromDirection(0,6))
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            vertical: Dimensions.paddingSizeExtraSmall,
            horizontal: Dimensions.paddingSizeSmall),
        child: Consumer<BankInfoProvider>(builder: (context, bankInfo, child) {
          return (bankInfo.userCommissions != null &&
                  bankInfo.userEarnings != null)
              ? const TransactionChart()
              : const SizedBox();
        }),
      ),
    );
  }
}
