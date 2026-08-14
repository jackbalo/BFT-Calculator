/// Data model to pass information between pages
class BftUserData {
  final int age;
  final String gender;
  final String ageCategory;
  final int pushupsMark;
  final int situpsMark;
  final String runTimeMark;

  BftUserData({
    required this.age,
    required this.gender,
    required this.ageCategory,
    required this.pushupsMark,
    required this.situpsMark,
    required this.runTimeMark,
  });
}
