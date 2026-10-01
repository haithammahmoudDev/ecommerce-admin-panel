

enum AppRole { admin, user }

enum Role {
  admin,
  manager,
  operator,
  fleetOwner,
  fleetManager,
  fleetOperator,
  driver,
  user,
  unknown,
}

enum ChatType { support }

enum TransactionType { buy, sell }

enum ProductType { single, variable }

enum ProductVisibility { published, hidden }

enum ImageType { asset, network, memory, file }

enum MediaCategory { folders, banners, brands, categories, products, users }

enum ChatMessageStatus { sending, sent, delivered, read, failed }

enum VerificationStatus {
  unknown,
  pending,
  submitted,
  underReview,
  approved,
  rejected,
}

enum TextSizes { small, medium, large }

enum OrderStatus { processing, shipped, delivered, pending, cancelled }

enum PaymentMethods {
  paypal,
  googlePay,
  applePay,
  visa,
  masterCard,
  creditCard,
  payStack,
  razorpay,
  paytm,
}

enum BannerTargetType {
  none,
  store,
  product,
  category,
  external;

  bool get requiresTarget =>
      this == BannerTargetType.product ||
      this == BannerTargetType.category ||
      this == BannerTargetType.external;
}
