part of 'cable_cost_screen.dart';

extension FrictionView on _CableWievState {
  Widget _build(BuildContext context) {
    return SelectionArea(
      child: Scaffold(
        backgroundColor: Utils.backgroundColor,
        appBar: buildAppBar(),
        body: Scrollbar(
            thickness: 3,
            child: Padding(
                padding: const EdgeInsets.all(10),
                child: ListView(
                  children: [
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                          color: Utils.foregroundColor,
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 5,
                            ),
                            Text("Kablo Malzemesi",
                                style: TextStyle(
                                    fontSize: 22, color: Utils.textColor)),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                menuItem(
                                    selectCable.name, selectCable.imagePath),
                              ],
                            )
                          ]),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      height: 130,
                      decoration: BoxDecoration(
                          color: Utils.foregroundColor,
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Text("Voltaj Değeri",
                                style: TextStyle(
                                    fontSize: 21, color: Utils.textColor)),
                            const SizedBox(height: 30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: button_230 == true
                                            ? Utils.primaryColor
                                            : Utils.backgroundColor),
                                    onPressed: () {
                                      button_230 = true;
                                      button_380 = false;
                                      button_500 = false;
                                      if (selectCable.name == "Bakır Kablo") {
                                        selectCable.friction =
                                            coefficientCu[230]!;
                                      } else {
                                        selectCable.friction =
                                            coefficientAl[230]!;
                                      }
                                      calculateCableCost();
                                      localSetState();
                                    },
                                    child: Text(
                                      "230",
                                      style: TextStyle(color: Utils.textColor),
                                    )),
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: button_380 == true
                                            ? Utils.primaryColor
                                            : Utils.backgroundColor),
                                    onPressed: () {
                                      button_230 = false;
                                      button_380 = true;
                                      button_500 = false;
                                      if (selectCable.name == "Bakır Kablo") {
                                        selectCable.friction =
                                            coefficientCu[380]!;
                                      } else {
                                        selectCable.friction =
                                            coefficientAl[380]!;
                                      }
                                      calculateCableCost();
                                      localSetState();
                                    },
                                    child: Text(
                                      "380",
                                      style: TextStyle(color: Utils.textColor),
                                    )),
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: button_500 == true
                                            ? Utils.primaryColor
                                            : Utils.backgroundColor),
                                    onPressed: () {
                                      button_230 = false;
                                      button_380 = false;
                                      button_500 = true;
                                      if (selectCable.name == "Bakır Kablo") {
                                        selectCable.friction =
                                            coefficientCu[500]!;
                                      } else {
                                        selectCable.friction =
                                            coefficientAl[500]!;
                                      }
                                      calculateCableCost();
                                      localSetState();
                                    },
                                    child: Text(
                                      "500",
                                      style: TextStyle(color: Utils.textColor),
                                    )),
                              ],
                            )
                          ]),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                          color: Utils.foregroundColor,
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(children: [
                        const SizedBox(height: 20),
                        EditWidgets.editBox(
                            cableFieldList.activePower, calculateCableCost),
                        EditWidgets.editBox(
                            cableFieldList.cableLong, calculateCableCost),
                        EditWidgets.editBox(
                            cableFieldList.dailyWork, calculateCableCost),
                        EditWidgets.editBox(
                            cableFieldList.valtageDrop, calculateCableCost)
                      ]),
                    ),
                    const SizedBox(height: 20),
                    result["minumum_diameter_result"] != null
                        ? Container(
                            height: 230,
                            decoration: BoxDecoration(
                                color: Utils.foregroundColor,
                                borderRadius: BorderRadius.circular(20)),
                            child: resultCalculate(result))
                        : Container()
                  ],
                ))),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: Utils.primaryColor,
      title: Text(
        title,
        style: TextStyle(color: Utils.textColor),
      ),
    );
  }

  Widget menuItem(String title, String imageName) {
    return ElevatedButton(
      onPressed: () async {
        var cable = await Selector.showCableSelector("Kablo seç");
        if (cable != null) {
          selectCable.name = cable["select"] ?? selectCable.name;
          selectCable.imagePath = cable["image"] ?? imageName;
          if (selectCable.name == "Bakır Kablo") {
            selectCable.friction = coefficientCu[380]!;
          } else {
            selectCable.friction = coefficientAl[380]!;
          }
          button_230 = false;
          button_380 = true;
          button_500 = false;
          localSetState();
          calculateCableCost();
        }
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),

        backgroundColor: Utils.backgroundColor, // Text Color (Foreground color)
      ),
      child: InkWell(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Image(
                  image:
                      AssetImage("assets/pipes/${selectCable.imagePath}.png"),
                  height: 80,
                ),
                Text("K.S.  :     ${selectCable.friction.toStringAsFixed(5)}"),
              ],
            ),
            const SizedBox(height: 30),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Utils.textColor),
            )
          ],
        ),
      ),
    );
  }

  Future<dynamic> showAnalyz(String title) async {
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
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    for (int i = 0; i < payOfList.length; i++)
                                      Container(
                                        width: 400,
                                        height: 35,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.black,
                                                width: 5.0,
                                                style: BorderStyle.solid),
                                            borderRadius:
                                                BorderRadius.circular(14),
                                            color: changeColor(payOfList[i])),
                                        child: Center(
                                          child: payOfList[i] < 0.01
                                              ? Text("yetersiz iç çap")
                                              : Text(innaDiameterList[i] +
                                                  " : " +
                                                  payOfList[i]
                                                      .toStringAsFixed(3) +
                                                  "   yılda amorti eder"),
                                        ),
                                      )
                                  ],
                                )
                              ],
                            )),
                      ));
            }));

    return res;
  }

  Widget resultCalculate(dynamic result) {
    return Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      const SizedBox(height: 10),
      SelectableText.rich(
        TextSpan(
          text: 'Minumum Kesit:   ',
          children: <TextSpan>[
            TextSpan(
              text:
                  " ${result["minumum_diameter_result"] != null ? result["minumum_diameter_result"].toStringAsFixed(2) : ""} ",
              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
            ),
            const TextSpan(text: 'mm²'),
          ],
        ),
        style: const TextStyle(
            color: Colors.white), // Varsayılan metin rengi, isteğe bağlı
      ),
      SelectableText.rich(
        TextSpan(
          text: 'Kablo Çapı:           ',
          children: <TextSpan>[
            TextSpan(
              text:
                  "${result["cable_diameter_result"] != null ? result["cable_diameter_result"].toStringAsFixed(2) : ""} ",
              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
            ),
            const TextSpan(text: 'mm²'),
          ],
        ),
        style: const TextStyle(
            color: Colors.white), // Varsayılan metin rengi, isteğe bağlı
      ),
      SelectableText.rich(
        TextSpan(
          text: 'Yıllık Kayıp:            ',
          children: <TextSpan>[
            TextSpan(
              text:
                  "${result["yearly_loss"] != null ? result["yearly_loss"].toStringAsFixed(2) : ""} ",
              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
            ),
            const TextSpan(text: 'kWh'),
          ],
        ),
        style: const TextStyle(
            color: Colors.white), // Varsayılan metin rengi, isteğe bağlı
      ),
      ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green, // Background color
          ),
          onPressed: () {
            calculateCableCost();
            showAnalyz("Kablo Maliyeti");
          },
          child: const Text("Maliyet Analizi"))
    ]);
  }
}
