import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screen_scaling/flutter_screen_scaling.dart';
import 'package:kiwi/kiwi.dart';
import 'package:saudimarchclient/gen/assets.gen.dart';
import 'package:saudimarchclient/helper/asset_image.dart';
import 'package:saudimarchclient/helper/extintions.dart';
import 'package:saudimarchclient/models/product_data.dart';
import 'package:saudimarchclient/view/favorit/bloc/events.dart';

import '../../generated/locale_keys.g.dart';
import '../../helper/failed_widget.dart';
import '../../helper/loading_app.dart';
import '../common_cards/product_card.dart';
import 'bloc/bloc.dart';
import 'bloc/states.dart';

class FavoriteView extends StatefulWidget {
  const FavoriteView({Key? key}) : super(key: key);

  @override
  State<FavoriteView> createState() => _FavoriteViewState();
}

class _FavoriteViewState extends State<FavoriteView> {
  final _bloc = KiwiContainer().resolve<FavoriteBloc>();
  @override
  void initState() {
    super.initState();
    _bloc.add(StartFavoriteEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: "#FBF9F4".toColor,
      appBar: AppBar(
        backgroundColor: "#FBF9F4".toColor,
        centerTitle: true,
        title: Text(
          LocaleKeys.Favorite.tr(),
          style: context.textTheme.headline2,
          textAlign: TextAlign.center,
        ),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_rounded),
          color: context.color.secondary,
        ),
      ),
      body: BlocBuilder(
          bloc: _bloc,
          builder: (context, state) {
            if (state is LoadingFavoriteState) {
              return LoadingApp(height: 100.h);
            } else if (state is FaildFavoriteState) {
              return FailedWidget(
                statusCode: state.statusCode,
                errType: state.errType,
                title: state.msg,
                onTap: () => _bloc.add(StartFavoriteEvent()),
              );
            } else if (state is DoneFavoriteState) {
              if (state.data.isEmpty) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomImage(Assets.svg.isFavorite, height: 150.h, color: context.color.secondary.withOpacity(0.2)).onCenter,
                    Text(
                      LocaleKeys.there_are_no_elements_in_the_favorite.tr(),
                      style: context.textTheme.subtitle1?.copyWith(color: context.color.secondary.withOpacity(0.4)),
                    ).paddingSymmetric(vertical: 12.h)
                  ],
                );
              }
              return GridView.builder(
                padding: EdgeInsets.only(top: 20.h),
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: context.w / 2,
                  mainAxisSpacing: 25.h,
                  crossAxisSpacing: 16.w,
                  childAspectRatio: 164.w / 317.14.h,
                ),
                itemBuilder: (BuildContext context, int index) => ProductCard(
                  data: state.data[index],
                  onFavorite: () {
                    setState(() {
                      state.data.removeAt(index);
                    });
                  },
                ),
                itemCount: state.data.length,
              ).paddingSymmetric(horizontal: 16.w);
            } else {
              return const SizedBox();
            }
          }),
    );
  }
}
