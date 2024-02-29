import 'dart:async';

import 'package:easy_localization/easy_localization.dart' as lang;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screen_scaling/flutter_screen_scaling.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:kiwi/kiwi.dart';
import 'package:saudimarchclient/gen/assets.gen.dart';
import 'package:saudimarchclient/helper/asset_image.dart';
import 'package:saudimarchclient/helper/extintions.dart';
import 'package:saudimarchclient/helper/flash_helper.dart';
import 'package:saudimarchclient/helper/loading_app.dart';
import 'package:saudimarchclient/helper/theme.dart';
import 'package:saudimarchclient/view/cart/bloc/events.dart';
import 'package:saudimarchclient/view/cart/bloc/states.dart';

import '../../generated/locale_keys.g.dart';
import '../cart/bloc/bloc.dart';
import '../cart/bloc/model.dart';
import '../favorit/bloc/bloc.dart';
import '../favorit/bloc/events.dart';
import '../favorit/bloc/states.dart';

class ProductInCart extends StatefulWidget {
  final CartItemDatum data;
  final Function(CartItemDatum data)? onFavorite;
  final Function(CartModel data) onUpdate;
  const ProductInCart({Key? key, required this.data, required this.onUpdate, this.onFavorite}) : super(key: key);

  @override
  State<ProductInCart> createState() => _ProductInCartState();
}

class _ProductInCartState extends State<ProductInCart> {
  final CartBloc _bloc = KiwiContainer().resolve<CartBloc>();
  final CartBloc _deleteBloc = KiwiContainer().resolve<CartBloc>();
  final _favoriteBloc = KiwiContainer().resolve<FavoriteBloc>();
  Timer? timer;
  _update() {
    if (timer != null && timer!.isActive) timer!.cancel();
    timer = Timer(500.milliseconds, () {
      _bloc.add(StartControllerCartEvent(type: "update", id: widget.data.cartItemId, quantity: widget.data.localQuantity));
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _bloc.close();
    _deleteBloc.close();
    _favoriteBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Slidable(
        endActionPane: ActionPane(
          extentRatio: .25,
          motion: const ScrollMotion(),
          children: [
            const Spacer(),
            BlocConsumer(
              bloc: _deleteBloc,
              listener: (context, deleteState) {
                if (deleteState is FaildCartState) {
                  FlashHelper.errorBar(message: deleteState.msg);
                } else if (deleteState is DoneControllerCartState) {
                  widget.onUpdate(deleteState.data);
                  Slidable.of(context)?.close();
                }
              },
              builder: (context, deleteState) {
                if (deleteState is LoadingCartState && deleteState.type == "delete") {
                  return Container(
                    width: 80.w,
                    decoration: BoxDecoration(
                      color: StylesApp.primary,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20.w),
                        bottomRight: Radius.circular(20.w),
                      ),
                    ),
                    child: const Center(
                      child: LoadingApp(),
                    ),
                  );
                }
                return InkWell(
                  onTap: () {
                    setState(() {});
                    _deleteBloc.add(StartControllerCartEvent(type: "delete", id: widget.data.cartItemId));
                  },
                  child: Container(
                    width: 80.w,
                    decoration: BoxDecoration(
                        color: StylesApp.primary,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20.w),
                          bottomRight: Radius.circular(20.w),
                        )),
                    child: const Icon(CupertinoIcons.delete, color: Colors.red).onCenter,
                  ),
                );
              },
            ),
          ],
        ),
       
        child: BlocConsumer(
            bloc: _bloc,
            listener: (context, state) {
              if (state is FaildCartState) {
                FlashHelper.errorBar(message: state.msg);
                widget.data.localQuantity = widget.data.quantity;
                setState(() {});
              } else if (state is DoneControllerCartState) {
                widget.onUpdate(state.data);
              }
            },
            builder: (context, state) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomImage(
                    widget.data.product.image,
                    height: 108.h,
                    width: 112.w,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  SizedBox(width: 15.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(text: widget.data.product.name, style: context.textTheme.headline5),
                              const TextSpan(text: "\n"),
                              TextSpan(
                                text: (widget.data.product.withDiscount
                                        ? widget.data.product.priceAfterDicount
                                        : widget.data.product.priceBeforeDicount)
                                    .toString(),
                                style: context.textTheme.bodyText2?.copyWith(fontSize: 20.0),
                              ),
                              TextSpan(
                                text: " ${LocaleKeys.SR.tr()}  ",
                                style: context.textTheme.bodyText2?.copyWith(fontSize: 14.0),
                              ),
                              if (widget.data.product.withDiscount)
                                TextSpan(
                                  text: widget.data.product.priceBeforeDicount.toString(),
                                  style: context.textTheme.bodyText2?.copyWith(
                                    fontSize: 14.0,
                                    decoration: TextDecoration.lineThrough,
                                    color: context.color.tertiary,
                                  ),
                                ),
                              if (widget.data.product.withDiscount)
                                TextSpan(
                                  text: " ${LocaleKeys.SR.tr()}",
                                  style: context.textTheme.bodyText2?.copyWith(
                                    fontSize: 10.0,
                                    decoration: TextDecoration.lineThrough,
                                    color: context.color.tertiary,
                                  ),
                                ),
                            ],
                          ),
                        ).paddingOnly(top: 8.h),
                        Container(
                          margin: EdgeInsets.only(top: 8.h),
                          height: 30.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: const Color(0xFFF7F5EF),
                            border: Border.all(width: 1.0, color: context.color.secondary.withOpacity(0.05)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              InkWell(
                                onTap: () {
                                  if (state is! LoadingCartState) {
                                    if (widget.data.localQuantity != 1) {
                                      setState(() {
                                        widget.data.localQuantity--;
                                      });
                                      _update();
                                    }
                                  }
                                },
                                child: Icon(Icons.remove, color: context.color.secondary.withOpacity(0.6)).paddingSymmetric(horizontal: 10.w),
                              ),
                              Builder(builder: (context) {
                                if (state is LoadingCartState) {
                                  return CustomProgress(size: 15.px, color: context.color.secondary);
                                }
                                return Text(
                                  widget.data.localQuantity.toString(),
                                  style: context.textTheme.bodyText1?.copyWith(height: 1),
                                  textAlign: TextAlign.center,
                                ).paddingSymmetric(horizontal: 5.w);
                              }),
                              InkWell(
                                onTap: () {
                                  if (state is! LoadingCartState) {
                                    setState(() {
                                      widget.data.localQuantity++;
                                    });
                                    _update();
                                  }
                                },
                                child: Icon(Icons.add, color: context.color.secondary.withOpacity(0.6)).paddingSymmetric(horizontal: 10.w),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  BlocConsumer(
                    bloc: _favoriteBloc,
                    listener: (context, state) {
                      if (state is DoneFavoriteControllerState) {
                        setState(() {
                          widget.data.product.isFav = !widget.data.product.isFav;
                        });
                        if (widget.onFavorite != null) widget.onFavorite!(widget.data);
                      } else if (state is FaildFavoriteState) {
                        FlashHelper.errorBar(message: state.msg);
                      }
                    },
                    builder: (context, state) {
                      if (state is LoadingFavoriteState) return CustomProgress(size: 20.w, color: context.color.secondary);
                      return InkWell(
                        onTap: () => _favoriteBloc.add(StartFavoriteControllerEvent(widget.data.product.id)),
                        child: CustomImage(widget.data.product.isFav ? Assets.svg.isFavorite : Assets.svg.unfavorite, width: 20.w),
                      );
                    },
                  )
                ],
              ).paddingSymmetric(horizontal: 25.w, vertical: 8.h);
            }),
      ),
    );
  }
}
