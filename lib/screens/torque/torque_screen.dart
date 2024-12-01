import 'dart:convert';
import 'dart:math';
import 'package:aquacalc/utils/utils.dart';
import 'package:aquacalc/entity/unit.dart';
import 'package:aquacalc/screens/widgets/my_widgets.dart';
import 'package:flutter/material.dart';
part 'torque_view.dart';

class TorqueScreen extends StatefulWidget {
  static const String route = "/torque";
  const TorqueScreen({super.key});

  @override
  State<TorqueScreen> createState() => _TorqueScreenState();
}

class _TorqueScreenState extends State<TorqueScreen> {
  localSetState() {
    setState(() {});
  }

  var fieldList = Torque();
  static int id = 0;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _textEditingController = TextEditingController();
  List<String> calcModes = [
    TorqueCalcMode.powertorque,
    TorqueCalcMode.torquepower,
  ];
  Map<String, dynamic> inputs = {};

  void resetForm() {
    fieldList.power.val = double.nan;
    fieldList.speed.val = double.nan;
    inputs["result"] = null;
    setState(() {});
  }

  @override
  void initState() {
    resetForm();
    super.initState();
  }

  String calcMode = TorqueCalcMode.powertorque;

  @override
  Widget build(BuildContext context) {
    return _build(context);
  }

  calculate() {
    double? power, speed,torque;

    power = fieldList.power.val ?? double.nan;
    power = (fieldList.power.unit) == "w" ? power / 1000 : power;

    torque=fieldList.torque.val ?? double.nan;
    torque = (fieldList.torque.unit) == "Ib.in" ? torque * 0.113 : torque;

    speed = fieldList.speed.val ?? double.nan;


    if (calcMode == TorqueCalcMode.powertorque) {
      if (!(speed.isNaN) && !(power.isNaN)) {

        inputs["result"]=(power/(speed*(2*pi/60))).toStringAsFixed(3);
        inputs["result_unit"] = Unit.powerUnits[1];
      }
      else
        inputs["result"] = null;
    }
    if (calcMode == TorqueCalcMode.torquepower) {
      if (!(speed.isNaN) && !(torque.isNaN)) {

        inputs["result"]=(torque*speed*(2*pi/60)).toStringAsFixed(3);
        inputs["result_unit"] = Unit.powerUnits[1];


      }
      else
        inputs["result"] = null;
    }
    localSetState();
  }
}
