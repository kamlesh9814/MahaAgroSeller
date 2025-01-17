import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:maidc_seller/data/model/response/product_model.dart';
import 'package:maidc_seller/localization/language_constrants.dart';
import 'package:maidc_seller/provider/product_provider.dart';
import 'package:maidc_seller/provider/shop_provider.dart';
import 'package:maidc_seller/utill/dimensions.dart';
import 'package:maidc_seller/utill/images.dart';
import 'package:maidc_seller/view/base/custom_app_bar.dart';
import 'package:maidc_seller/view/base/custom_delegate.dart';
import 'package:maidc_seller/view/base/custom_search_field.dart';
import 'package:maidc_seller/view/base/no_data_screen.dart';
import 'package:maidc_seller/view/screens/pos/widget/category_filter_botto_sheet.dart';
import 'package:maidc_seller/view/screens/pos/widget/pos_product_list.dart';
import 'package:maidc_seller/view/screens/pos/widget/pos_product_shimmer.dart';
import 'package:maidc_seller/view/screens/pos/widget/product_search_dialog.dart';

class POSProductScreen extends StatefulWidget {
  const POSProductScreen({Key? key}) : super(key: key);

  @override
  State<POSProductScreen> createState() => _POSProductScreenState();
}

class _POSProductScreenState extends State<POSProductScreen> {
  @override
  void initState() {
    Provider.of<ProductProvider>(context, listen: false)
        .getPosProductList(1, context, []);
    Provider.of<SellerProvider>(context, listen: false)
        .getCategoryList(context, null, 'en');

    super.initState();
  }

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    TextEditingController searchController = TextEditingController();
    return Scaffold(
      appBar: CustomAppBar(
        title: getTranslated('product_list', context),
        isCart: true,
        isAction: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          Provider.of<ProductProvider>(context, listen: false)
              .getPosProductList(1, context, []);
        },
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverPersistentHeader(
                pinned: true,
                delegate: SliverDelegate(
                    height: 85,
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
                                searchProductController
                                    .getSearchedPosProductList(
                                        context, value, []);
                              } else {
                                searchProductController.shoHideDialog(false);
                              }
                            },
                            isFilter: true,
                            filterAction: () {
                              showModalBottomSheet(
                                  backgroundColor: Colors.transparent,
                                  isScrollControlled: true,
                                  context: context,
                                  builder: (_) =>
                                      const CategoryFilterBottomSheet());
                            },
                          ),
                        ),
                      );
                    }))),
            SliverToBoxAdapter(
              child: Consumer<ProductProvider>(
                  builder: (context, prodProvider, child) {
                List<Product>? productList = [];
                productList = prodProvider.posProductModel?.products;
                return Stack(
                  children: [
                    Column(children: [
                      const SizedBox(
                        height: Dimensions.paddingSizeExtraSmall,
                      ),
                      productList != null
                          ? productList.isNotEmpty
                              ? PosProductList(
                                  productList: productList,
                                  scrollController: _scrollController,
                                  productProvider: prodProvider)
                              : Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical:
                                          MediaQuery.of(context).size.height /
                                              4),
                                  child: const NoDataScreen(),
                                )
                          : const PosProductShimmer(),
                      prodProvider.isLoading
                          ? Center(
                              child: Padding(
                              padding: const EdgeInsets.all(
                                  Dimensions.paddingSizeSmall),
                              child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Theme.of(context).primaryColor)),
                            ))
                          : const SizedBox.shrink(),
                      const SizedBox(
                        height: Dimensions.paddingSizeBottomSpace,
                      ),
                    ]),
                    prodProvider.showDialog
                        ? const ProductSearchDialog()
                        : const SizedBox(),
                  ],
                );
              }),
            )
          ],
        ),
      ),
    );
  }
}
