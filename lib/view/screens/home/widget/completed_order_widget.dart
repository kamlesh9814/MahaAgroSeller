import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:maidc_seller/localization/language_constrants.dart';
import 'package:maidc_seller/provider/order_provider.dart';
import 'package:maidc_seller/utill/color_resources.dart';
import 'package:maidc_seller/utill/dimensions.dart';
import 'package:maidc_seller/utill/images.dart';
import 'package:maidc_seller/utill/styles.dart';
import 'package:maidc_seller/view/screens/home/widget/order_type_button.dart';

class CompletedOrderWidget extends StatelessWidget {
  final Function? callback;
  const CompletedOrderWidget({Key? key, this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(builder: (context, order, child) {
      return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          boxShadow: [
            BoxShadow(
                color: ColorResources.getPrimary(context).withOpacity(.05),
                spreadRadius: -3,
                blurRadius: 12,
                offset: Offset.fromDirection(0, 6))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  Dimensions.paddingSizeDefault,
                  Dimensions.paddingSizeExtraSmall,
                  Dimensions.paddingSizeDefault,
                  0),
              child: Text(
                getTranslated('completed_orders', context)!,
                style:
                    robotoBold.copyWith(color: Theme.of(context).primaryColor),
              ),
            ),
            order.orderModel != null
                ? Consumer<OrderProvider>(
                    builder: (context, orderProvider, child) => SizedBox(
                      child: ListView(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          OrderTypeButton(
                            color: ColorResources.mainCardThreeColor(context),
                            icon: Images.delivered,
                            text: getTranslated('delivered', context),
                            index: 3,
                            numberOfOrder: orderProvider
                                .businessAnalyticsFilterData?.delivered,
                            callback: callback,
                          ),
                          OrderTypeButton(
                            color: ColorResources.mainCardFourColor(context),
                            icon: Images.cancelled,
                            text: getTranslated('cancelled', context),
                            index: 6,
                            numberOfOrder: orderProvider
                                .businessAnalyticsFilterData?.canceled,
                            callback: callback,
                          ),
                          OrderTypeButton(
                            color: ColorResources.getTextColor(context),
                            icon: Images.returned,
                            text: getTranslated('return', context),
                            index: 4,
                            numberOfOrder: orderProvider
                                .businessAnalyticsFilterData?.returned,
                            callback: callback,
                          ),
                          OrderTypeButton(
                            showBorder: false,
                            color: ColorResources.mainCardFourColor(context),
                            icon: Images.failed,
                            text: getTranslated('failed', context),
                            index: 5,
                            numberOfOrder: orderProvider
                                .businessAnalyticsFilterData?.failed,
                            callback: callback,
                          ),
                        ],
                      ),
                    ),
                  )
                : SizedBox(
                    height: 150,
                    child: Center(
                        child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(
                                Theme.of(context).primaryColor)))),
            const SizedBox(height: Dimensions.paddingSizeSmall),
          ],
        ),
      );
    });
  }
}
