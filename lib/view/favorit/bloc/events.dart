class FavoriteEvent {}

class StartFavoriteEvent extends FavoriteEvent {
  Map<String, dynamic> get body => {};

  StartFavoriteEvent();
}

class StartFavoriteControllerEvent extends FavoriteEvent {
  int id;
  Map<String, dynamic> get body => {"product_id": id};

  StartFavoriteControllerEvent(this.id);
}
