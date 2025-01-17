import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:maidc_seller/localization/language_constrants.dart';
import 'package:maidc_seller/provider/shipping_provider.dart';
import 'package:maidc_seller/view/base/custom_app_bar.dart';
import 'package:maidc_seller/view/screens/settings/order_wise_shipping_list_screen.dart';
import 'package:maidc_seller/view/screens/shipping/category_wise_shipping.dart';
import 'package:maidc_seller/view/screens/shipping/widget/product_wise_shipping.dart';

class ShippingMainPage extends StatelessWidget {
  const ShippingMainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          title: getTranslated('shipping_method', context),
        ),
        body:
            Consumer<ShippingProvider>(builder: (context, shippingProvider, _) {
          return shippingProvider.selectedShippingTypeIndex == 0
              ? const CategoryWiseShippingScreen()
              : shippingProvider.selectedShippingTypeIndex == 1
                  ? const OrderWiseShippingScreen()
                  : const ProductWiseShipping();
        }));
  }
}
