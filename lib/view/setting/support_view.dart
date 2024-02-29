import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screen_scaling/flutter_screen_scaling.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kiwi/kiwi.dart';
import 'package:saudimarchclient/gen/assets.gen.dart';
import 'package:saudimarchclient/generated/locale_keys.g.dart';
import 'package:saudimarchclient/helper/asset_image.dart';
import 'package:saudimarchclient/helper/extintions.dart';
import 'package:saudimarchclient/view/setting/bloc/events.dart';
import 'package:saudimarchclient/view/setting/bloc/states.dart';
import '../../helper/failed_widget.dart';
import '../../helper/loading_app.dart';
import 'bloc/bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportView extends StatefulWidget {
  const SupportView({Key? key}) : super(key: key);

  @override
  State<SupportView> createState() => _SupportViewState();
}

class _SupportViewState extends State<SupportView> {
  final _bloc = KiwiContainer().resolve<SettingBloc>();
  final Completer<GoogleMapController> _controller = Completer();
  final CameraPosition _kGooglePlex = const CameraPosition(target: LatLng(37.42796133580664, -122.085749655962), zoom: 14.4746);

  @override
  void initState() {
    _bloc.add(StartSupportEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
      bloc: _bloc,
      listener: (context, state) async {
        if (state is DoneSupportState) {
          final GoogleMapController controller = await _controller.future;
          controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: state.support.location.latLng, zoom: 9.4746)));
        }
      },
      builder: (context, state) {
        if (state is DoneSupportState) {
          return Scaffold(
            backgroundColor: context.color.primaryContainer,
            body: SingleChildScrollView(
              child: Stack(
                children: [
                  SizedBox(
                    height: 350.h,
                    width: context.w,
                    child: GoogleMap(
                      mapType: MapType.normal,
                      initialCameraPosition: _kGooglePlex,
                      mapToolbarEnabled: false,
                      scrollGesturesEnabled: false,
                      markers: {Marker(markerId: const MarkerId("location"), position: state.support.location.latLng)},
                      myLocationButtonEnabled: false,
                      zoomControlsEnabled: false,
                      zoomGesturesEnabled: false,
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                      },
                    ),
                  ),
                  SafeArea(
                    child: Row(
                      children: [
                        Expanded(
                          child: Align(
                            alignment: AlignmentDirectional.topStart,
                            child: IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: Icon(Icons.arrow_back_ios, color: context.color.secondary),
                            ),
                          ),
                        ),
                        Text(LocaleKeys.call_us.tr(), style: context.textTheme.headline3),
                        const Expanded(child: SizedBox.shrink()),
                      ],
                    ).paddingAll(10.px),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 34.h),
                    width: context.w,
                    decoration: BoxDecoration(
                      color: context.color.primaryContainer,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(25.h)),
                    ),
                    child: Column(
                      children: [
                        Text(
                          LocaleKeys.be_connected_to_us.tr(),
                          style: context.textTheme.headline2,
                          textAlign: TextAlign.center,
                        ),
                        ...List.generate(
                          3,
                          (i) => Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 20.h),
                            decoration: i == 2 ? null : BoxDecoration(border: Border(bottom: BorderSide(color: "#BDC4CC".toColor))),
                            child: Column(
                              children: [
                                CustomImage(
                                  [Assets.svg.location, Assets.svg.phone, Assets.svg.email][i],
                                  color: context.color.secondary,
                                ).paddingSymmetric(vertical: 14.h),
                                Text(
                                  [state.support.location.desc, state.support.email, state.support.phone][i],
                                  style: context.textTheme.bodyText1?.copyWith(
                                    fontSize: 14.0,
                                    color: context.color.secondary.withOpacity(0.8),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ).paddingSymmetric(horizontal: 34.w),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            3,
                            (i) => InkWell(
                              onTap: () {
                                launchUrl(Uri.parse(state.support.socialList[i]));
                              },
                              child: CustomImage([Assets.svg.facebook, Assets.svg.twitter, Assets.svg.instgram][i], height: 40.h)
                                  .paddingSymmetric(horizontal: 12.w),
                            ),
                          ),
                        )
                      ],
                    ),
                  ).paddingOnly(top: 320.h),
                ],
              ),
            ),
          );
        } else {
          return Scaffold(
            backgroundColor: context.color.primaryContainer,
            appBar: AppBar(
              centerTitle: true,
              elevation: 0,
              backgroundColor: context.color.primaryContainer,
            ),
            body: Builder(
              builder: (context) {
                if (state is LoadingSettingState) {
                  return const LoadingApp();
                } else if (state is FaildSettingState) {
                  return FailedWidget(
                    statusCode: state.statusCode,
                    errType: state.errType,
                    title: state.msg,
                    onTap: () => _bloc.add(StartSupportEvent()),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          );
        }
      },
    );
  }
}
