import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screen_scaling/flutter_screen_scaling.dart';
import 'package:kiwi/kiwi.dart';
import 'package:saudimarchclient/helper/extintions.dart';
import 'package:saudimarchclient/helper/flash_helper.dart';
import 'package:saudimarchclient/helper/loading_app.dart';
import 'package:saudimarchclient/helper/rout.dart';
import 'package:saudimarchclient/models/product_data.dart';
import 'package:saudimarchclient/view/favorit/bloc/events.dart';
import 'package:saudimarchclient/view/favorit/bloc/states.dart';
import 'package:saudimarchclient/view/product/single_product/view.dart';

import '../../gen/assets.gen.dart';
import '../../generated/locale_keys.g.dart';
import '../../helper/asset_image.dart';
import '../favorit/bloc/bloc.dart';

class ProductCard extends StatefulWidget {
  final ProductData data;
  final Function? onFavorite;
  const ProductCard({Key? key, required this.data, this.onFavorite}) : super(key: key);

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  final _favoriteBloc = KiwiContainer().resolve<FavoriteBloc>();
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => push(SingleProductView(id: widget.data.id)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              CustomImage(
                widget.data.mainImage.url,
                height: 240.h,
                borderRadius: BorderRadius.circular(10),
              ).onCenter,
              widget.data.discountPercentage > 0
                  ? Align(
                      alignment: AlignmentDirectional.topEnd,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.w).copyWith(bottom: 2.h),
                            decoration: BoxDecoration(
                              color: context.color.secondary,
                              borderRadius: const BorderRadiusDirectional.only(
                                topEnd: Radius.circular(10),
                                // bottomEnd: Radius.circular(10),
                                topStart: Radius.circular(10),
                                bottomStart: Radius.circular(10),
                              ),
                            ),
                            child: Text.rich(
                              TextSpan(
                                style: context.textTheme.bodyText1?.copyWith(
                                  fontSize: 12,
                                  color: Colors.white,
                                  height: 1.5.h,
                                ),
                                children: [
                                  TextSpan(
                                    text: widget.data.discountPercentage.toString(),
                                    style: context.textTheme.bodyText1?.copyWith(fontWeight: FontWeight.w700, color: Colors.white, fontSize: 12),
                                  ),
                                  TextSpan(text: ' ${LocaleKeys.Off.tr()}'),
                                ],
                              ),
                            ),
                          ),
                          // Container(
                          //   height: 40.h,
                          //   width: 40.h,
                          //   decoration: BoxDecoration(shape: BoxShape.circle, color: context.color.secondary),
                          //   child: CustomImage(Assets.svg.gift).onCenter,
                          // ).paddingOnly(top: 23.h)
                        ],
                      ),
                    )
                  : const SizedBox.shrink()
            ],
          ),
          const Expanded(child: SizedBox.shrink()),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: widget.data.name,
                  style: context.textTheme.headline5,
                ),
                const TextSpan(text: "\n"),
                TextSpan(
                  text: widget.data.category.name,
                  style: context.textTheme.bodyText1?.copyWith(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w300,
                    height: 1.25,
                    color: context.color.tertiary,
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: widget.data.mainPrice.toString(),
                      style: context.textTheme.bodyText2?.copyWith(fontSize: 14.0),
                    ),
                    TextSpan(
                      text: " ${LocaleKeys.SR.tr()}  ",
                      style: context.textTheme.bodyText2?.copyWith(fontSize: 10.0),
                    ),
                    if (widget.data.priceAfterDicount != 0)
                      TextSpan(
                        text: widget.data.priceBeforeDicount.toString(),
                        style: context.textTheme.bodyText2?.copyWith(
                          fontSize: 14.0,
                          decoration: TextDecoration.lineThrough,
                          color: context.color.tertiary,
                        ),
                      ),
                    if (widget.data.priceAfterDicount != 0)
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
              ),
              BlocConsumer(
                bloc: _favoriteBloc,
                listener: (context, state) {
                  if (state is DoneFavoriteControllerState) {
                    setState(() {
                      widget.data.isFav = !widget.data.isFav;
                    });
                    if (widget.onFavorite != null && !widget.data.isFav) widget.onFavorite!();
                  } else if (state is FaildFavoriteState) {
                    FlashHelper.errorBar(message: state.msg);
                  }
                },
                builder: (context, state) {
                  if (state is LoadingFavoriteState) return CustomProgress(size: 20.w, color: context.color.secondary);
                  return InkWell(
                    onTap: () => _favoriteBloc.add(StartFavoriteControllerEvent(widget.data.id)),
                    child: CustomImage(widget.data.isFav ? Assets.svg.isFavorite : Assets.svg.unfavorite, width: 20.w),
                  );
                },
              )
            ],
          )
        ],
      ),
    );
  }
}
