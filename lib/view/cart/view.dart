import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screen_scaling/flutter_screen_scaling.dart';
import 'package:kiwi/kiwi.dart';
import 'package:saudimarchclient/common/btn.dart';
import 'package:saudimarchclient/generated/locale_keys.g.dart';
import 'package:saudimarchclient/helper/extintions.dart';
import 'package:saudimarchclient/helper/flash_helper.dart';
import 'package:saudimarchclient/helper/rout.dart';
import 'package:saudimarchclient/view/cart/common/invoic_widget.dart';
import 'package:easy_localization/easy_localization.dart' as lang;

import '../../gen/assets.gen.dart';
import '../../helper/asset_image.dart';
import '../../helper/failed_widget.dart';
import '../../helper/loading_app.dart';
import '../common_cards/prodict_in_cart.dart';
import '../create_order/view.dart';
import 'bloc/bloc.dart';
import 'bloc/events.dart';
import 'bloc/states.dart';

class CartView extends StatefulWidget {
  const CartView({Key? key}) : super(key: key);

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  final CartBloc _bloc = KiwiContainer().resolve<CartBloc>();
  final CartBloc _applyBloc = KiwiContainer().resolve<CartBloc>();
  final _controller = TextEditingController();
  @override
  void initState() {
    _bloc.add(StartGetCartEvent());
    super.initState();
  }

  @override
  void dispose() {
    _bloc.close();
    _applyBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: _bloc,
        builder: (context, state) {
          return Scaffold(
            backgroundColor: context.color.secondaryContainer,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: context.color.secondaryContainer,
              title: Text(
                LocaleKeys.cart.tr(),
                style: context.textTheme.headline2,
                textAlign: TextAlign.center,
              ),
              centerTitle: true,
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
            floatingActionButton: Builder(builder: (context) {
              if (state is DoneGetCartState && state.data.data.items.isNotEmpty) {
                return Container(
                  transform: Matrix4.translationValues(0, 20.h, 0),
                  height: 75.h,
                  child: Btn(
                    onTap: () => push(const CreateOrderView()),
                    widget: Text(
                      LocaleKeys.completion_of_purchase.tr(),
                      style: context.textTheme.headline4!.copyWith(color: context.theme.primaryColor),
                    ).paddingOnly(bottom: 20.h).onCenter,
                    height: 75.h,
                    borderRadius: BorderRadiusDirectional.vertical(top: Radius.circular(25.px)),
                  ),
                );
              }
              return const SizedBox.shrink();
            }),
            body: Builder(builder: (context) {
              if (state is LoadingCartState && state.type == 'start') {
                return const LoadingApp();
              } else if (state is FaildCartState) {
                return FailedWidget(
                  statusCode: state.statusCode,
                  errType: state.errType,
                  title: state.msg,
                  onTap: () => _bloc.add(StartGetCartEvent()),
                );
              } else if (state is DoneGetCartState) {
                if (state.data.data.items.isEmpty) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomImage(Assets.svg.cartIcon, height: 150.h, color: context.color.secondary.withOpacity(0.2)).onCenter,
                      // Text(
                      //   LocaleKeys.there_are_no_elements_in_the_favorite.tr(),
                      //   style: context.textTheme.subtitle1?.copyWith(color: context.color.secondary.withOpacity(0.4)),
                      // ).paddingSymmetric(vertical: 12.h)
                    ],
                  );
                }
                return ListView(
                  padding: EdgeInsets.symmetric(vertical: 16.h).copyWith(bottom: 70.h),
                  children: [
                    ...List.generate(
                      state.data.data.items.length,
                      (i) => ProductInCart(
                        data: state.data.data.items[i],
                        onUpdate: (v) {
                          setState(() {
                            state.data = v;
                          });
                        },
                        onFavorite: (v) {
                          setState(() {
                            for (var element in state.data.data.items) {
                              if (element.product.id == v.product.id) {
                                element.product.isFav = v.product.isFav;
                              }
                            }
                          });
                        },
                      ),
                    ),
                    SizedBox(height: 42.h),
                    Column(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 26.w),
                          height: 47.0.h,
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50.0),
                            border: Border.all(width: 1.0, color: Colors.black.withOpacity(0.15)),
                          ),
                          child: TextField(
                            controller: _controller,
                            decoration: InputDecoration.collapsed(hintText: LocaleKeys.Discount_Coupon.tr()).copyWith(
                              contentPadding: EdgeInsets.symmetric(vertical: 6.h),
                              suffixIcon: InkWell(
                                onTap: () => _applyBloc.add(StartApplyCouponEvent(_controller.text)),
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 47.0.h,
                                  width: 20.w,
                                  child: BlocConsumer(
                                    bloc: _applyBloc,
                                    listener: (context, state) {
                                      if (state is DoneApplyCouponState) {
                                        FlashHelper.successBar(message: state.msg);
                                      } else if (state is FaildCartState) {
                                        FlashHelper.errorBar(message: state.msg);
                                      }
                                    },
                                    builder: (context, snapshot) {
                                      if (snapshot is LoadingCartState && snapshot.type == 'coupon') {
                                        return CustomProgress(size: 20.px, color: context.color.secondary);
                                      }
                                      return Text(LocaleKeys.send.tr(), style: context.textTheme.headline5);
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 24.h),
                        IvoiceWidget(price: state.data.totalProductsPrice, title: LocaleKeys.product_price.tr()),
                        IvoiceWidget(price: state.data.dicount, title: LocaleKeys.Discount.tr()),
                        IvoiceWidget(price: state.data.deliveryPrice, title: LocaleKeys.shipping_price.tr()),
                        IvoiceWidget(price: state.data.totalPrice, textSize: 33, title: LocaleKeys.totla.tr()),
                      ],
                    )
                  ],
                );
              } else {
                return const SizedBox.shrink();
              }
            }),
          );
        });
  }
}
