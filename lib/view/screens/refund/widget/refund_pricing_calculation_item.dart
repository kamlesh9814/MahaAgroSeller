import 'package:flutter/material.dart';
import 'package:maidc_seller/helper/price_converter.dart';
import 'package:maidc_seller/localization/language_constrants.dart';
import 'package:maidc_seller/utill/color_resources.dart';
import 'package:maidc_seller/utill/dimensions.dart';
import 'package:maidc_seller/utill/styles.dart';

class ProductCalculationItem extends StatelessWidget {
  final String? title;
  final double? price;
  final bool isQ;
  const ProductCalculationItem(
      {Key? key, this.title, this.price, this.isQ = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        isQ
            ? Text('${getTranslated(title, context)} (x 1)',
                style: titilliumRegular.copyWith(
                    fontSize: Dimensions.fontSizeDefault,
                    color: ColorResources.titleColor(context)))
            : Text('${getTranslated(title, context)}',
                style: robotoRegular.copyWith(
                    fontSize: Dimensions.fontSizeDefault,
                    color: ColorResources.titleColor(context))),
        const Spacer(),
        Text('-${PriceConverter.convertPrice(context, price)}',
            style: robotoRegular.copyWith(
                fontSize: Dimensions.fontSizeDefault,
                color: ColorResources.titleColor(context))),
      ],
    );
  }
}
