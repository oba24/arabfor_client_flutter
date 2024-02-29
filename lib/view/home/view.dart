import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screen_scaling/flutter_screen_scaling.dart';
import 'package:kiwi/kiwi.dart';
import 'package:saudimarchclient/view/competition/competition_view.dart';
import '../../gen/assets.gen.dart';
import '../../generated/locale_keys.g.dart';
import '../../helper/asset_image.dart';
import '../../helper/extintions.dart';
import '../../helper/failed_widget.dart';
import '../../helper/loading_app.dart';
import '../../helper/rout.dart';
import '../../models/product_data.dart';
import '../common_cards/product_card.dart';
import '../notification/view.dart';
import '../product/products/view.dart';
import '../search/view.dart';
import 'Bloc/bloc.dart';
import 'Bloc/events.dart';
import 'Bloc/states.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  HomeBloc homeBloc = KiwiContainer().resolve<HomeBloc>();
  @override
  void initState() {
    homeBloc.add(StartHomeEvent());
    super.initState();
  }

  @override
  void dispose() {
    homeBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.colorScheme.primaryContainer,
      floatingActionButton: FloatingActionButton(
        onPressed: () => push(const CompetitionView()),
        child: CustomIconImg(
          Assets.svg.gift,
          color: "#FFC400".toColor,
        ),
      ),
      appBar: AppBar(
        backgroundColor: context.theme.colorScheme.primaryContainer,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              push(const NotificationView());
            },
            icon: CustomIconImg(
              Assets.svg.iconAlert,
              color: context.color.secondary,
            ),
          ),
        ],
        leading: BlocBuilder(
          bloc: homeBloc,
          builder: (context, state) {
            if (state is DoneHomeState) {
              return IconButton(
                onPressed: () {
                  showCustomBottomSheet(context: context, cat: state.model.data.mainCategory);
                },
                icon: CustomIconImg(
                  Assets.svg.categoryIcon,
                  color: context.color.secondary,
                ),
              );
            } else {
              return IconButton(
                onPressed: () {},
                icon: CustomIconImg(
                  Assets.svg.categoryIcon,
                  color: context.color.secondary,
                ),
              );
            }
          },
        ),
        title: CustomImage(Assets.svg.homeLogo),
        bottom: PreferredSize(
          child: SizedBox(
            height: 40.h,
            child: InkWell(
              onTap: () {
                push(const SearchView());
              },
              child: TextFormField(
                enabled: false,
                decoration: const InputDecoration.collapsed(
                  hintText: '',
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
            ),
          ).paddingSymmetric(horizontal: 14.w),
          preferredSize: const Size.fromHeight(0),
        ),
        toolbarHeight: 100.h,
      ),
      body: BlocBuilder(
        bloc: homeBloc,
        builder: (context, state) {
          if (state is LoadingHomeState) {
            return const Center(child: LoadingApp());
          } else if (state is DoneHomeState) {
            return CustomScrollView(
              slivers: [
                if (state.model.data.sliderHeader.isNotEmpty)
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 174.h,
                      child: PageView.builder(
                        itemCount: state.model.data.sliderHeader.length,
                        itemBuilder: (context, i) {
                          return Container(
                            height: 174.h,
                            color: context.color.secondary.withOpacity(i / 10),
                            width: context.w,
                            child: CustomImage(state.model.data.sliderHeader[i].image),
                          );
                        },
                      ),
                    ),
                  ),
                if (state.model.data.mainCategory.isNotEmpty)
                  SliverToBoxAdapter(
                    child: Container(
                      height: 183.h,
                      margin: EdgeInsets.symmetric(vertical: 17.h),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () => push(ProductsView(
                                id: state.model.data.mainCategory[0].id,
                                title: state.model.data.mainCategory[0].name,
                                type: '',
                                categoryData: state.model.data.mainCategory[0],
                              )),
                              child: Container(
                                width: 188.h,
                                height: 183.h,
                                padding: EdgeInsets.all(14.h),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: const Color(0xFFF7F5EF),
                                  border: Border.all(width: 1.0, color: context.color.secondaryContainer),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(child: CustomImage(state.model.data.mainCategory[0].categoryImage, fit: BoxFit.contain)),
                                    Text(
                                      state.model.data.mainCategory[0].name,
                                      style: context.textTheme.headline6!.copyWith(
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.w700,
                                        height: 1.35,
                                      ),
                                      maxLines: 1,
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.symmetric(horizontal: 10.w),
                              scrollDirection: Axis.horizontal,
                              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 183.h / 2,
                                mainAxisSpacing: 10.0.h,
                                crossAxisSpacing: 10.0.h,
                                childAspectRatio: 87.h / 103.w,
                              ),
                              itemCount: state.model.data.mainCategory.length - 1,
                              itemBuilder: (context, index) {
                                int i = index + 1;
                                return InkWell(
                                  onTap: () => push(ProductsView(
                                    id: state.model.data.mainCategory[i].id,
                                    title: state.model.data.mainCategory[i].name,
                                    type: '',
                                    categoryData: state.model.data.mainCategory[i],
                                  )),
                                  child: Container(
                                    padding: EdgeInsets.all(8.h),
                                    decoration: BoxDecoration(
                                      color: context.color.secondaryContainer,
                                      borderRadius: BorderRadius.circular(10.px),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Expanded(child: CustomImage(state.model.data.mainCategory[i].categoryImage, fit: BoxFit.contain)),
                                        Text(
                                          state.model.data.mainCategory[i].name,
                                          style: context.textTheme.headline6!.copyWith(
                                            fontSize: 17.0,
                                            fontWeight: FontWeight.w700,
                                            height: 1.35,
                                          ),
                                          maxLines: 1,
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                if (state.model.data.newerProductAdditions.isNotEmpty)
                  SliverToBoxAdapter(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(LocaleKeys.the_latest_additions.tr(), style: context.textTheme.headline2),
                        InkWell(
                          onTap: () => push(ProductsView(type: 'latest_added', id: 0, title: LocaleKeys.the_latest_additions.tr())),
                          child: Text(LocaleKeys.show_all.tr(), style: context.textTheme.headline3),
                        ),
                      ],
                    ).paddingSymmetric(horizontal: 16.w),
                  ),
                if (state.model.data.newerProductAdditions.isNotEmpty)
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
                                data: state.model.data.newerProductAdditions[index],
                              ),
                          childCount: state.model.data.newerProductAdditions.length),
                    ),
                  ),
                if (state.model.data.sliderBody.isNotEmpty)
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 174.h,
                      child: PageView.builder(
                        itemCount: state.model.data.sliderBody.length,
                        itemBuilder: (context, i) {
                          return Container(
                            height: 174.h,
                            color: context.color.secondary.withOpacity(i / 10),
                            width: context.w,
                            child: CustomImage(state.model.data.sliderBody[i].image),
                          );
                        },
                      ),
                    ).paddingOnly(top: 5.h, bottom: 5.h),
                  ),
                if (state.model.data.bestSeller.isNotEmpty)
                  SliverToBoxAdapter(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(LocaleKeys.best_selling.tr(), style: context.textTheme.headline2),
                        InkWell(
                          onTap: () => push(ProductsView(id: 0, type: 'best_seller', title: LocaleKeys.best_selling.tr())),
                          child: Text(LocaleKeys.show_all.tr(), style: context.textTheme.headline3),
                        ),
                      ],
                    ).paddingSymmetric(horizontal: 16.w),
                  ),
                if (state.model.data.bestSeller.isNotEmpty)
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
                                data: state.model.data.bestSeller[index],
                              ),
                          childCount: state.model.data.bestSeller.length),
                    ),
                  ),
                SliverToBoxAdapter(child: SizedBox(height: 20.h))
              ],
            );
          } else if (state is FaildHomeState) {
            return FailedWidget(
              statusCode: state.statusCode,
              onTap: () {
                homeBloc.add(StartHomeEvent());
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

  void showCustomBottomSheet({required BuildContext context, required List<CategoryData> cat}) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30.px))),
      isScrollControlled: true,
      context: context,
      builder: (BuildContext bc) {
        return Container(
          decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(70))),
          // padding: EdgeInsets.all(10),
          height: MediaQuery.of(context).size.height * .8,
          width: double.infinity,
          child: cat.isEmpty
              ? Text(
                  'No category available',
                  style: context.textTheme.headline3,
                ).onCenter
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(
                        LocaleKeys.main_category.tr(),
                        style: context.textTheme.headline3,
                      ).paddingOnly(
                        top: 15.h,
                        bottom: 25.h,
                      ),
                      Wrap(
                        children: List.generate(
                          cat.length,
                          (index) => InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              push(ProductsView(
                                id: cat[index].id,
                                title: cat[index].name,
                                type: '',
                                categoryData: cat[index],
                              ));
                            },
                            child: Container(
                              height: 90.h,
                              width: 110.w,
                              padding: EdgeInsets.all(8.h),
                              decoration: BoxDecoration(
                                color: context.color.secondaryContainer,
                                borderRadius: BorderRadius.circular(10.px),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(child: CustomImage(cat[index].categoryImage, fit: BoxFit.contain)),
                                  Text(
                                    cat[index].name,
                                    style: context.textTheme.headline6!.copyWith(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w700,
                                      height: 1.35,
                                    ),
                                    maxLines: 1,
                                  ),
                                ],
                              ),
                            ),
                          ).paddingAll(5.w),
                        ),
                      ).onCenter,
                    ],
                  ),
                ),
        );
      },
    );
  }
}
