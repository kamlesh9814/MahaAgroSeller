import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:maidc_seller/localization/language_constrants.dart';
import 'package:maidc_seller/provider/theme_provider.dart';
import 'package:maidc_seller/utill/dimensions.dart';
import 'package:maidc_seller/utill/images.dart';
import 'package:maidc_seller/utill/styles.dart';

class BankInfoWidget extends StatelessWidget {
  final String? name;
  final String? bank;
  final String? branch;
  final String? accountNo;
  final String? ifsc;
  const BankInfoWidget(
      {Key? key, this.name, this.bank, this.branch, this.accountNo, this.ifsc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)),
        child: Stack(
          children: [
            Positioned(
              child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  width: MediaQuery.of(context).size.width / 3,
                  height: 200,
                  decoration: BoxDecoration(
                      color: Theme.of(context).cardColor.withOpacity(.05),
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(100),
                          bottomLeft: Radius.circular(100))),
                ),
              ),
            ),
            Positioned(
              child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  width: MediaQuery.of(context).size.width / 4,
                  height: 200,
                  decoration: BoxDecoration(
                      color: Theme.of(context).cardColor.withOpacity(.05),
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(100),
                          bottomLeft: Radius.circular(100))),
                ),
              ),
            ),
            Column(
              children: [
                const SizedBox(height: Dimensions.paddingSizeDefault),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: CardItem(title: 'A/C Holder', value: name)),
                    Padding(
                      padding: const EdgeInsets.only(
                          right: Dimensions.paddingSizeDefault,
                          left: Dimensions.paddingSizeDefault),
                      child: SizedBox(width: 40, child: Image.asset(Images.bankInfo)),
                    )
                  ],
                ),
                Divider(
                    color: Theme.of(context).cardColor.withOpacity(.5),
                    thickness: 1.5),
                CardItem(title: 'Bank', value: bank),
                CardItem(title: 'Branch', value: branch),
                CardItem(title: 'A/C No', value: accountNo),
                CardItem(title: 'IFSC Code', value: ifsc),
                const SizedBox(height: Dimensions.paddingSizeDefault),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CardItem extends StatelessWidget {
  final String? title;
  final String? value;
  final String? text;
  const CardItem({Key? key, this.title, this.value, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          Dimensions.paddingSizeDefault,
          Dimensions.paddingSizeSmall,
          Dimensions.paddingSizeDefault,
          Dimensions.paddingSizeSmall),
      child: Row(
        children: [
          Text('${(title)} : ',
              style: robotoRegular.copyWith(
                  color: Provider.of<ThemeProvider>(context, listen: false)
                          .darkTheme
                      ? Theme.of(context).hintColor
                      : Theme.of(context).cardColor)),
          Text(value!,
              style: robotoMedium.copyWith(
                  color: Provider.of<ThemeProvider>(context, listen: false)
                          .darkTheme
                      ? Theme.of(context).hintColor
                      : Theme.of(context).cardColor)),
        ],
      ),
    );
  }
}
