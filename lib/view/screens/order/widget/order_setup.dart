import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:maidc_seller/data/model/response/order_model.dart';
import 'package:maidc_seller/localization/language_constrants.dart';
import 'package:maidc_seller/main.dart';
import 'package:maidc_seller/provider/delivery_man_provider.dart';
import 'package:maidc_seller/provider/order_provider.dart';
import 'package:maidc_seller/provider/splash_provider.dart';
import 'package:maidc_seller/utill/dimensions.dart';
import 'package:maidc_seller/utill/styles.dart';
import 'package:maidc_seller/view/base/custom_app_bar.dart';
import 'package:maidc_seller/view/base/custom_drop_down_item.dart';
import 'package:maidc_seller/view/screens/order/widget/delivery_man_assign_widget.dart';

class OrderSetup extends StatefulWidget {
  final Order? orderModel;
  final bool onlyDigital;
  const OrderSetup({Key? key, this.orderModel, this.onlyDigital = false})
      : super(key: key);

  @override
  State<OrderSetup> createState() => _OrderSetupState();
}

class _OrderSetupState extends State<OrderSetup> {
  @override
  void initState() {
    Provider.of<DeliveryManProvider>(Get.context!, listen: false)
        .getDeliveryManList(widget.orderModel);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool inHouseShipping = false;
    String? shipping = Provider.of<SplashProvider>(context, listen: false)
        .configModel!
        .shippingMethod;
    if (shipping == 'inhouse_shipping' &&
        (widget.orderModel!.orderStatus == 'out_for_delivery' ||
            widget.orderModel!.orderStatus == 'delivered' ||
            widget.orderModel!.orderStatus == 'returned' ||
            widget.orderModel!.orderStatus == 'failed' ||
            widget.orderModel!.orderStatus == 'canceled')) {
      inHouseShipping = true;
    } else {
      inHouseShipping = false;
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
          title: getTranslated('order_setup', context),
          isBackButtonExist: true),
      body: Column(
        children: [
          Consumer<OrderProvider>(builder: (context, order, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: Dimensions.paddingSizeMedium,
                ),
                inHouseShipping
                    ? Padding(
                        padding: const EdgeInsets.fromLTRB(
                            Dimensions.paddingSizeDefault,
                            Dimensions.paddingSizeExtraSmall,
                            Dimensions.paddingSizeDefault,
                            Dimensions.paddingSizeSmall),
                        child: Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: .5,
                                    color: Theme.of(context)
                                        .hintColor
                                        .withOpacity(.125)),
                                color: Theme.of(context)
                                    .hintColor
                                    .withOpacity(.12),
                                borderRadius: BorderRadius.circular(
                                    Dimensions.paddingSizeExtraSmall)),
                            child: Padding(
                              padding:
                                  const EdgeInsets.all(Dimensions.paddingSize),
                              child: Text(getTranslated(
                                  widget.orderModel!.orderStatus, context)!),
                            )),
                      )
                    : CustomDropDownItem(
                        title: 'order_status',
                        widget: DropdownButtonFormField<String>(
                          value: widget.orderModel!.orderStatus,
                          isExpanded: true,
                          decoration:
                              const InputDecoration(border: InputBorder.none),
                          iconSize: 24,
                          elevation: 16,
                          style: robotoRegular,
                          onChanged: (value) {
                            order.updateOrderStatus(
                                widget.orderModel!.id, value, context);
                          },
                          items: order.orderStatusList
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(getTranslated(value, context)!,
                                  style: robotoRegular.copyWith(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .color)),
                            );
                          }).toList(),
                        ),
                      ),
                CustomDropDownItem(
                  title: 'payment_status',
                  widget: DropdownButtonFormField<String>(
                    value: widget.orderModel!.paymentStatus,
                    isExpanded: true,
                    decoration: const InputDecoration(border: InputBorder.none),
                    iconSize: 24,
                    elevation: 16,
                    style: robotoRegular,
                    onChanged: (value) {
                      order.setPaymentMethodIndex(value == 'paid' ? 0 : 1);
                      order.updatePaymentStatus(
                          orderId: widget.orderModel!.id,
                          status: value,
                          context: context);
                    },
                    items: <String>['paid', 'unpaid'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(getTranslated(value, context)!,
                            style: robotoRegular.copyWith(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .color)),
                      );
                    }).toList(),
                  ),
                ),
                !widget.onlyDigital
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.paddingSizeDefault),
                        child: DeliveryManAssignWidget(
                            orderType: widget.orderModel?.orderType,
                            orderModel: widget.orderModel,
                            orderId: widget.orderModel!.id),
                      )
                    : const SizedBox(),
              ],
            );
          }),
        ],
      ),
    );
  }
}
