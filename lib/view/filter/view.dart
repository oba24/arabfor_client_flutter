import 'package:easy_localization/easy_localization.dart' as lang;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screen_scaling/flutter_screen_scaling.dart';
import 'package:kiwi/kiwi.dart';
import 'package:saudimarchclient/common/btn.dart';
import 'package:saudimarchclient/common/stare_bar.dart';
import 'package:saudimarchclient/helper/extintions.dart';
import 'package:saudimarchclient/helper/loading_app.dart';
import 'package:saudimarchclient/models/product_data.dart';

import '../../common/alert.dart';
import '../../gen_bloc/colors/bloc.dart';
import '../../gen_bloc/colors/events.dart';
import '../../gen_bloc/colors/states.dart';
import '../../gen_bloc/get_providers_bloc/bloc.dart';
import '../../gen_bloc/get_providers_bloc/events.dart';
import '../../gen_bloc/get_providers_bloc/states.dart';
import '../../generated/locale_keys.g.dart';
import '../../helper/rout.dart';
import '../../models/category_provider_model.dart';
import '../../models/colors_model.dart';
import '../../models/rate_model.dart';
import '../product/products/view.dart';

class FilterView extends StatefulWidget {
  final CategoryData? categoryData;
  final String? calssification;
  final int? providerId;
  final String? providerTitle;
  final String type;
  const FilterView({Key? key, this.categoryData, this.calssification, this.providerId, required this.type, this.providerTitle}) : super(key: key);

  @override
  State<FilterView> createState() => _FilterViewState();
}

class _FilterViewState extends State<FilterView> {
  ColorsDatum colorDatum = ColorsDatum.fromJson({});
  final ColorsBloc _colorsBloc = KiwiContainer().resolve<ColorsBloc>();
  final GetCategoryProvidersBloc categoryProvidersBloc = KiwiContainer().resolve<GetCategoryProvidersBloc>();
  CategoryProviderDatum providerDatum = CategoryProviderDatum.fromJson({});
  RangeValues _currentRangeValues = const RangeValues(1, 1000);

  bool isPrice = false;
  String url = '';
  FilterData filterData = FilterData();
  List<RatesModel> ratesLst = [
    RatesModel(id: 0, name: '1'),
    RatesModel(id: 1, name: '2'),
    RatesModel(id: 2, name: '3'),
    RatesModel(id: 3, name: '4'),
    RatesModel(id: 4, name: '5'),
  ];
  List<ClassificationModel> classificationLst = [
    ClassificationModel(id: 0, name: LocaleKeys.the_latest_additions.tr(), key: 'latest_added'),
    ClassificationModel(id: 1, name: LocaleKeys.best_selling.tr(), key: 'best_seller'),
  ];

  RatesModel rateData = RatesModel.fromJson(({}));
  ClassificationModel classificationData = ClassificationModel.fromJson(({}));

  @override
  void initState() {
    if (widget.type != '') {
      filterData.classification = widget.type;
    } else {
      filterData.categoryId = widget.categoryData!.id;
    }
    filterData.colorId = null;
    filterData.ratingValue = null;

    super.initState();
  }

  String getClassificationName(key) {
    if (key == 'latest_added') {
      return LocaleKeys.the_latest_additions.tr();
    } else if (key == 'best_seller') {
      return LocaleKeys.best_selling.tr();
    } else {
      return key;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.color.primaryContainer,
      appBar: AppBar(
        title: Text(LocaleKeys.filter.tr(), style: context.textTheme.headline2),
        centerTitle: true,
        elevation: 0,
        backgroundColor: context.color.primaryContainer,
      ),
      body: Column(
        children: [
          if (widget.type != '')
            FilterFeild(
                ontap: () {
                  CustomAlert.selectOptionalSeetButton(
                    title: LocaleKeys.classification.tr(),
                    items: classificationLst,
                    // trailing: List.generate(
                    //   classificationLst.length,
                    //   (i) => CustomStarBar(size: 10, rate: i + 1),
                    // ),
                    onSubmit: (v) {
                      setState(() {
                        classificationData = v;
                        filterData.classification = classificationData.key;
                        print('classificationData.key -=-=-=-=-=-=-=-= ' + classificationData.key);
                        // _event.payType = payTypeData.key;
                      });
                    },
                    item: classificationData,
                  );
                },
                hint: LocaleKeys.classification.tr(),
                title: classificationData.key == '' ? getClassificationName(widget.type) : getClassificationName(classificationData.key)
                //  widget.type == 'latest_added'
                //     ? LocaleKeys.the_latest_additions.tr()
                //     : widget.type == 'best_seller'
                //         ? LocaleKeys.best_selling.tr()
                //         : widget.type,
                ),
          if (widget.categoryData != null)
            FilterFeild(
              ontap: () {},
              hint: LocaleKeys.classification.tr(),
              title: widget.categoryData!.name,
            ),
          if (widget.categoryData != null)
            BlocConsumer(
              bloc: categoryProvidersBloc,
              listener: (context, state) {
                if (state is DoneGetCategoryProvidersState) {
                  CustomAlert.selectOptionalSeetButton(
                    title: LocaleKeys.choose_store.tr(),
                    items: state.data,
                    onSubmit: (v) {
                      setState(() {
                        providerDatum = v;
                        filterData.providerId = providerDatum.id;
                      });
                    },
                    item: providerDatum,
                  );
                }
              },
              builder: (context, snapshot) {
                return FilterFeild(
                  ontap: () {
                    if (snapshot is! LoadingGetCategoryProvidersState) {
                      categoryProvidersBloc.add(StartGetCategoryProvidersEvent(widget.categoryData!.id));
                    }
                  },
                  hint: LocaleKeys.store.tr(),
                  title: providerDatum.id == 0 ? LocaleKeys.choose_store.tr() : providerDatum.name,
                  trailing: snapshot is LoadingGetCategoryProvidersState ? CustomProgress(size: 20, color: context.color.secondary) : null,
                );
              },
            ),
          // if (widget.providerId != null)
          //   FilterFeild(
          //     ontap: () {},
          //     hint: LocaleKeys.store.tr(),
          //     title: widget.providerTitle ?? '',
          //   ),
          FilterFeild(
            ontap: () {
              showModalBottomSheet(
                // isDismissible: false,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30.px))),
                isScrollControlled: true,
                context: navigator.currentContext!,
                builder: (ctx) {
                  return StatefulBuilder(
                    builder: (context, s) {
                      return Container(
                        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(70))),
                        // padding: EdgeInsets.all(10),
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AnimatedOpacity(
                              duration: const Duration(seconds: 1),
                              opacity: 1,
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 50.w),
                                alignment: Alignment.center,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      LocaleKeys.choose_price.tr(),
                                      style: context.textTheme.headline4,
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 42.h),
                                    RangeSlider(
                                      values: _currentRangeValues,
                                      max: 1000,
                                      divisions: 1000,
                                      labels: RangeLabels(
                                        _currentRangeValues.start.round().toString(),
                                        _currentRangeValues.end.round().toString(),
                                      ),
                                      onChanged: (RangeValues values) {
                                        s(() {
                                          _currentRangeValues = values;
                                          isPrice = true;
                                          filterData.priceFrom = _currentRangeValues.start.round().toString();
                                          filterData.priceTo = _currentRangeValues.end.round().toString();
                                        });
                                        setState(() {});
                                      },
                                    ),
                                    SizedBox(height: 42.h),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              );
            },
            hint: LocaleKeys.price.tr(),
            title: isPrice ? '${_currentRangeValues.start.round().toString()} -  ${_currentRangeValues.end.round().toString()}' : 'إختر السعر',
          ),
          BlocConsumer(
            bloc: _colorsBloc,
            listener: (context, state) {
              if (state is DoneColorsState) {
                CustomAlert.selectOptionalSeetButton(
                  title: LocaleKeys.Color.tr(),
                  trailing: List.generate(
                    state.data.length,
                    (i) => Container(
                      margin: EdgeInsetsDirectional.only(end: 8.w),
                      height: 20.h,
                      width: 20.h,
                      decoration: BoxDecoration(color: state.data[i].hexValue.toColor, borderRadius: BorderRadius.circular(4)),
                    ),
                  ),
                  items: state.data,
                  onSubmit: (v) {
                    setState(() {
                      colorDatum = v;
                      filterData.colorId = colorDatum.id;
                    });
                  },
                  item: colorDatum,
                );
              }
            },
            builder: (context, snapshot) {
              return FilterFeild(
                ontap: () {
                  if (snapshot is! LoadingColorsState) _colorsBloc.add(StartColorsEvent());
                },
                colorDatum: colorDatum,
                isColor: true,
                hint: LocaleKeys.Color.tr(),
                title: colorDatum.id == 0 ? LocaleKeys.choose_color.tr() : '',
                trailing: snapshot is LoadingColorsState
                    ? CustomProgress(
                        size: 20,
                        color: context.color.secondary,
                      )
                    : null,
              );
            },
          ),
          FilterFeild(
            ontap: () {
              CustomAlert.selectOptionalSeetButton(
                title: LocaleKeys.pay_type.tr(),
                items: ratesLst,
                trailing: List.generate(
                  ratesLst.length,
                  (i) => CustomStarBar(size: 10, rate: i + 1),
                ),
                onSubmit: (v) {
                  setState(() {
                    rateData = v;
                    filterData.ratingValue = rateData.id + 1;
                    // _event.payType = payTypeData.key;
                  });
                },
                item: rateData,
              );
            },
            isRate: true,
            rateData: rateData,
            hint: LocaleKeys.rate.tr(),
            title: rateData.id == -1 ? LocaleKeys.choose_rate.tr() : '',
            // trailing: rateData.id == -1 ? null : Row(children: [CustomStarBar(size: 20, rate: rateData.id + 1)]),
          ),
          const Spacer(),
          Row(
            children: [
              Expanded(
                  child: Btn(
                onTap: () {
                  setState(() {
                    // url = widget.type == ''
                    //     ? 'filter?&category_id=${widget.categoryData!.id}&provider_id=${providerDatum.id}&price_from=${_currentRangeValues.start.round().toString()}&price_to=${_currentRangeValues.end.round().toString()}&color_id=${colorDatum.id}&rating_value=${rateData.id}'
                    //     : 'filter?classification=${widget.type}&price_from=${_currentRangeValues.start.round().toString()}&price_to=${_currentRangeValues.end.round().toString()}&color_id=${colorDatum.id == 0 ? null : colorDatum.id}&rating_value=${rateData.id == -1 ? null : rateData.id}';
                    push(ProductsView(filterData: filterData, title: LocaleKeys.filter.tr(), type: '', id: 0));
                  });
                },
                text: LocaleKeys.apply.tr(),
              )),
              SizedBox(width: 10.w),
              Expanded(
                  child: Btn(
                onTap: () {
                  setState(() {
                    if (widget.categoryData != null) {
                      providerDatum = CategoryProviderDatum.fromJson({});
                    }
                    colorDatum = ColorsDatum.fromJson({});
                    rateData = RatesModel.fromJson(({}));
                    isPrice = false;
                    filterData.colorId = 0;
                    filterData.ratingValue = 0;
                    classificationData = ClassificationModel.fromJson(({}));
                    filterData.classification = widget.calssification ?? '';
                  });
                },
                border: Border.all(color: context.color.secondary),
                textColor: context.color.secondary,
                color: context.color.background,
                text: LocaleKeys.clear.tr(),
              )),
            ],
          ).paddingSymmetric(vertical: 10.h, horizontal: 30.w),
        ],
      ),
    );
  }
}

class FilterFeild extends StatefulWidget {
  final String title;
  final String hint;
  final bool isColor;
  final ColorsDatum? colorDatum;
  final RatesModel? rateData;
  final Function() ontap;
  final Widget? trailing;
  final bool isRate;
  const FilterFeild({
    Key? key,
    required this.title,
    required this.hint,
    this.isColor = false,
    this.colorDatum,
    required this.ontap,
    this.trailing,
    this.isRate = false,
    this.rateData,
  }) : super(key: key);

  @override
  State<FilterFeild> createState() => _FilterFeildState();
}

class _FilterFeildState extends State<FilterFeild> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.ontap,
      child: Row(
        children: [
          widget.isColor
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.hint),
                    widget.colorDatum!.id == 0
                        ? Text(widget.title, style: context.textTheme.bodyText1!.copyWith(color: Colors.grey))
                        : Container(
                            margin: EdgeInsetsDirectional.only(end: 8.w),
                            height: 20.h,
                            width: 20.h,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(color: widget.colorDatum!.hexValue.toColor, borderRadius: BorderRadius.circular(4)),
                          ),
                  ],
                )
              : widget.isRate
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.hint),
                        widget.rateData!.id == -1
                            ? Text(widget.title, style: context.textTheme.bodyText1!.copyWith(color: Colors.grey))
                            : CustomStarBar(size: 20, rate: widget.rateData!.id + 1)
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.hint),
                        Text(widget.title, style: context.textTheme.bodyText1!.copyWith(color: Colors.grey)),
                      ],
                    ),
          const Spacer(),
          widget.trailing == null ? Icon(Icons.arrow_forward_ios, color: context.color.secondary, size: 15.px) : widget.trailing!,
        ],
      ).paddingSymmetric(vertical: 10.h, horizontal: 30.w),
    );
  }
}

class FilterData {
  String? classification;
  int? categoryId;
  int? providerId;
  String? priceFrom;
  String? priceTo;
  int? colorId;
  int? ratingValue;

  FilterData({
    this.classification,
    this.categoryId,
    this.providerId,
    this.priceFrom,
    this.priceTo,
    this.colorId,
    this.ratingValue,
  });

  Map<String, dynamic> toJson() => {
        "classification": classification,
        "category_id": categoryId,
        "provider_id": providerId,
        "price_from": priceFrom,
        "price_to": priceTo,
        "color_id": colorId,
        "rating_value": ratingValue,
      };
}

//classification:recently_added
//category_id:
//provider_id:
//price_from:
//price_to:
//color_id:
//rating_value: