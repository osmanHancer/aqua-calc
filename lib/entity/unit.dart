import 'package:flutter/src/material/dropdown.dart';

class Unit {
  static List<String> powerUnits = ["kW", "w"];

  static List<String> lenghtUnits = ["mm","m", "cm"];

  static List<String> flowUnits = ["m³/h", "l/s"];

  static List<String> percentUnits = ["%"];

  static List<String> temparatures = ["°C"];

  static List<String> time = ["h","m"];

  static List<String> speed = ["rpm"];

  static List<String> torque = ["N.m","Ib.in"];
}

class EffCalcMode {
  static String systemEff = "Sistem Verimi";
  static String power = "Güç";
  static String flow = "Debi";
  static String hm = "Hm";
  static String motorEff = "Motor Verimi";
  static String hydraulicEff = "Hidrolik Verimi";
}

class TorqueCalcMode{
static String powertorque = "Güçten Tork Hesapla";
  static String torquepower = "Torktan Güç Hesapla";

}

class EditField {
  String title;
  List<String> unitList;
  String unit;
  double? val;
  double? coefficient;
  String? image;

  EditField(
      {required this.title,
      required this.unitList,
      required this.unit,
      this.val,
      this.image});

  map(DropdownMenuItem<String> Function(String value) param0) {}
}

class Torque{

 final power = EditField(
      title: "Güç", image: "clampmeter", unitList: Unit.powerUnits, unit: "kW");

 final speed = EditField(
      title: "Hız", image: "speed", unitList: Unit.speed, unit: "rpm");

 final torque = EditField(
      title: "Tork", image: "torque", unitList: Unit.torque, unit: "N.m");




}

class Field {
  final power = EditField(
      title: "Güç", image: "clampmeter", unitList: Unit.powerUnits, unit: "kW");
  final motoreff = EditField(
      title: "Motor Verimi",
      image: "motor",
      unitList: Unit.percentUnits,
      unit: "%");
  final flow = EditField(
      title: "Debi", image: "debi", unitList: Unit.flowUnits, unit: "m³/h");
  final hyrauliceff = EditField(
      title: "Hidrolik Verimi",
      image: "hyraulic",
      unitList: Unit.percentUnits,
      unit: "%");
  final hm = EditField(
      title: "Basma Yüksekliği",
      image: "basma_yuksekligi",
      unitList: Unit.lenghtUnits,
      unit: "m");
  final systemeff = EditField(
      title: "Sistem Verimi",
      image: "system_eff",
      unitList: Unit.percentUnits,
      unit: "%");

  final pipeLength = EditField(
      title: "Boru Uzunluğu",
      image: "pipe_lenght",
      unitList: Unit.lenghtUnits,
      unit: "m");

  final waterTemp = EditField(
      title: "Su Sıcaklığı",
      image: "water_temp",
      unitList: Unit.temparatures,
      unit: "°C");

  final pipeInnaDiameter = EditField(
      title: "Boru İç Çapı",
      image: "pipeline_diameter_icon",
      unitList: Unit.lenghtUnits,
      unit: "mm");
}

class Cable {
  final cableLong = EditField(
      title: "Kablo Uzunluğu",
      image: "cable_long",
      unitList: Unit.lenghtUnits,
      unit: "m");
  final dailyWork = EditField(
      title: "Günlük Çalışma",
      image: "daily_work",
      val: 24,
      unitList: Unit.time,
      unit: "h");
  final valtageDrop = EditField(
      title: "Voltaj Düşümü",
      image: "voltage",
      val: 2,
      unitList: Unit.percentUnits,
      unit: "%");
  final activePower = EditField(
      title: "Aktif Güç",
      image: "energetic",
      unitList: Unit.powerUnits,
      unit: "kW");
}
