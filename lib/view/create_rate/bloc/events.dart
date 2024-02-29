class AddRatingEvent {}

class StartAddRatingEvent extends AddRatingEvent {
  final dynamic id;
  final String comment;
  final num ratingValue;

  StartAddRatingEvent(
      {required this.id, required this.comment, required this.ratingValue});
}
