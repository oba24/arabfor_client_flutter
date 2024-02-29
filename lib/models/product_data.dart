class ProductData {
  ProductData({
    required this.id,
    required this.name,
    required this.desc,
    required this.category,
    required this.subCategory,
    required this.priceBeforeDicount,
    required this.priceAfterDicount,
    required this.discountPercentage,
    required this.isActive,
    required this.isFav,
    required this.productImage,
    required this.quantity,
    required this.similerProduct,
    required this.user,
    required this.weight,
    required this.ratingValue,
    required this.review,
    required this.reviews,
    required this.deliveryPrice,
    required this.deliveryTime,
    required this.expiryDate,
    required this.offerExpiryDate,
    required this.productDetails,
  });

  int id;
  String name;
  String desc;
  CategoryData category;
  CategoryData subCategory;
  num priceBeforeDicount;
  num priceAfterDicount;
  num discountPercentage;
  bool isActive;
  bool isFav;
  List<ProductImageData> productImage;
  int quantity;
  List<ProductData> similerProduct;
  num get mainPrice => discountPercentage > 0 ? priceAfterDicount : priceBeforeDicount;
  ProviderData user;
  bool get isAvilable => quantity > 0;
  int weight;
  double ratingValue;
  List<ReviewModel> review;
  List<ReviewModel> reviews;

  num deliveryPrice;
  num deliveryTime;

  dynamic expiryDate;
  dynamic offerExpiryDate;
  List<ProductDetail> productDetails;
  List<ColorDatum> get allColors => productDetails.map((e) => e.color).toSet().toList();
  List<SizeDatum> allSuzes(int id) => productDetails.where((e) => e.color.id == id).toList().map((e) => e.size).toList();
  ProductImageData get mainImage => productImage.isEmpty ? ProductImageData.fromJson({}) : productImage.first;
  factory ProductData.fromJson(Map<String, dynamic> json) => ProductData(
        id: json["id"] ?? 0,
        name: json["name"] ?? '',
        desc: json["desc"] ?? '',
        category: CategoryData.fromJson(json["category"] ?? {}),
        subCategory: CategoryData.fromJson(json["sub_category"] ?? {}),
        priceBeforeDicount: json["price_before_dicount"] ?? 0,
        priceAfterDicount: json["price_after_dicount"] ?? 0,
        discountPercentage: json["discount_percentage"] ?? 0,
        isActive: json["is_active"] ?? false,
        isFav: json["is_fav"] ?? false,
        productImage: List<ProductImageData>.from((json["product_image"] ?? []).map((x) => ProductImageData.fromJson(x))),
        quantity: json["quantity"] ?? 1,
        similerProduct: List<ProductData>.from((json["similerProduct"] ?? []).map((x) => ProductData.fromJson(x))),
        deliveryPrice: json["delivery_price"] ?? 0,
        deliveryTime: json["delivery_time"] ?? 0,
        expiryDate: json["expiry_date"] ?? '',
        offerExpiryDate: json["offer_expiry_date"] ?? '',
        productDetails: List<ProductDetail>.from((json["product_details"] ?? []).map((x) => ProductDetail.fromJson(x))),
        ratingValue: (json["rating_value"] ?? 0) + 0.0,
        review: List<ReviewModel>.from((json["review"] ?? []).map((x) => ReviewModel.fromJson(x))),
        reviews: List<ReviewModel>.from((json["reviews"] ?? []).map((x) => ReviewModel.fromJson(x))),
        user: ProviderData.fromJson(json["user"] ?? {}),
        weight: json["weight"] ?? 0,
      );
}

class CategoryData {
  CategoryData({
    required this.id,
    required this.name,
    required this.desc,
    required this.categoryImage,
    required this.subCategoryImage,
  });

  int id;
  String name;
  String desc;
  String categoryImage;
  String subCategoryImage;

  factory CategoryData.fromJson(Map<String, dynamic> json) => CategoryData(
        id: json["id"] ?? 0,
        name: json["name"] ?? '',
        desc: json["desc"] ?? '',
        categoryImage: json["category_image"] ?? '',
        subCategoryImage: json["sub_category_image"] ?? '',
      );
}

class ProductImageData {
  ProductImageData({
    required this.id,
    required this.url,
  });

  int id;
  String url;

  factory ProductImageData.fromJson(Map<String, dynamic> json) => ProductImageData(
        id: json["id"] ?? 0,
        url: json["url"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "url": url,
      };
}

class ProductDetail {
  ProductDetail({
    required this.id,
    required this.size,
    required this.color,
    required this.weight,
    required this.priceBeforeDicount,
    required this.priceAfterDicount,
    required this.discountPercentage,
    required this.isActive,
    required this.expiryDate,
  });

  int id;
  SizeDatum size;
  ColorDatum color;
  dynamic weight;
  dynamic priceBeforeDicount;
  dynamic priceAfterDicount;
  dynamic discountPercentage;
  bool isActive;
  dynamic expiryDate;

  factory ProductDetail.fromJson(Map<String, dynamic> json) => ProductDetail(
        id: json["id"] ?? 0,
        size: SizeDatum.fromJson(json["size"] ?? {}),
        color: ColorDatum.fromJson(json["color"] ?? {}),
        weight: json["weight"] ?? '',
        priceBeforeDicount: json["price_before_dicount"] ?? 0,
        priceAfterDicount: json["price_after_dicount"] ?? 0,
        discountPercentage: json["discount_percentage"] ?? 0,
        isActive: json["is_active"] ?? false,
        expiryDate: json["expiry_date"] ?? '',
      );
}

class ColorDatum {
  ColorDatum({
    required this.id,
    required this.hexValue,
    required this.name,
  });

  int id;
  String hexValue;
  String name;

  factory ColorDatum.fromJson(Map<String, dynamic> json) => ColorDatum(
        id: json["id"] ?? 0,
        hexValue: json["hex_value"] ?? '#FFFFFF',
        name: json["name"] ?? '',
      );
  @override
  bool operator ==(Object other) => identical(this, other) || other is ColorDatum && runtimeType == other.runtimeType && id == other.id;
  @override
  int get hashCode => id.hashCode;
}

class SizeDatum {
  SizeDatum({
    required this.id,
    required this.name,
    required this.abbreviation,
  });

  int id;
  String name;
  String abbreviation;

  factory SizeDatum.fromJson(Map<String, dynamic> json) => SizeDatum(
        id: json["id"] ?? 0,
        name: json["name"] ?? '',
        abbreviation: json["abbreviation"] ?? '',
      );
}

class ProviderData {
  ProviderData({
    required this.id,
    required this.userType,
    required this.userName,
    required this.phone,
    required this.email,
    required this.image,
    required this.commercialRegisterImage,
    required this.logo,
    required this.lang,
    required this.lastLoginAt,
  });

  int id;
  String userType;
  String userName;
  String phone;
  String email;
  String image;
  String commercialRegisterImage;
  String logo;
  String lang;
  String lastLoginAt;

  factory ProviderData.fromJson(Map<String, dynamic> json) => ProviderData(
        id: json["id"] ?? 0,
        userType: json["user_type"] ?? '',
        userName: json["user_name"] ?? '',
        phone: json["phone"] ?? '',
        email: json["email"] ?? '',
        image: json["image"] ?? '',
        commercialRegisterImage: json["commercial_register_image"] ?? '',
        logo: json["logo"] ?? '',
        lang: json["lang"] ?? '',
        lastLoginAt: json["last_login_at"] ?? '',
      );
}

class ReviewModel {
  ReviewModel({
    required this.id,
    required this.client,
    required this.ratingValue,
    required this.comment,
  });

  int id;
  ReviewClientDatum client;
  num ratingValue;
  String comment;

  factory ReviewModel.fromJson(Map<String, dynamic> json) => ReviewModel(
        id: json["id"] ?? 0,
        client: ReviewClientDatum.fromJson(json["client"] ?? {}),
        ratingValue: json["rating_value"] ?? 0,
        comment: json["comment"] ?? '',
      );
}

class ReviewClientDatum {
  ReviewClientDatum({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  int id;
  String name;
  String imageUrl;

  factory ReviewClientDatum.fromJson(Map<String, dynamic> json) => ReviewClientDatum(
        id: json["id"] ?? 0,
        name: json["name"] ?? "",
        imageUrl: json["image"] ?? "",
      );
}
