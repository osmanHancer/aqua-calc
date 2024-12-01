import 'dart:convert';
import 'dart:developer';
import 'package:aquacalc/entity/pipe.dart';
import 'package:aquacalc/routes.dart';
import 'package:aquacalc/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/src/shared_preferences_legacy.dart';

class MainWidget extends StatefulWidget {
  const MainWidget({super.key});

  static const String route = "/home";

  @override
  State<MainWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MainWidget> {
  final String title = 'Aqua Calculator';
  late List<Measurements> measurements = [];
  late List<Measurements> filtermeasurements = [];
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = (screenWidth > 1200)
        ? 4
        : (screenWidth > 800)
            ? 3
            : 2;

    final List<Widget> options = [
      menuItem("Verim Hesabı", "/effiency", "system_eff"),
      menuItem("Sürtünme Kaybı", "/friction", "friction_loss"),
      menuItem("Kablo Seçimi", "/cable", "cable"),
      menuItem("Tork Hesapla", "/torque", "torque"),
      menuItem("Notlar", "data", "data"),
    ];

    return Scaffold(
      backgroundColor: Utils.backgroundColor,
      appBar: buildAppBar(),
      body: Scrollbar(
        thickness: 3,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: screenWidth > 1200
              ? Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 200,
                        width: 200,
                        child:
                            menuItem("Verim Hesabı", "/effiency", "system_eff"),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        height: 200,
                        width: 200,
                        child: menuItem(
                            "Sürtünme Kaybı", "/friction", "friction_loss"),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        height: 200,
                        width: 200,
                        child: menuItem("Kablo Seçimi", "/cable", "cable"),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        height: 200,
                        width: 200,
                        child: menuItem("Notlar", "data", "data"),
                      ),
                    ],
                  ),
                )
              : GridView.count(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: options,
                ),
        ),
      ),
    );
  }

  Widget menuItem(String title, String route, String image) {
    return ElevatedButton(
      onPressed: () async {
        if (route == "data") {
          await getMeasurements();
          await showMeasurements("Ölçümler");
        } else {
          Routes.push(route);
        }
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),

        backgroundColor: Utils.foregroundColor, // Text Color (Foreground color)
      ),
      child: InkWell(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image(
              image: AssetImage("assets/icons/$image.png"),
              width: 90,
            ),
            // Icon(
            //   menu[index].icon as IconData?,
            //   size: 30,
            // ),
            const SizedBox(height: 20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Utils.textColor),
            )
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: Utils.primaryColor,
      title: Center(
        child: Text(title, style: TextStyle(color: Utils.textColor)),
      ),
    );
  }

  Future<dynamic> showMeasurements(String title) async {
  // Başlangıçta tüm ölçümleri göstermek için filterMeasurements'i measurements ile doldur
  filtermeasurements = List.from(measurements);

  dynamic res = await showModalBottomSheet(
    context: Routes.navigatorKey.currentContext!,
    isScrollControlled: true,
    isDismissible: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20),
      ),
    ),
    builder: (context) =>
        StatefulBuilder(builder: (context, bottomSheetSetState) {
      return DraggableScrollableSheet(
        initialChildSize: 0.75,
        minChildSize: 0.50,
        maxChildSize: 0.9,
        expand: false,
        builder: (BuildContext context, ScrollController scrollController) =>
            SafeArea(
          child: Container(
            decoration: BoxDecoration(
              color: Utils.foregroundColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(15),
              ),
            ),
            child: Column(
              children: [
                // Arama çubuğu
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Ara',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onChanged: (value) {
                      // Filtreleme işlemi
                      bottomSheetSetState(() {
                        filtermeasurements = measurements.where((measurement) {
                          return measurement.note
                              .toLowerCase()
                              .contains(value.toLowerCase());
                        }).toList();
                      });
                    },
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: filtermeasurements.length,
                    itemBuilder: (BuildContext context, int index) {
                      return listMeasurement(filtermeasurements[index]);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }),
  );

  return res;
}


  Future<dynamic> getMeasurements() async {
    Utils.prefs = await SharedPreferences.getInstance();
    setState(() {
      measurements = [];
      filtermeasurements=[];
    });
    log(Utils.prefs.getKeys().toString());
    if (Utils.prefs.getKeys().isNotEmpty) {
      var keys = Utils.prefs.getKeys();
      for (String key in keys) {
        String? jsonString = Utils.prefs.getString(key);
        Map<String, dynamic> dataMap = jsonDecode(jsonString!);
        measurements.add(Measurements(
            dataMap['id'],
            dataMap['description'],
            dataMap['result'],
            dataMap['note'],
            dataMap['calcMode'],
            dataMap['date']));
      }
    }

    setState(() {
     measurements;
    });
  }

  Widget listMeasurement(Measurements measurements) {
    if (measurements.calcmode == "Sistem Verimi") {
      measurements.img = "system_eff";
    }
    if (measurements.calcmode == "Güç") {
      measurements.img = "clampmeter";
    }
    if (measurements.calcmode == "Debi") {
      measurements.img = "debi";
    }
    if (measurements.calcmode == "Hm") {
      measurements.img = "basma_yuksekligi";
    }
    if (measurements.calcmode == "Motor Verimi") {
      measurements.img = "motor";
    }
    if (measurements.calcmode == "Hidrolik Verimi") {
      measurements.img = "hyraulic";
    }
    if (measurements.calcmode == "Güçten Tork Hesapla") {
      measurements.img = "torque";
    }
    if (measurements.calcmode == "Torktan Güç Hesapla") {
      measurements.img = "torque";
    }

    return Dismissible(
      direction: DismissDirection.endToStart,
      onDismissed: (direction) async {
        Utils.prefs.remove(measurements.id.toString());
      },
      key: Key(measurements.id.toString()),
      background: Container(
        alignment: AlignmentDirectional.centerEnd,
        color: Colors.red,
        child: const Padding(
          padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
      ),
      child: ListTile(
        subtitle: Text(
          "Not: ${measurements.note}\nResult: ${measurements.result}",
          style: TextStyle(
              color: Utils.inactiveColor,
              fontSize: 15,
              fontWeight: FontWeight.w500),
        ),
        trailing: Text(measurements.date,
            style: TextStyle(
                color: Utils.textColor,
                fontSize: 15,
                fontWeight: FontWeight.w500)),
        leading: Image.asset("assets/icons/${measurements.img}.png"),
        title: Text(
          "Description: ${measurements.description} \nCalc Mode: ${measurements.calcmode}",
          style: TextStyle(
              color: Utils.textColor,
              fontSize: 15,
              fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
