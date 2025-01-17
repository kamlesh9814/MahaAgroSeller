import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:maidc_seller/provider/delivery_man_provider.dart';
import 'package:maidc_seller/view/base/no_data_screen.dart';
import 'package:maidc_seller/view/base/order_shimmer.dart';
import 'package:maidc_seller/view/base/paginated_list_view.dart';
import 'package:maidc_seller/data/model/response/top_delivery_man.dart';
import 'package:maidc_seller/view/screens/delivery/widget/earning_card.dart';

class DeliverymanEarningListView extends StatefulWidget {
  final DeliveryMan? deliveryMan;
  final ScrollController? scrollController;
  const DeliverymanEarningListView(
      {Key? key, this.deliveryMan, this.scrollController})
      : super(key: key);

  @override
  State<DeliverymanEarningListView> createState() =>
      _DeliverymanEarningListViewState();
}

class _DeliverymanEarningListViewState
    extends State<DeliverymanEarningListView> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DeliveryManProvider>(
        builder: (context, earningProvider, child) {
      return earningProvider.deliveryManEarning != null
          ? earningProvider.deliveryManEarning!.orders!.isNotEmpty
              ? RefreshIndicator(
                  backgroundColor: Theme.of(context).primaryColor,
                  onRefresh: () async {
                    await earningProvider.getDeliveryManEarningListHistory(
                        context, 1, widget.deliveryMan!.id);
                  },
                  child: PaginatedListView(
                    reverse: false,
                    scrollController: widget.scrollController,
                    onPaginate: (int? offset) =>
                        earningProvider.getDeliveryManEarningListHistory(
                            context, offset!, widget.deliveryMan!.id,
                            reload: false),
                    totalSize: earningProvider.deliveryManEarning!.totalSize,
                    offset:
                        int.parse(earningProvider.deliveryManEarning!.offset!),
                    enabledPagination:
                        earningProvider.deliveryManEarning != null,
                    itemView: ListView.builder(
                      itemCount:
                          earningProvider.deliveryManEarning!.orders!.length,
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return EarningCardWidget(
                            earning: earningProvider
                                .deliveryManEarning!.orders![index]);
                      },
                    ),
                  ))
              : const NoDataScreen(
                  title: 'no_order_found',
                )
          : const OrderShimmer(isEnabled: true);
    });
  }
}
