import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screen_scaling/flutter_screen_scaling.dart';
import 'package:kiwi/kiwi.dart';
import 'package:saudimarchclient/helper/extintions.dart';
import '../../generated/locale_keys.g.dart';
import '../../helper/asset_image.dart';
import '../../helper/failed_widget.dart';
import '../../helper/loading_app.dart';
import 'bloc/bloc.dart';
import 'bloc/events.dart';
import 'bloc/states.dart';

class LastCompetitionView extends StatefulWidget {
  const LastCompetitionView({Key? key}) : super(key: key);

  @override
  State<LastCompetitionView> createState() => _LastCompetitionViewState();
}

class _LastCompetitionViewState extends State<LastCompetitionView> {
  final _bloc = KiwiContainer().resolve<CompetitionBloc>();
  @override
  void initState() {
    super.initState();
    _bloc.add(StartAllCompetitionEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.colorScheme.primaryContainer,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: context.theme.colorScheme.primaryContainer,
        title: Text(
          LocaleKeys.Winner_of_the_past_months.tr(),
          style: context.textTheme.headline2,
        ),
      ),
      body: BlocBuilder(
          bloc: _bloc,
          builder: (context, state) {
            if (state is LoadingCompetitionState) {
              return LoadingApp(
                height: 100.h,
              );
            } else if (state is FaildCompetitionState) {
              return FailedWidget( statusCode: state.statusCode,
                errType: state.errType,
                title: state.msg,
                onTap: () => _bloc.add(StartAllCompetitionEvent()),
              );
            } else if (state is DoneAllCompetitionState) {
              return ListView.builder(
                itemCount: state.data.length,
                itemBuilder: (context, i) {
                  return Container(
                    padding: EdgeInsets.symmetric(vertical: 24.h),
                    margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: context.color.secondaryContainer,
                      border: Border.all(width: 1.0, color: context.color.primaryContainer),
                    ),
                    child: Column(
                      children: [
                        Text(
                          LocaleKeys.list_of_the_winners_of_the_Month_Competition.tr(namedArgs: {"MONTH": state.data[i].month}),
                          style: context.textTheme.headline5,
                        ),
                        Text(state.data[i].question, style: context.textTheme.headline2),
                        Text(LocaleKeys.answer.tr(), style: context.textTheme.headline5).paddingSymmetric(vertical: 5.h),
                        Text(state.data[i].correctAnswer, style: context.textTheme.headline5?.copyWith(fontSize: 28.0))
                            .paddingSymmetric(vertical: 5.h),
                        Row(
                          children: List.generate(
                            state.data[i].winners.length,
                            (index) {
                              var item = state.data[i].winners[index];
                              if (item.id == 0) return const Expanded(child: SizedBox());
                              return Expanded(
                                child: Container(
                                  height: 144.h,
                                  margin: EdgeInsets.symmetric(horizontal: 1.5.w),
                                  // decoration: BoxDecoration(
                                  //   borderRadius: BorderRadius.circular(10.0),
                                  //   color: context.color.secondaryContainer,
                                  //   border: Border.all(width: 1.0, color: context.color.primaryContainer),
                                  // ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        item.place,
                                        style: context.textTheme.headline1?.copyWith(fontSize: 13.0),
                                      ),
                                      CustomImage(
                                        item.imageUrl,
                                        height: 60.h,
                                        width: 60.h,
                                        borderRadius: BorderRadius.circular(100),
                                        border: Border.all(width: 5.h, color: Colors.white),
                                      ),
                                      // Text.rich(
                                      //   TextSpan(
                                      //     children: [
                                      //       TextSpan(
                                      //         text: item.name,
                                      //         style: context.textTheme.headline4,
                                      //       ),
                                      //       const TextSpan(text: "\n"),
                                      //       TextSpan(
                                      //         text: item.prize,
                                      //         style: context.textTheme.subtitle2,
                                      //       ),
                                      //     ],
                                      //   ),
                                      //   textAlign: TextAlign.center,
                                      //   maxLines: 2,
                                      // ),
                                      Text(
                                        item.name,
                                        style: context.textTheme.headline4,
                                        maxLines: 1,
                                        textAlign: TextAlign.center,
                                      ),
                                      Text(
                                        item.prize,
                                        style: context.textTheme.subtitle2,
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  );
                },
              );
            } else {
              return const SizedBox();
            }
          }),
    );
  }
}
