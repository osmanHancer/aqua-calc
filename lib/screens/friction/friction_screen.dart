import 'dart:developer';

import 'package:aquacalc/entity/pump_efficiency.dart';
import 'package:aquacalc/entity/unit.dart';
import 'package:aquacalc/screens/widgets/my_widgets.dart';
import 'package:aquacalc/screens/widgets/pipe_selector.dart';
import 'package:aquacalc/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:aquacalc/entity/pipe.dart';

part 'friction_view.dart';

class FrictionLoss extends StatefulWidget {
  const FrictionLoss({super.key});
  static const String route = "/friction";
  @override
  State<FrictionLoss> createState() => FrictionScreenState();
}

class FrictionScreenState extends State<FrictionLoss> {
    localSetState() {
    setState(() {});
  }

  Pipe selectPipe = Pipe(
      name: "Galveniz Çelik", friction: 0.008, imagePath: "galvanizli_boru");
  @override
  void initState() {
    super.initState();
  }


  var fieldList = Field();
  //   List<FrictionField> frictionMenuItems=[
  //   FrictionField(title: "Boru Uzunluğu", unitList: Unit.lenghtUnits, unit: "cm"),
  //   FrictionField(title: "Su Sıcaklığı", unitList: Unit.temparatures, unit: "°C"),
  //   FrictionField(title: "Debi", unitList: Unit.flowUnits, unit: "m³/h"),

  // ];

  List<String> resultItems = [
    "Sürtünme Kaybı",
    "Su Hızı",
    "Reynolds",
    "Akış Tipi",
    "Direnç Katsayısı"
  ];
  List<String> resultItemsVal = ["friction_lost", "u", "ren", "turb", "fd"];

  Map<String, dynamic> result = {};

  String title = "Boru Sürtünme Kaybı";
  @override
  Widget build(BuildContext context) {
    return _build(context);

    
  }

  calculateFriction() {
    double? pipeLength, pipeInnaDiameter, flow, temp;
    pipeLength = fieldList.pipeLength.val ?? double.nan;
    pipeLength = (fieldList.pipeLength.unit == "cm")
    ? pipeLength / 100
    : (fieldList.pipeLength.unit == "mm")
        ? pipeLength/1000
        : pipeLength;
    pipeInnaDiameter = fieldList.pipeInnaDiameter.val ?? double.nan;
   pipeInnaDiameter = (fieldList.pipeInnaDiameter.unit == "cm")
    ? pipeInnaDiameter / 100
    : (fieldList.pipeInnaDiameter.unit == "mm")
        ? pipeInnaDiameter/1000
        : pipeInnaDiameter;

    flow = fieldList.flow.val ?? double.nan;
    flow = (fieldList.flow.unit) == "l/s" ? flow * 3.6 : flow;
    temp = fieldList.waterTemp.val ?? double.nan;
    if (!(pipeLength.isNaN) &&
        !(pipeInnaDiameter.isNaN) &&
        !(flow.isNaN) &&
        !(temp.isNaN)) {
      result = PumpEfficiency.calcFrictionLoss(
          flow, pipeInnaDiameter,selectPipe.friction, pipeLength, temp);
      log(result.toString());
      
    } else {}
   log(result[resultItemsVal[1]].toString());
    setState(() {
        result;
      });
  }
}
