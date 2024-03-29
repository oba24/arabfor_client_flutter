import 'package:kiwi/kiwi.dart';
import 'package:saudimarchclient/view/competition/bloc/bloc.dart';
import 'package:saudimarchclient/view/create_rate/bloc/bloc.dart';
import 'package:saudimarchclient/view/home/Bloc/bloc.dart';
import 'package:saudimarchclient/view/notification/bloc/bloc.dart';
import 'package:saudimarchclient/view/offers/bloc/bloc.dart';
import 'package:saudimarchclient/view/product/single_product/Bloc/bloc.dart';
import 'package:saudimarchclient/view/profile/bloc/bloc.dart';
import 'package:saudimarchclient/view/search/bloc/bloc.dart';
import 'package:saudimarchclient/view/search/get_search_keys_bloc/bloc.dart';
import 'package:saudimarchclient/view/setting/bloc/bloc.dart';
import 'package:saudimarchclient/view/store_detail/bloc/bloc.dart';
import 'package:saudimarchclient/view/wallet/bloc/bloc.dart';

import 'gen_bloc/cities/bloc.dart';
import 'gen_bloc/colors/bloc.dart';
import 'gen_bloc/get_providers_bloc/bloc.dart';
import 'gen_bloc/order/bloc.dart';
import 'gen_bloc/profile/bloc.dart';
import 'gen_bloc/shipping_types/bloc.dart';
import 'view/auth/active_code/bloc/bloc.dart';
import 'view/auth/forget_password/bloc/bloc.dart';
import 'view/auth/login/bloc/bloc.dart';
import 'view/auth/register/bloc/bloc.dart';
import 'view/auth/reset_password/bloc/bloc.dart';
import 'view/cart/bloc/bloc.dart';
import 'view/create_order/bloc/bloc.dart';
import 'view/favorit/bloc/bloc.dart';
import 'view/product/products/bloc/bloc.dart';
import 'view/user_address/bloc/bloc.dart';

void initKiwi() {
  KiwiContainer container = KiwiContainer();
  container.registerFactory((c) => CitiesBloc());
  container.registerFactory((c) => RegisterBloc());
  container.registerFactory((c) => ActiveCodeBloc());
  container.registerFactory((c) => LoginBloc());
  container.registerFactory((c) => ProfileBloc());
  container.registerFactory((c) => HomeBloc());
  container.registerFactory((c) => ProductDetailBloc());
  container.registerFactory((c) => CartBloc());
  container.registerFactory((c) => UserAddresBloc());
  container.registerFactory((c) => ShippingBloc());
  container.registerFactory((c) => CreateOrderBloc());
  container.registerFactory((c) => OrderBloc());
  container.registerFactory((c) => UpdateProfileBloc());
  container.registerFactory((c) => CategoryProductsBloc());
  container.registerFactory((c) => AddRatingBloc());
  container.registerFactory((c) => CompetitionBloc());
  container.registerFactory((c) => FavoriteBloc());
  container.registerFactory((c) => SearchBloc());
  container.registerFactory((c) => SearchKeysBloc());
  container.registerFactory((c) => ColorsBloc());
  container.registerFactory((c) => GetCategoryProvidersBloc());
  container.registerFactory((c) => SettingBloc());
  container.registerFactory((c) => WalletBloc());
  container.registerFactory((c) => OffersBloc());
  container.registerFactory((c) => NotificationBloc());
  container.registerFactory((c) => StoreDetailBloc());
  container.registerFactory((c) => ForgetPasswordBloc());
  container.registerFactory((c) => ResetPasswordBloc());
}
