import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:maidc_seller/data/model/response/collected_cash_model.dart';
import 'package:maidc_seller/data/model/response/top_delivery_man.dart';
import 'package:maidc_seller/provider/delivery_man_provider.dart';
import 'package:maidc_seller/view/base/no_data_screen.dart';
import 'package:maidc_seller/view/base/order_shimmer.dart';
import 'package:maidc_seller/view/base/paginated_list_view.dart';
import 'package:maidc_seller/view/screens/delivery/widget/delivery_man_collected_cash_card.dart';

class CollectedCashFromDeliveryMan extends StatefulWidget {
  final DeliveryMan? deliveryMan;
  const CollectedCashFromDeliveryMan({Key? key, this.deliveryMan})
      : super(key: key);

  @override
  State<CollectedCashFromDeliveryMan> createState() =>
      _CollectedCashFromDeliveryManState();
}

class _CollectedCashFromDeliveryManState
    extends State<CollectedCashFromDeliveryMan> {
  ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Consumer<DeliveryManProvider>(
        builder: (context, collectedCashProvider, child) {
      List<CollectedCash>? collectedCashList;
      collectedCashList =
          collectedCashProvider.collectedCashModel!.collectedCash;
      return collectedCashList != null
          ? collectedCashProvider.earningList.isNotEmpty
              ? RefreshIndicator(
                  backgroundColor: Theme.of(context).primaryColor,
                  onRefresh: () async {
                    await collectedCashProvider.getDeliveryCollectedCashList(
                        context, widget.deliveryMan!.id, 1);
                  },
                  child: collectedCashList.isNotEmpty
                      ? SingleChildScrollView(
                          controller: scrollController,
                          child: PaginatedListView(
                            reverse: false,
                            scrollController: scrollController,
                            totalSize: collectedCashProvider
                                .collectedCashModel?.totalSize,
                            offset:
                                collectedCashProvider.collectedCashModel != null
                                    ? int.parse(collectedCashProvider
                                        .collectedCashModel!.offset
                                        .toString())
                                    : null,
                            onPaginate: (int? offset) async {
                              if (kDebugMode) {
                                print('==========offset========>$offset');
                              }
                              await collectedCashProvider
                                  .getDeliveryCollectedCashList(
                                      context, widget.deliveryMan!.id, offset!,
                                      reload: false);
                            },
                            itemView: ListView.builder(
                              itemCount: collectedCashList.length,
                              padding: const EdgeInsets.all(0),
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                return DeliveryManCollectedCashCard(
                                    collectedCash: collectedCashList![index],
                                    index: index);
                              },
                            ),
                          ),
                        )
                      : const NoDataScreen(),
                )
              : const NoDataScreen(
                  title: 'no_order_found',
                )
          : const OrderShimmer(isEnabled: true);
    });
  }
}
