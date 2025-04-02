import 'dart:async';
import 'package:airbound/common%20widgets/infocard.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import '../services/firestore_service.dart';
import '../controller/auth_controller.dart';
import 'package:fl_chart/fl_chart.dart';

class Progress extends GetView<AuthController> {
  final _firestoreService = FirestoreService();
  final _todayCigarettes = 0.obs;
  final _isLoading = true.obs;
  final _weeklyData = <Map<String, dynamic>>[].obs;
  final _costPerCigarette = 0.0.obs;
  final _smokedToday = 0.obs;
  final _totalCigs = 0.obs;
  final _lastResetDate = DateTime.now().obs;
  final _lastSmokeTime = DateTime.now().obs;
  final _misspend = "0".obs;
  final _cigsmk = "0".obs;
  final _life = "0".obs;
  final _nic = "0".obs;
  final _timeSinceLastSmoke = "0 minutes, 0 hours, 0 days".obs;

  Timer? _timer;
  Timer? _lastSmokeTimer;

  Progress({super.key}) {
    _initializeData();
    _startTimers();
  }

  Future<void> _initializeData() async {
    await _loadTodayCigarettes();
    await _loadWeeklyData();
    await _loadData();
    await _loadCostPerCigarette();
    _updateValues();
    _isLoading.value = false;
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    _smokedToday.value = prefs.getInt('smokedToday') ?? 0;
    _totalCigs.value = prefs.getInt('totalCigs') ?? 0;
    _lastResetDate.value = DateTime.parse(
        prefs.getString('lastResetDate') ?? DateTime.now().toIso8601String());
    _lastSmokeTime.value = DateTime.parse(
        prefs.getString('lastSmokeTime') ?? DateTime.now().toIso8601String());
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('smokedToday', _smokedToday.value);
    await prefs.setInt('totalCigs', _totalCigs.value);
    await prefs.setString('lastResetDate', _lastResetDate.value.toIso8601String());
    await prefs.setString('lastSmokeTime', _lastSmokeTime.value.toIso8601String());
  }

  Future<void> _loadCostPerCigarette() async {
    try {
      final user = controller.user.value;
      if (user != null) {
        final userData = await _firestoreService.getUserAdditionalInfo(user.uid);
        _costPerCigarette.value = (userData['costPerCigarette'] as num?)?.toDouble() ?? 0.0;
      }
    } catch (e) {
      print('Error loading cost per cigarette: $e');
    }
  }

  void _startTimers() {
    _timer = Timer.periodic(Duration(minutes: 1), (timer) {
      DateTime now = DateTime.now();
      if (now.day != _lastResetDate.value.day) {
        _totalCigs.value += _smokedToday.value;
        _smokedToday.value = 0;
        _lastResetDate.value = now;
        _updateValues();
        _saveData();
      }
    });

    _lastSmokeTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      Duration diff = DateTime.now().difference(_lastSmokeTime.value);
      _timeSinceLastSmoke.value = _formattedDuration(diff);
    });
  }

  void increment() {
    _smokedToday.value++;
    _lastSmokeTime.value = DateTime.now();
    _updateValues();
    _saveData();
  }

  void _updateValues() {
    int cumulative = _totalCigs.value + _smokedToday.value;
    _misspend.value = (cumulative * _costPerCigarette.value).toStringAsFixed(2);
    _life.value = (cumulative * 11).toString();
    _nic.value = (cumulative * 12).toString();
    _cigsmk.value = cumulative.toString();
  }

  String _formattedDuration(Duration duration) {
    int days = duration.inDays;
    int hours = duration.inHours % 24;
    int minutes = duration.inMinutes % 60;
    String result = "";

    if (days > 0) result += "$days days";
    if (hours > 0) {
      if (result.isNotEmpty) result += ", ";
      result += "$hours hours";
    }
    if (result.isNotEmpty) result += ", ";
    result += "$minutes mins ago";
    return result;
  }

  Future<void> _loadTodayCigarettes() async {
    try {
      final count = await _firestoreService.getTodayCigaretteCount();
      print('Loaded cigarette count: $count');
      _todayCigarettes.value = count;
    } catch (e) {
      print('Error loading cigarette count: $e');
      Get.snackbar(
        'Error',
        'Failed to load cigarette count',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _loadWeeklyData() async {
    try {
      final data = await _firestoreService.getLastWeekCigaretteData();
      _weeklyData.value = data;
    } catch (e) {
      print('Error loading weekly data: $e');
    }
  }

  Widget _buildLineChart() {
    if (_weeklyData.isEmpty) {
      final now = DateTime.now();
      _weeklyData.value = List.generate(7, (index) {
        final date = DateTime(now.year, now.month, now.day - (6 - index));
        return {
          'date': date,
          'count': 0,
        };
      });
    }

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: true),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                  ),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= 0 && value.toInt() < _weeklyData.length) {
                  final date = _weeklyData[value.toInt()]['date'] as DateTime;
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      '${date.day}/${date.month}',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                      ),
                    ),
                  );
                }
                return const Text('');
              },
              reservedSize: 30,
            ),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(show: true),
        lineBarsData: [
          LineChartBarData(
            spots: _weeklyData.asMap().entries.map((entry) {
              return FlSpot(
                entry.key.toDouble(),
                (entry.value['count'] as int).toDouble(),
              );
            }).toList(),
            isCurved: true,
            color: const Color(0xFF006A67),
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: const Color(0xFF006A67).withOpacity(0.1),
            ),
          ),
        ],
        minY: 0,
        maxY: _weeklyData.isEmpty ? 10 : _weeklyData.map((d) => d['count'] as int).reduce((a, b) => a > b ? a : b) + 2,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Track and Crack"),
      ),
      body: Obx(() => _isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04,
                vertical: screenHeight * 0.03,
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("You last smoked: ", style: theme.textTheme.bodySmall),
                        Text(_timeSinceLastSmoke.value, style: theme.textTheme.bodySmall),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Center(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.02,
                          vertical: screenHeight * 0.02,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF006A67),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            const Text("Today, You have smoked"),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "${_smokedToday.value}",
                                  style: const TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add_circle,
                                      size: 26, color: Colors.black),
                                  onPressed: increment,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    Text("Since you joined", style: theme.textTheme.bodyMedium),
                    SizedBox(height: screenHeight * 0.01),
                    Center(
                      child: Container(
                        width: screenWidth * 0.87,
                        height: screenHeight * 0.065,
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.03,
                          vertical: screenHeight * 0.01,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).appBarTheme.backgroundColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                "Total cigarette smoked",
                                style: theme.textTheme.bodySmall,
                              ),
                            ),
                            Text("${_cigsmk.value}", style: theme.textTheme.bodySmall),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        infoCard(
                          "₹${_misspend.value}",
                          "Misspend",
                          Icons.attach_money_sharp,
                          screenWidth * 0.42,
                          screenHeight * 0.15,
                        ),
                        infoCard(
                          "${_cigsmk.value}",
                          "cigs smoked",
                          Icons.smoke_free,
                          screenWidth * 0.42,
                          screenHeight * 0.15,
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.015),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        infoCard(
                          "${_life.value} mins",
                          "life reduced",
                          Icons.favorite,
                          screenWidth * 0.42,
                          screenHeight * 0.15,
                        ),
                        infoCard(
                          "${_nic.value} mg",
                          "Nicotine Consumed",
                          Icons.bubble_chart,
                          screenWidth * 0.42,
                          screenHeight * 0.15,
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    Container(
                      width: screenWidth * 0.87,
                      padding: EdgeInsets.all(screenWidth * 0.04),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Weekly graph",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF006A67),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          SizedBox(
                            height: screenHeight * 0.3,
                            child: _buildLineChart(),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.03),
                  ],
                ),
              ),
            )),
    );
  }
}