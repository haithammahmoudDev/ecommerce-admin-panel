/* --
      LIST OF Enums
      They cannot be created inside a class.
-- */

enum AppRole { admin, user }

enum Role { admin, manager, operator, fleetOwner, fleetManager, fleetOperator, driver, user, unknown }

enum ChatType { support }

enum TransactionType { buy, sell }

enum ProductType { single, variable }

enum ProductVisibility { published, hidden }

enum ImageType { asset, network, memory, file }

enum MediaCategory { folders, banners, brands, categories, products, users }

enum ChatMessageStatus { sending, sent, delivered, read, failed }

enum VerificationStatus { unknown, pending, submitted, underReview, approved, rejected }

enum TextSizes { small, medium, large }

enum OrderStatus {processing, shipped, delivered, pending, cancelled}

enum PaymentMethods {paypal, googlepay, applePay, visa, masterCard, creditCard, paystack , razorpay, paytm}
enum BannerTargetType {
  none('none'),
  store('store'),
  product('product'),
  category('category'),
  external('external');

  final String value;
  const BannerTargetType(this.value);

  static BannerTargetType fromValue(String? value) {
    return BannerTargetType.values.firstWhere(
          (type) => type.value == value,
      orElse: () => BannerTargetType.none,
    );
  }

  bool get requiresTarget =>
      this == BannerTargetType.product ||
          this == BannerTargetType.category ||
          this == BannerTargetType.external;

  String get label {
    switch (this) {
      case BannerTargetType.none:
        return 'None';
      case BannerTargetType.store:
        return 'Store';
      case BannerTargetType.product:
        return 'Product';
      case BannerTargetType.category:
        return 'Category';
      case BannerTargetType.external:
        return 'External Link';
    }
  }
}
