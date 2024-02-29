class CartEvent {}

class StartGetCartEvent extends CartEvent {
  StartGetCartEvent();
}

class StartControllerCartEvent extends CartEvent {
  String type; // add - delete - update
  int id;
  int? colorId, providerId, quantity, sizeId;

  String get url => {"delete": "client/delete_item/$id", "add": "client/add_item", "update": "client/update_item_quantity/$id"}[type] ?? "";

  Map<String, dynamic> get body => {
        if (type == "delete") "_method": "DELETE",
        "provider_id": providerId,
        "product_id": id,
        "quantity": quantity,
        "color_id": colorId,
        "size_id": sizeId,
      };
  StartControllerCartEvent({
    required this.type,
    required this.id,
    this.colorId,
    this.providerId,
    this.quantity,
    this.sizeId,
  });
}

class StartApplyCouponEvent extends CartEvent {
  String text;
  StartApplyCouponEvent(this.text);
}
