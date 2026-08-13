import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

// Data model to pass information between pages
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BFT Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0F6CBD)),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F9FF),
        textTheme: GoogleFonts.poppinsTextTheme(),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFDBE8F8)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFF0F6CBD), width: 1.8),
          ),
        ),
      ),
      home: const BftInputPage(),
    );
  }
}

// ============== INPUT PAGE ==============
class BftInputPage extends StatefulWidget {
  const BftInputPage({super.key});

  @override
  State<BftInputPage> createState() => _BftInputPageState();
}

class _BftInputPageState extends State<BftInputPage> {
  final _ageController = TextEditingController();
  String? _selectedGender;
  String? _errorMessage;

  static const List<List<dynamic>> maleStandards = [
    [18, 21, 42, 52, '15:54'],
    [22, 26, 40, 47, '16:36'],
    [27, 31, 38, 42, '17:18'],
    [32, 36, 33, 38, '18:00'],
    [37, 41, 32, 33, '18:42'],
    [42, 46, 26, 29, '19:06'],
    [47, 51, 22, 27, '19:36'],
    [52, 56, 16, 26, '20:00']
  ];

  static const List<List<dynamic>> femaleStandards = [
    [18, 21, 18, 50, '18:54'],
    [22, 26, 16, 45, '19:36'],
    [27, 31, 15, 40, '19:42'],
    [32, 36, 14, 35, '22:36'],
    [37, 41, 13, 30, '23:36'],
    [42, 46, 12, 27, '24:00'],
    [47, 51, 10, 24, '24:30'],
    [52, 56, 9, 22, '25:00']
  ];

  @override
  void dispose() {
    _ageController.dispose();
    super.dispose();
  }

  void _clearForm() {
    setState(() {
      _ageController.clear();
      _selectedGender = null;
      _errorMessage = null;
    });
  }

  void _proceedToOptions() {
    setState(() {
      _errorMessage = null;
    });

    final ageText = _ageController.text.trim();
    final gender = _selectedGender;

    if (gender == null || gender.isEmpty) {
      setState(() {
        _errorMessage = 'Please select your gender.';
      });
      return;
    }

    if (ageText.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter your age.';
      });
      return;
    }

    final age = int.tryParse(ageText);
    if (age == null || age < 18 || age > 60) {
      setState(() {
        _errorMessage = 'Age must be between 18 and 60.';
      });
      return;
    }

    final standards = gender == 'male' ? maleStandards : femaleStandards;
    final entry = standards.firstWhere(
      (item) => age >= item[0] && age <= item[1],
      orElse: () => const [],
    );

    if (entry.isEmpty) {
      setState(() {
        _errorMessage = 'No matching standard was found.';
      });
      return;
    }

    final userData = BftUserData(
      age: age,
      gender: gender,
      ageCategory: '${entry[0]}-${entry[1]}',
      pushupsMark: entry[2] as int,
      situpsMark: entry[3] as int,
      runTimeMark: entry[4] as String,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PassMarkDetailPage(userData: userData),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 12.0), // Adds space from the screen edge
          child: Image.asset(
            'assets/gaf3.jpg', 
            fit: BoxFit.contain, // Prevents the logo from distorting
          ),
        ),
  
  // 2. Optional: Adjust width so the logo doesn't clip if it's wide
        leadingWidth: 56, 
        title: const Text('BFT Calculator'),
        centerTitle: true,
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  const SizedBox(height: 20),
                  Card(
                    elevation: 0,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F7FF),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.fitness_center, color: primaryColor),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    'Enter your details to get started',
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: const Color(0xFF4E5B6D),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          DropdownButtonFormField<String>(
                            key: const Key('genderField'),
                            decoration: const InputDecoration(
                              labelText: 'Gender',
                            ),
                            initialValue: _selectedGender,
                            items: const [
                              DropdownMenuItem(value: 'male', child: Text('Male')),
                              DropdownMenuItem(value: 'female', child: Text('Female')),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _selectedGender = value;
                              });
                            },
                          ),
                          const SizedBox(height: 14),
                          TextField(
                            key: const Key('ageField'),
                            controller: _ageController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Age',
                              hintText: '18 to 60',
                            ),
                          ),
                          const SizedBox(height: 20),
                          FilledButton.icon(
                            onPressed: _proceedToOptions,
                            icon: const Icon(Icons.arrow_forward_rounded),
                            label: const Text('Proceed'),
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          OutlinedButton.icon(
                            onPressed: _clearForm,
                            icon: const Icon(Icons.clear_all_rounded),
                            label: const Text('Clear'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              side: const BorderSide(color: Color(0xFFD32F2F)),
                              foregroundColor: const Color(0xFFD32F2F),
                              backgroundColor: const Color(0xFFFFF5F5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                          if (_errorMessage != null) ...[
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF1F1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                _errorMessage!,
                                style: const TextStyle(
                                  color: Color(0xFFC62828),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============== PASS MARK DETAIL PAGE ==============
class PassMarkDetailPage extends StatelessWidget {
  final BftUserData userData;

  const PassMarkDetailPage({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Options'),
        centerTitle: true,
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  Card(
                    elevation: 0,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F7FF),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.person, color: primaryColor),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    '${userData.gender.toUpperCase()} | Age: ${userData.age}',
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: const Color(0xFF4E5B6D),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'What would you like to do?',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 16),
                          FilledButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      CheckPassMarkPage(userData: userData),
                                ),
                              );
                            },
                            icon: const Icon(Icons.check_circle_outline),
                            label: const Text('Check BFT Pass Mark'),
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              backgroundColor: const Color(0xFF0F6CBD),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          FilledButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      BftCalculatorPage(userData: userData),
                                ),
                              );
                            },
                            icon: const Icon(Icons.calculate_outlined),
                            label: const Text('Calculate BFT Percentage'),
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              backgroundColor: const Color(0xFF2196F3),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============== CHECK PASS MARK PAGE ==============
class CheckPassMarkPage extends StatelessWidget {
  final BftUserData userData;

  const CheckPassMarkPage({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pass Mark Requirements'),
        centerTitle: true,
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  Card(
                    elevation: 0,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.check_circle_outline,
                                  color: primaryColor),
                              const SizedBox(width: 8),
                              const Text(
                                'PASS REQUIREMENT',
                                style: TextStyle(
                                  color: Color(0xFF17324D),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _ResultRow(
                              label: 'Age category',
                              value: userData.ageCategory),
                          _ResultRow(
                              label: 'Push-ups (2 min)',
                              value: '${userData.pushupsMark}'),
                          _ResultRow(
                              label: 'Sit-ups (2 min)',
                              value: '${userData.situpsMark}'),
                          _ResultRow(
                              label: '3.2 km run time',
                              value: userData.runTimeMark),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF5E6),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: const Color(0xFFFFB74D)),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.info_outline,
                                    color: Color(0xFFF57C00), size: 20),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    'These are the minimum scores needed to pass at 60% (passmark)',
                                    style: TextStyle(
                                      color: Color(0xFFF57C00),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Back'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============== BFT CALCULATOR PAGE ==============
class BftCalculatorPage extends StatefulWidget {
  final BftUserData userData;

  const BftCalculatorPage({super.key, required this.userData});

  @override
  State<BftCalculatorPage> createState() => _BftCalculatorPageState();
}

class _BftCalculatorPageState extends State<BftCalculatorPage> {
  final _pushupsController = TextEditingController();
  final _situpsController = TextEditingController();
  final _runningMinutesController = TextEditingController();
  String? _errorMessage;
  bool _showResults = false;

  late double _pushupsPercentage;
  late double _situpsPercentage;
  late double _runningPercentage;
  late double _averagePercentage;

  @override
  void dispose() {
    _pushupsController.dispose();
    _situpsController.dispose();
    _runningMinutesController.dispose();
    super.dispose();
  }

  void _calculatePercentages() {
    setState(() {
      _errorMessage = null;
      _showResults = false;
    });

    final pushupsText = _pushupsController.text.trim();
    final situpsText = _situpsController.text.trim();
    final runningText = _runningMinutesController.text.trim();

    if (pushupsText.isEmpty ||
        situpsText.isEmpty ||
        runningText.isEmpty) {
      setState(() {
        _errorMessage = 'Please fill in all fields.';
      });
      return;
    }

    final pushups = int.tryParse(pushupsText);
    final situps = int.tryParse(situpsText);
    final runningMinutes = double.tryParse(runningText);

    if (pushups == null || situps == null || runningMinutes == null) {
      setState(() {
        _errorMessage = 'Please enter valid numbers.';
      });
      return;
    }

    // Parse run time mark (e.g., "15:54")
    final parts = widget.userData.runTimeMark.split(':');
    final passmarkMinutes = int.parse(parts[0]);
    final passmarkSeconds = int.parse(parts[1]);
    final passmarkTotalSeconds =
        passmarkMinutes * 60 + passmarkSeconds;

    // Calculate percentages
    // Passmark represents 60%
    // For pushups and situps: each count above passmark = 1%
    _pushupsPercentage = 60.0 + (pushups - widget.userData.pushupsMark).toDouble();
    _situpsPercentage = 60.0 + (situps - widget.userData.situpsMark).toDouble();

    // For running: each minute below passmark = 10% addition
    final runningSeconds = runningMinutes * 60;
    final secondsDifference = passmarkTotalSeconds - runningSeconds;
    _runningPercentage = 60.0 + (secondsDifference / 60) * 10.0;

    // Cap percentages at 100%
    _pushupsPercentage = _pushupsPercentage > 100.0 ? 100.0 : _pushupsPercentage;
    _situpsPercentage = _situpsPercentage > 100.0 ? 100.0 : _situpsPercentage;
    _runningPercentage = _runningPercentage > 100.0 ? 100.0 : _runningPercentage;

    // Ensure no negative percentages
    _pushupsPercentage = _pushupsPercentage < 0.0 ? 0.0 : _pushupsPercentage;
    _situpsPercentage = _situpsPercentage < 0.0 ? 0.0 : _situpsPercentage;
    _runningPercentage = _runningPercentage < 0.0 ? 0.0 : _runningPercentage;

    // Calculate average
    _averagePercentage =
        (_pushupsPercentage + _situpsPercentage + _runningPercentage) / 3;

    setState(() {
      _showResults = true;
    });
  }

  void _clearForm() {
    setState(() {
      _pushupsController.clear();
      _situpsController.clear();
      _runningMinutesController.clear();
      _errorMessage = null;
      _showResults = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculate Percentage'),
        centerTitle: true,
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  const SizedBox(height: 20),
                  Card(
                    elevation: 0,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F7FF),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.fitness_center, color: primaryColor),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    'Enter your BFT activity results',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: const Color(0xFF4E5B6D),
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            controller: _pushupsController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Push-ups (count)',
                              hintText: 'e.g., 45',
                            ),
                          ),
                          const SizedBox(height: 14),
                          TextField(
                            controller: _situpsController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Sit-ups (count)',
                              hintText: 'e.g., 55',
                            ),
                          ),
                          const SizedBox(height: 14),
                          TextField(
                            controller: _runningMinutesController,
                            keyboardType:
                                const TextInputType.numberWithOptions(
                                    decimal: true),
                            decoration: const InputDecoration(
                              labelText: 'Running time (minutes)',
                              hintText: 'e.g., 15.5',
                            ),
                          ),
                          const SizedBox(height: 20),
                          FilledButton.icon(
                            onPressed: _calculatePercentages,
                            icon: const Icon(Icons.calculate_outlined),
                            label: const Text('Calculate'),
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          OutlinedButton.icon(
                            onPressed: _clearForm,
                            icon: const Icon(Icons.clear_all_rounded),
                            label: const Text('Clear'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              side: const BorderSide(
                                  color: Color(0xFFD32F2F)),
                              foregroundColor: const Color(0xFFD32F2F),
                              backgroundColor: const Color(0xFFFFF5F5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                          if (_errorMessage != null) ...[
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF1F1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                _errorMessage!,
                                style: const TextStyle(
                                  color: Color(0xFFC62828),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                          if (_showResults) ...[
                            const SizedBox(height: 24),
                            Container(
                              padding: const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF7FBFF),
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                    color: const Color(0xFFDAEAFD)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.04),
                                    blurRadius: 10,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.assessment_outlined,
                                        color: primaryColor,
                                      ),
                                      const SizedBox(width: 8),
                                      const Text(
                                        'YOUR RESULTS',
                                        style: TextStyle(
                                          color: Color(0xFF17324D),
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  _PercentageRow(
                                    label: 'Push-ups',
                                    percentage: _pushupsPercentage,
                                  ),
                                  _PercentageRow(
                                    label: 'Sit-ups',
                                    percentage: _situpsPercentage,
                                  ),
                                  _PercentageRow(
                                    label: 'Running',
                                    percentage: _runningPercentage,
                                  ),
                                  const SizedBox(height: 12),
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE3F2FD),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Average',
                                          style: TextStyle(
                                            color: Color(0xFF0F6CBD),
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          '${_averagePercentage.toStringAsFixed(2)}%',
                                          style: const TextStyle(
                                            color: Color(0xFF0F6CBD),
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============== HELPER WIDGETS ==============
class _ResultRow extends StatelessWidget {
  const _ResultRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF617285),
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF17324D),
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class _PercentageRow extends StatelessWidget {
  const _PercentageRow({
    required this.label,
    required this.percentage,
  });

  final String label;
  final double percentage;

  Color _getPercentageColor() {
    if (percentage >= 80) return const Color(0xFF4CAF50); // Green
    if (percentage >= 60) return const Color(0xFF2196F3); // Blue
    return const Color(0xFFFF9800); // Orange
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Color(0xFF617285),
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
              Text(
                '${percentage.toStringAsFixed(2)}%',
                style: TextStyle(
                  color: _getPercentageColor(),
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: percentage / 100,
              minHeight: 8,
              backgroundColor: const Color(0xFFE0E0E0),
              valueColor: AlwaysStoppedAnimation<Color>(
                _getPercentageColor(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
