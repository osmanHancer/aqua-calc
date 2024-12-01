import 'dart:math' as math;

class PumpEfficiency {
  // The list of the temperatures and their corresponding viscosities of water.
  static const vis = [
    [0, 1.791468],
    [5, 1.517938],
    [10, 1.306096],
    [15, 1.138451],
    [20, 1.003317],
    [25, 0.892654],
    [30, 0.800782],
    [35, 0.723598],
    [40, 0.658075],
    [45, 0.601942],
    [50, 0.553461],
    [55, 0.511289],
    [60, 0.474368],
    [65, 0.441859],
    [70, 0.413086],
    [75, 0.387498],
    [80, 0.364647],
    [85, 0.344158],
    [90, 0.325721],
    [95, 0.309076],
    [100, 0.294002],
    [200, 0.294002]
  ];

  static Map<String, dynamic> calcReynold(rho, u, innerDiameter, mu, vi) {
    /*
    The Reynolds number is used to determine whether the fluid flow is laminar or turbulent.

    In laminar flows, fluid layers slide in parallel, with no eddies, swirls or currents normal to the flow.
    In turbulent flows, there is an irregular flow in which eddies, swirls, and flow instabilities occur.
    */
    Map<String, dynamic> result = {};
    double re = -1;

    if (rho != null &&
        u != null &&
        innerDiameter != null &&
        mu != null &&
        mu != 0) {
      re = (rho * u * innerDiameter / mu).round();
    }
    if (u != null && innerDiameter != null && vi != null) {
      re = (u * innerDiameter / vi);
    }

    if (re > 4000) {
      result["flow"] = "turbulans";
    }
    if (re > 2300 && re < 4000) {
      result["flow"] = "turbulans - laminer";
    }
    if (re < 2300) {
      result["flow"] = "laminer";
    }
    result["rn"] = re;

    return result;
  }

  static double frictionCoefficient(innerDiameter,sk,re) {
    /*
    Calculates the friction coefficient which is a unit-less value which represents the friction between two surfaces.
    */
    double lambda = 0.08; // Darcy
    var leftL = 1 / math.sqrt(lambda);
    var rightL = -2 *
        math.log10e *
        math.log(2.51 / (re * math.sqrt(lambda)) +sk / 3.72);



    while (rightL - leftL >= 0) {
      leftL = 1 / math.sqrt(lambda);
      rightL = -2 *
          math.log10e *
          math.log(2.51 / (re * math.sqrt(lambda)) + sk / innerDiameter / 3.72);

      lambda = lambda - 0.0005;
    }
    return lambda;
  }

  static double calcVis(t3 // Celcius
      ) {
    /*
    Calculates the viscosity of water using the temperature (or finds a closer one if it does not exist in the list).
    */
    if (t3 == null || t3 <= 0 || t3 > 100) {
      return 0;
    }

    int i = vis.length; // added "vis.length".
    for (var v = 0; v < vis.length; v++) {
      if (t3 < vis[v][0]) {
        i = v;
        break;
      }
    }

    var t1 = vis[i - 1][0];
    var t2 = vis[i][0];
    var v1 = vis[i - 1][1];
    var v2 = vis[i][1];
    var v3 = ((t2 - t3) * (v1 - v2)) / (t2 - t1) + v2;

    return v3 / 1000000;
  }

  static Map<String, dynamic> calcColebrook(innerDiameter, k, u, temperature) {
    /*
    The Colebrook equation is an engineering equation used to approximate the Darcy friction factor in full flowing pipes or ducts.
    */
    Map<String, dynamic> result = {};
    result["vi"] = calcVis(temperature);

    Map<String, dynamic> rey =
        calcReynold(0, u, innerDiameter, 0, result["vi"]);
    result["ren"] = rey["rn"];
    result["fd"] = frictionCoefficient(innerDiameter, k, result["ren"]);
    result["rr"] = k / innerDiameter;
  

    result["turb"] = rey["flow"];
    return result;
  }

  static Map<String, dynamic> calcEfficiencyAdvanced(
      flow, // Debi m³/h
      power, // Güç kW
      innerDiameter, // İç Çap m
      k, // Boru Yüzeyi m
      l, // Boru Uzunluğu m
      temperature, // Sıcaklık °C
      motorEfficiency, // Motor Verim %
      waterLevel, // Su Seviyesi m
      pressure, // Basınç bar
      exloss // Sürtünme kalibre m
      ) {
    /*
    Calculates the yield.
    */
    var a = math.pi * math.pow(innerDiameter, 2) / 4;

    var u = flow / 3600 / a;
    var result = calcColebrook(innerDiameter, k, u, temperature);

    result["u"] = u;

    try {
      result["headLoss"] =
          (result["fd"] * l * math.pow(u, 2)) / (innerDiameter * (2 * 9.7905)) +
              exloss;
    } catch (_) {
      result["headLoss"] = exloss;
    }

    result["hm"] = (pressure * 10.197162 + waterLevel + result["headLoss"]);
    result["hydraulic"] =
        (result["hm"] * flow) / (367.2 * power * motorEfficiency / 10000);
    result["system"] = result["hydraulic"] * motorEfficiency / 100;

    return result;
  }

  static Map<String, dynamic> calcEfficiencyBasicWell(
      flow, // Debi m³/h
      power, // Güç kW
      motorEfficiency, // Motor Verim %
      waterLevel, // Su Seviyesi m
      pressure, // Basınç bar
      exloss, // Sürtünme kalibre m
      {double? dia} // İç Çap m
      ) {
    /*
    Calculates the yield.
    */

    Map<String, dynamic> result = {};

    result["hm"] = (pressure * 10.197162 + waterLevel + exloss);
    result["hydraulic"] =
        (result["hm"] * flow) / (367.2 * power * motorEfficiency / 10000);
    result["system"] = result["hydraulic"] * motorEfficiency / 100;

    if (dia != null) {
      double area = math.pi * math.pow(dia, 2) / 4;
      result["water_vel"] = flow / 3600 / area;
    }

    return result;
  }

  static Map<String, dynamic> calcEfficiencyBasicRiser(
      flow, // Debi m³/h
      power, // Güç kW
      motorEfficiency, // Motor Verim %
      pressureIn, // Basınç bar
      pressureOut, // Basınç bar
      exloss, // Sürtünme kalibre m
      {double? dia} // İç Çap m
      ) {
    /*
    Calculates the yield.
    */

    Map<String, dynamic> result = {};

    result["hm"] = (pressureOut - pressureIn) * 10.197162 + exloss;
    result["hydraulic"] =
        (result["hm"] * flow) / (367.2 * power * motorEfficiency / 10000);
    result["system"] = result["hydraulic"] * motorEfficiency / 100;

    if (dia != null) {
      double area = math.pi * math.pow(dia, 2) / 4;
      result["water_vel"] = flow / 3600 / area;
    }

    return result;
  }

  static Map<String, dynamic> calcEfficiency(
      {
      required double flow, // Debi m³/h
      required double power, // Güç kW
      required double motorEfficiency, // Motor Verim %
      required double dischargeHead,
      double? dia} // İç Çap m
      ) {
    /*
    Calculates the yield.
    */

    Map<String, dynamic> result = {};

    result["hydraulic"] =(dischargeHead * flow) / (367.2 * power * motorEfficiency / 10000);
    result["system"] = result["hydraulic"] * motorEfficiency / 100;

    if (dia != null) {
      double area = math.pi * math.pow(dia, 2) / 4;
      result["water_vel"] = flow / 3600 / area;
    }

    return result;
  }
  static double calcMotorEfficiency(
      flow, // Debi m³/h
      power, // Güç kW
      hydraulic, // Motor Verim %
      dischargeHead,
      {double? dia} // İç Çap m
      ) {
    /*
    Calculates the yield.
    */



    return (dischargeHead*flow)/(hydraulic*367.2*power/10000);

  }
  static double calcdischargeHead(
      flow, // Debi m³/h
      power, // Güç kW
      hydraulic, // Motor Verim %
      motorEfficiency,
      {double? dia} // İç Çap m
      ) {
    /*
    Calculates the yield.
    */


    return ((367.2 * power * motorEfficiency / 10000)*hydraulic)/flow;
  }
  static double calcpower(
      flow, // Debi m³/h
      dischargeHead, // Güç kW
      hydraulic, // Motor Verim %
      motorEfficiency,
      {double? dia} // İç Çap m
      ) {
    /*
    Calculates the yield.
    */
   

    return (flow*dischargeHead)/(motorEfficiency*hydraulic*367.2/10000);
  }
  static Map<String, dynamic> calcflow(
      power, // Debi m³/h
      dischargeHead, // Güç kW
      hydraulic, // Motor Verim %
      motorEfficiency,
      {double? dia} // İç Çap m
      ) {
    /*
    Calculates the yield.
    */

    Map<String, dynamic> result = {};


    result["flow"] =(power*(motorEfficiency*hydraulic*367.2/10000))/dischargeHead;
 

    return result;
  }
  static Map<String, dynamic> calcFrictionLoss(
      flow, // Debi m³/h
      innerDiameter, // İç Çap m
      k, // Boru Yüzeyi m
      l, // Boru Uzunluğu m
      temperature, // Sıcaklık °C
       // Sürtünme kalibre m
      ) {
    /*
    Calculates the yield.
    */
    var a = math.pi * math.pow(innerDiameter, 2) / 4;

    var u = flow / 3600 / a;
    var result = calcColebrook(innerDiameter, k, u, temperature);

    result["u"] = u;

   result["friction_lost"]= (result["fd"] * l * math.pow(u, 2)) / (innerDiameter * (2 * 9.7905));

   
    return result;
  }
}
