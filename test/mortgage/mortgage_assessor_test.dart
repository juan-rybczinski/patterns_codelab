import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:patterns_codelab/mortgage/credit_score_service.dart';
import 'package:patterns_codelab/mortgage/mortgage_assessor.dart';

class MockCreditScoreService extends Mock implements CreditScoreService {}

void main() {
  group('MortgageAssessor', () {
    // 테스트 상수도 상태/설정 공유와 동일한 효과를 낸다
    const customerId = 1234;

    late CreditScoreService creditScoreService;
    late MortgageAssessor mortgageAssessor;

    setUpAll(() {
      // 11.4.3 설정 공유는 문제가 될 수 있다
      creditScoreService = MockCreditScoreService();
    });

    setUp(() {
      // 11.4.5 설정 공유가 적절한 경우
      mortgageAssessor = MortgageAssessor(creditScoreService: creditScoreService);
    });

    tearDown(() {
      reset(creditScoreService);
    });

    test('CreditScore가 GOOD_CREDIT_SCORE_THRESHOLD 이상이면 1천만원 대출 실행', () {
      // 11.4.4 해결책: 중요한 설정은 테스트 케이스 내에서 정의하라
      when(() => creditScoreService.query(customerId)).thenReturn(1000.0);

      final result = mortgageAssessor.assess(customerId);
      
      expect(result, MortgageApproved(amount: 10000000.0));
    });

    test('CreditScore가 GOOD_CREDIT_SCORE_THRESHOLD 미만이면 대출 거부', () {
      // 11.4.4 해결책: 중요한 설정은 테스트 케이스 내에서 정의하라
      when(() => creditScoreService.query(customerId)).thenReturn(500.0);

      final result = mortgageAssessor.assess(customerId);

      expect(result, MortgageRejected());
    });
  });
}
