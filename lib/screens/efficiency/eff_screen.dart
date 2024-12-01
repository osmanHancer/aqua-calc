import 'dart:convert';
import 'dart:developer';
import 'package:aquacalc/entity/pump_efficiency.dart';
import 'package:aquacalc/entity/unit.dart';
import 'package:aquacalc/screens/widgets/my_widgets.dart';
import 'package:aquacalc/utils/utils.dart';
import 'package:flutter/material.dart';
part 'eff_view.dart';

class EffScreen extends StatefulWidget {
  static const String route = "/effiency";
  const EffScreen({super.key});

  @override
  State<EffScreen> createState() => _EffScreenState();
}

class _EffScreenState extends State<EffScreen> {
  localSetState() {
    setState(() {});
  }

  var fieldList = Field();
  static int id = 0;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _textEditingController = TextEditingController();
  List<String> calcModes = [
    EffCalcMode.systemEff,
    EffCalcMode.power,
    EffCalcMode.flow,
    EffCalcMode.hm,
    EffCalcMode.motorEff,
    EffCalcMode.hydraulicEff
  ];
  Map<String, dynamic> inputs = {};

  void resetForm() {
    fieldList.flow.val = double.nan;
    fieldList.systemeff.val = double.nan;
    fieldList.hm.val = double.nan;
    fieldList.hyrauliceff.val = double.nan;
    fieldList.motoreff.val = 85;
    fieldList.power.val = double.nan;
    inputs["result"] = null;
    setState(() {});
  }

  @override
  void initState() {
    resetForm();
    super.initState();
  }

  String calcMode = EffCalcMode.systemEff;

  @override
  Widget build(BuildContext context) {
    return _build(context);
  }

  calculate() {
    // ignore: unused_local_variable
    double? hm, power, flow, systemeff, motoreff, hydrauliceff;
    hm = fieldList.hm.val ?? double.nan;
   hm = (fieldList.hm.unit == "cm")
    ? hm / 100
    : (fieldList.hm.unit == "mm")
        ? hm /1000
        : hm;

    power = fieldList.power.val ?? double.nan;
    power = (fieldList.power.unit) == "w" ? power / 1000 : power;
    flow = fieldList.flow.val ?? double.nan;
    flow = (fieldList.flow.unit) == "l/s" ? flow * 3.6 : flow;
    motoreff = fieldList.motoreff.val ?? double.nan;
    systemeff = fieldList.systemeff.val ?? double.nan;
    hydrauliceff = fieldList.hyrauliceff.val ?? double.nan;

    if (calcMode == EffCalcMode.flow) {
      if (!(hm.isNaN) &&
          !(power.isNaN) &&
          !(hydrauliceff.isNaN) &&
          !(motoreff.isNaN)) {
        inputs["result"] =
            PumpEfficiency.calcflow(power, hm, hydrauliceff, motoreff)["flow"]
                .toStringAsFixed(3);
        inputs["result_unit"] = Unit.flowUnits.first;
      } else {
        inputs["result"] = null;
        inputs["result_unit"] = null;
      }
      localSetState();
    }
    if (calcMode == EffCalcMode.hm) {
      if (!(flow.isNaN) &&
          !(power.isNaN) &&
          !(hydrauliceff.isNaN) &&
          !(motoreff.isNaN)) {
        inputs["result"] = PumpEfficiency.calcdischargeHead(
                flow, power, hydrauliceff, motoreff)
            .toStringAsFixed(3);
        inputs["result_unit"] = Unit.lenghtUnits.first;
      } else {
        inputs["result"] = null;
        inputs["result_unit"] = null;
      }
      localSetState();
    }
    if (calcMode == EffCalcMode.hydraulicEff) {
      if (!(flow.isNaN) && !(power.isNaN) && !(hm.isNaN) && !(motoreff.isNaN)) {
        inputs["result"] = PumpEfficiency.calcEfficiency(
                flow:flow, power:power,motorEfficiency: motoreff,dischargeHead:hm)["hydraulic"]
            .toStringAsFixed(3);
            log(inputs["result"]);

        inputs["result_unit"] = Unit.percentUnits.first;
      } else {
        inputs["result"] = null;
        inputs["result_unit"] = null;
      }
      localSetState();
    }
    if (calcMode == EffCalcMode.motorEff) {
      if (!(hm.isNaN) &&
          !(flow.isNaN) &&
          !(power.isNaN) &&
          !(hydrauliceff.isNaN)) {
        inputs["result"] =
            PumpEfficiency.calcMotorEfficiency(flow, power, hydrauliceff, hm)
                .toStringAsFixed(3);
        inputs["result_unit"] = Unit.percentUnits.first;
      } else {
        inputs["result_unit"] = null;
        inputs["result"] = null;
      }
      localSetState();
    }
    if (calcMode == EffCalcMode.power) {
      if (!(hm.isNaN) &&
          !(flow.isNaN) &&
          !(hydrauliceff.isNaN) &&
          !(motoreff.isNaN)) {
        inputs["result"] =
            PumpEfficiency.calcpower(flow, hm, hydrauliceff, motoreff)
                .toStringAsFixed(3);
        inputs["result_unit"] = Unit.powerUnits.first;
      } else {
        inputs["result"] = null;
        inputs["result_unit"] = null;
      }
      localSetState();
    }
    if (calcMode == EffCalcMode.systemEff) {
      if (!(flow.isNaN) && !(power.isNaN) && !(hm.isNaN) && !(motoreff.isNaN)) {
        inputs["result"] =
            PumpEfficiency.calcEfficiency(flow:flow, power: power, motorEfficiency: motoreff, dischargeHead: hm)["system"]
                .toStringAsFixed(3);
        inputs["result_unit"] = Unit.percentUnits.first;
      } else {
        inputs["result"] = null;
        inputs["result_unit"] = null;
      }
      localSetState();
    }
  }
}
