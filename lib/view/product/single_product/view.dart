import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screen_scaling/flutter_screen_scaling.dart';
import 'package:kiwi/kiwi.dart';
import 'package:saudimarchclient/common/alert.dart';
import 'package:saudimarchclient/common/btn.dart';
import 'package:saudimarchclient/helper/failed_widget.dart';
import 'package:saudimarchclient/helper/flash_helper.dart';
import 'package:saudimarchclient/helper/loading_app.dart';
import 'package:saudimarchclient/helper/theme.dart';
import 'package:saudimarchclient/models/product_data.dart';
import 'package:saudimarchclient/view/cart/bloc/bloc.dart';
import 'package:saudimarchclient/view/cart/bloc/events.dart';
import 'package:saudimarchclient/view/cart/bloc/states.dart';
import 'package:saudimarchclient/view/common_cards/product_menu_card.dart';
import 'package:saudimarchclient/view/nav_bar/view.dart';
import 'package:saudimarchclient/view/product/single_product/Bloc/bloc.dart';
import '../../../gen/assets.gen.dart';
import '../../../helper/asset_image.dart';
import '../../../helper/extintions.dart';
import '../../../common/stare_bar.dart';
import '../../../generated/locale_keys.g.dart';
import '../../../helper/rout.dart';
import '../../create_rate/view.dart';
import '../../favorit/bloc/bloc.dart';
import '../../favorit/bloc/events.dart';
import '../../favorit/bloc/states.dart';
import '../../store_detail/view.dart';
import 'Bloc/events.dart';
import 'Bloc/states.dart';

class SingleProductView extends StatefulWidget {
  final dynamic id;
  final Function? onFavorite;
  const SingleProductView({Key? key, required this.id, this.onFavorite}) : super(key: key);

  @override
  State<SingleProductView> createState() => _SingleProductViewState();
}

class _SingleProductViewState extends State<SingleProductView> with TickerProviderStateMixin {
  PageController controller = PageController();
  ProductDetailBloc productDetailBloc = KiwiContainer().resolve<ProductDetailBloc>();
  CartBloc cartBloc = KiwiContainer().resolve<CartBloc>();
  ColorDatum colorDatum = ColorDatum.fromJson({});
  SizeDatum sizeDatum = SizeDatum.fromJson({});
  final _favoriteBloc = KiwiContainer().resolve<FavoriteBloc>();
  Timer? _timer;
  @override
  void initState() {
    productDetailBloc.add(StartProductDetailEvent(widget.id));

    super.initState();
  }

  int _selTaps = 0;
  int productQuantity = 1;
  @override
  void dispose() {
    if (_timer != null && _timer!.isActive) _timer!.cancel();
    productDetailBloc.close();
    cartBloc.close();
    controller.dispose();
    _favoriteBloc.close();
    super.dispose();
  }

  _submit(dynamic providerId) {
    if (colorDatum.id == 0) {
      FlashHelper.errorBar(message: LocaleKeys.choose_color.tr());
    } else if (sizeDatum.id == 0) {
      FlashHelper.errorBar(message: LocaleKeys.choose_size.tr());
    } else {
      cartBloc.add(StartControllerCartEvent(
        id: widget.id,
        type: 'add',
        colorId: colorDatum.id,
        sizeId: sizeDatum.id,
        providerId: providerId,
        quantity: productQuantity,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: "#FBF9F4".toColor,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: BlocBuilder(
        bloc: productDetailBloc,
        builder: (context, state) {
          if (state is DoneProductDetailState) {
            return BlocConsumer(
              bloc: cartBloc,
              listener: (context, cartState) {
                if (cartState is DoneControllerCartState) {
                  CustomAlert.succAlert(
                    LocaleKeys.product_added_to_cart.tr(),
                    Row(
                      children: [
                        Expanded(
                          child: Btn(
                            text: LocaleKeys.confirm_order.tr(),
                            onTap: () => push(const NavBarView(page: 2)),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Btn(
                            text: LocaleKeys.continue_shopping.tr(),
                            color: Colors.white,
                            border: Border.all(color: StylesApp.secondary),
                            textColor: StylesApp.secondary,
                            onTap: () => Navigator.pop(context),
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (cartState is FaildCartState) {
                  FlashHelper.errorBar(message: cartState.msg);
                }
              },
              builder: (context, cartState) {
                if (cartState is LoadingCartState) {
                  return Container(
                    width: context.w,
                    height: 70.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(borderRadius: const BorderRadius.vertical(top: Radius.circular(25.0)), color: context.color.secondary),
                    child: const Center(child: LoadingApp()),
                  );
                } else {
                  return InkWell(
                    onTap: () {
                      if (state.model.data.isAvilable) {
                        _submit(state.model.data.user.id);
                      } else {
                        FlashHelper.infoBar(message: LocaleKeys.this_product_is_not_avilable_now.tr());
                      }
                    },
                    child: Container(
                      width: context.w,
                      height: 70.h,
                      alignment: Alignment.center,
                      decoration:
                          BoxDecoration(borderRadius: const BorderRadius.vertical(top: Radius.circular(25.0)), color: context.color.secondary),
                      child: Text(
                        LocaleKeys.add_to_cart.tr(),
                        style: context.textTheme.bodyText2?.copyWith(fontSize: 20.0, color: Colors.white, height: 1),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
              },
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
      body: BlocConsumer(
        bloc: productDetailBloc,
        listener: (context, state) {
          if (state is DoneProductDetailState && state.model.data.productImage.length > 1) {
            _timer = Timer.periodic(10.seconds, (v) {
              if (controller.page != state.model.data.productImage.length - 1) {
                controller.nextPage(duration: 500.milliseconds, curve: Curves.easeInOutCubicEmphasized);
              } else {
                controller.animateToPage(0, duration: 500.milliseconds, curve: Curves.decelerate);
              }
            });
          }
        },
        builder: (context, state) {
          if (state is LoadingProductDetailState) {
            return const Center(child: LoadingApp());
          } else if (state is DoneProductDetailState) {
            var data = state.model.data;
            return SingleChildScrollView(
              child: Stack(
                children: [
                  SizedBox(
                    width: context.w,
                    height: 422.h,
                    child: PageView.builder(
                      controller: controller,
                      itemCount: data.productImage.length,
                      itemBuilder: (context, i) {
                        return CustomImage(data.productImage[i].url, fit: BoxFit.fill);
                      },
                    ),
                  ),
                  Container(
                    width: context.w,
                    height: 121.0.h,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: const Alignment(-0.04, -1.99),
                        end: const Alignment(-0.04, 0.78),
                        colors: [Colors.black, Colors.black.withOpacity(0.0)],
                      ),
                    ),
                  ),
                  SafeArea(
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                        ),
                        const Spacer(),
                        BlocConsumer(
                          bloc: _favoriteBloc,
                          listener: (context, state) {
                            if (state is DoneFavoriteControllerState) {
                              setState(() {
                                data.isFav = !data.isFav;
                              });
                              if (widget.onFavorite != null && !data.isFav) widget.onFavorite!();
                            } else if (state is FaildFavoriteState) {
                              FlashHelper.errorBar(message: state.msg);
                            }
                          },
                          builder: (context, state) {
                            if (state is LoadingFavoriteState) {
                              return IconButton(
                                onPressed: () {},
                                icon: CustomProgress(size: 20.w, color: context.color.secondary),
                              );
                            }
                            return IconButton(
                              onPressed: () {
                                _favoriteBloc.add(StartFavoriteControllerEvent(data.id));
                              },
                              icon: CustomImage(
                                data.isFav ? Assets.svg.isFavorite : Assets.svg.unfavorite,
                                color: data.isFav == false ? Colors.white : null,
                              ),
                            );
                          },
                        )
                        // IconButton(
                        //   onPressed: () {},
                        //   icon: CustomImage(
                        //     data.isFav ? Assets.svg.isFavorite : Assets.svg.unfavorite,
                        //     color: data.isFav == false ? Colors.white : null,
                        //   ),
                        // ),
                      ],
                    ),
                  ).paddingSymmetric(horizontal: 10.w),
                  // Group: Group 18923
                  if (data.discountPercentage > 0)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 35.h,
                          height: 35.h,
                          decoration: BoxDecoration(shape: BoxShape.circle, color: context.color.secondary),
                          child: Text(
                            "${data.discountPercentage}%\nOFF",
                            style: context.textTheme.subtitle1?.copyWith(color: Colors.white, height: 0.8, fontSize: 16),
                            textAlign: TextAlign.center,
                          ).onCenter,
                        ).paddingOnly(top: 281.h, left: 24.w, right: 24.w),
                      ],
                    ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 22.h),
                    width: context.w,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(50.0)),
                      color: Color(0xFFFBF9F4),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          data.name,
                          style: context.textTheme.headline2,
                        ),
                        CustomStarBar(rate: data.ratingValue, size: 20.px).paddingSymmetric(vertical: 4.h),
                        InkWell(
                          onTap: () {
                            push(StoreDetail(providerData: data.user, categoryData: data.category));
                          },
                          child: Text(
                            data.user.userName,
                            style: context.textTheme.subtitle1?.copyWith(
                              fontSize: 20.0,
                              color: context.color.secondary,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: data.mainPrice.toString(),
                                style: context.textTheme.headline3?.copyWith(
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              TextSpan(
                                text: "  ${LocaleKeys.SR.tr()}  ",
                                style: TextStyle(
                                  fontFamily: 'Somar',
                                  fontSize: 18.0,
                                  color: context.color.secondary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (data.priceAfterDicount != 0)
                                TextSpan(
                                  text: "${data.priceBeforeDicount}  ${LocaleKeys.SR.tr()}",
                                  style: context.textTheme.subtitle2?.copyWith(
                                      fontFamily: 'Somar',
                                      fontSize: 17.0,
                                      color: const Color(0xFF958A7E),
                                      fontWeight: FontWeight.w600,
                                      decoration: TextDecoration.lineThrough),
                                ),
                              const TextSpan(text: "\n"),
                              TextSpan(
                                text: LocaleKeys.Product_Code.tr(),
                                style: context.textTheme.subtitle1?.copyWith(
                                  fontSize: 18.0,
                                  color: const Color(0xFF958A7E),
                                  fontWeight: FontWeight.w600,
                                  height: 1.5,
                                ),
                              ),
                              TextSpan(
                                text: data.id.toString(),
                                style: context.textTheme.subtitle1?.copyWith(
                                  color: context.color.secondary,
                                  fontWeight: FontWeight.w600,
                                  height: 1.5,
                                ),
                              ),
                              const TextSpan(text: "         "),
                              TextSpan(
                                text: LocaleKeys.Quantity_available.tr(),
                                style: context.textTheme.subtitle1?.copyWith(
                                  fontSize: 18.0,
                                  color: const Color(0xFF958A7E),
                                  fontWeight: FontWeight.w600,
                                  height: 1.5,
                                ),
                              ),
                              TextSpan(
                                text: data.quantity.toString(),
                                style: context.textTheme.subtitle1?.copyWith(
                                  color: context.color.secondary,
                                  fontWeight: FontWeight.w600,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 35.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: List.generate(
                            2,
                            (i) => InkWell(
                              onTap: () => setState(() => _selTaps = i),
                              child: Text(
                                [LocaleKeys.about_product.tr(), LocaleKeys.Comments.tr()][i],
                                style: context.textTheme.bodyText2?.copyWith(
                                  fontSize: 18.0,
                                  height: 1.22,
                                  color: _selTaps == i ? context.color.secondary : context.color.tertiary,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            const Expanded(child: Divider(thickness: 2, color: Colors.white)),
                            Expanded(child: Divider(thickness: 2, color: _selTaps == 0 ? context.color.secondary : Colors.white)),
                            const Expanded(flex: 2, child: Divider(thickness: 2, color: Colors.white)),
                            Expanded(child: Divider(thickness: 2, color: _selTaps == 1 ? context.color.secondary : Colors.white)),
                            const Expanded(child: Divider(thickness: 2, color: Colors.white)),
                          ],
                        ),
                        if (_selTaps == 0)
                          Row(
                            children: [
                              Text(
                                data.desc,
                                style: context.textTheme.bodyText1,
                              ).paddingSymmetric(vertical: 12.h),
                            ],
                          ),
                        if (_selTaps == 0)
                          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                            InkWell(
                              onTap: () {
                                CustomAlert.selectOptionalSeetButton(
                                  title: LocaleKeys.Color.tr(),
                                  trailing: List.generate(
                                    data.allColors.length,
                                    (i) => Container(
                                      margin: EdgeInsetsDirectional.only(end: 8.w),
                                      height: 20.h,
                                      width: 20.h,
                                      decoration: BoxDecoration(color: data.allColors[i].hexValue.toColor, borderRadius: BorderRadius.circular(4)),
                                    ),
                                  ),
                                  items: data.allColors,
                                  onSubmit: (v) {
                                    setState(() {
                                      colorDatum = v;
                                    });
                                  },
                                  item: colorDatum,
                                );
                              },
                              child: Container(
                                width: 153.0.w,
                                height: 37.0.h,
                                padding: EdgeInsets.symmetric(horizontal: 12.w),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  border: Border.all(color: context.color.tertiary.withOpacity(0.5)),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      LocaleKeys.Color.tr(),
                                      style: context.textTheme.bodyText2?.copyWith(height: 1),
                                      textAlign: TextAlign.center,
                                    ),
                                    Container(
                                      margin: EdgeInsetsDirectional.only(end: 8.w),
                                      height: 20.h,
                                      width: 20.h,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(color: colorDatum.hexValue.toColor, borderRadius: BorderRadius.circular(4)),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                if (colorDatum.id != 0) {
                                  CustomAlert.selectOptionalSeetButton(
                                    title: LocaleKeys.size.tr(),
                                    trailing: List.generate(
                                      data.allSuzes(colorDatum.id).length,
                                      (i) => Container(
                                        margin: EdgeInsetsDirectional.only(end: 8.w),
                                        height: 20.h,
                                        width: 20.h,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(color: context.color.secondary, borderRadius: BorderRadius.circular(4)),
                                        child: Text(
                                          data.allSuzes(colorDatum.id)[i].abbreviation,
                                          style: context.textTheme.subtitle1?.copyWith(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    items: data.allSuzes(colorDatum.id),
                                    onSubmit: (v) {
                                      setState(() {
                                        sizeDatum = v;
                                      });
                                    },
                                    item: sizeDatum,
                                  );
                                }
                              },
                              child: Container(
                                width: 153.0.w,
                                height: 37.0.h,
                                padding: EdgeInsets.symmetric(horizontal: 12.w),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  border: Border.all(color: context.color.tertiary.withOpacity(0.5)),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      LocaleKeys.size.tr(),
                                      style: context.textTheme.bodyText2?.copyWith(height: 1),
                                      textAlign: TextAlign.center,
                                    ),
                                    Container(
                                      margin: EdgeInsetsDirectional.only(end: 8.w),
                                      height: 20.h,
                                      width: 20.h,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(color: context.color.secondary, borderRadius: BorderRadius.circular(4)),
                                      child: Text(
                                        sizeDatum.abbreviation,
                                        style: context.textTheme.subtitle1?.copyWith(color: Colors.white),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ]
                              //  List.generate(
                              //   2,
                              //   (index) =>
                              // ),
                              ),
                        if (_selTaps == 0)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    if (productQuantity >= data.quantity) {
                                      FlashHelper.errorBar(message: LocaleKeys.more_quantity_than_store.tr());
                                    } else {
                                      setState(() {
                                        productQuantity++;
                                      });
                                    }
                                  },
                                  icon: Icon(Icons.add, color: context.color.secondary)),
                              Container(
                                width: 50.w,
                                height: 40.w,
                                decoration: BoxDecoration(shape: BoxShape.circle, color: context.color.secondary),
                                child: Text(
                                  productQuantity.toString(),
                                  style: context.textTheme.bodyText2?.copyWith(color: Colors.white, fontSize: 24),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    if (productQuantity > 1) {
                                      setState(() {
                                        productQuantity--;
                                      });
                                    }
                                  },
                                  icon: Icon(Icons.remove, color: context.color.secondary)),
                            ],
                          ).paddingSymmetric(vertical: 18.h, horizontal: 12.w),
                        if (_selTaps == 1)
                          ...List.generate(
                            state.model.data.review.length,
                            (index) => Row(
                              children: [
                                CustomImage(
                                  state.model.data.review[index].client.imageUrl,
                                  width: 41.h,
                                  height: 41.h,
                                  fit: BoxFit.cover,
                                  borderRadius: BorderRadius.circular(1000),
                                ),
                                SizedBox(width: 20.w),
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          state.model.data.review[index].client.name,
                                          style: context.textTheme.bodyText1,
                                        ),
                                        CustomStarBar(
                                          size: 15.px,
                                          rate: int.parse(state.model.data.review[index].ratingValue.toString()),
                                        )
                                      ],
                                    ),
                                    Text(
                                      state.model.data.review[index].comment,
                                      style: context.textTheme.subtitle1,
                                    ),
                                  ],
                                ),
                              ],
                            ).paddingSymmetric(vertical: 8.h),
                          )..add(Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () {
                                    push(CreateRate(id: widget.id)).then((value) {
                                      setState(() {
                                        if (value != null) {
                                          state.model.data.ratingValue = value[0];
                                          state.model.data.review = value[1];
                                        }
                                      });
                                      setState(() {});
                                    });
                                  },
                                  child: Text(LocaleKeys.add_comment.tr()).paddingAll(10.h),
                                )
                              ],
                            )),
                        if (data.similerProduct.isNotEmpty)
                          Row(
                            children: [
                              Text(LocaleKeys.similar_products.tr(), style: context.textTheme.headline2).paddingOnly(bottom: 14.h),
                            ],
                          ),
                        ...List.generate(
                          data.similerProduct.length,
                          (index) => ProductMenuCard(data: data.similerProduct[index]),
                        )
                      ],
                    ),
                  ).paddingOnly(top: 328.h, bottom: 80.h),
                ],
              ),
            );
          } else if (state is FaildProductDetailState) {
            return FailedWidget(
              statusCode: state.statusCode,
              onTap: () {
                productDetailBloc.add(StartProductDetailEvent(widget.id));
              },
              errType: state.errType,
              title: state.msg,
            );
          } else {
            return const Center(child: LoadingApp());
          }
        },
      ),
    );
  }
}
