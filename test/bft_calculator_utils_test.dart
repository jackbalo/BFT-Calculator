import 'package:flutter_test/flutter_test.dart';
import 'package:bft_calculator/constants/bft_standards.dart';
import 'package:bft_calculator/utils/bft_calculator_utils.dart';

void main() {
  group('BFT chart scoring', () {
    test('all existing pass marks score 60 points', () {
      for (final standards in BftStandards.maleStandards) {
        final age = standards[0] as int;
        expect(
          BftCalculatorUtils.calculatePushupsPercentage(
            standards[2] as int,
            age,
            'male',
          ),
          60,
          reason: 'male push-ups age $age',
        );
        expect(
          BftCalculatorUtils.calculateSitupsPercentage(
            standards[3] as int,
            age,
            'male',
          ),
          60,
          reason: 'male sit-ups age $age',
        );
        expect(
          BftCalculatorUtils.calculateRunningPercentage(
            BftCalculatorUtils.parseRunTimeToSeconds(standards[4] as String),
            age,
            'male',
          ),
          60,
          reason: 'male run age $age',
        );
      }

      for (final standards in BftStandards.femaleStandards) {
        final age = standards[0] as int;
        expect(
          BftCalculatorUtils.calculatePushupsPercentage(
            standards[2] as int,
            age,
            'female',
          ),
          60,
          reason: 'female push-ups age $age',
        );
        expect(
          BftCalculatorUtils.calculateSitupsPercentage(
            standards[3] as int,
            age,
            'female',
          ),
          60,
          reason: 'female sit-ups age $age',
        );
        expect(
          BftCalculatorUtils.calculateRunningPercentage(
            BftCalculatorUtils.parseRunTimeToSeconds(standards[4] as String),
            age,
            'female',
          ),
          60,
          reason: 'female run age $age',
        );
      }
    });

    test('all chart endpoints score 100 points', () {
      const ages = [18, 22, 27, 32, 37, 42, 47, 52];
      const malePushups = [82, 80, 78, 73, 72, 66, 62, 56];
      const femalePushups = [58, 56, 54, 52, 48, 45, 41, 40];
      const maleSitups = [92, 87, 82, 78, 73, 69, 67, 66];
      const femaleSitups = [90, 85, 80, 75, 70, 67, 64, 62];
      const maleRunSeconds = [714, 756, 798, 840, 882, 906, 936, 960];
      const femaleRunSeconds = [894, 936, 942, 1116, 1176, 1200, 1230, 1260];

      for (var index = 0; index < ages.length; index++) {
        expect(
          BftCalculatorUtils.calculatePushupsPercentage(
            malePushups[index],
            ages[index],
            'male',
          ),
          100,
        );
        expect(
          BftCalculatorUtils.calculatePushupsPercentage(
            femalePushups[index],
            ages[index],
            'female',
          ),
          100,
        );
        expect(
          BftCalculatorUtils.calculateSitupsPercentage(
            maleSitups[index],
            ages[index],
            'male',
          ),
          100,
        );
        expect(
          BftCalculatorUtils.calculateSitupsPercentage(
            femaleSitups[index],
            ages[index],
            'female',
          ),
          100,
        );
        expect(
          BftCalculatorUtils.calculateRunningPercentage(
            maleRunSeconds[index],
            ages[index],
            'male',
          ),
          100,
        );
        expect(
          BftCalculatorUtils.calculateRunningPercentage(
            femaleRunSeconds[index],
            ages[index],
            'female',
          ),
          100,
        );
      }
    });

    test('looks up push-up scores by age and gender', () {
      expect(
        BftCalculatorUtils.calculatePushupsPercentage(42, 18, 'male'),
        60,
      );
      expect(
        BftCalculatorUtils.calculatePushupsPercentage(82, 18, 'male'),
        100,
      );
      expect(
        BftCalculatorUtils.calculatePushupsPercentage(18, 18, 'male'),
        36,
      );
      expect(
        BftCalculatorUtils.calculatePushupsPercentage(18, 18, 'female'),
        60,
      );
    });

    test('looks up sit-up scores by age and gender', () {
      expect(
        BftCalculatorUtils.calculateSitupsPercentage(52, 18, 'male'),
        60,
      );
      expect(
        BftCalculatorUtils.calculateSitupsPercentage(92, 18, 'male'),
        100,
      );
      expect(
        BftCalculatorUtils.calculateSitupsPercentage(50, 18, 'female'),
        60,
      );
      expect(
        BftCalculatorUtils.calculateSitupsPercentage(90, 18, 'female'),
        100,
      );
    });

    test('uses the next slower run chart bracket', () {
      expect(
        BftCalculatorUtils.calculateRunningPercentage(15 * 60 + 54, 18, 'male'),
        60,
      );
      expect(
        BftCalculatorUtils.calculateRunningPercentage(15 * 60 + 55, 18, 'male'),
        59,
      );
      expect(
        BftCalculatorUtils.calculateRunningPercentage(11 * 60 + 54, 18, 'male'),
        100,
      );
      expect(
        BftCalculatorUtils.calculateRunningPercentage(18 * 60 + 54, 18, 'female'),
        60,
      );
    });

    test('returns zero outside the charted performance range', () {
      expect(
        BftCalculatorUtils.calculatePushupsPercentage(0, 18, 'male'),
        0,
      );
      expect(
        BftCalculatorUtils.calculateRunningPercentage(19 * 60 + 24, 18, 'male'),
        0,
      );
    });
  });
}