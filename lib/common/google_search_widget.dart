import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaling/flutter_screen_scaling.dart';
import 'package:saudimarchclient/helper/asset_image.dart';
import 'package:saudimarchclient/helper/extintions.dart';
import 'package:saudimarchclient/helper/google_search.dart';
import 'package:saudimarchclient/helper/loading_app.dart';

import '../generated/locale_keys.g.dart';

class GoogleSearchWidget extends StatefulWidget {
  final Function(SearchGoogleModel result) onSelecte;
  const GoogleSearchWidget({Key? key, required this.onSelecte}) : super(key: key);

  @override
  State<GoogleSearchWidget> createState() => _GoogleSearchWidgetState();
}

class _GoogleSearchWidgetState extends State<GoogleSearchWidget> {
  Timer? timer;
  bool hideResult = false;
  String? last;
  List<SearchGoogleModel> _result = [];
  final _apisHelper = GoogleApisHelper();
  bool _loading = false;
  _onCange(String input) {
    if (timer != null && timer!.isActive) timer!.cancel();
    timer = Timer(700.milliseconds, () async {
      if (input != last) {
        _loading = true;
        setState(() {});
        _result = await _apisHelper.searchGoogle(input);
        _loading = false;
        setState(() {});
        last = input;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SafeArea(
          bottom: false,
          child: Container(
            margin: EdgeInsets.all(26.w).copyWith(bottom: 8.h),
            height: 47.0.h,
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            decoration: BoxDecoration(
              color: context.color.primaryContainer,
              borderRadius: BorderRadius.circular(50.0),
              border: Border.all(width: 1.0, color: Colors.black.withOpacity(0.15)),
            ),
            child: TextField(
              onTap: () {
                setState(() {
                  hideResult = true;
                });
              },
              // controller: _controller,
              onChanged: _onCange,
              decoration: InputDecoration.collapsed(hintText: LocaleKeys.search_here.tr()).copyWith(
                contentPadding: EdgeInsets.symmetric(vertical: 10.h),
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.all(26.w).copyWith(top: 0),
          // alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          constraints: BoxConstraints(maxHeight: context.h / 3),
          decoration: BoxDecoration(
            color: context.color.primaryContainer,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(width: 1.0, color: Colors.black.withOpacity(0.15)),
          ),
          child: Builder(
            builder: (context) {
              if (_loading) {
                return CustomProgress(size: 25.px).paddingSymmetric(vertical: 10.h);
              } else if (hideResult && _result.isNotEmpty) {
                return ListView.builder(
                  itemCount: _result.length,
                  shrinkWrap: true,
                  itemBuilder: (context, i) {
                    return Container(
                      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: context.color.secondaryContainer))),
                      child: ListTile(
                        leading: CustomImage(_result[i].icon, height: 25.h, fit: BoxFit.contain),
                        onTap: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                          setState(() {
                            hideResult = false;
                          });
                          widget.onSelecte(_result[i]);
                        },
                        title: Text(_result[i].name, style: context.textTheme.headline4),
                      ),
                    );
                  },
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ),
      ],
    );
  }
}
