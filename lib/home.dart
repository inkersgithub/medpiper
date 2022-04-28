import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medpiper/components/home_top.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool bHasSession = false;

  @override
  Widget build(BuildContext context) {
    var itemList = ['One', 'Two', 'Three', 'Four', 'Five', 'Six'];

    const List<Color> colorList = [
      Colors.blue,
      Colors.red,
      Colors.orange,
      Colors.green,
      Colors.greenAccent,
      Colors.teal
    ];

    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.white));
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xff131b26),
      body: SafeArea(
        child: Column(
          children: [
            const HomeTop(),
            const SizedBox(
              height: 25.0,
            ),
            Container(
              padding: EdgeInsets.only(left: 15.0),
              width: width,
              height: 120.0,
              child: ListView.builder(
                itemCount: 6,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final item = itemList[index];

                  return Container(
                    width: 120,
                    margin: EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
                        color: colorList[index],
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: colorList[index],
                            blurRadius: 3.0,
                            offset: const Offset(0.5, 1.5),
                          )
                        ]),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.substring(0, 2).toUpperCase(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              )),
                          Text(item,
                              style: TextStyle(
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
            )
          ],
        ),
      ),
    );
  }
}
