import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:maidc_seller/localization/language_constrants.dart';
import 'package:maidc_seller/provider/product_provider.dart';
import 'package:maidc_seller/provider/profile_provider.dart';
import 'package:maidc_seller/utill/dimensions.dart';
import 'package:maidc_seller/utill/images.dart';
import 'package:maidc_seller/view/base/custom_app_bar.dart';
import 'package:maidc_seller/view/base/custom_search_field.dart';
import 'package:maidc_seller/view/screens/shop/widget/all_product_widget.dart';

class ProductListMenuScreen extends StatefulWidget {
  const ProductListMenuScreen({Key? key}) : super(key: key);
  @override
  State<ProductListMenuScreen> createState() => _ProductListMenuScreenState();
}

class _ProductListMenuScreenState extends State<ProductListMenuScreen> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    int? userId = Provider.of<ProfileProvider>(context, listen: false).userId;
    Provider.of<ProductProvider>(context, listen: false).initSellerProductList(
        userId.toString(), 1, context, 'en', '',
        reload: true);

    return Scaffold(
      appBar: CustomAppBar(title: getTranslated('product_list', context)),
      body: Column(
        children: [
          SizedBox(
              height: 80,
              child: Consumer<ProductProvider>(
                  builder: (context, searchProductController, _) {
                return Container(
                  color: Theme.of(context).cardColor,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                        Dimensions.paddingSizeDefault,
                        Dimensions.paddingSizeDefault,
                        Dimensions.paddingSizeDefault,
                        Dimensions.paddingSizeDefault),
                    child: CustomSearchField(
                      controller: searchController,
                      hint: getTranslated('search', context),
                      prefix: Images.iconsSearch,
                      iconPressed: () => () {},
                      onSubmit: (text) => () {},
                      onChanged: (value) {
                        if (value.toString().isNotEmpty) {
                          searchProductController.initSellerProductList(
                              userId.toString(), 1, context, 'en', value,
                              reload: true);
                        }
                      },
                    ),
                  ),
                );
              })),
          Expanded(child: ProductView(sellerId: userId))
        ],
      ),
    );
  }
}
