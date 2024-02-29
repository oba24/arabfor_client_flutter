class StoreDetailEvent {}

class StartStoreDetailEvent extends StoreDetailEvent {
  final dynamic id;

  StartStoreDetailEvent(this.id);
}
