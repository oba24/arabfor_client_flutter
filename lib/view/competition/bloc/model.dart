import 'package:easy_localization/easy_localization.dart';

class CompetitionModel {
  CompetitionModel({
    required this.single,
    required this.multi,
    required this.message,
  });

  CompetitionData single;
  List<PreviousMonthWinnersDatum> multi;
  String message;

  factory CompetitionModel.fromJson(Map<String, dynamic> json, [bool multi = false]) => CompetitionModel(
        single: CompetitionData.fromJson(!multi ? (json["data"] ?? {}) : {}),
        message: json["message"] ?? "",
        multi: multi ? List<PreviousMonthWinnersDatum>.from((json["data"] ?? []).map((x) => PreviousMonthWinnersDatum.fromJson(x))) : [],
      );
}

class CompetitionData {
  CompetitionData({
    required this.id,
    required this.month,
    required this.question,
    required this.previousMonthWinners,
  });

  int id;
  String month;
  String question;
  PreviousMonthWinnersDatum previousMonthWinners;

  factory CompetitionData.fromJson(Map<String, dynamic> json) => CompetitionData(
        id: json["id"] ?? 0,
        month: json["month"] ?? "",
        question: json["question"] ?? "",
        previousMonthWinners: PreviousMonthWinnersDatum.fromJson(json["previous_month_winners"] ?? {}),
      );
}

class PreviousMonthWinnersDatum {
  PreviousMonthWinnersDatum({
    required this.id,
    required this.month,
    required this.question,
    required this.correctAnswer,
    required this.winners,
  });

  int id;
  String month;
  String question;
  String correctAnswer;
  List<WinnerDatum> winners;

  factory PreviousMonthWinnersDatum.fromJson(Map<String, dynamic> json) => PreviousMonthWinnersDatum(
        id: json["id"] ?? 0,
        month: json["month"] ?? "",
        question: json["question"] ?? "",
        correctAnswer: json["correct_answer"] ?? "",
        winners: [
          WinnerDatum.fromJson(json["first_winner"] ?? {}, "first_winner"),
          WinnerDatum.fromJson(json["second_winner"] ?? {}, "second_winner"),
          WinnerDatum.fromJson(json["third_winner"] ?? {}, "third_winner")
        ],
      );
}

class WinnerDatum {
  WinnerDatum({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.prize,
    required this.place,
  });

  int id;
  String name;
  String imageUrl;
  String prize;
  String place;

  factory WinnerDatum.fromJson(Map<String, dynamic> json, String key) => WinnerDatum(
        id: json["id"] ?? 0,
        name: json["name"] ?? "",
        imageUrl: json["image_url"] ?? "https://www.salonlfc.com/wp-content/uploads/2018/01/image-not-found-scaled-1150x647.png",
        prize: json["prize"] ?? "",
        place: key.tr(),
      );
}
