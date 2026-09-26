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
