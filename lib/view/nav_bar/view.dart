import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screen_scaling/flutter_screen_scaling.dart';
import 'package:saudimarchclient/view/cart/view.dart';
import '../../gen/assets.gen.dart';
import '../../generated/locale_keys.g.dart';
import '../../helper/asset_image.dart';
import '../../helper/extintions.dart';
import '../home/view.dart';
import '../offers/view.dart';
import '../profile/view/profile.dart';

class NavBarView extends StatefulWidget {
  final int? page;
  const NavBarView({Key? key, this.page}) : super(key: key);

  @override
  State<NavBarView> createState() => _NavBarViewState();
}

class _NavBarViewState extends State<NavBarView> {
  late int _pageRoute;
  @override
  void initState() {
    _pageRoute = widget.page ?? 0;
    super.initState();
  }

  final List<Widget> _roouts = const [
    HomeView(),
    Offers(),
    // Center(),
    CartView(),
    ProfileView(),
  ];
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_pageRoute == 0) {
          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        } else {
          setState(() {
            _pageRoute = 0;
          });
        }
        return false;
      },
      child: Scaffold(
        body: _roouts[_pageRoute],
        backgroundColor: "#FBF9F4".toColor,
        bottomNavigationBar: Container(
          height: 84.0.h,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(25.0)),
            color: const Color(0xFFFBF9F4),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF242424).withOpacity(0.05),
                offset: const Offset(0, -1.0),
                blurRadius: 20.0,
              ),
            ],
          ),
          child: Row(
            children: List.generate(
              4,
              (index) => Expanded(
                child: AnimatedSwitcher(
                  duration: 200.milliseconds,
                  child: _pageRoute == index
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              [
                                LocaleKeys.Discov.tr(),
                                LocaleKeys.offers.tr(),
                                LocaleKeys.cart.tr(),
                                LocaleKeys.Profile.tr(),
                              ][index],
                              style: context.textTheme.headline6!.copyWith(height: 1),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 4.h),
                            Container(
                              height: 3.h,
                              width: 3.h,
                              decoration: BoxDecoration(color: context.color.secondary, shape: BoxShape.circle),
                            )
                          ],
                        )
                      : IconButton(
                          onPressed: () {
                            setState(() {
                              _pageRoute = index;
                            });
                          },
                          iconSize: index == 2 ? 50.h : 20.h,
                          icon: CustomImage(
                            [
                              Assets.svg.homeIcon,
                              Assets.svg.offerIcon,
                              Assets.svg.cartIcon,
                              Assets.svg.iconUser,
                            ][index],
                          ),
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
