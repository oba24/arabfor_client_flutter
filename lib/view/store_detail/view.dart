
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screen_scaling/flutter_screen_scaling.dart';
import 'package:kiwi/kiwi.dart';
import 'package:saudimarchclient/helper/extintions.dart';
import 'package:saudimarchclient/helper/failed_widget.dart';
import 'package:saudimarchclient/helper/loading_app.dart';

import '../../gen/assets.gen.dart';
import '../../helper/asset_image.dart';
import '../../helper/rout.dart';
import '../../models/product_data.dart';
import '../common_cards/product_card.dart';
import '../filter/view.dart';
import 'bloc/bloc.dart';
import 'bloc/events.dart';
import 'bloc/states.dart';

class StoreDetail extends StatefulWidget {
  final ProviderData providerData;
  final CategoryData categoryData;
  const StoreDetail({Key? key, required this.providerData, required this.categoryData}) : super(key: key);

  @override
  State<StoreDetail> createState() => _StoreDetailState();
}

class _StoreDetailState extends State<StoreDetail> {
  StoreDetailBloc storeDetailBloc = KiwiContainer().resolve<StoreDetailBloc>();
  @override
  void initState() {
    storeDetailBloc.add(StartStoreDetailEvent(widget.providerData.id));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.color.primaryContainer,
      appBar: AppBar(
        title: Text(widget.providerData.userName, style: context.textTheme.headline2),
        centerTitle: true,
        elevation: 0,
        backgroundColor: context.color.primaryContainer,
        actions: [
          // widget.filterData == null
          //     ?
          IconButton(
            onPressed: () {
              push(FilterView(
                type: '',
                categoryData: widget.categoryData,
              ));
            },
            icon: CustomImage(
              Assets.svg.filtterIcon,
              color: context.color.secondary,
            ),
          )
          // : const SizedBox.shrink(),
        ],
      ),
      body: BlocBuilder(
        bloc: storeDetailBloc,
        builder: (context, state) {
          if (state is LoadingStoreDetailState) {
            return const LoadingApp().onCenter;
          } else if (state is FaildStoreDetailState) {
            return FailedWidget(
                statusCode: state.statusCode,
                errType: state.errType,
                title: state.msg,
                onTap: () {
                  storeDetailBloc.add(StartStoreDetailEvent(widget.providerData.id));
                }).onCenter;
          } else if (state is DoneStoreDetailState) {
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Center(
                    child: CustomImage(
                      state.model.data.image,
                      height: 100.h,
                      width: 100.h,
                      fit: BoxFit.fill,
                      borderRadius: BorderRadius.circular(50.h),
                    ),
                  ).paddingAll(20.h),
                ),
                SliverToBoxAdapter(
                  child: Text(
                    state.model.data.desc,
                    style: context.textTheme.bodyText2!.copyWith(fontSize: 18, color: context.color.tertiary),
                  ).onCenter,
                ),
                SliverToBoxAdapter(child: SizedBox(height: 20.h)),
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: context.w / 2,
                      mainAxisSpacing: 25.h,
                      crossAxisSpacing: 16.w,
                      childAspectRatio: 164.w / 317.14.h,
                    ),
                    delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) => ProductCard(
                              data: state.model.data.products[index],
                            ),
                        childCount: state.model.data.products.length),
                  ),
                ),
              ],
            );
          } else {
            return const LoadingApp().onCenter;
          }
        },
      ),
    );
  }
}
