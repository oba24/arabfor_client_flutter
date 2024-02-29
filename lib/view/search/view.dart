import 'dart:async';

import 'package:easy_localization/easy_localization.dart' as lang;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screen_scaling/flutter_screen_scaling.dart';
import 'package:kiwi/kiwi.dart';
import 'package:saudimarchclient/helper/extintions.dart';
import 'package:saudimarchclient/helper/failed_widget.dart';
import 'package:saudimarchclient/helper/loading_app.dart';
import 'package:saudimarchclient/helper/user_data.dart';

import '../../gen/assets.gen.dart';
import '../../generated/locale_keys.g.dart';
import '../../helper/asset_image.dart';
import '../common_cards/product_card.dart';
import 'bloc/bloc.dart';
import 'bloc/events.dart';
import 'bloc/states.dart';
import 'get_search_keys_bloc/bloc.dart';
import 'get_search_keys_bloc/events.dart';
import 'get_search_keys_bloc/states.dart';

class SearchView extends StatefulWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  TextEditingController searchController = TextEditingController(text: '');
  SearchBloc searchBloc = KiwiContainer().resolve<SearchBloc>();
  SearchKeysBloc searchKeysBloc = KiwiContainer().resolve<SearchKeysBloc>();
  Timer? timer;
  String? last;
  @override
  void dispose() {
    searchBloc.close();
    searchKeysBloc.close();
    super.dispose();
  }

  @override
  void initState() {
    if (UserHelper.isAuth) {
      searchKeysBloc.add(StartSearchKeysEvent());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.color.primaryContainer,
      appBar: AppBar(
        title: Text(LocaleKeys.search.tr(), style: context.textTheme.headline2),
        centerTitle: true,
        elevation: 0,
        backgroundColor: context.color.primaryContainer,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(
              height: 40.h,
              child: TextFormField(
                controller: searchController,
                onChanged: (v) {
                  if (v.trim() != '') {
                    if (timer != null && timer!.isActive) timer!.cancel();
                    timer = Timer(700.milliseconds, () {
                      if (searchController.text != last) {
                        searchBloc.add(StartSearchEvent(searchController.text));
                        last = searchController.text;
                      }
                    });
                  }
                },
                decoration: InputDecoration.collapsed(
                  hintText: LocaleKeys.search_here.tr(),
                ).copyWith(
                  contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5),
                  suffixIcon: SizedBox(width: 18.w, child: CustomImage(Assets.images.iconSearch.path).onCenter),
                  fillColor: context.color.secondaryContainer,
                  filled: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: context.theme.colorScheme.primary, width: 2.h),
                    borderRadius: BorderRadius.circular(10.px),
                  ),
                ),
              ),
            ).paddingSymmetric(horizontal: 14.w, vertical: 20.h),
          ),
          BlocBuilder(
            bloc: searchKeysBloc,
            builder: (context, state) {
              if (state is DoneSearchKeysState) {
                return SliverToBoxAdapter(
                  child: state.model.data.isEmpty
                      ? const SizedBox.shrink()
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'نتائج البحث',
                                  style: context.textTheme.bodyMedium,
                                ).paddingSymmetric(horizontal: 14.w, vertical: 5.h),
                              ],
                            ),
                            Row(
                              children: [
                                Wrap(
                                  alignment: WrapAlignment.start,
                                  children: List.generate(
                                    state.model.data.length,
                                    (index) => Padding(
                                      padding: EdgeInsets.all(5.w),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(vertical: 10.w, horizontal: 30.w),
                                        decoration:
                                            BoxDecoration(border: Border.all(color: context.color.primary), borderRadius: BorderRadius.circular(10)),
                                        child: Text(state.model.data[index].key),
                                      ),
                                    ),
                                  ),
                                ).paddingSymmetric(horizontal: 14.w, vertical: 5.h),
                              ],
                            ),
                          ],
                        ),
                );
              } else {
                return const SliverToBoxAdapter(child: SizedBox.shrink());
              }
            },
          ),
          BlocBuilder(
            bloc: searchBloc,
            builder: (context, state) {
              if (state is LoadingSearchState) {
                return const SliverToBoxAdapter(child: LoadingApp());
              } else if (state is DoneSearchState) {
                return SliverPadding(
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
                              data: state.model.data[index],
                            ),
                        childCount: state.model.data.length),
                  ),
                );
              } else if (state is FaildSearchState) {
                return SliverToBoxAdapter(
                  child: FailedWidget(
                    statusCode: state.statusCode,
                    errType: state.errType,
                    title: state.msg,
                    onTap: () {
                      searchBloc.add(StartSearchEvent(searchController.text));
                    },
                  ).paddingOnly(top: 70.h),
                );
              } else {
                return const SliverToBoxAdapter(child: SizedBox.shrink());
              }
            },
          ),
        ],
      ),
    );
  }
}
