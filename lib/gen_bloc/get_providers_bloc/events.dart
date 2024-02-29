class GetCategoryProvidersEvent {}

class StartGetCategoryProvidersEvent extends GetCategoryProvidersEvent {
  final int id;

  StartGetCategoryProvidersEvent(this.id);
}
