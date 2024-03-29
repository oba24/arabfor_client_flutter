import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screen_scaling/flutter_screen_scaling.dart';
import 'package:kiwi/kiwi.dart';
import 'package:saudimarchclient/helper/extintions.dart';

import '../../gen/assets.gen.dart';
import '../../generated/locale_keys.g.dart';
import '../../helper/asset_image.dart';
import '../../helper/failed_widget.dart';
import '../../helper/loading_app.dart';
import '../../helper/rout.dart';
import '../order_details/view.dart';
import 'bloc/bloc.dart';
import 'bloc/events.dart';
import 'bloc/states.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({Key? key}) : super(key: key);

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  final _bloc = KiwiContainer().resolve<NotificationBloc>();
  @override
  void initState() {
    _bloc.add(StartGetNotificationEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.color.primaryContainer,
      appBar: AppBar(
        title: Text(LocaleKeys.Notifications.tr(), style: context.textTheme.headline2),
        centerTitle: true,
        elevation: 0,
        backgroundColor: context.color.primaryContainer,
      ),
      body: BlocBuilder(
        bloc: _bloc,
        builder: (context, state) {
          if (state is LoadingNotificationState) {
            return const LoadingApp();
          } else if (state is FaildNotificationState) {
            return FailedWidget(
              statusCode: state.statusCode,
              errType: state.errType,
              title: state.msg,
              onTap: () => _bloc.add(StartGetNotificationEvent()),
            );
          } else if (state is DoneNotificationState) {
            if (state.data.notifications.isEmpty) {
              return CustomImage(
                Assets.svg.iconAlert,
                height: 150.h,
                color: context.color.secondary.withOpacity(0.2),
              ).onCenter;
            }
            return NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification sn) {
                if (state is LoadingNotificationState &&
                    state.url != null &&
                    sn is ScrollUpdateNotification &&
                    sn.metrics.pixels >= (sn.metrics.maxScrollExtent - 70.h) &&
                    sn.metrics.axisDirection == AxisDirection.down) {
                  _bloc.add(StartPaginationEvent(state.url!));
                }
                return true;
              },
              child: ListView.separated(
                separatorBuilder: (context, index) {
                  return Divider(color: context.color.secondary.withOpacity(0.4));
                },
                itemCount: state.data.notifications.length,
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                itemBuilder: (context, i) {
                  return Column(
                    children: [
                      ListTile(
                        onTap: () {
                          if (["pending_order", "accept_order", "reject_order", "finished_order"]
                              .any((element) => element == state.data.notifications[i].notifyType)) {
                            push(OrderDetailsView(id: state.data.notifications[i].orderId));
                          } else {
                            // management
                          }
                        },
                        leading: CustomImage(Assets.svg.logo, width: 40.h, height: 40.h),
                        title: Text(
                          state.data.notifications[i].title,
                          style: context.textTheme.bodyText2,
                        ),
                        subtitle: Text(
                          state.data.notifications[i].body,
                          style: context.textTheme.subtitle1,
                        ),
                      ).paddingSymmetric(vertical: 8.h),
                      if ((state.url != null || state.loading == true) && i == (state.data.notifications.length - 1))
                        SliverToBoxAdapter(child: SizedBox(height: 70.h, child: const LoadingApp().onCenter))
                    ],
                  );
                },
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
