import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screen_scaling/flutter_screen_scaling.dart';
import 'package:kiwi/kiwi.dart';
import 'package:saudimarchclient/helper/extintions.dart';
import 'package:saudimarchclient/helper/flash_helper.dart';
import 'package:saudimarchclient/helper/loading_app.dart';
import 'package:saudimarchclient/helper/rout.dart';
import 'package:saudimarchclient/view/favorit/bloc/events.dart';
import 'package:saudimarchclient/view/favorit/bloc/states.dart';
import 'package:saudimarchclient/view/product/single_product/view.dart';

import '../../gen/assets.gen.dart';
import '../../generated/locale_keys.g.dart';
import '../../helper/asset_image.dart';
import '../../models/product_data.dart';
import '../favorit/bloc/bloc.dart';

class ProductMenuCard extends StatefulWidget {
  final ProductData data;
  const ProductMenuCard({Key? key, required this.data}) : super(key: key);

  @override
  State<ProductMenuCard> createState() => _ProductMenuCardState();
}

class _ProductMenuCardState extends State<ProductMenuCard> {
  final _favoriteBloc = KiwiContainer().resolve<FavoriteBloc>();
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => push(SingleProductView(id: widget.data.id)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomImage(
            widget.data.mainImage.url,
            height: 108.h,
            width: 112.w,
            borderRadius: BorderRadius.circular(10),
          ),
          SizedBox(width: 14.w),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(text: widget.data.name, style: context.textTheme.headline5?.copyWith(height: 1.8.h)),
                const TextSpan(text: '\n'),
                TextSpan(
                  text: widget.data.category.name,
                  style: context.textTheme.subtitle2?.copyWith(
                    fontSize: 16.0,
                    decoration: TextDecoration.underline,
                    height: 1.8.h,
                    color: context.color.secondary,
                  ),
                ),
                const TextSpan(text: '\n'),
                TextSpan(
                  text: widget.data.priceBeforeDicount.toString(),
                  style: context.textTheme.bodyText2?.copyWith(fontSize: 20),
                ),
                TextSpan(
                  text: " ${LocaleKeys.SR.tr()}  ",
                  style: context.textTheme.bodyText2?.copyWith(fontSize: 14),
                ),
                if (widget.data.priceAfterDicount != 0)
                  TextSpan(
                    text: widget.data.priceAfterDicount.toString(),
                    style: context.textTheme.bodyText2?.copyWith(
                      fontSize: 13.0,
                      decoration: TextDecoration.lineThrough,
                      color: context.color.tertiary,
                    ),
                  ),
                if (widget.data.priceAfterDicount != 0)
                  TextSpan(
                    text: " ${LocaleKeys.SR.tr()}",
                    style: context.textTheme.bodyText2?.copyWith(
                      fontSize: 9.0,
                      decoration: TextDecoration.lineThrough,
                      color: context.color.tertiary,
                    ),
                  ),
              ],
            ),
          ),
          const Expanded(child: SizedBox.shrink()),
          BlocConsumer(
            bloc: _favoriteBloc,
            builder: (context, state) {
              if (state is LoadingFavoriteState) return CustomProgress(size: 25.h, color: context.color.secondary);
              return InkWell(
                onTap: () => _favoriteBloc.add(StartFavoriteControllerEvent(widget.data.id)),
                child: CustomImage(
                  widget.data.isFav ? Assets.svg.isFavorite : Assets.svg.unfavorite,
                  color: context.color.secondary,
                ),
              );
            },
            listener: (context, state) {
              if (state is DoneFavoriteControllerState) {
                setState(() {
                  widget.data.isFav = !widget.data.isFav;
                });
              } else if (state is FaildFavoriteState) {
                FlashHelper.errorBar(message: state.msg);
              }
            },
          ),
        ],
      ).paddingSymmetric(vertical: 6.h),
    );
  }
}
