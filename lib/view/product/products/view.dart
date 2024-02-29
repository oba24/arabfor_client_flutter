import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screen_scaling/flutter_screen_scaling.dart';
import 'package:kiwi/kiwi.dart';
import 'package:saudimarchclient/gen/assets.gen.dart';
import 'package:saudimarchclient/generated/locale_keys.g.dart';
import 'package:saudimarchclient/helper/asset_image.dart';
import 'package:saudimarchclient/helper/extintions.dart';
import 'package:saudimarchclient/helper/failed_widget.dart';
import 'package:saudimarchclient/helper/loading_app.dart';
import 'package:easy_localization/easy_localization.dart' as lang;
import 'package:saudimarchclient/helper/rout.dart';

import '../../../models/product_data.dart';
import '../../common_cards/product_card.dart';
import '../../filter/view.dart';
import 'bloc/bloc.dart';
import 'bloc/events.dart';
import 'bloc/states.dart';

class ProductsView extends StatefulWidget {
  final String title;
  final bool isCategory;
  final int id;
  final String type;
  final CategoryData? categoryData;
  final FilterData? filterData;
  const ProductsView(
      {Key? key, required this.title, this.isCategory = false, required this.id, required this.type, this.categoryData, this.filterData})
      : super(key: key);

  @override
  State<ProductsView> createState() => _ProductsViewState();
}

class _ProductsViewState extends State<ProductsView> {
  CategoryProductsBloc productsBloc = KiwiContainer().resolve<CategoryProductsBloc>();
  CategoryProductsBloc categoryBloc = KiwiContainer().resolve<CategoryProductsBloc>();

  @override
  void initState() {
    super.initState();
    productsBloc.add(StartCategoryProductsEvent(id: widget.id, type: widget.type, filterData: widget.filterData));
    if (widget.filterData == null) {
      categoryBloc.add(StartCategoryProductsEvent(id: widget.id, type: widget.type));
    }
  }

  @override
  void dispose() {
    productsBloc.close();
    categoryBloc.close();
    super.dispose();
  }

  int selCategoryId = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.colorScheme.primaryContainer,
      appBar: AppBar(
        backgroundColor: context.theme.colorScheme.primaryContainer,
        elevation: 0,
        title: Text(widget.title, style: context.textTheme.headline2),
        centerTitle: true,
        actions: [
          widget.filterData == null
              ? IconButton(
                  onPressed: () {
                    push(FilterView(
                      type: widget.type,
                      categoryData: widget.categoryData,
                    ));
                  },
                  icon: CustomImage(
                    Assets.svg.filtterIcon,
                    color: context.color.secondary,
                  ),
                )
              : const SizedBox.shrink(),
        ],
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios,
            color: context.color.secondary,
          ),
        ),
      ),
      body: BlocBuilder(
          bloc: categoryBloc,
          builder: (context, state) {
            return CustomScrollView(
              slivers: [
                widget.type != ''
                    ? const SliverToBoxAdapter(child: SizedBox.shrink())
                    : BlocBuilder(
                        bloc: categoryBloc,
                        builder: (context, state) {
                          if (state is DoneCategoryProductsState) {
                            return SliverToBoxAdapter(
                                child: SizedBox(
                              height: 56.h,
                              width: context.w,
                              child: state.model.data.subCategory.isEmpty
                                  ? const SizedBox.shrink()
                                  : ListView(
                                      // itemCount: state.model.data.subCategory.length,
                                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                                      scrollDirection: Axis.horizontal,
                                      children: List.generate(
                                        state.model.data.subCategory.length,
                                        (i) => Padding(
                                          padding: EdgeInsetsDirectional.only(end: 6.w),
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                selCategoryId = state.model.data.subCategory[i].id;
                                                productsBloc.add(StartCategoryProductsEvent(
                                                    id: widget.id, subCategoryId: state.model.data.subCategory[i].id, type: widget.type));
                                              });
                                            },
                                            child: AnimatedContainer(
                                              height: 56.h,
                                              padding: EdgeInsets.all(8.w),
                                              constraints: BoxConstraints(minWidth: 66.w),
                                              decoration: BoxDecoration(
                                                color: selCategoryId == state.model.data.subCategory[i].id ? context.color.secondary : Colors.white,
                                                borderRadius: BorderRadius.circular(4),
                                              ),
                                              duration: 200.milliseconds,
                                              child: Text(
                                                state.model.data.subCategory[i].name,
                                                style: context.textTheme.headline5?.copyWith(
                                                    color:
                                                        selCategoryId == state.model.data.subCategory[i].id ? Colors.white : context.color.secondary),
                                              ).onCenter,
                                            ),
                                          ),
                                        ),
                                      )..insert(
                                          0,
                                          Padding(
                                            padding: EdgeInsetsDirectional.only(end: 6.w),
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  selCategoryId = 0;
                                                  productsBloc.add(StartCategoryProductsEvent(id: widget.id, type: widget.type));
                                                });
                                              },
                                              child: AnimatedContainer(
                                                height: 56.h,
                                                padding: EdgeInsets.all(8.w),
                                                constraints: BoxConstraints(minWidth: 66.w),
                                                decoration: BoxDecoration(
                                                  color: selCategoryId == 0 ? context.color.secondary : Colors.white,
                                                  borderRadius: BorderRadius.circular(4),
                                                ),
                                                duration: 200.milliseconds,
                                                child: Text(
                                                  LocaleKeys.all,
                                                  style: context.textTheme.headline5
                                                      ?.copyWith(color: selCategoryId == 0 ? Colors.white : context.color.secondary),
                                                ).onCenter,
                                              ),
                                            ),
                                          ),
                                        ),
                                    ),
                            ));
                          } else {
                            return const SliverToBoxAdapter(child: SizedBox.shrink());
                          }
                        },
                      ),
                BlocBuilder(
                    bloc: productsBloc,
                    builder: (context, state) {
                      if (state is LoadingCategoryProductsState) {
                        return SliverToBoxAdapter(child: SizedBox(height: MediaQuery.of(context).size.height * .8, child: const LoadingApp()));
                      } else if (state is FaildCategoryProductsState) {
                        return SliverToBoxAdapter(
                          child: FailedWidget(
                              statusCode: state.statusCode,
                              errType: state.errType,
                              title: state.msg,
                              onTap: () {
                                productsBloc.add(StartCategoryProductsEvent(id: widget.id, type: widget.type));
                              }),
                        );
                      } else if (state is DoneCategoryProductsState) {
                        return SliverPadding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 30.h),
                          sliver: state.model.data.products.isEmpty
                              ? SliverToBoxAdapter(
                                  child: SizedBox(
                                      height: MediaQuery.of(context).size.height * .8,
                                      child: Center(child: Text(LocaleKeys.no_product_category.tr()))))
                              : SliverGrid(
                                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: context.w / 2,
                                    mainAxisSpacing: 25.h,
                                    crossAxisSpacing: 16.w,
                                    childAspectRatio: 164.w / 317.14.h,
                                  ),
                                  delegate: SliverChildBuilderDelegate(
                                      (BuildContext context, int index) => ProductCard(data: state.model.data.products[index]),
                                      childCount: state.model.data.products.length),
                                ),
                        );
                      } else {
                        return SliverToBoxAdapter(child: SizedBox(height: MediaQuery.of(context).size.height * .8, child: const LoadingApp()));
                      }
                    })
              ],
            );
          }),
    );
  }
}
