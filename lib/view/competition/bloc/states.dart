import 'model.dart';

class CompetitionState {}

class LoadingCompetitionState extends CompetitionState {}

class FaildCompetitionState extends CompetitionState {
  String msg;
  int errType;
  int statusCode;
  FaildCompetitionState({required this.errType, required this.msg, required this.statusCode});
}

class DoneCompetitionState extends CompetitionState {
  CompetitionData data;
  String msg;
  DoneCompetitionState(this.msg, this.data);
}

class DoneAllCompetitionState extends CompetitionState {
  List<PreviousMonthWinnersDatum> data;

  String msg;
  DoneAllCompetitionState(this.msg, this.data);
}

class DoneAddAnswerCompetitionState extends CompetitionState {
  String msg;
  DoneAddAnswerCompetitionState(this.msg);
}
