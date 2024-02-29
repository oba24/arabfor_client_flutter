import '../../../repo/server_gate.dart';
import 'events.dart';
import 'model.dart';
import 'states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc() : super(NotificationState());
  ServerGate serverGate = ServerGate();
  late NotificationsData _data;

  @override
  Stream<NotificationState> mapEventToState(NotificationEvent event) async* {
    if (event is StartGetNotificationEvent) {
      yield LoadingNotificationState();
      CustomResponse response = await repo("notifications");
      if (response.success) {
        NotificationModel _model = NotificationModel.fromJson(response.response?.data);
        _data = _model.data;
        yield DoneNotificationState(response.msg, _data, false, _model.links.next);
      } else {
        // await CustomProgressDialog.hidePr();
        yield FaildNotificationState(msg: response.msg, errType: response.errType!, statusCode: response.statusCode);
      }
    }
    if (event is StartPaginationEvent) {
      yield DoneNotificationState("", _data, true, null);
      CustomResponse response = await repo(event.nextUrl);
      if (response.success) {
        NotificationModel _model = NotificationModel.fromJson(response.response?.data);
        _data.notifications.addAll(_model.data.notifications);
        _data.unreadnotificationsCount = _model.data.unreadnotificationsCount;
        // await CustomProgressDialog.hidePr();
        yield DoneNotificationState("", _data, false, _model.links.next);
      } else {
        yield DoneNotificationState(response.msg, _data, false, null);
      }
    }
  }

  Future<CustomResponse> repo(String url) async {
    CustomResponse response = await serverGate.getFromServer(url: url);
    return response;
  }
}
