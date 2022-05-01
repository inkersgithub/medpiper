import 'dart:convert';

import 'package:flutter/foundation.dart';

class Habit {
  String habitId;
  String habitName;
  DateTime startDate;
  int repeatDays;
  int streakCount;
  int bestStreak;
  DateTime lastCompletedDate;
  List<DateTime> dateList;
  Habit({
    required this.habitId,
    required this.habitName,
    required this.startDate,
    required this.repeatDays,
    required this.streakCount,
    required this.bestStreak,
    required this.lastCompletedDate,
    required this.dateList,
  });

  Habit copyWith({
    String? habitId,
    String? habitName,
    DateTime? startDate,
    int? repeatDays,
    int? streakCount,
    int? bestStreak,
    DateTime? lastCompletedDate,
    List<DateTime>? dateList,
  }) {
    return Habit(
      habitId: habitId ?? this.habitId,
      habitName: habitName ?? this.habitName,
      startDate: startDate ?? this.startDate,
      repeatDays: repeatDays ?? this.repeatDays,
      streakCount: streakCount ?? this.streakCount,
      bestStreak: bestStreak ?? this.bestStreak,
      lastCompletedDate: lastCompletedDate ?? this.lastCompletedDate,
      dateList: dateList ?? this.dateList,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'habitId': habitId});
    result.addAll({'habitName': habitName});
    result.addAll({'startDate': startDate.millisecondsSinceEpoch});
    result.addAll({'repeatDays': repeatDays});
    result.addAll({'streakCount': streakCount});
    result.addAll({'bestStreak': bestStreak});
    result.addAll(
        {'lastCompletedDate': lastCompletedDate.millisecondsSinceEpoch});
    result.addAll(
        {'dateList': dateList.map((x) => x.millisecondsSinceEpoch).toList()});

    return result;
  }

  factory Habit.fromMap(Map<String, dynamic> map) {
    return Habit(
      habitId: map['habitId'] ?? '',
      habitName: map['habitName'] ?? '',
      startDate: DateTime.fromMillisecondsSinceEpoch(map['startDate']),
      repeatDays: map['repeatDays']?.toInt() ?? 0,
      streakCount: map['streakCount']?.toInt() ?? 0,
      bestStreak: map['bestStreak']?.toInt() ?? 0,
      lastCompletedDate:
          DateTime.fromMillisecondsSinceEpoch(map['lastCompletedDate']),
      dateList: List<DateTime>.from(
          map['dateList']?.map((x) => DateTime.fromMillisecondsSinceEpoch(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory Habit.fromJson(String source) => Habit.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Habit(habitId: $habitId, habitName: $habitName, startDate: $startDate, repeatDays: $repeatDays, streakCount: $streakCount, bestStreak: $bestStreak, lastCompletedDate: $lastCompletedDate, dateList: $dateList)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Habit &&
        other.habitId == habitId &&
        other.habitName == habitName &&
        other.startDate == startDate &&
        other.repeatDays == repeatDays &&
        other.streakCount == streakCount &&
        other.bestStreak == bestStreak &&
        other.lastCompletedDate == lastCompletedDate &&
        listEquals(other.dateList, dateList);
  }

  @override
  int get hashCode {
    return habitId.hashCode ^
        habitName.hashCode ^
        startDate.hashCode ^
        repeatDays.hashCode ^
        streakCount.hashCode ^
        bestStreak.hashCode ^
        lastCompletedDate.hashCode ^
        dateList.hashCode;
  }
}
