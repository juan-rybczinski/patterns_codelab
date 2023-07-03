import 'package:patterns_codelab/mortgage/credit_score_service.dart';

sealed class MortgageDecision {}

class MortgageApproved extends MortgageDecision {
  final double amount;

  MortgageApproved({
    required this.amount,
  });
}

class MortgageRejected extends MortgageDecision {}

class MortgageAssessor {
  static const MORTGAGE_MULTIPLIER = 10.0;
  static const GOOD_CREDIT_SCORE_THRESHOLD = 880.0;

  final CreditScoreService creditScoreService;

  MortgageAssessor({
    required this.creditScoreService,
  });

  MortgageDecision assess(int customerId) {
    if (!_isCreditRatingGood(customerId)) {
      return MortgageRejected();
    }

    return MortgageApproved(amount: _getMaxLoanAmount(customerId));
  }

  bool _isCreditRatingGood(int customerId) {
    final response = creditScoreService.query(customerId);
    return response >= GOOD_CREDIT_SCORE_THRESHOLD;
  }

  double _getMaxLoanAmount(int customerId) => 10000000.0;
}
