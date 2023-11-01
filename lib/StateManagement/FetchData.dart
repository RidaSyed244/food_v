// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ProductDetails {
  final String productName;
  final String productPrice;
  final String productImage;
  final String productDescription;

  ProductDetails({
    required this.productName,
    required this.productPrice,
    required this.productImage,
    required this.productDescription,
  });

  ProductDetails copyWith({
    String? productName,
    String? productPrice,
    String? productImage,
    String? productDescription,
  }) {
    return ProductDetails(
      productName: productName ?? this.productName,
      productPrice: productPrice ?? this.productPrice,
      productImage: productImage ?? this.productImage,
      productDescription: productDescription ?? this.productDescription,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'productName': productName,
      'productPrice': productPrice,
      'productImage': productImage,
      'productDescription': productDescription,
    };
  }

  factory ProductDetails.fromMap(Map<String, dynamic> map) {
    return ProductDetails(
      productName: map['productName'] as String,
      productPrice: map['productPrice'] as String,
      productImage: map['productImage'] as String,
      productDescription: map['productDescription'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductDetails.fromJson(String source) =>
      ProductDetails.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Category(productName: $productName, productPrice: $productPrice, productImage: $productImage, productDescription: $productDescription)';
  }

  @override
  bool operator ==(covariant ProductDetails other) {
    if (identical(this, other)) return true;

    return other.productName == productName &&
        other.productPrice == productPrice &&
        other.productImage == productImage &&
        other.productDescription == productDescription;
  }

  @override
  int get hashCode {
    return productName.hashCode ^
        productPrice.hashCode ^
        productImage.hashCode ^
        productDescription.hashCode;
  }
}

class Category {
  final String CategoryName;
  final String CategoryImage;

  Category({
    required this.CategoryName,
    required this.CategoryImage,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'CategoryName': CategoryName,
      'CategoryImage': CategoryImage,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      CategoryName: map['CategoryName'] as String,
      CategoryImage: map['CategoryImage'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Category.fromJson(String source) => Category.fromMap(json.decode(source) as Map<String, dynamic>);
}

class RestrauntLogo {
  final String restraunt_logo;
  final String restaurant_name;
  RestrauntLogo({
    required this.restraunt_logo,
    required this.restaurant_name,
  });

  RestrauntLogo copyWith({
    String? restraunt_logo,
    String? restaurant_name,
  }) {
    return RestrauntLogo(
      restraunt_logo: restraunt_logo ?? this.restraunt_logo,
      restaurant_name: restaurant_name ?? this.restaurant_name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'restraunt_logo': restraunt_logo,
      'restaurant_name': restaurant_name,
    };
  }

  factory RestrauntLogo.fromMap(Map<String, dynamic> map) {
    return RestrauntLogo(
      restraunt_logo: map['restraunt_logo'] as String,
      restaurant_name: map['restaurant_name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory RestrauntLogo.fromJson(String source) =>
      RestrauntLogo.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'RestrauntLogo(restraunt_logo: $restraunt_logo, restaurant_name: $restaurant_name)';

  @override
  bool operator ==(covariant RestrauntLogo other) {
    if (identical(this, other)) return true;

    return other.restraunt_logo == restraunt_logo &&
        other.restaurant_name == restaurant_name;
  }

  @override
  int get hashCode => restraunt_logo.hashCode ^ restaurant_name.hashCode;
}

class storeDetailss {
  final String? restaurant_name;
  final String? restraunt_logo;
  final String? restraunt_Phone;
  final String? restraunt_About;
  final String? restaurant_address;
  final String? deliver_time;
  final String? deliver_charges;
  final String? OrderType;

  storeDetailss({
    this.restaurant_name,
    this.restraunt_logo,
    this.restraunt_Phone,
    this.restraunt_About,
    this.restaurant_address,
    this.deliver_time,
    this.deliver_charges,
    this.OrderType,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'restaurant_name': restaurant_name,
      'restraunt_logo': restraunt_logo,
      'restraunt_Phone': restraunt_Phone,
      'restraunt_About': restraunt_About,
      'restaurant_address': restaurant_address,
      'deliver_time': deliver_time,
      'deliver_charges': deliver_charges,
      'OrderType': OrderType,
    };
  }

  factory storeDetailss.fromMap(Map<String, dynamic> map) {
    return storeDetailss(
      restaurant_name: map['restaurant_name'] != null
          ? map['restaurant_name'] as String
          : null,
      restraunt_logo: map['restraunt_logo'] != null
          ? map['restraunt_logo'] as String
          : null,
      restraunt_Phone: map['restraunt_Phone'] != null
          ? map['restraunt_Phone'] as String
          : null,
      restraunt_About: map['restraunt_About'] != null
          ? map['restraunt_About'] as String
          : null,
      restaurant_address: map['restaurant_address'] != null
          ? map['restaurant_address'] as String
          : null,
      deliver_time:
          map['deliver_time'] != null ? map['deliver_time'] as String : null,
      deliver_charges: map['deliver_charges'] != null
          ? map['deliver_charges'] as String
          : null,
      OrderType: map['OrderType'] != null ? map['OrderType'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory storeDetailss.fromJson(String source) =>
      storeDetailss.fromMap(json.decode(source) as Map<String, dynamic>);
}

/////////////////Rating Reviews///////////////
class AllRatingAndReview {
  final String? Name;
  final String? Email;
  final double? Rating;
  final String? Review;
  final String? url;

  AllRatingAndReview({
    this.Name,
    this.Email,
    this.Rating,
    this.Review,
    this.url,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'Name': Name,
      'Email': Email,
      'Rating': Rating,
      'Review': Review,
      'url': url,
    };
  }

  factory AllRatingAndReview.fromMap(Map<String, dynamic> map) {
    return AllRatingAndReview(
      Name: map['Name'] != null ? map['Name'] as String : null,
      Email: map['Email'] != null ? map['Email'] as String : null,
      Rating: map['Rating'] != null ? map['Rating'] as double : null,
      Review: map['Review'] != null ? map['Review'] as String : null,
      url: map['url'] != null ? map['url'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AllRatingAndReview.fromJson(String source) =>
      AllRatingAndReview.fromMap(json.decode(source) as Map<String, dynamic>);
}
