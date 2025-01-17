import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:maidc_seller/localization/language_constrants.dart';
import 'package:maidc_seller/provider/auth_provider.dart';
import 'package:maidc_seller/provider/profile_provider.dart';
import 'package:maidc_seller/utill/color_resources.dart';
import 'package:maidc_seller/utill/dimensions.dart';
import 'package:maidc_seller/utill/images.dart';
import 'package:maidc_seller/utill/styles.dart';
import 'package:maidc_seller/view/base/custom_button.dart';
import 'package:maidc_seller/view/screens/auth/auth_screen.dart';

class SignOutConfirmationDialog extends StatelessWidget {
  final bool isDelete;
  const SignOutConfirmationDialog({Key? key, this.isDelete = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: ColorResources.getBottomSheetColor(context),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              Column(mainAxisSize: MainAxisSize.min, children: [
                const SizedBox(height: 30),
                SizedBox(
                  width: 52,
                  height: 52,
                  child: Image.asset(Images.logOutIcon),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                      Dimensions.paddingSizeLarge,
                      13,
                      Dimensions.paddingSizeLarge,
                      0),
                  child: Text(
                      isDelete
                          ? getTranslated('want_to_delete_account', context)!
                          : getTranslated('want_to_sign_out', context)!,
                      style: titilliumRegular.copyWith(
                          fontSize: Dimensions.fontSizeLarge,
                          color: Theme.of(context).hintColor),
                      textAlign: TextAlign.center),
                ),
                SizedBox(
                  height: 80,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                        Dimensions.paddingSizeDefault,
                        24,
                        Dimensions.paddingSizeDefault,
                        Dimensions.paddingSizeDefault),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Row(children: [
                        Expanded(
                          child: CustomButton(
                            borderRadius: 15,
                            btnTxt: getTranslated('yes', context),
                            backgroundColor:
                                Theme.of(context).colorScheme.error,
                            fontColor: Colors.white,
                            isColor: true,
                            onTap: () {
                              if (isDelete) {
                                Provider.of<ProfileProvider>(context,
                                        listen: false)
                                    .deleteCustomerAccount(context)
                                    .then((condition) {
                                  if (condition.response!.statusCode == 200) {
                                    Navigator.pop(context);
                                    Provider.of<AuthProvider>(context,
                                            listen: false)
                                        .clearSharedData();
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const AuthScreen()),
                                        (route) => false);
                                  }
                                });
                              } else {
                                Provider.of<AuthProvider>(context,
                                        listen: false)
                                    .clearSharedData();
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const AuthScreen()),
                                    (route) => false);
                                // Provider.of<AuthProvider>(context, listen: false).clearSharedData().then((condition) {
                                //   Navigator.pop(context);
                                //   Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => AuthScreen()), (route) => false);
                                // });
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: Dimensions.paddingSizeSmall),
                        Expanded(
                          child: CustomButton(
                            borderRadius: 15,
                            btnTxt: getTranslated('no', context),
                            isColor: true,
                            fontColor: ColorResources.getTextColor(context),
                            backgroundColor:
                                Theme.of(context).hintColor.withOpacity(.25),
                            onTap: () => Navigator.pop(context),
                          ),
                        ),
                      ]),
                    ),
                  ),
                ),
              ]),
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Padding(
                    padding:
                        const EdgeInsets.all(Dimensions.paddingSizeDefault),
                    child: SizedBox(
                        width: 18,
                        child: Image.asset(Images.cross,
                            color: ColorResources.getTextColor(context))),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
