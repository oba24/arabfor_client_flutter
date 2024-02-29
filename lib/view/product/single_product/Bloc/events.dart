class ProductDetailEvent {}

class StartProductDetailEvent extends ProductDetailEvent {
  final dynamic id;

  StartProductDetailEvent(this.id);
}
