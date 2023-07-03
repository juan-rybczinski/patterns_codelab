import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:patterns_codelab/mortgage/credit_score_service.dart';
import 'package:patterns_codelab/mortgage/mortgage_assessor.dart';

class MockCreditScoreService extends Mock implements CreditScoreService {}

void main() {
  group('MortgageAssessor', () {
    test('CreditScore가 GOOD_CREDIT_SCORE_THRESHOLD 이상이면 1천만원 대출 실행', () {
      const customerId = 1234;
      final creditScoreService = MockCreditScoreService();
      when(() => creditScoreService.query(customerId)).thenReturn(1000.0);
      final mortgageAssessor = MortgageAssessor(creditScoreService: creditScoreService);

      final result = mortgageAssessor.assess(customerId);
      
      expect(result, MortgageApproved(amount: 10000000.0));
    });

    test('CreditScore가 GOOD_CREDIT_SCORE_THRESHOLD 미만이면 대출 거부', () {
      const customerId = 1234;
      final creditScoreService = MockCreditScoreService();
      when(() => creditScoreService.query(customerId)).thenReturn(500.0);
      final mortgageAssessor = MortgageAssessor(creditScoreService: creditScoreService);

      final result = mortgageAssessor.assess(customerId);

      expect(result, MortgageRejected());
    });
  });
}
