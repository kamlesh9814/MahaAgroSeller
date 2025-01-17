import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:maidc_seller/data/model/response/cart_model.dart';
import 'package:maidc_seller/helper/price_converter.dart';
import 'package:maidc_seller/provider/cart_provider.dart';
import 'package:maidc_seller/provider/splash_provider.dart';
import 'package:maidc_seller/utill/dimensions.dart';
import 'package:maidc_seller/utill/images.dart';
import 'package:maidc_seller/utill/styles.dart';
import 'package:maidc_seller/view/base/custom_image.dart';

class ItemCartWidget extends StatelessWidget {
  final CartModel? cartModel;
  final int? index;
  const ItemCartWidget({Key? key, this.cartModel, this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String baseUrl =
        '${Provider.of<SplashProvider>(context, listen: false).configModel!.baseUrls!.productThumbnailUrl}';
    return Padding(
      padding: const EdgeInsets.only(top: Dimensions.paddingSizeMedium),
      child: Dismissible(
        key: UniqueKey(),
        onDismissed: (DismissDirection direction) {
          Provider.of<CartProvider>(context, listen: false)
              .removeFromCart(index!);
        },
        child: Container(
          decoration:
              BoxDecoration(color: Theme.of(context).cardColor, boxShadow: [
            BoxShadow(
                color: Theme.of(context).primaryColor.withOpacity(.125),
                spreadRadius: 0.5,
                blurRadius: 0.3,
                offset: const Offset(1, 2))
          ]),
          padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeExtraSmall,
              Dimensions.paddingSizeSmall, 0, Dimensions.paddingSizeSmall),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: Dimensions.productImageSize,
                          width: Dimensions.productImageSize,
                          padding: const EdgeInsets.all(
                              Dimensions.paddingSizeBorder),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                                Dimensions.paddingSizeExtraSmall),
                            child: CustomImage(
                                image:
                                    '$baseUrl/${cartModel!.product!.thumbnail}',
                                placeholder: Images.placeholderImage,
                                fit: BoxFit.cover,
                                width: Dimensions.productImageSize,
                                height: Dimensions.productImageSize),
                          ),
                        ),
                        const SizedBox(width: Dimensions.paddingSizeSmall),
                        Expanded(
                            child: Text(
                          '${cartModel!.product!.name}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeSmall),
                        )),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Consumer<CartProvider>(
                        builder: (context, cartController, _) {
                      return Row(
                        children: [
                          InkWell(
                            onTap: () {
                              cartController.setQuantity(context, false, index,
                                  showToaster: true);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: Dimensions.paddingSizeExtraSmall),
                              child: Icon(Icons.remove_circle,
                                  size: Dimensions.incrementButton,
                                  color: cartModel!.quantity! > 1
                                      ? Theme.of(context).colorScheme.onPrimary
                                      : Theme.of(context).hintColor),
                            ),
                          ),
                          Center(
                              child: Text(cartModel!.quantity.toString(),
                                  style: robotoRegular.copyWith())),
                          InkWell(
                            onTap: () {
                              cartController.setQuantity(
                                context,
                                true,
                                index,
                                showToaster: true,
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: Dimensions.paddingSizeExtraSmall),
                              child: Icon(Icons.add_circle,
                                  size: Dimensions.incrementButton,
                                  color: Theme.of(context).primaryColor),
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                  Expanded(
                      flex: 2,
                      child: Text(
                          PriceConverter.convertPrice(
                              context, cartModel!.price),
                          style: robotoRegular.copyWith())),
                ],
              ),
              const SizedBox(height: Dimensions.paddingSizeExtraSmall),
            ],
          ),
        ),
      ),
    );
  }
}
