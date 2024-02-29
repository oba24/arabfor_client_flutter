class CartModel {
  CartModel({
    required this.data,
    required this.totalProductsPrice,
    required this.dicount,
    required this.deliveryPrice,
    required this.totalPrice,
    required this.message,
  });

  CartDatum data;
  double totalProductsPrice;
  double dicount;
  double deliveryPrice;
  double totalPrice;
  String message;

  factory CartModel.fromJson(Map<String, dynamic> json) => CartModel(
        data: CartDatum.fromJson(json["data"] ?? {}),
        totalProductsPrice: (json["total_products_price"] ?? 0) + 0.0,
        dicount: (json["dicount"] ?? 0) + 0.0,
        deliveryPrice: (json["delivery_price"] ?? 0) + 0.0,
        totalPrice: (json["total_price"] ?? 0) + 0.0,
        message: json["message"] ?? "",
      );
}

class CartDatum {
  CartDatum({
    required this.cartId,
    required this.items,
  });

  int cartId;
  List<CartItemDatum> items;

  factory CartDatum.fromJson(Map<String, dynamic> json) => CartDatum(
        cartId: json["cart_id"] ?? 0,
        items: List<CartItemDatum>.from((json["items"] ?? []).map((x) => CartItemDatum.fromJson(x))),
      );
}

class CartItemDatum {
  CartItemDatum({
    required this.cartItemId,
    required this.quantity,
    required this.product,
    required this.localQuantity,
  });

  int cartItemId;
  int quantity;
  int localQuantity;
  _Product product;

  factory CartItemDatum.fromJson(Map<String, dynamic> json) => CartItemDatum(
        cartItemId: json["cart_item_id"] ?? 0,
        quantity: json["quantity"] ?? 0,
        localQuantity: json["quantity"] ?? 0,
        product: _Product.fromJson(json["product"] ?? {}),
      );
}

class _Product {
  _Product({
    required this.id,
    required this.name,
    required this.priceBeforeDicount,
    required this.priceAfterDicount,
    required this.image,
    required this.isFav,
    required this.quantity,
  });

  int id;
  String name;
  double priceBeforeDicount;
  double priceAfterDicount;
  String image;
  bool isFav;
  bool get withDiscount => priceAfterDicount > 0;
  bool get isAvilable => quantity > 0;

  int quantity;

  factory _Product.fromJson(Map<String, dynamic> json) => _Product(
        id: json["id"] ?? 0,
        name: json["name"] ?? "",
        priceBeforeDicount: (json["price_before_dicount"] ?? 0) + 0.0,
        priceAfterDicount: (json["price_after_dicount"] ?? 0) + 0.0,
        image: json["image"] ?? "",
        isFav: json["is_fav"] ?? false,
        quantity: json["quantity"] ?? 0,
      );
}
