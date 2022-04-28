import 'package:flutter/material.dart';

class HomeTop extends StatelessWidget {
  const HomeTop({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
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
            onPressed: () {},
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
            style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(10),
                primary: const Color(0xff744af6), // <-- Button color
                onPrimary: Colors.red),
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      ),
    );
  }
}
