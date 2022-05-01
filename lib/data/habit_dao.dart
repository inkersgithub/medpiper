import 'package:firebase_database/firebase_database.dart';
import 'package:medpiper/data/habit.dart';
import 'package:medpiper/static_data.dart';

class HabitDAO {
  final DatabaseReference _habitsRef = FirebaseDatabase.instance
      .ref()
      .child('users')
      .child(StaticData.userPhone);

  saveHabit(Habit habit) {
    _habitsRef.push().set({
      'habitName': habit.habitName,
      'startDate': habit.startDate.millisecondsSinceEpoch,
      'repeatDays': habit.repeatDays,
      'streakCount': habit.streakCount,
      'bestStreak': habit.bestStreak,
      'lastCompletedDate': habit.startDate.microsecondsSinceEpoch,
      'dateList': []
    });
  }

  Future<DataSnapshot> getAllHabits() async {
    DatabaseEvent dbEvent = await _habitsRef.once();
    return dbEvent.snapshot;
  }

  updateHabit(Habit habit) {
    _habitsRef.child(habit.habitId).set({
      'habitName': habit.habitName,
      'startDate': habit.startDate.millisecondsSinceEpoch,
      'repeatDays': habit.repeatDays,
      'streakCount': habit.streakCount,
      'bestStreak': habit.bestStreak,
      'lastCompletedDate': habit.startDate.microsecondsSinceEpoch
    });
  }
}
