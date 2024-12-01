part of 'friction_screen.dart';

extension FrictionView on FrictionScreenState {
  Widget _build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Utils.backgroundColor,
      appBar: buildAppBar(),
      body: Scrollbar(
        thickness: 3,
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: screenWidth > 700 ? 16 : 8,
            horizontal: screenWidth > 700 ? 64 : 8,
          ),
          child: Center(
            child: ListView(children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                height: 240,
                child: menuItem(
                    selectPipe.name, selectPipe.imagePath, selectPipe.friction),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: kIsWeb ? 12.0 : 0.0),
                decoration: BoxDecoration(
                    color: Utils.foregroundColor,
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const SizedBox(height: 4),
                      EditWidgets.editBox(
                          fieldList.pipeLength, calculateFriction),
                      EditWidgets.editBox(
                          fieldList.pipeInnaDiameter, calculateFriction),
                      EditWidgets.editBox(fieldList.flow, calculateFriction),
                      EditWidgets.editBox(
                          fieldList.waterTemp, calculateFriction)
                    ]),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                    color: Utils.foregroundColor,
                    borderRadius: BorderRadius.circular(20)),
                child: Card(
                  color: Utils.foregroundColor,
                  margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  elevation: 5,
                  child: Column(
  children: [
    for (int i = 0; i < resultItems.length; i++) ...[
      RichText(
        text: TextSpan(
          text: '${resultItems[i]}  : ',
          children: <TextSpan>[
            const TextSpan(
              style: TextStyle(fontWeight: FontWeight.w900),
            ),
            TextSpan(
              text: "${result[resultItemsVal[i]] != null ? (result[resultItemsVal[i]] is num ? (result[resultItemsVal[i]] as num).toStringAsFixed(3) : result[resultItemsVal[i]]) : ''}", 
              style: TextStyle(fontWeight: FontWeight.w900,fontSize: 20),
            ),
          ],
        ),
      ),
      SizedBox(height: 10.0), // Boşluk miktarını ayarlamak için height parametresini değiştirin
    ],
  ],
)
                ),
              )
            ]),
          ),
        ),
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

  Widget menuItem(String title, String imageName, double friction) {
    return ElevatedButton(
      onPressed: () async {
        var pipe = await Selector.showPipeSelector("boru seç");
        if (pipe != null) {
          selectPipe.name = pipe["select"] ?? selectPipe.name;
          selectPipe.imagePath = pipe["image"] ?? imageName;
          selectPipe.friction = pipe["friction"] ?? friction;
          localSetState();
          calculateFriction();
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
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text("Malzeme Seçimi",
                style: TextStyle(fontSize: 26, color: Utils.textColor)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Image(
                  image: AssetImage("assets/pipes/${selectPipe.imagePath}.png"),
                  height: 60,
                ),
                Text("S.K.  :     $friction"),
              ],
            ),
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
}
