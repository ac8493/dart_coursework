import 'package:flutter/material.dart';
import 'decision_map.dart';
import 'dart:core';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';

//List<DecisionMap> decisionMap = [];
late Box<DecisionMap> box;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter(); //HIVE SETUP
  Hive.registerAdapter(DecisionMapAdapter());
  box = await Hive.openBox<DecisionMap>('decMap');

  String csv = "assets/nba.csv";
  String fileData = await rootBundle.loadString(csv);
  List<String> rows = fileData.split("\n");

  for (int i = 0; i < rows.length; i++) {
    String row = rows[i];
    List<String> itemInRow = row.split(",");
    DecisionMap decMap = DecisionMap()
      ..ID = int.parse(itemInRow[0])
      ..yesID = int.parse(itemInRow[1])
      ..noID = int.parse(itemInRow[2])
      ..description = itemInRow[3];

    int key = int.parse(itemInRow[0]);
    box.put(key, decMap);
  }

  runApp(
    const MaterialApp(
      home: MyFlutterApp(),
    ),
  );
}

class MyFlutterApp extends StatefulWidget {
  const MyFlutterApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MyFlutterState();
  }
}

class MyFlutterState extends State<MyFlutterApp> {
  late int ID;
  late int yesID;
  late int noID;
  String description = "";

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {});
    setState(() {
      DecisionMap? current = box.get(1);
      if (current != null) {
        ID = current.ID;
        yesID = current.yesID;
        noID = current.noID;
        description = current.description;
      }
    });
  }

  void yesClickHandler() {
    setState(() {
      DecisionMap? current = box.get(yesID);
      if (current != null) {
        ID = current.ID;
        yesID = current.yesID;
        noID = current.noID;
        description = current.description;
      }
    });
  }

  void noClickHandler() {
    setState(() {
      DecisionMap? current = box.get(noID);
      if (current != null) {
        ID = current.ID;
        yesID = current.yesID;
        noID = current.noID;
        description = current.description;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff3e87c5),
      body: Align(
        alignment: Alignment.center,
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            alignment: Alignment.topLeft,
            children: [
              Align(
                alignment: Alignment.bottomLeft, //const Alignment(0.0, 0.0),
                child: MaterialButton(
                  onPressed: () {
                    yesClickHandler();
                  },
                  color: const Color(0xff3a21d9),
                  elevation: 0,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  textColor: const Color(0xfffffdfd),
                  height: 40,
                  minWidth: 140,
                  padding: const EdgeInsets.all(30.0),
                  //const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: const Text(
                    "yes",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: const Alignment(0.0, -0.7),
                child: Text(
                  description,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.clip,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 34,
                    color: Color(0xffffffff),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight, //const Alignment(0.0, 0.0),
                child: MaterialButton(
                  onPressed: () {
                    noClickHandler();
                  },
                  color: const Color(0xff3a21d9),
                  elevation: 0,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  textColor: const Color(0xfffffdfd),
                  height: 40,
                  minWidth: 140,
                  padding: const EdgeInsets.all(30.0),
                  //const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: const Text(
                    "no",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
