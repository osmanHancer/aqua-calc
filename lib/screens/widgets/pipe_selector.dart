import 'package:aquacalc/entity/pipe.dart';
import 'package:aquacalc/routes.dart';
import 'package:aquacalc/utils/utils.dart';
import 'package:flutter/material.dart';

class Selector {
   static List<Pipe> pipes=[
  Pipe(name: "Galvanizli Çelik", friction:0.008, imagePath: "galvanizli_boru"),
  Pipe(name: "Aliminyum", friction: 0.0014, imagePath: "aluminyum_boru"),
  Pipe(name: "Asbest Beton", friction: 0.06, imagePath: "asbest_boru"),
  Pipe(name: "Bakır", friction: 0.0014, imagePath: "bakir_boru"),
  Pipe(name: "Pürüzsüz Beton", friction: 0.5, imagePath: "pruruzsuz_beton_boru"),
  Pipe(name: "Orta Pürüzlü Beton", friction: 1.5, imagePath: "orta_puruzlu_beton_boru"),
  Pipe(name: "Pürüzlü Beton", friction: 2.5, imagePath: "puruzlu_beton_boru"),
  Pipe(name: "Bitümlü Çelik", friction: 0.03, imagePath: "bitumlu_celik_boru"),
  Pipe(name: "Paslanmaz Çelik", friction: 0.015, imagePath: "paslanmaz_çelik"),
  Pipe(name: "Pik Demir", friction: 1.2, imagePath: "pik_demir_boru"),
  Pipe(name: "Bitümlü Demir", friction: 0.11, imagePath: "bitumlu_demir_boru"),
  Pipe(name: "Pirinç", friction: 0.03, imagePath: "pirinc_boru"),
  Pipe(name: "Polietlilen", friction: 0.02, imagePath: "polyethylene_boru"),
  Pipe(name: "Pvc", friction: 0.00425, imagePath: "pvc_boru"),
  

  ];
   static List<SelectCable> cables=[
  SelectCable(name: "Bakır Kablo", friction:0.008, imagePath: "bakır_m"),
  SelectCable(name: "Aliminyum Kablo", friction:0.008, imagePath: "aliminyum_m"),

  

  ];
    static Map<String, dynamic> selectedPipe = {
    "select": "Galvenizli Çelik ",
    "image": "galvanizli_boru",
    "friction":0.008
  };
  static Future<dynamic> showPipeSelector(String title) async {
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
                  builder: (context, scrollController) => SafeArea(
                        child: Container(
                            decoration: BoxDecoration(
                              color: Utils.foregroundColor,
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(15),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  title,
                                  style: TextStyle(
                                      color: Utils.textColor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(height: 15),
                                Expanded(
                                  child: GridView.count(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 2,
                                      mainAxisSpacing: 2,
                                      children: [
                                         for(int i=0;i<pipes.length;i++)
                                          selectorMenu(pipes[i]),
                                      ]),
                                ),
                              ],
                            )),
                      ));
            }));

    return res;
  }
  static Future<dynamic> showCableSelector(String title) async {
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
                  builder: (context, scrollController) => SafeArea(
                        child: Container(
                            decoration: BoxDecoration(
                              color: Utils.foregroundColor,
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(15),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  title,
                                  style: TextStyle(
                                      color: Utils.textColor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(height: 15),
                                SizedBox(
                                  height: 400,
                                  child: GridView.count(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 2,
                                      mainAxisSpacing: 2,
                                      children: [
                                         for(int i=0;i<cables.length;i++)
                                          selectorMenu(cables[i]),
                                      ]),
                                ),
                              ],
                            )),
                      ));
            }));

    return res;
  }

  static Widget selectorMenu(dynamic pipe) {
    return ElevatedButton(
      onPressed: () {
        selectedPipe["select"] = pipe.name;
        selectedPipe["image"] = pipe.imagePath;
        selectedPipe["friction"] = pipe.friction;
        Routes.pop(data: selectedPipe);
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),

        backgroundColor: Utils.foregroundColor, // Text Color (Foreground color)
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image(
            image: AssetImage("assets/pipes/${pipe.imagePath}.png"),
            width: 180,
          ),
      
          const SizedBox(height: 20),
          Text(
            pipe.name,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Utils.textColor),
          )
        ],
      ),
    );
  }
}
