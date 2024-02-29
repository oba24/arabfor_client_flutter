import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screen_scaling/flutter_screen_scaling.dart';
import 'package:kiwi/kiwi.dart';
import 'package:saudimarchclient/helper/extintions.dart';

import '../../gen/assets.gen.dart';
import '../../generated/locale_keys.g.dart';
import '../../helper/asset_image.dart';
import '../../helper/failed_widget.dart';
import '../../helper/loading_app.dart';
import '../common_cards/product_card.dart';
import 'bloc/bloc.dart';
import 'bloc/events.dart';
import 'bloc/states.dart';

class Offers extends StatefulWidget {
  const Offers({Key? key}) : super(key: key);

  @override
  State<Offers> createState() => _OffersState();
}

class _OffersState extends State<Offers> {
  final _bloc = KiwiContainer().resolve<OffersBloc>();
  @override
  void initState() {
    super.initState();
    _bloc.add(StartOffersEvent());
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.color.secondaryContainer,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: context.color.secondaryContainer,
        title: Text(
          LocaleKeys.offers.tr(),
          style: context.textTheme.headline2,
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
      ),
      body: BlocBuilder(
          bloc: _bloc,
          builder: (context, state) {
            if (state is LoadingOffersState) {
              return LoadingApp(height: 100.h);
            } else if (state is FaildOffersState) {
              return FailedWidget(
                statusCode: state.statusCode,
                errType: state.errType,
                title: state.msg,
                onTap: () => _bloc.add(StartOffersEvent()),
              );
            } else if (state is DoneOffersState) {
              if (state.data.isEmpty) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomImage(Assets.svg.offerIcon, height: 150.h, color: context.color.secondary.withOpacity(0.2)).onCenter,
                    Text(
                      LocaleKeys.no_product_category.tr(),
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
                  // onFavorite: () {
                  //   setState(() {
                  //     state.data.removeAt(index);
                  //   });
                  // },
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
