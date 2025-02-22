import 'package:restaurant_app/data/model/customer_review.dart';

class AddReviewRequest {
  final bool error;
  final String message;
  final List<CustomerReview> customerReviews;

  AddReviewRequest({
    required this.error,
    required this.message,
    required this.customerReviews,
  });
}