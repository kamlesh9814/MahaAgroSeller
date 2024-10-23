import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:maidc_seller/data/model/response/coupon_model.dart';
import 'package:maidc_seller/localization/language_constrants.dart';
import 'package:maidc_seller/provider/cart_provider.dart';
import 'package:maidc_seller/provider/coupon_provider.dart';
import 'package:maidc_seller/utill/dimensions.dart';
import 'package:maidc_seller/utill/images.dart';
import 'package:maidc_seller/utill/styles.dart';
import 'package:maidc_seller/view/base/custom_app_bar.dart';
import 'package:maidc_seller/view/base/custom_button.dart';
import 'package:maidc_seller/view/base/custom_date_picker.dart';
import 'package:maidc_seller/view/base/custom_drop_down_item.dart';
import 'package:maidc_seller/view/base/custom_field_with_title.dart';
import 'package:maidc_seller/view/base/custom_snackbar.dart';
import 'package:maidc_seller/view/base/textfeild/custom_text_feild.dart';
import 'package:maidc_seller/view/screens/pos/customer_search_screen.dart';

class AddNewCouponScreen extends StatefulWidget {
  final Coupons? coupons;
  const AddNewCouponScreen({Key? key, this.coupons}) : super(key: key);

  @override
  State<AddNewCouponScreen> createState() => _AddNewCouponScreenState();
}

class _AddNewCouponScreenState extends State<AddNewCouponScreen> {
  TextEditingController couponTitleController = TextEditingController();
  TextEditingController limitController = TextEditingController();
  TextEditingController couponCodeController = TextEditingController();
  TextEditingController discountAmountController = TextEditingController();
  TextEditingController minimumPurchaseController = TextEditingController();
  TextEditingController maximumDiscountController = TextEditingController();

  bool update = false;

  @override
  void initState() {
    update = widget.coupons != null ? true : false;
    if (update) {
      couponTitleController.text = widget.coupons!.title!;
      couponCodeController.text = widget.coupons!.code!;
      discountAmountController.text = widget.coupons!.discount.toString();
      minimumPurchaseController.text = widget.coupons!.minPurchase.toString();
      limitController.text = widget.coupons!.limit.toString();
      maximumDiscountController.text = widget.coupons!.maxDiscount.toString();
      Provider.of<CouponProvider>(context, listen: false).startDate =
          DateTime.parse(widget.coupons!.startDate!);
      Provider.of<CouponProvider>(context, listen: false).endDate =
          DateTime.parse(widget.coupons!.expireDate!);
    }
    Provider.of<CouponProvider>(context, listen: false)
        .getCouponCustomerList(context, '');
    if (Provider.of<CouponProvider>(context, listen: false)
            .customerSelectedName ==
        '') {
      Provider.of<CouponProvider>(context, listen: false)
          .searchCustomerController
          .text = 'All Customer';
      Provider.of<CouponProvider>(context, listen: false)
          .setCustomerInfo(0, 'All Customer', false);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: getTranslated('coupon_setup', context),
      ),
      body: Consumer<CouponProvider>(builder: (context, coupon, _) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: Dimensions.paddingSizeSmall,
              ),
              CustomDropDownItem(
                title: 'coupon_type',
                widget: DropdownButtonFormField<String>(
                  value: coupon.selectedCouponType,
                  isExpanded: true,
                  decoration: const InputDecoration(border: InputBorder.none),
                  iconSize: 24,
                  elevation: 16,
                  style: robotoRegular,
                  onChanged: (value) {
                    coupon.setSelectedCouponType(value);
                  },
                  items: coupon.couponTypeList.map((String value) {
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
              Padding(
                  padding: const EdgeInsets.fromLTRB(
                      Dimensions.paddingSizeDefault,
                      Dimensions.paddingSizeSmall,
                      Dimensions.paddingSizeDefault,
                      Dimensions.paddingSizeExtraSmall),
                  child: Text(getTranslated('select_customer', context)!)),
              GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const CustomerSearchScreen(
                                isCoupon: true,
                              ))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.paddingSizeDefault),
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: .25,
                                color: Theme.of(context)
                                    .hintColor
                                    .withOpacity(.75)),
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(
                                Dimensions.paddingSizeExtraSmall)),
                        child: Padding(
                          padding:
                              const EdgeInsets.all(Dimensions.paddingSizeSmall),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Text(
                                      coupon.searchCustomerController.text)),
                              Icon(Icons.arrow_drop_down,
                                  color: Theme.of(context).hintColor)
                            ],
                          ),
                        )),
                  )),
              const SizedBox(
                height: Dimensions.paddingSizeMedium,
              ),
              CustomFieldWithTitle(
                isCoupon: true,
                title: getTranslated('coupon_title', context),
                customTextField: CustomTextField(
                  border: true,
                  controller: couponTitleController,
                  hintText: getTranslated('coupon_title_hint', context),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.paddingSizeDefault,
                    vertical: Dimensions.paddingSizeDefault),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(getTranslated('coupon_code', context)!,
                            style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeDefault)),
                        const Spacer(),
                        InkWell(
                            onTap: () {
                              const chars =
                                  'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
                              Random rnd = Random();

                              String getRandomString(int length) =>
                                  String.fromCharCodes(Iterable.generate(
                                      length,
                                      (_) => chars.codeUnitAt(
                                          rnd.nextInt(chars.length))));
                              var code = getRandomString(10);
                              couponCodeController.text = code.toString();
                            },
                            child: Text(
                                getTranslated('generate_code', context)!,
                                style: robotoRegular.copyWith(
                                    fontSize: Dimensions.fontSizeDefault,
                                    color: Theme.of(context).primaryColor))),
                      ],
                    ),
                    const SizedBox(height: Dimensions.paddingSizeSmall),
                    CustomTextField(
                      border: true,
                      controller: couponCodeController,
                      textInputAction: TextInputAction.next,
                      textInputType: TextInputType.number,
                      isAmount: true,
                      hintText: 'Ex: ze5uzkyu0s',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeExtraSmall),
              CustomFieldWithTitle(
                isCoupon: true,
                title: getTranslated('limit_for_same_user', context),
                customTextField: CustomTextField(
                  border: true,
                  isAmount: true,
                  controller: limitController,
                  hintText: getTranslated('limit_user_hint', context),
                ),
              ),
              coupon.selectedCouponType == 'discount_on_purchase'
                  ? const SizedBox(height: Dimensions.paddingSizeMedium)
                  : const SizedBox.shrink(),
              coupon.selectedCouponType == 'discount_on_purchase'
                  ? CustomDropDownItem(
                      title: 'discount_type',
                      widget: DropdownButtonFormField<String>(
                        value: coupon.discountTypeName,
                        isExpanded: true,
                        decoration:
                            const InputDecoration(border: InputBorder.none),
                        iconSize: 24,
                        elevation: 16,
                        style: robotoRegular,
                        onChanged: (value) {
                          coupon.setSelectedDiscountNameType(value);
                        },
                        items: coupon.discountTypeList.map((String value) {
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
                    )
                  : const SizedBox.shrink(),
              coupon.selectedCouponType == 'discount_on_purchase'
                  ? const SizedBox(height: Dimensions.paddingSizeExtraSmall)
                  : const SizedBox.shrink(),
              coupon.selectedCouponType == 'discount_on_purchase'
                  ? CustomFieldWithTitle(
                      isCoupon: true,
                      title: getTranslated('discount_amount', context),
                      customTextField: CustomTextField(
                        border: true,
                        isAmount: true,
                        controller: discountAmountController,
                        hintText:
                            getTranslated('discount_amount_hint', context),
                      ),
                    )
                  : const SizedBox.shrink(),
              const SizedBox(height: Dimensions.paddingSizeMedium),
              CustomFieldWithTitle(
                isCoupon: true,
                title: getTranslated('minimum_purchase', context),
                customTextField: CustomTextField(
                  border: true,
                  isAmount: true,
                  textInputAction: TextInputAction.done,
                  controller: minimumPurchaseController,
                  hintText: getTranslated('minimum_purchase_hint', context),
                ),
              ),
              if (coupon.discountTypeName == 'percentage')
                const SizedBox(height: Dimensions.paddingSizeMedium),
              if (coupon.discountTypeName == 'percentage')
                CustomFieldWithTitle(
                  isCoupon: true,
                  title: getTranslated('maximum_discount', context),
                  customTextField: CustomTextField(
                    border: true,
                    isAmount: true,
                    textInputAction: TextInputAction.done,
                    controller: maximumDiscountController,
                    hintText: getTranslated('minimum_purchase_hint', context),
                  ),
                ),
              const SizedBox(height: Dimensions.paddingSizeDefault),
              Row(
                children: [
                  Expanded(
                      child: CustomDatePicker(
                    title: getTranslated('start_date', context),
                    image: Images.calenderIcon,
                    text: coupon.startDate != null
                        ? coupon.dateFormat.format(coupon.startDate!).toString()
                        : getTranslated('select_date', context),
                    selectDate: () => coupon.selectDate("start", context),
                  )),
                  Expanded(
                      child: CustomDatePicker(
                    title: getTranslated('expire_date', context),
                    image: Images.calenderIcon,
                    text: coupon.endDate != null
                        ? coupon.dateFormat.format(coupon.endDate!).toString()
                        : getTranslated('select_date', context),
                    selectDate: () => coupon.selectDate("end", context),
                  )),
                ],
              ),
              const SizedBox(height: Dimensions.paddingSizeMedium),
            ],
          ),
        );
      }),
      bottomNavigationBar: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: ThemeShadow.getShadow(context)),
          child: Consumer<CouponProvider>(builder: (context, coupon, _) {
            return Consumer<CartProvider>(builder: (context, customer, _) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.paddingSizeDefault,
                    vertical: Dimensions.paddingSizeExtraLarge),
                child: coupon.isAdd
                    ? const SizedBox(
                        width: 40,
                        height: 40,
                        child: Center(child: CircularProgressIndicator()))
                    : CustomButton(
                        btnTxt: update
                            ? getTranslated('update', context)
                            : getTranslated('submit', context),
                        onTap: () {
                          String? couponType = coupon.selectedCouponType;
                          int? customerId = coupon.selectedCustomerIdForCoupon;
                          String couponTitle =
                              couponTitleController.text.trim();
                          String couponCode = couponCodeController.text.trim();
                          String limit = limitController.text.trim();
                          String? discountType = coupon.discountTypeName;
                          String discountAmount =
                              discountAmountController.text.trim();
                          String minimumPurchase =
                              minimumPurchaseController.text.trim();
                          String maxDiscount =
                              maximumDiscountController.text.trim();
                          String? startDate = coupon.dateFormat
                              .format(coupon.startDate ?? DateTime.now())
                              .toString();
                          String? endDate = coupon.dateFormat
                              .format(coupon.endDate ?? DateTime.now())
                              .toString();

                          if (couponTitle.isEmpty) {
                            showCustomSnackBar(
                                getTranslated(
                                    'coupon_title_is_required', context),
                                context);
                          } else if (couponCode.isEmpty) {
                            showCustomSnackBar(
                                getTranslated(
                                    'coupon_code_is_required', context),
                                context);
                          } else if (limit.isEmpty) {
                            showCustomSnackBar(
                                getTranslated('limit_is_required', context),
                                context);
                          } else if (discountAmount.isEmpty &&
                              coupon.selectedCouponType ==
                                  'discount_on_purchase') {
                            showCustomSnackBar(
                                getTranslated('amount_is_required', context),
                                context);
                          } else if (minimumPurchase.isEmpty) {
                            showCustomSnackBar(
                                getTranslated(
                                    'minimum_purchase_is_required', context),
                                context);
                          } else if (maxDiscount.isEmpty &&
                              coupon.discountTypeName == 'percentage') {
                            showCustomSnackBar(
                                getTranslated(
                                    'max_discount_is_required', context),
                                context);
                          } else if (coupon.startDate == null && !update) {
                            showCustomSnackBar(
                                getTranslated(
                                    'start_date_is_required', context),
                                context);
                          } else if (coupon.endDate == null && !update) {
                            showCustomSnackBar(
                                getTranslated('end_date_is_required', context),
                                context);
                          } else {
                            Coupons coupons = Coupons(
                                id: update ? widget.coupons!.id : null,
                                title: couponTitle,
                                couponType: couponType,
                                customerId: customerId,
                                code: couponCode,
                                limit: int.parse(limit),
                                discountType: discountType,
                                discount: coupon.selectedCouponType ==
                                        'discount_on_purchase'
                                    ? double.parse(discountAmount)
                                    : 0,
                                minPurchase: double.parse(minimumPurchase),
                                maxDiscount: maxDiscount.isNotEmpty
                                    ? double.parse(maxDiscount)
                                    : 0,
                                startDate: startDate,
                                expireDate: endDate);
                            coupon.addNewCoupon(context, coupons, update);
                          }
                        }),
              );
            });
          })),
    );
  }
}
