import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screen_scaling/flutter_screen_scaling.dart';
import 'package:kiwi/kiwi.dart';
import 'package:saudimarchclient/common/btn.dart';
import 'package:saudimarchclient/generated/locale_keys.g.dart';
import 'package:saudimarchclient/helper/asset_image.dart';
import 'package:saudimarchclient/helper/extintions.dart';
import 'package:saudimarchclient/helper/flash_helper.dart';
import 'package:saudimarchclient/helper/rout.dart';

import '../../helper/failed_widget.dart';
import '../../helper/loading_app.dart';
import 'bloc/bloc.dart';
import 'bloc/events.dart';
import 'bloc/states.dart';
import 'last_Competition_view.dart';

class CompetitionView extends StatefulWidget {
  const CompetitionView({Key? key}) : super(key: key);

  @override
  State<CompetitionView> createState() => _CompetitionViewState();
}

class _CompetitionViewState extends State<CompetitionView> {
  final _bloc = KiwiContainer().resolve<CompetitionBloc>();
  final _answerBloc = KiwiContainer().resolve<CompetitionBloc>();
  final TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    _bloc.add(StartCompetitionEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.colorScheme.primaryContainer,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: "#FBF9F4".toColor,
        title: Text(
          LocaleKeys.competitions_and_awards.tr(),
          style: context.textTheme.headline2,
        ),
      ),
      body: BlocBuilder(
          bloc: _bloc,
          builder: (context, state) {
            if (state is LoadingCompetitionState) {
              return LoadingApp(height: 100.h);
            } else if (state is FaildCompetitionState) {
              return FailedWidget(
                statusCode: state.statusCode,
                errType: state.errType,
                title: state.msg,
                onTap: () => _bloc.add(StartCompetitionEvent()),
              );
            } else if (state is DoneCompetitionState) {
              return ListView(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 26.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: context.color.secondaryContainer,
                      border: Border.all(width: 1.0, color: context.color.secondary.withOpacity(0.05)),
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(LocaleKeys.month_question.tr(), style: context.textTheme.headline5),
                        Text(state.data.question, style: context.textTheme.headline2),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 26.w),
                    height: 47.0.h,
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50.0),
                      border: Border.all(width: 1.0, color: Colors.black.withOpacity(0.15)),
                    ),
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration.collapsed(hintText: LocaleKeys.Write_the_answer_here.tr()).copyWith(
                        contentPadding: EdgeInsets.symmetric(vertical: 6.h),
                      ),
                    ),
                  ),
                  BlocConsumer(
                      bloc: _answerBloc,
                      listener: (context, state) {
                        if (state is DoneAddAnswerCompetitionState) {
                          FlashHelper.successBar(message: state.msg);
                        } else if (state is FaildCompetitionState) {
                          FlashHelper.errorBar(message: state.msg);
                        }
                      },
                      builder: (context, s) {
                        return Btn(
                          loading: s is LoadingCompetitionState,
                          width: 156.w,
                          onTap: () {
                            if (_controller.text.isNotEmpty) {
                              _answerBloc.add(StartAddAnswerCompetitionEvent(_controller.text, state.data.id));
                            }
                          },
                          text: LocaleKeys.send.tr(),
                        ).paddingSymmetric(horizontal: 24.w, vertical: 57.h);
                      }),
                  Text(
                    LocaleKeys.list_of_the_winners_of_the_Month_Competition.tr(namedArgs: {"MONTH": state.data.month}),
                    style: context.textTheme.headline1?.copyWith(fontSize: 27.0),
                    textAlign: TextAlign.center,
                  ).paddingSymmetric(vertical: 24.h),
                  Row(
                    children: List.generate(
                      state.data.previousMonthWinners.winners.length,
                      (i) {
                        var item = state.data.previousMonthWinners.winners[i];
                        if (item.id == 0) return const Expanded(child: SizedBox());
                        return Expanded(
                          child: Container(
                            height: 144.h,
                            margin: EdgeInsets.symmetric(horizontal: 1.5.w),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: context.color.secondaryContainer,
                              border: Border.all(width: 1.0, color: context.color.primaryContainer),
                            ),
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
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: item.name,
                                        style: context.textTheme.headline4,
                                      ),
                                      const TextSpan(text: "\n"),
                                      TextSpan(
                                        text: item.prize,
                                        style: context.textTheme.subtitle2,
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ).paddingSymmetric(horizontal: 14.w),
                  Btn(
                    text: LocaleKeys.Winner_of_the_past_months.tr(),
                    onTap: () => push(const LastCompetitionView()),
                  ).paddingSymmetric(horizontal: 24.w, vertical: 57.h)
                ],
              );
            } else {
              return const SizedBox();
            }
          }),
    );
  }
}
