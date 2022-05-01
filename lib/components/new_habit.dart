import 'package:flutter/material.dart';
import 'package:medpiper/data/habit.dart';
import 'package:medpiper/data/habit_dao.dart';

class NewHabit extends StatefulWidget {
  const NewHabit({Key? key}) : super(key: key);

  @override
  State<NewHabit> createState() => _NewHabitState();
}

class _NewHabitState extends State<NewHabit> {
  TextEditingController newHabitName = TextEditingController();
  int groupValue = 1;

  final HabitDAO habitDAO = HabitDAO();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Container(
        padding: const EdgeInsets.all(15.0),
        height: 400,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
            Text("New Habit",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                )),
          ]),
          TextFormField(
            controller: newHabitName,
            decoration: const InputDecoration(
              labelText: "Habit Name",
              labelStyle: TextStyle(fontSize: 15.0, color: Colors.black),
              floatingLabelStyle:
                  TextStyle(fontSize: 15.0, color: Color(0xff744af6)),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xff744af6)),
              ),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          const Text("Select Frequency",
              style: TextStyle(
                fontSize: 15.0,
              )),
          ListTile(
            title: const Text("Daily"),
            leading: Radio(
                value: 1,
                activeColor: const Color(0xff744af6),
                groupValue: groupValue,
                onChanged: (value) => frequencyChanged(value as int)),
          ),
          ListTile(
            title: const Text("Every Other Day"),
            leading: Radio(
                value: 2,
                activeColor: const Color(0xff744af6),
                groupValue: groupValue,
                onChanged: (value) => frequencyChanged(value as int)),
          ),
          ListTile(
            title: const Text("Once A Week"),
            leading: Radio(
                value: 3,
                activeColor: const Color(0xff744af6),
                groupValue: groupValue,
                onChanged: (value) => frequencyChanged(value as int)),
          ),
          const SizedBox(
            height: 10.0,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            ElevatedButton(
              onPressed: () => saveHabit(),
              child: const Text("Submit"),
              style: ElevatedButton.styleFrom(
                  primary: const Color(0xff744af6),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
            ),
          ])
        ]),
      ),
    );
  }

  frequencyChanged(int value) {
    setState(() {
      groupValue = value;
    });
  }

  saveHabit() {
    if (newHabitName.text.isNotEmpty) {
      Habit tempHabit = Habit(
          habitId: "",
          habitName: newHabitName.text.trim(),
          startDate: DateTime.now(),
          repeatDays: groupValue,
          streakCount: 0,
          bestStreak: 0,
          lastCompletedDate: DateTime.now(),
          dateList: [DateTime.now()]);

      habitDAO.saveHabit(tempHabit);
      Navigator.pop(context);
    }
  }
}
