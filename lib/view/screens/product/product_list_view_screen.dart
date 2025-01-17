import 'package:flutter/material.dart';
import 'package:maidc_seller/localization/language_constrants.dart';
import 'package:maidc_seller/view/base/custom_app_bar.dart';
import 'package:maidc_seller/view/screens/product/most_popular_product.dart';
import 'package:maidc_seller/view/screens/product/top_selling_product.dart';

class ProductListScreen extends StatelessWidget {
  final String title;
  final bool isPopular;
  const ProductListScreen(
      {Key? key, required this.title, this.isPopular = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();

    return Scaffold(
      appBar: CustomAppBar(title: getTranslated(title, context)),
      body: SingleChildScrollView(
        controller: scrollController,
        child: Container(
            child: isPopular
                ? const MostPopularProductScreen()
                : TopSellingProductScreen(scrollController: scrollController)),
      ),
    );
  }
}
