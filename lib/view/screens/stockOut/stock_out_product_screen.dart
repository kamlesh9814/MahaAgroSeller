import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:maidc_seller/localization/language_constrants.dart';
import 'package:maidc_seller/provider/product_provider.dart';
import 'package:maidc_seller/utill/dimensions.dart';
import 'package:maidc_seller/view/base/custom_app_bar.dart';
import 'package:maidc_seller/view/screens/home/widget/stock_out_product_widget.dart';

class StockOutProductScreen extends StatelessWidget {
  const StockOutProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: getTranslated('stock_out_product', context)),
      body: RefreshIndicator(
        onRefresh: () async {
          Provider.of<ProductProvider>(context, listen: false)
              .getStockOutProductList(1, 'en');
        },
        child: const Padding(
          padding: EdgeInsets.only(top: Dimensions.paddingSizeSmall),
          child: StockOutProductView(isHome: false),
        ),
      ),
    );
  }
}
