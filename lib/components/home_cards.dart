import 'package:flutter/material.dart';
import 'package:medpiper/data/habit.dart';

class HomeCards extends StatelessWidget {
  const HomeCards({
    Key? key,
    required this.width,
    required this.itemList,
    required this.colorList,
  }) : super(key: key);

  final double width;
  final List<Habit> itemList;
  final List<Color> colorList;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 15.0),
      width: width,
      height: 150.0,
      child: ListView.builder(
        itemCount: itemList.length,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final item = itemList[index];

          return Container(
            width: 150,
            margin: const EdgeInsets.all(6.0),
            decoration: BoxDecoration(
                color: colorList[index % 5],
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: colorList[index % 5],
                    blurRadius: 3.0,
                    offset: const Offset(0.5, 1.5),
                  )
                ]),
            child: Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      item.habitName.split(" ").length < 2
                          ? item.habitName.substring(0, 2).toUpperCase()
                          : item.habitName.split(" ")[0].substring(0, 1) +
                              item.habitName.split(" ")[1].substring(0, 1),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      )),
                  Text(item.habitName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15.0,
                        fontWeight: FontWeight.normal,
                      ))
                ],
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              ),
            ),
          );
        },
      ),
    );
  }
}
