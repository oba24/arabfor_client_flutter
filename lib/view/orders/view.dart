import 'package:easy_localization/easy_localization.dart' as lang;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screen_scaling/flutter_screen_scaling.dart';
import 'package:kiwi/kiwi.dart';
import 'package:saudimarchclient/gen/assets.gen.dart';
import 'package:saudimarchclient/gen_bloc/order/bloc.dart';
import 'package:saudimarchclient/helper/asset_image.dart';
import 'package:saudimarchclient/helper/extintions.dart';
import 'package:saudimarchclient/helper/rout.dart';
import 'package:saudimarchclient/view/common_cards/order.dart';
import 'package:saudimarchclient/view/order_details/view.dart';

import '../../gen_bloc/order/events.dart';
import '../../gen_bloc/order/states.dart';
import '../../generated/locale_keys.g.dart';
import '../../helper/failed_widget.dart';
import '../../helper/loading_app.dart';

class OrdersView extends StatefulWidget {
  const OrdersView({Key? key}) : super(key: key);

  @override
  State<OrdersView> createState() => _OrdersViewState();
}

class _OrdersViewState extends State<OrdersView> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    _bloc.add(StartOrderEvent());
    super.initState();
  }

  final _bloc = KiwiContainer().resolve<OrderBloc>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: context.color.primaryContainer,
        appBar: AppBar(
          title: Text(LocaleKeys.My_requests.tr(), style: context.textTheme.headline2),
          centerTitle: true,
          elevation: 0,
          backgroundColor: context.color.primaryContainer,
        ),
        body: BlocBuilder(
          bloc: _bloc,
          builder: (context, state) {
            if (state is LoadingOrderState) {
              return LoadingApp(height: 60.h);
            } else if (state is FaildOrderState) {
              return FailedWidget(
                statusCode: state.statusCode,
                errType: state.errType,
                title: state.msg,
                onTap: () => _bloc.add(StartOrderEvent()),
              );
            } else if (state is DoneOrderState) {
              if (state.data.isEmpty) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomImage(Assets.svg.orders, color: context.color.secondary.withOpacity(0.3), height: 120.h),
                    Text(LocaleKeys.There_are_no_requests_at_the_present_time.tr(), style: context.textTheme.headline4).paddingOnly(top: 24.h),
                  ],
                ).onCenter;
              }
              return ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 35.h),
                itemCount: state.data.length,
                itemBuilder: (context, i) {
                  return OrderCard(
                    onTap: () => push(OrderDetailsView(id: state.data[i].id)),
                    id: state.data[i].id,
                    date: state.data[i].date,
                    price: state.data[i].totalPrice,
                    status: state.data[i].statusTr,
                    statusColor: state.data[i].hexColor.toColor,
                    images: state.data[i].orderProducts.map((e) => e.product.imageUrl).toList(),
                  ).paddingOnly(bottom: 12.h);
                },
              );
            } else {
              return const SizedBox();
            }
          },
        ));
  }
}
