import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:maidc_seller/data/model/body/delivery_man_body.dart';
import 'package:maidc_seller/data/model/response/top_delivery_man.dart';
import 'package:maidc_seller/helper/email_checker.dart';
import 'package:maidc_seller/localization/language_constrants.dart';
import 'package:maidc_seller/provider/delivery_man_provider.dart';
import 'package:maidc_seller/utill/dimensions.dart';
import 'package:maidc_seller/utill/styles.dart';
import 'package:maidc_seller/view/base/custom_app_bar.dart';
import 'package:maidc_seller/view/base/custom_button.dart';
import 'package:maidc_seller/view/base/custom_snackbar.dart';
import 'package:maidc_seller/view/screens/delivery/delivery_man_setup.dart';
import 'package:maidc_seller/view/screens/delivery/widget/delivery_man_info.dart';

class AddNewDeliveryManScreen extends StatefulWidget {
  final DeliveryMan? deliveryMan;
  const AddNewDeliveryManScreen({Key? key, this.deliveryMan}) : super(key: key);

  @override
  State<AddNewDeliveryManScreen> createState() =>
      _AddNewDeliveryManScreenState();
}

class _AddNewDeliveryManScreenState extends State<AddNewDeliveryManScreen>
    with TickerProviderStateMixin {
  TabController? _tabController;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, initialIndex: 0, vsync: this);

    _tabController?.addListener(() {
      switch (_tabController!.index) {
        case 0:
          Provider.of<DeliveryManProvider>(context, listen: false)
              .setIndexForTabBar(1, isNotify: true);
          break;
        case 1:
          Provider.of<DeliveryManProvider>(context, listen: false)
              .setIndexForTabBar(0, isNotify: true);
          break;
      }
    });

    if (widget.deliveryMan != null) {
      Provider.of<DeliveryManProvider>(context, listen: false)
          .firstNameController
          .text = widget.deliveryMan!.fName!;
      Provider.of<DeliveryManProvider>(context, listen: false)
          .lastNameController
          .text = widget.deliveryMan!.lName!;
      Provider.of<DeliveryManProvider>(context, listen: false)
          .emailController
          .text = widget.deliveryMan!.email!;
      Provider.of<DeliveryManProvider>(context, listen: false)
          .phoneController
          .text = widget.deliveryMan!.phone!;
      Provider.of<DeliveryManProvider>(context, listen: false)
          .addressController
          .text = widget.deliveryMan!.address!;
      Provider.of<DeliveryManProvider>(context, listen: false)
          .identityNumber
          .text = widget.deliveryMan!.identityNumber!;
    } else {
      Provider.of<DeliveryManProvider>(context, listen: false)
          .firstNameController
          .clear();
      Provider.of<DeliveryManProvider>(context, listen: false)
          .lastNameController
          .clear();
      Provider.of<DeliveryManProvider>(context, listen: false)
          .emailController
          .clear();
      Provider.of<DeliveryManProvider>(context, listen: false)
          .phoneController
          .clear();
      Provider.of<DeliveryManProvider>(context, listen: false)
          .addressController
          .clear();
      Provider.of<DeliveryManProvider>(context, listen: false)
          .identityNumber
          .clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          title: getTranslated('add_delivery_man', context),
          isBackButtonExist: true),
      body: Consumer<DeliveryManProvider>(
          builder: (authContext, deliveryManProvider, _) {
        return Column(children: [
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width,
              color: Theme.of(context).cardColor,
              child: TabBar(
                padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.paddingSizeExtraLarge),
                controller: _tabController,
                labelColor: Theme.of(context).primaryColor,
                unselectedLabelColor: Theme.of(context).hintColor,
                indicatorColor: Theme.of(context).primaryColor,
                indicatorWeight: 1,
                unselectedLabelStyle: robotoRegular.copyWith(
                  fontSize: Dimensions.fontSizeDefault,
                  fontWeight: FontWeight.w400,
                ),
                labelStyle: robotoRegular.copyWith(
                  fontSize: Dimensions.fontSizeDefault,
                  fontWeight: FontWeight.w700,
                ),
                tabs: [
                  Tab(text: getTranslated("delivery_man_info", context)),
                  Tab(text: getTranslated("account_info", context)),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: Dimensions.paddingSizeSmall,
          ),
          Expanded(
              child: TabBarView(
            controller: _tabController,
            children: [
              DeliveryManInfo(deliveryMan: widget.deliveryMan),
              DeliveryManInfo(
                  isPassword: true, deliveryMan: widget.deliveryMan),
            ],
          )),
        ]);
      }),
      bottomNavigationBar: Consumer<DeliveryManProvider>(
          builder: (context, deliveryManProvider, _) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
                padding:
                    const EdgeInsets.only(top: Dimensions.paddingSizeDefault),
                child: LinearPercentIndicator(
                    width: MediaQuery.of(context).size.width,
                    lineHeight: 4.0,
                    percent:
                        deliveryManProvider.selectionTabIndex == 1 ? 0.5 : 0.9,
                    backgroundColor: Theme.of(context).hintColor,
                    progressColor: Theme.of(context).primaryColor)),
            Container(
              height: 70,
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              decoration: BoxDecoration(color: Theme.of(context).cardColor),
              child: (deliveryManProvider.selectionTabIndex == 1)
                  ? CustomButton(
                      btnTxt: getTranslated('next', context),
                      onTap: () {
                        if (deliveryManProvider.firstNameController.text
                            .trim()
                            .isEmpty) {
                          showCustomSnackBar(
                              getTranslated('first_name_is_required', context),
                              context);
                        } else if (deliveryManProvider.lastNameController.text
                            .trim()
                            .isEmpty) {
                          showCustomSnackBar(
                              getTranslated('last_name_is_required', context),
                              context);
                        } else if (deliveryManProvider.emailController.text
                            .trim()
                            .isEmpty) {
                          showCustomSnackBar(
                              getTranslated('email_is_required', context),
                              context);
                        } else if (EmailChecker.isNotValid(
                            deliveryManProvider.emailController.text.trim())) {
                          showCustomSnackBar(
                              getTranslated('email_is_ot_valid', context),
                              context);
                        } else if (deliveryManProvider.phoneController.text
                            .trim()
                            .isEmpty) {
                          showCustomSnackBar(
                              getTranslated('phone_is_required', context),
                              context);
                        } else if (deliveryManProvider.phoneController.text
                                .trim()
                                .length <
                            8) {
                          showCustomSnackBar(
                              getTranslated(
                                  'phone_number_is_not_valid', context),
                              context);
                        } else if (deliveryManProvider.profileImage == null &&
                            widget.deliveryMan == null) {
                          showCustomSnackBar(
                              getTranslated(
                                  'profile_image_is_required', context),
                              context);
                        } else if (deliveryManProvider.identityNumber.text
                            .trim()
                            .isEmpty) {
                          showCustomSnackBar(
                              getTranslated(
                                  'identity_number_is_required', context),
                              context);
                        } else if (deliveryManProvider.identityImages.isEmpty &&
                            widget.deliveryMan == null) {
                          showCustomSnackBar(
                              getTranslated(
                                  'identity_image_is_required', context),
                              context);
                        } else {
                          _tabController!
                              .animateTo((_tabController!.index + 1) % 2);
                          selectedIndex = _tabController!.index + 1;
                          deliveryManProvider.setIndexForTabBar(selectedIndex);
                        }
                      },
                    )
                  : Row(
                      children: [
                        SizedBox(
                          width: 120,
                          child: CustomButton(
                            btnTxt: getTranslated('back', context),
                            backgroundColor: Theme.of(context).hintColor,
                            isColor: true,
                            onTap: () {
                              _tabController!
                                  .animateTo((_tabController!.index + 1) % 2);
                              selectedIndex = _tabController!.index + 1;
                              deliveryManProvider
                                  .setIndexForTabBar(selectedIndex);
                            },
                          ),
                        ),
                        const SizedBox(width: Dimensions.paddingSizeSmall),
                        deliveryManProvider.isLoading
                            ? const CircularProgressIndicator()
                            : Expanded(
                                child: CustomButton(
                                  btnTxt: getTranslated('submit', context),
                                  onTap: () {
                                    if (deliveryManProvider.firstNameController.text.trim().isEmpty &&
                                        widget.deliveryMan == null) {
                                      showCustomSnackBar(
                                          getTranslated(
                                              'first_name_is_required',
                                              context),
                                          context);
                                    } else if (deliveryManProvider.lastNameController.text.trim().isEmpty &&
                                        widget.deliveryMan == null) {
                                      showCustomSnackBar(
                                          getTranslated(
                                              'last_name_is_required', context),
                                          context);
                                    } else if (deliveryManProvider.emailController.text.trim().isEmpty &&
                                        widget.deliveryMan == null) {
                                      showCustomSnackBar(
                                          getTranslated(
                                              'email_is_required', context),
                                          context);
                                    } else if (EmailChecker.isNotValid(deliveryManProvider.emailController.text.trim()) &&
                                        widget.deliveryMan == null) {
                                      showCustomSnackBar(
                                          getTranslated(
                                              'email_is_ot_valid', context),
                                          context);
                                    } else if (deliveryManProvider.phoneController.text
                                            .trim()
                                            .isEmpty &&
                                        widget.deliveryMan == null) {
                                      showCustomSnackBar(
                                          getTranslated(
                                              'phone_is_required', context),
                                          context);
                                    } else if (deliveryManProvider.phoneController.text.trim().length <
                                        8) {
                                      showCustomSnackBar(
                                          getTranslated(
                                              'phone_number_is_not_valid',
                                              context),
                                          context);
                                    } else if (deliveryManProvider.passwordController.text
                                            .trim()
                                            .isEmpty &&
                                        widget.deliveryMan == null) {
                                      showCustomSnackBar(
                                          getTranslated(
                                              'password_is_required', context),
                                          context);
                                    } else if (deliveryManProvider.passwordController.text.trim().length < 8 &&
                                        widget.deliveryMan == null) {
                                      showCustomSnackBar(
                                          getTranslated(
                                              'password_minimum_length_is_6',
                                              context),
                                          context);
                                    } else if (deliveryManProvider
                                            .confirmPasswordController.text
                                            .trim()
                                            .isEmpty &&
                                        widget.deliveryMan == null) {
                                      showCustomSnackBar(
                                          getTranslated(
                                              'confirm_password_is_required',
                                              context),
                                          context);
                                    } else if (deliveryManProvider.passwordController.text.trim() !=
                                        deliveryManProvider
                                            .confirmPasswordController.text
                                            .trim()) {
                                      showCustomSnackBar(
                                          getTranslated(
                                              'password_is_mismatch', context),
                                          context);
                                    } else if (deliveryManProvider.identityNumber.text
                                        .trim()
                                        .isEmpty) {
                                      showCustomSnackBar(
                                          getTranslated(
                                              'identity_number_is_required',
                                              context),
                                          context);
                                    } else if (deliveryManProvider.identityImages.isEmpty &&
                                        widget.deliveryMan == null) {
                                      showCustomSnackBar(
                                          getTranslated(
                                              'identity_image_is_required',
                                              context),
                                          context);
                                    } else {
                                      DeliveryManBody deliveryManBody = DeliveryManBody(
                                          id: widget.deliveryMan != null
                                              ? widget.deliveryMan!.id
                                              : 0,
                                          fName: deliveryManProvider
                                              .firstNameController.text
                                              .trim(),
                                          lName: deliveryManProvider
                                              .lastNameController.text
                                              .trim(),
                                          address: deliveryManProvider
                                              .addressController.text
                                              .trim(),
                                          phone: deliveryManProvider.phoneController.text
                                              .trim(),
                                          email: deliveryManProvider.emailController.text
                                              .trim(),
                                          countryCode: deliveryManProvider
                                              .countryDialCode,
                                          identityNumber: deliveryManProvider
                                              .identityNumber.text
                                              .trim(),
                                          identityType:
                                              deliveryManProvider.identityType,
                                          password: deliveryManProvider
                                              .passwordController.text
                                              .trim(),
                                          confirmPassword: deliveryManProvider
                                              .confirmPasswordController.text
                                              .trim());

                                      deliveryManProvider
                                          .addNewDeliveryMan(
                                              context, deliveryManBody,
                                              isUpdate:
                                                  widget.deliveryMan != null)
                                          .then((value) {
                                        if (value.response!.statusCode == 200) {
                                          _tabController!.animateTo(
                                              (_tabController!.index + 1) % 2);
                                          selectedIndex =
                                              _tabController!.index + 1;
                                          deliveryManProvider
                                              .setIndexForTabBar(selectedIndex);
                                          Navigator.of(context).pushReplacement(
                                              MaterialPageRoute(
                                                  builder: (BuildContext
                                                          context) =>
                                                      const DeliveryManSetupScreen()));
                                        }
                                      });
                                    }
                                  },
                                ),
                              ),
                      ],
                    ),
            ),
          ],
        );
      }),
    );
  }
}
