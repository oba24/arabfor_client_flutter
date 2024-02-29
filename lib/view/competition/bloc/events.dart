class CompetitionEvent {}

class StartCompetitionEvent extends CompetitionEvent {
  Map<String, dynamic> get body => {};

  StartCompetitionEvent();
}

class StartAllCompetitionEvent extends CompetitionEvent {
  Map<String, dynamic> get body => {};

  StartAllCompetitionEvent();
}

class StartAddAnswerCompetitionEvent extends CompetitionEvent {
  int id;
  String answer;
  Map<String, dynamic> get body => {"answer": answer};

  StartAddAnswerCompetitionEvent(this.answer, this.id);
}
