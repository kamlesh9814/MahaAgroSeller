import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:maidc_seller/localization/language_constrants.dart';
import 'package:maidc_seller/provider/auth_provider.dart';
import 'package:maidc_seller/provider/splash_provider.dart';
import 'package:maidc_seller/utill/color_resources.dart';
import 'package:maidc_seller/utill/dimensions.dart';
import 'package:maidc_seller/utill/images.dart';
import 'package:maidc_seller/view/base/custom_button.dart';
import 'package:maidc_seller/view/base/custom_snackbar.dart';
import 'package:maidc_seller/view/screens/forgetPassword/widget/reset_password_widget.dart';

class VerificationScreen extends StatelessWidget {
  final String mobileNumber;

  const VerificationScreen(this.mobileNumber, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Scrollbar(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Center(
              child: SizedBox(
                width: 1170,
                child: Consumer<AuthProvider>(
                  builder: (context, authProvider, child) => Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 55),
                      Image.asset(
                        Images.logo,
                        width: 100,
                        height: 100,
                      ),
                      const SizedBox(height: 40),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: Center(
                            child: Text(
                          '${getTranslated('please_enter_4_digit_code', context)}\n$mobileNumber',
                          textAlign: TextAlign.center,
                        )),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 39, vertical: 35),
                        child: PinCodeTextField(
                          length: 4,
                          appContext: context,
                          obscureText: false,
                          showCursor: true,
                          keyboardType: TextInputType.number,
                          animationType: AnimationType.fade,
                          pinTheme: PinTheme(
                            shape: PinCodeFieldShape.box,
                            fieldHeight: 63,
                            fieldWidth: 55,
                            borderWidth: 1,
                            borderRadius: BorderRadius.circular(10),
                            selectedColor: ColorResources.colorMap[200],
                            selectedFillColor: Colors.white,
                            inactiveFillColor:
                                ColorResources.getSearchBg(context),
                            inactiveColor: ColorResources.colorMap[200],
                            activeColor: ColorResources.colorMap[400],
                            activeFillColor:
                                ColorResources.getSearchBg(context),
                          ),
                          animationDuration: const Duration(milliseconds: 300),
                          backgroundColor: Colors.transparent,
                          enableActiveFill: true,
                          onChanged: authProvider.updateVerificationCode,
                          beforeTextPaste: (text) {
                            return true;
                          },
                        ),
                      ),
                      Center(
                          child: Text(
                        getTranslated('i_didnt_receive_the_code', context)!,
                      )),
                      Center(
                        child: InkWell(
                          onTap: () {
                            Provider.of<AuthProvider>(context, listen: false)
                                .forgetPassword(mobileNumber)
                                .then((value) {
                              if (value.isSuccess) {
                                showCustomSnackBar(
                                    'Resent code successful', context,
                                    isError: false);
                              } else {
                                showCustomSnackBar(value.message, context);
                              }
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(
                                Dimensions.paddingSizeExtraSmall),
                            child: Text(
                              getTranslated('resend_code', context)!,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 48),
                      authProvider.isEnableVerificationCode
                          ? !authProvider.isPhoneNumberVerificationButtonLoading
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: Dimensions.paddingSizeLarge),
                                  child: CustomButton(
                                    btnTxt: getTranslated('verify', context),
                                    onTap: () {
                                      bool phoneVerification =
                                          Provider.of<SplashProvider>(context,
                                                      listen: false)
                                                  .configModel!
                                                  .forgetPasswordVerification ==
                                              'phone';
                                      if (phoneVerification) {
                                        Provider.of<AuthProvider>(context,
                                                listen: false)
                                            .verifyOtp(mobileNumber)
                                            .then((value) {
                                          if (value.isSuccess) {
                                            Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        ResetPasswordWidget(
                                                            mobileNumber:
                                                                mobileNumber,
                                                            otp: authProvider
                                                                .verificationCode)),
                                                (route) => false);
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                              content: Text(getTranslated(
                                                  'input_valid_otp', context)!),
                                              backgroundColor: Colors.red,
                                            ));
                                          }
                                        });
                                      }
                                    },
                                  ),
                                )
                              : Center(
                                  child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Theme.of(context).primaryColor)))
                          : const SizedBox.shrink()
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
