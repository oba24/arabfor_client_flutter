import 'model.dart';

class NotificationState {}

class LoadingNotificationState extends NotificationState {}

class FaildNotificationState extends NotificationState {
  String msg;
  int errType;
  int statusCode;
  FaildNotificationState({required this.errType, required this.msg, required this.statusCode});
}

class DoneNotificationState extends NotificationState {
  NotificationsData data;
  String msg;
  bool? loading;
  String? url;
  DoneNotificationState(this.msg, this.data, [this.loading, this.url]);
}
