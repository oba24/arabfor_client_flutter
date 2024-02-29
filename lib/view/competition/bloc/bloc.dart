import '../../../repo/server_gate.dart';
import 'events.dart';
import 'model.dart';
import 'states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CompetitionBloc extends Bloc<CompetitionEvent, CompetitionState> {
  CompetitionBloc() : super(CompetitionState());
  ServerGate serverGate = ServerGate();

  @override
  Stream<CompetitionState> mapEventToState(CompetitionEvent event) async* {
    if (event is StartCompetitionEvent) {
      yield LoadingCompetitionState();
      // await CustomProgressDialog.showProgressDialog();
      CustomResponse response = await repo();
      if (response.success) {
        CompetitionModel _model = CompetitionModel.fromJson(response.response?.data);
        // await CustomProgressDialog.hidePr();
        yield DoneCompetitionState(response.msg, _model.single);
      } else {
        // await CustomProgressDialog.hidePr();
        yield FaildCompetitionState(msg: response.msg, errType: response.errType!, statusCode: response.statusCode);
      }
    }
    if (event is StartAllCompetitionEvent) {
      yield LoadingCompetitionState();
      CustomResponse response = await allCompetitionRepo();
      if (response.success) {
        CompetitionModel _model = CompetitionModel.fromJson(response.response?.data, true);
        yield DoneAllCompetitionState(response.msg, _model.multi);
      } else {
        yield FaildCompetitionState(msg: response.msg, errType: response.errType!, statusCode: response.statusCode);
      }
    }
    if (event is StartAddAnswerCompetitionEvent) {
      yield LoadingCompetitionState();
      CustomResponse response = await _addAnswerRepo(event);
      if (response.success) {
        yield DoneAddAnswerCompetitionState(response.msg);
      } else {
        yield FaildCompetitionState(msg: response.msg, errType: response.errType!, statusCode: response.statusCode);
      }
    }
  }

  Future<CustomResponse> repo() async {
    CustomResponse response = await serverGate.getFromServer(url: "client/competition");
    return response;
  }

  Future<CustomResponse> allCompetitionRepo() async {
    CustomResponse response = await serverGate.getFromServer(url: "client/competition/all_competition");
    return response;
  }

  Future<CustomResponse> _addAnswerRepo(StartAddAnswerCompetitionEvent event) async {
    CustomResponse response = await serverGate.sendToServer(url: "client/competition/add_answer/${event.id}", body: event.body);
    return response;
  }
}
