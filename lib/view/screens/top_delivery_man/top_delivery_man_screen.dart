import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:maidc_seller/localization/language_constrants.dart';
import 'package:maidc_seller/provider/delivery_man_provider.dart';
import 'package:maidc_seller/view/base/custom_app_bar.dart';
import 'package:maidc_seller/view/screens/top_delivery_man/top_delivery_man_view.dart';

class TopDeliveryMAnScreen extends StatelessWidget {
  const TopDeliveryMAnScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
            title: getTranslated('top_delivery_man_list', context),
            isBackButtonExist: true),
        body: RefreshIndicator(
          onRefresh: () async {
            Provider.of<DeliveryManProvider>(context, listen: false)
                .getTopDeliveryManList(context);
          },
          child: const SingleChildScrollView(
            child: TopDeliveryManView(),
          ),
        ));
  }
}
