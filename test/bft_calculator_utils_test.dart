import 'package:bft_calculator/utils/bft_calculator_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BftCalculatorUtils run time parsing', () {
    test('treats missing seconds as zero', () {
      expect(BftCalculatorUtils.parseRunTimeToMinutes('03:'), 3.0);
      expect(BftCalculatorUtils.parseRunTimeToMinutes('03'), 3.0);
      expect(BftCalculatorUtils.parseRunTimeToSeconds('03:'), 180);
      expect(BftCalculatorUtils.validateCalculatorInputs('10', '20', '03:'), isNull);
    });
  });
}
