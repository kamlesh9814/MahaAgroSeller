import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:maidc_seller/localization/language_constrants.dart';
import 'package:maidc_seller/provider/delivery_man_provider.dart';
import 'package:maidc_seller/utill/dimensions.dart';
import 'package:maidc_seller/utill/images.dart';
import 'package:maidc_seller/view/base/custom_app_bar.dart';
import 'package:maidc_seller/view/base/custom_delegate.dart';
import 'package:maidc_seller/view/base/custom_search_field.dart';
import 'package:maidc_seller/view/screens/delivery/widget/delivery_man_list_view.dart';

class DeliveryManListScreen extends StatefulWidget {
  const DeliveryManListScreen({Key? key}) : super(key: key);

  @override
  State<DeliveryManListScreen> createState() => _DeliveryManListScreenState();
}

class _DeliveryManListScreenState extends State<DeliveryManListScreen> {
  final TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    Provider.of<DeliveryManProvider>(context, listen: false)
        .deliveryManListURI(1, '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: getTranslated('delivery_man_list', context),
        isBackButtonExist: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          Provider.of<DeliveryManProvider>(context, listen: false)
              .deliveryManListURI(1, '');
        },
        child: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
                delegate: SliverDelegate(
                    height: 80,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                          Dimensions.paddingSizeMedium,
                          Dimensions.paddingSizeDefault,
                          Dimensions.paddingSizeMedium,
                          Dimensions.paddingSizeDefault),
                      child: CustomSearchField(
                        controller: searchController,
                        hint: getTranslated('search', context),
                        prefix: Images.iconsSearch,
                        iconPressed: () => () {},
                        onSubmit: (text) => () {},
                        onChanged: (value) {
                          Provider.of<DeliveryManProvider>(context,
                                  listen: false)
                              .deliveryManListURI(1, value);
                        },
                        isFilter: false,
                      ),
                    ))),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  DeliveryManListView(),
                  SizedBox(height: Dimensions.paddingSizeSmall)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
