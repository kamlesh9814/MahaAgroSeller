import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:maidc_seller/helper/network_info.dart';
import 'package:maidc_seller/provider/auth_provider.dart';
import 'package:maidc_seller/provider/splash_provider.dart';
import 'package:maidc_seller/utill/app_constants.dart';
import 'package:maidc_seller/utill/dimensions.dart';
import 'package:maidc_seller/utill/images.dart';
import 'package:maidc_seller/utill/styles.dart';
import 'package:maidc_seller/view/screens/auth/auth_screen.dart';
import 'package:maidc_seller/view/screens/dashboard/dashboard_screen.dart';
import 'package:maidc_seller/view/screens/splash/widget/splash_painter.dart';

class SplashScreen extends StatefulWidget {
  final int? orderId;

  const SplashScreen({Key? key, this.orderId}) : super(key: key);
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    NetworkInfo.checkConnectivity(context);
    Provider.of<SplashProvider>(context, listen: false)
        .initConfig()
        .then((bool isSuccess) {
      if (isSuccess) {
        Provider.of<SplashProvider>(context, listen: false)
            .initShippingTypeList(context, '');
        Timer(const Duration(seconds: 1), () {
          if (Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
            Provider.of<AuthProvider>(context, listen: false)
                .updateToken(context);
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => const DashboardScreen()));
          } else {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => const AuthScreen()));
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: Stack(
          clipBehavior: Clip.none,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: CustomPaint(
                painter: SplashPainter(),
              ),
            ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Hero(
                    tag: 'logo',
                    child: Container(
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(Images.logo, width: 100.0),
                        )),
                  ),
                  const SizedBox(
                    height: Dimensions.paddingSizeExtraLarge,
                  ),
                  Text(
                    AppConstants.appName,
                    style: titilliumBold.copyWith(
                        fontSize: Dimensions.fontSizeWallet,
                        color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
