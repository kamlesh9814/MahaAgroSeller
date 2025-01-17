import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:maidc_seller/localization/language_constrants.dart';
import 'package:maidc_seller/provider/shipping_provider.dart';
import 'package:maidc_seller/utill/dimensions.dart';
import 'package:maidc_seller/utill/images.dart';
import 'package:maidc_seller/utill/styles.dart';
import 'package:maidc_seller/view/base/custom_app_bar.dart';
import 'package:maidc_seller/view/screens/shipping/widget/drop_down_for_shipping_type.dart';

class ProductWiseShipping extends StatefulWidget {
  const ProductWiseShipping({Key? key}) : super(key: key);

  @override
  State<ProductWiseShipping> createState() => _ProductWiseShippingState();
}

class _ProductWiseShippingState extends State<ProductWiseShipping> {
  @override
  void initState() {
    Provider.of<ShippingProvider>(context, listen: false)
        .iniType('product_type');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          title: getTranslated('shipping_method', context),
          isBackButtonExist: true,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const DropDownForShippingTypeWidget(),
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 5),
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width / 3,
                        child: Image.asset(Images.productWiseShipping)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeButton),
                    child: Text(
                      getTranslated('product_wise_delivery_note', context)!,
                      style: robotoRegular.copyWith(),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            ),
            const SizedBox()
          ],
        ));
  }
}
