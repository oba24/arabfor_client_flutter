import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_screen_scaling/flutter_screen_scaling.dart';
import 'package:kiwi/kiwi.dart';
import 'package:saudimarchclient/common/btn.dart';
import 'package:saudimarchclient/helper/extintions.dart';
import 'package:saudimarchclient/helper/flash_helper.dart';
import 'package:saudimarchclient/helper/location_helper.dart';
import 'package:saudimarchclient/view/user_address/bloc/states.dart';

import '../../../common/google_search_widget.dart';
import '../../../generated/locale_keys.g.dart';
import '../bloc/bloc.dart';
import '../bloc/events.dart';

class AddAddressView extends StatefulWidget {
  const AddAddressView({Key? key}) : super(key: key);

  @override
  _PickLocationMapState createState() => _PickLocationMapState();
}

class _PickLocationMapState extends State<AddAddressView> {
  final UserAddresBloc _bloc = KiwiContainer().resolve<UserAddresBloc>();
  final Completer<GoogleMapController> _controller = Completer();
  final StartAddAddresEvent _event = StartAddAddresEvent();
  late CameraPosition _kGooglePlex;
  late GoogleMapController mapController;
  Set<Marker> markers = {};
  @override
  void initState() {
    super.initState();
    _kGooglePlex = CameraPosition(target: _event.latLng, zoom: 12);
  }

  final _focus = FocusNode();
  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: context.color.secondary),
        backgroundColor: Colors.transparent,
        title: Text(
          LocaleKeys.Add_a_new_address.tr(),
          style: context.textTheme.headline2,
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          GoogleMap(
            zoomControlsEnabled: false,
            initialCameraPosition: _kGooglePlex,
            markers: markers,
            onTap: (argument) async {
              markers = await LocationHelper.setMarkers(LatLng(argument.latitude, argument.longitude));
              var _result = await LocationHelper.getPlacemarks(LatLng(argument.latitude, argument.longitude));
              _event.address = _result.name;
              setState(() {});
              _goToTheLake(argument);
            },
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              mapController = controller;
            },
          ),
          GoogleSearchWidget(
            onSelecte: (result) async {
              markers = await LocationHelper.setMarkers(result.geometry.location.latLng);
              _event.address = result.name;
              setState(() {});
              _goToTheLake(result.geometry.location.latLng);
            },
          ),
          // SafeArea(
          //   bottom: false,
          //   child: Container(
          //     margin: EdgeInsets.all(26.w),
          //     height: 47.0.h,
          //     alignment: Alignment.center,
          //     padding: EdgeInsets.symmetric(horizontal: 8.w),
          //     decoration: BoxDecoration(
          //       color: Colors.white,
          //       borderRadius: BorderRadius.circular(50.0),
          //       border: Border.all(width: 1.0, color: Colors.black.withOpacity(0.15)),
          //     ),
          //     child: TextField(
          //       // controller: _controller,
          //       decoration: InputDecoration.collapsed(hintText: LocaleKeys.search_here.tr()).copyWith(
          //         contentPadding: EdgeInsets.symmetric(vertical: 10.h),
          //       ),
          //     ),
          //   ),
          //   // Column(
          //   //   crossAxisAlignment: CrossAxisAlignment.start,
          //   //   children: [
          //   //     // SearchGoogleMap(
          //   //     //   onChange: (lat, lng) {
          //   //     //     _goToTheLake(lat);
          //   //     //     _locationName = lng;
          //   //     //   },
          //   //     // ),
          //   //     Container(
          //   //       decoration: BoxDecoration(color: context.color.primary, shape: BoxShape.circle),
          //   //       child: IconButton(
          //   //         icon: Icon(
          //   //           Icons.gps_fixed,
          //   //           color: context.color.secondary,
          //   //         ),
          //   //         onPressed: () async {
          //   //           var _location = await LocationHelper.getLocation();
          //   //           if (_location != null) {
          //   //             LocationHelper.setMarkers(LatLng(_location.lat, _location.lng));
          //   //             _goToTheLake(LatLng(_location.lat, _location.lng));
          //   //             setState(() {
          //   //               _locationName = _location.desc;
          //   //               _latLong = LatLng(_location.lat, _location.lng);
          //   //             });
          //   //           } else {
          //   //             FlashHelper.infoBar(message: LocaleKeys.failed_to_get_your_location.tr());
          //   //           }
          //   //         },
          //   //       ),
          //   //     )
          //   //   ],
          //   // ).paddingAll(24.w),
          // ),
          // const Expanded(child: SizedBox()),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.all(26.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(color: context.color.secondary, shape: BoxShape.circle),
                    child: IconButton(
                      icon: const Icon(Icons.gps_fixed, color: Colors.white),
                      onPressed: () async {
                        var _location = await LocationHelper.getLocation();
                        if (_location != null) {
                          LocationHelper.setMarkers(LatLng(_location.lat, _location.lng));
                          markers = await LocationHelper.setMarkers(LatLng(_location.lat, _location.lng));
                          _goToTheLake(LatLng(_location.lat, _location.lng));
                          _event.address = _location.desc;
                          _event.latLng = LatLng(_location.lat, _location.lng);
                          setState(() {});
                        } else {
                          FlashHelper.infoBar(message: LocaleKeys.failed_to_get_your_location.tr());
                        }
                      },
                    ),
                  ),
                  Container(
                    height: 47.0.h,
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50.0),
                      border: Border.all(width: 1.0, color: Colors.black.withOpacity(0.15)),
                    ),
                    child: TextField(
                      controller: _event.title,
                      focusNode: _focus,
                      onTap: () {
                        setState(() {});
                      },
                      decoration: InputDecoration.collapsed(hintText: LocaleKeys.address_name.tr()).copyWith(
                        contentPadding: EdgeInsets.symmetric(vertical: 10.h),
                      ),
                    ),
                  ).paddingSymmetric(vertical: 22.w),
                  BlocConsumer(
                    bloc: _bloc,
                    listener: (context, state) {
                      if (state is DoneAddAddresState) {
                        FlashHelper.successBar(message: state.msg);
                        Navigator.pop(context, state.single);
                      } else if (state is FaildUserAddresState) {
                        FlashHelper.errorBar(message: state.msg);
                      }
                    },
                    builder: (context, snapshot) {
                      return Btn(
                        loading: snapshot is LoadingUserAddresState,
                        onTap: () {
                          _bloc.add(_event);
                        },
                        text: LocaleKeys.selecte_your_location.tr(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ).paddingOnly(bottom: _focus.hasFocus ? MediaQuery.of(context).viewInsets.bottom : 0)
        ],
      ),
    );
  }

  Future<void> _goToTheLake(LatLng latLng) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: latLng, zoom: 16)));
  }
}
