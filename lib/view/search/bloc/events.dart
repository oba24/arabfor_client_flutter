class SearchEvent {}

class StartSearchEvent extends SearchEvent {
  final dynamic id;

  StartSearchEvent(this.id);
}
