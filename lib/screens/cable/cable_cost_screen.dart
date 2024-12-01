import 'dart:developer';

import 'package:aquacalc/entity/pipe.dart';
import 'package:aquacalc/entity/unit.dart';
import 'package:aquacalc/routes.dart';
import 'package:aquacalc/screens/widgets/my_widgets.dart';
import 'package:aquacalc/screens/widgets/pipe_selector.dart';
import 'package:aquacalc/utils/utils.dart';
import 'package:flutter/material.dart';

part 'cable_cost_view.dart';

class CableLost extends StatefulWidget {
  const CableLost({super.key});
  static const String route = "/cable";
  @override
  State<CableLost> createState() => _CableWievState();
}

class _CableWievState extends State<CableLost> {
  @override
  void initState() {
    super.initState();
  }

  localSetState() {
    setState(() {});
  }

  Map<String, dynamic> result = {};
  bool button_230 = false, button_380 = true, button_500 = false;
  SelectCable selectCable =
      SelectCable(name: "Bakır Kablo", friction: 0.0124, imagePath: "bakır_m");
  String title = "Kablo Seçimi";
  int index = -1;
  List<double> pirceListDolar = [
    2.010,
    3,
    4.278,
    7.216,
    10.859,
    16.924,
    23.367,
    32.646,
    41,
    50,
    62,
    73
  ];
  List<String> innaDiameterList = [
    "3 x 2.5 mm²",
    "3 x 4 mm²",
    "3 x 6 mm²",
    "3 x 10 mm²",
    "3 x 16 mm²",
    "3 x 25 mm²",
    "3 x 35 mm²",
    "3 x 50 mm²",
    "3 x 70 mm²",
    "3 x 95 mm²",
    "3 x 120 mm²",
    "3 x 150 mm²",
  ];
  List<double> payOfList = [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1];
  List<double> diameters = [2.5, 4, 6, 10, 16, 25, 35, 50, 70, 95, 120, 150];
  Map<double, double> coefficientCu = {230: 0.0714, 380: 0.0124, 500: 0.007505};
  Map<double, double> coefficientAl = {
    230: 0.11424,
    380: 0.01984,
    500: 0.012008
  };
  var cableFieldList = Cable();

  @override
  Widget build(BuildContext context) {
    return _build(context);
  }

  calculateCableCost() {
    double? activePower, cableLong, dailyWork, valtageDrop;

    activePower = cableFieldList.activePower.val ?? double.nan;
    activePower = cableFieldList.activePower.unit == "kW"
        ? activePower
        : activePower / 1000;
    cableLong = cableFieldList.cableLong.val ?? double.nan;
    cableLong =
       cableLong = cableFieldList.cableLong.unit == "cm"
    ? cableLong / 100
    : cableFieldList.cableLong.unit == "mm"
        ? cableLong /1000
        : cableLong;

    dailyWork = cableFieldList.dailyWork.val ?? double.nan;
    dailyWork =
        cableFieldList.dailyWork.unit == "h" ? dailyWork : dailyWork / 60;
    valtageDrop = cableFieldList.valtageDrop.val ?? double.nan;

    if (!(activePower.isNaN) &&
        !(cableLong.isNaN) &&
        !(dailyWork.isNaN) &&
        !(valtageDrop.isNaN)) {
      result["minumum_diameter_result"] =
          (selectCable.friction * cableLong * activePower) /
              (valtageDrop * 100) *
              100;
      for (int i = 0; i < diameters.length; i++) {
        if (diameters[i] >= result["minumum_diameter_result"]) {
          result["cable_diameter_result"] = diameters[i];
          index = i;
          break;
        }
      }
      result["energy_loss"] =
          ((selectCable.friction * cableLong * activePower) /
                  (result["cable_diameter_result"] / 100)) /
              100;
      result["yearly_total_spend_energy"] = activePower * dailyWork * 365;
      result["yearly_loss"] =
          (result["energy_loss"] / 100) * result["yearly_total_spend_energy"];
      for (int i = 0; i <= 11; i++) {
        if (diameters[i] < result["minumum_diameter_result"]) {
          log("girdi");
        } else {
          result["temp_energy_loss"] =
              ((selectCable.friction * cableLong * activePower) /
                      (diameters[i] / 100)) /
                  100;
          result["pay_off_year"] =
              (cableLong * (pirceListDolar[i] - pirceListDolar[index])) /
                  ((result["temp_energy_loss"] / 100) *
                      result["yearly_total_spend_energy"]);
          log(result["pay_off_year"].toString());
          payOfList[i] = result["pay_off_year"];
        }
      }
      localSetState();
    }
    // log(result["minumum_diameter_result"].toString());
    // log(result["cable_diameter_result"].toString());
     localSetState();
  }

  changeColor(double element) {
    if (element < 0.01) {
      return Color.fromARGB(255, 137, 5, 5);
    }
    if (element >= 0 && element < 0.5) {
      return Color.fromARGB(255, 51, 202, 174);
    }
    if (element >= 0.5 && element < 1.5) {
      return Color.fromARGB(255, 81, 125, 214);
    }
    if (element >= 1.5 && element < 3) {
      return Color.fromARGB(255, 39, 210, 20);
    }
    if (element >= 3 && element < 4) {
      return Colors.red;
    }
    if (element >= 4 && element < 5) {
      return Colors.red;
    }
    if (element >= 5 && element < 6) {
      return Colors.red;
    }
    if (element >= 6 && element < 8) {
      return Colors.red;
    }
    if (element >= 8) {
      return Colors.red;
    }
  }
}
