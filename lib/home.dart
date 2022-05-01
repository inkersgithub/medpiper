import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:medpiper/components/new_habit.dart';
import 'package:medpiper/data/habit.dart';
import 'package:medpiper/data/habit_dao.dart';
import 'package:medpiper/static_data.dart';
import 'components/home_cards.dart';

class Home extends StatefulWidget {
  final String? number;
  final bool isFromLogin;
  const Home({Key? key, required this.number, required this.isFromLogin})
      : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool bDataFetched = false;
  List<DateTime> _dateList = [];
  Map<DateTime, List<Habit>> habitsMap = {};
  List<Habit> _topHabitsList = [];
  List<Habit> _selectedDateHabits = [];
  late DateTime selectedDate;
  int habitCount = 0;
  final HabitDAO _habitDAO = HabitDAO();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    if (widget.isFromLogin) {
      var box = Hive.box('user');
      box.put('phone', widget.number);
    }
    //Hive.deleteFromDisk();
    StaticData.userPhone = widget.number!;
    selectedDate = DateTime.now();
    _dateList = generateDateList();
    fetchHabits();
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) => (context) {
          if (DateTime.now().weekday > 4) {
            _scrollController
                .jumpTo(_scrollController.position.minScrollExtent);
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    const List<Color> colorList = [
      Colors.blue,
      Colors.red,
      Colors.orange,
      Colors.green,
      Colors.teal
    ];

    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.white));
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xff131b26),
      body: SafeArea(
        child: (!bDataFetched
            ? Center(
                child: CircularProgressIndicator(color: Color(0xff744af6)),
              )
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      children: [
                        Row(
                          children: const [
                            Text("Most Popular",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                )),
                            Text(" Habits",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.normal,
                                )),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () => addHabit(context),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                          style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(10),
                              primary: const Color(0xff744af6),
                              onPrimary: Colors.red),
                        ),
                      ],
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    ),
                  ),
                  const SizedBox(
                    height: 25.0,
                  ),
                  _topHabitsList.isEmpty
                      ? const Center(
                          child: Text(
                              "No Top Habit to Show. Add one by using + button",
                              style: TextStyle(color: Colors.white)),
                        )
                      : HomeCards(
                          width: width,
                          itemList: _topHabitsList,
                          colorList: colorList),
                  const SizedBox(
                    height: 25.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 18.0),
                    child: Container(
                      height: 100,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            bottomLeft: Radius.circular(10.0)),
                        color: Color(0xff1b232e),
                      ),
                      child: ListView.builder(
                        itemCount: _dateList.length,
                        scrollDirection: Axis.horizontal,
                        controller: _scrollController,
                        itemBuilder: (context, index) {
                          final item = _dateList[index];
                          return GestureDetector(
                            child: Container(
                              width: 75,
                              height: 75,
                              margin: const EdgeInsets.only(
                                  top: 10, bottom: 10, left: 10, right: 5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7.5),
                                  color: selectedDate.day == item.day
                                      ? const Color(0xff727be8)
                                      : const Color(0xff131b26)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    item.day.toString(),
                                    style: TextStyle(
                                        fontWeight: selectedDate.day == item.day
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                        fontSize: 18.0,
                                        color: selectedDate.day == item.day
                                            ? Colors.white
                                            : const Color.fromARGB(
                                                255, 121, 120, 120)),
                                  ),
                                  const SizedBox(height: 2.0),
                                  Text(
                                    DateFormat('EEEE')
                                        .format(item)
                                        .substring(0, 3),
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 10.0,
                                        color: selectedDate.day == item.day
                                            ? Colors.white
                                            : const Color.fromARGB(
                                                255, 121, 120, 120)),
                                  )
                                ],
                              ),
                            ),
                            onTap: () => dateClicked(item),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25.0,
                  ),
                  HabitListLabel(habitCount: _selectedDateHabits.length),
                  const SizedBox(
                    height: 15.0,
                  ),
                  _selectedDateHabits.isEmpty
                      ? const Center(
                          child: Text(
                          "No Habit to list. Add one by using + button",
                          style: TextStyle(color: Colors.white),
                        ))
                      : Padding(
                          padding:
                              const EdgeInsets.only(left: 15.0, right: 15.0),
                          child: Expanded(
                            child: Container(
                              height: 330,
                              decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10.0),
                                      topRight: Radius.circular(10.0)),
                                  color: Color(0xff1b232e)),
                              child: SingleChildScrollView(
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: _selectedDateHabits.length,
                                    itemBuilder: (context, index) {
                                      final item = _selectedDateHabits[index];
                                      var isChecked = isHabitChecked(item);
                                      return ListTile(
                                        title: Text(
                                          item.habitName,
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        leading: Icon(
                                          isChecked
                                              ? Icons.check_circle_outline
                                              : Icons.check_circle,
                                          color: Colors.white,
                                          size: 35.0,
                                        ),
                                      );
                                    }),
                              ),
                            ),
                          ),
                        )
                ],
              )),
      ),
    );
  }

  addHabit(BuildContext context) async {
    var result = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return const NewHabit();
        });
    fetchHabits();
  }

  fetchHabits() async {
    List<Habit> topHabitsList = [];
    Map<DateTime, List<Habit>> tempHabitsMap = {};
    DataSnapshot dbSnapshot = await _habitDAO.getAllHabits();
    if (dbSnapshot.exists) {
      Habit tempHabit;
      DateTime tempDateTime;
      List<DateTime> tempDateList = [];
      List<Habit> dateHabitList = [];
      List<Habit> tempHabitList = [];
      Map<dynamic, dynamic> values = dbSnapshot.value as Map;
      if (values[StaticData.userPhone] != null) {
        values = values[StaticData.userPhone];
        values.forEach((key, value) {
          tempDateList = [];
          if (value["dateList"] != null) {
            for (int i = 0; i < value["dateList"].length; i++) {
              DateTime date =
                  DateTime.fromMillisecondsSinceEpoch(value["dateList"][i]);
              DateTime newDate = DateTime(date.year, date.month, date.day);
              if (!tempDateList.contains(newDate)) {
                tempDateList.add(newDate);
              }
            }
          }
          tempHabit = Habit(
              habitId: key,
              habitName: value["habitName"],
              startDate:
                  DateTime.fromMillisecondsSinceEpoch(value["startDate"]),
              repeatDays: value["repeatDays"],
              streakCount: value["streakCount"],
              bestStreak: value["bestStreak"],
              lastCompletedDate: DateTime.fromMillisecondsSinceEpoch(
                  value["lastCompletedDate"]),
              dateList: tempDateList);
          tempHabitList.add(tempHabit);
          if (topHabitsList.length < 6) {
            topHabitsList.add(tempHabit);
          }
        });

        _dateList.forEach((date) {
          dateHabitList = [];
          tempHabitList.forEach((habit) {
            if (habit.repeatDays == 1) {
              dateHabitList.add(habit);
            } else if (habit.repeatDays == 2 &&
                (date.weekday == 1 || date.weekday == 3 || date.weekday == 4)) {
              dateHabitList.add(habit);
            } else if (habit.repeatDays == 3 && date.weekday == 1) {
              dateHabitList.add(habit);
            }
          });
          tempHabitsMap.putIfAbsent(date, () => dateHabitList);
        });
      } else {
        habitsMap = {};
      }
    } else {
      habitsMap = {};
    }
    setState(() {
      bDataFetched = true;
      _topHabitsList = topHabitsList;
      habitsMap = tempHabitsMap;
    });
  }

  isHabitChecked(Habit habit) {
    return habit.dateList.contains(selectedDate);
  }

  generateDateList() {
    List<DateTime> dateList = [];
    DateTime today = DateTime.now();
    today = DateTime(today.year, today.month, today.day);
    final dayTobeReduced = today.weekday == 1 ? 0 : today.weekday - 1;
    DateTime weekday = getDate(today.subtract(Duration(days: dayTobeReduced)));
    for (int i = 0; i < 7; i++) {
      dateList.add(weekday);
      weekday = weekday.add(const Duration(days: 1));
    }
    return dateList;
  }

  DateTime getDate(DateTime d) => DateTime(d.year, d.month, d.day);

  dateClicked(DateTime clickedDate) {
    selectedDate = clickedDate;
    dateSelected(clickedDate);
  }

  dateSelected(DateTime date) {
    habitsMap.entries.forEach((element) {
      if (element.key == date) {
        setState(() {
          _selectedDateHabits = element.value;
        });
      }
    });
  }
}

class HabitListLabel extends StatelessWidget {
  const HabitListLabel({
    Key? key,
    required this.habitCount,
  }) : super(key: key);

  final int habitCount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text("Your Habits  ",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              )),
          Text(habitCount.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.normal,
              )),
        ],
      ),
    );
  }
}
