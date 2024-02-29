import 'package:easy_localization/easy_localization.dart' as lang;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screen_scaling/flutter_screen_scaling.dart';
import 'package:kiwi/kiwi.dart';
import 'package:saudimarchclient/gen/assets.gen.dart';
import 'package:saudimarchclient/gen_bloc/order/bloc.dart';
import 'package:saudimarchclient/helper/asset_image.dart';
import 'package:saudimarchclient/helper/extintions.dart';

import '../../gen_bloc/order/events.dart';
import '../../gen_bloc/order/states.dart';
import '../../generated/locale_keys.g.dart';
import '../../helper/failed_widget.dart';
import '../../helper/loading_app.dart';

class OrderDetailsView extends StatefulWidget {
  final int id;
  const OrderDetailsView({Key? key, required this.id}) : super(key: key);

  @override
  State<OrderDetailsView> createState() => _OrderDetailsStateView();
}

class _OrderDetailsStateView extends State<OrderDetailsView> {
  final _bloc = KiwiContainer().resolve<OrderBloc>();
  @override
  void initState() {
    _bloc.add(StartSingleOrderEvent(widget.id));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: "#FBF9F4".toColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: "#FBF9F4".toColor,
        elevation: 0,
        title: Text('#${widget.id}', style: context.textTheme.headline2),
      ),
      body: BlocBuilder(
          bloc: _bloc,
          builder: (context, state) {
            if (state is LoadingOrderState) {
              return const LoadingApp();
            } else if (state is FaildOrderState) {
              return FailedWidget(
                statusCode: state.statusCode,
                errType: state.errType,
                title: state.msg,
                onTap: () => _bloc.add(StartSingleOrderEvent(widget.id)),
              );
            } else if (state is DoneSingleOrderState) {
              return ListView(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        state.data.statusTr,
                        style: context.textTheme.subtitle1
                            ?.copyWith(fontSize: 20, color: state.data.status == 'finished' ? "#00C569".toColor : "#FB9F14".toColor),
                      ),
                      Text(
                        state.data.date + "\n" + state.data.time,
                        style: context.textTheme.subtitle1?.copyWith(fontSize: 20, color: "#929292".toColor, height: 0.8),
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.ltr,
                      ),
                    ],
                  ).paddingSymmetric(horizontal: 32.w),
                  SizedBox(height: 18.h),
                  SizedBox(
                    height: 220.h,
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 32.w),
                      itemCount: state.data.orderProducts.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsetsDirectional.only(end: 18.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomImage(
                                state.data.orderProducts[index].product.imageUrl,
                                width: 133.5.h,
                                height: 128.w,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: state.data.orderProducts[index].product.name,
                                      style: context.textTheme.headline3?.copyWith(color: context.color.secondary, fontSize: 21),
                                    ),
                                    const TextSpan(text: "\n"),
                                    TextSpan(
                                      text: 'X${state.data.orderProducts[index].quantity}',
                                      style: context.textTheme.bodyText1,
                                    ),
                                    const TextSpan(text: "\n"),
                                    TextSpan(
                                      text: state.data.orderProducts[index].product.finalPrice.toString(),
                                      style: context.textTheme.headline3,
                                    ),
                                    TextSpan(
                                      text: "  ${LocaleKeys.SR.tr()}  ",
                                      style: context.textTheme.subtitle2?.copyWith(color: context.color.secondary),
                                    ),
                                    if (state.data.orderProducts[index].product.priceAfterDiscount > 0)
                                      TextSpan(
                                        text: "${state.data.orderProducts[index].product.priceBeforeDiscount}  ${LocaleKeys.SR.tr()}",
                                        style: context.textTheme.subtitle2
                                            ?.copyWith(color: context.color.secondary, decoration: TextDecoration.lineThrough),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 18.h),

                  /// invoic pay
                  ...List.generate(
                    4,
                    (i) => Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          [
                            LocaleKeys.Product_Price,
                            LocaleKeys.Discount,
                            LocaleKeys.Shipping_Rate,
                            LocaleKeys.Total,
                          ][i]
                              .tr(),
                          style: i == 3 ? context.textTheme.headline2 : context.textTheme.headline5,
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: List.generate(
                              20,
                              (index) => Container(
                                width: 4,
                                height: 1,
                                color: "#DDDDDD".toColor,
                                padding: EdgeInsets.symmetric(horizontal: 2.w),
                              ),
                            ),
                          ).paddingSymmetric(horizontal: 5.w),
                        ),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: [
                                  state.data.productsPrice,
                                  state.data.totaleDiscount,
                                  state.data.deliveryPrice,
                                  state.data.totalPrice,
                                ][i]
                                    .toString(),
                                style: context.textTheme.headline2,
                              ),
                              TextSpan(
                                text: " ${LocaleKeys.SR.tr()}",
                                style: context.textTheme.subtitle1,
                              ),
                            ],
                          ),
                        ).paddingOnly(bottom: 4.h),
                      ],
                    ).paddingSymmetric(horizontal: 32.w),
                  ),
                  Divider(color: "#DDDDDD".toColor, height: 32.h).paddingSymmetric(horizontal: 32.w),
                  // client data
                  ListTile(
                    leading: CustomImage(
                      state.data.provider.imageUrl,
                      borderRadius: BorderRadius.circular(1000),
                      height: 46.h,
                      width: 46.h,
                    ),
                    title: Text(
                      state.data.provider.name,
                      style: context.textTheme.headline3,
                    ),
                  ).paddingSymmetric(horizontal: 32.w),
                  Divider(color: "#DDDDDD".toColor, height: 32.h).paddingSymmetric(horizontal: 32.w),
                  Row(
                    children: [
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: LocaleKeys.Delivery_Address.tr(),
                                style: context.textTheme.headline2?.copyWith(fontSize: 27),
                              ),
                              const TextSpan(text: "\n"),
                              TextSpan(
                                text: state.data.addressDetails.name,
                                style: context.textTheme.headline6,
                              ),
                              const TextSpan(text: "\n"),
                              TextSpan(
                                text: state.data.addressDetails.address,
                                style: context.textTheme.bodyText1?.copyWith(color: "#958A7E".toColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                      CustomImage(Assets.svg.iconAwesomeDirections).paddingOnly(top: 40.h)
                    ],
                  ).paddingSymmetric(horizontal: 32.w),
                  Divider(color: "#DDDDDD".toColor, height: 32.h).paddingSymmetric(horizontal: 32.w),
                  Text(
                    LocaleKeys.payment_method.tr(),
                    style: context.textTheme.headline2?.copyWith(fontSize: 27),
                    textAlign: TextAlign.right,
                  ).paddingSymmetric(horizontal: 32.w),
                  ListTile(
                    title: Text(state.data.payTypeTr, style: context.textTheme.headline5),
                    leading: CustomImage(
                      state.data.payType == "cash" ? Assets.svg.cashSvgrepoCom : Assets.images.iconMasterCard.path,
                      height: 18.h,
                    ),
                  ).paddingSymmetric(horizontal: 32.w),
                ],
              );
            } else {
              return const SizedBox.shrink();
            }
          }),
    );
  }
}
