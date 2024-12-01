part of 'torque_screen.dart';

extension EffView on _TorqueScreenState {
  Widget _build(BuildContext context) {
    return Scaffold(
        backgroundColor: Utils.backgroundColor,
        appBar: buildAppBar(),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                  padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                  scrollDirection: Axis.vertical,
                  itemExtent: 100.0,
                  children: [
                    ...getEditList(calcMode),
                    if (inputs["result"] != null)
                      Container(
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 106, 23, 145),
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 15,
                            ),
                            Column(
                              children: [
                                Text(
                                  calcMode == "Güçten Tork Hesapla"
                                      ? "Tork"
                                      : "Güç",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Utils.textColor),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                     const SizedBox(
                                      width: 30,
                                    ),
                                    Text(
                                      inputs["result"],
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Utils.textColor),
                                    ),
                                    const SizedBox(
                                      width: 30,
                                    ),
                                    // Text(
                                    //   inputs["result_unit"] ?? "",
                                    //   style: TextStyle(
                                    //       fontSize: 16,
                                    //       fontWeight: FontWeight.w400,
                                    //       color: Utils.textColor),
                                    // ),
                                    Expanded(
                                      child: DropdownButton<String>(
                                        dropdownColor: Utils.inactiveColor,
                                        value: inputs["result_unit"],
                                        icon: const Icon(Icons.expand_more),
                                        elevation: 16,
                                        style:
                                            TextStyle(color: Utils.textColor),
                                        onChanged: (value) {},
                                        items: fieldList.power.unitList
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(
                                              value,
                                              style: TextStyle(
                                                  color: Utils.textColor),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    ElevatedButton(
                                        style: const ButtonStyle(
                                          backgroundColor:
                                              WidgetStatePropertyAll<Color>(
                                                  Color.fromRGBO(
                                                      22, 28, 54, 1)),
                                        ),
                                        onPressed: () {
                                          resetForm();
                                          localSetState();
                                        },
                                        child: Text("Sıfırla",style: TextStyle(
                                    color: Utils.textColor))),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    ElevatedButton.icon(
                                      style: ButtonStyle(
                                        backgroundColor:
                                            WidgetStatePropertyAll<Color>(
                                                Color.fromRGBO(22, 28, 54, 1)),
                                      ),
                                      onPressed: () async {
                                        await showInformationDialog(context);
                                      },
                                      icon: const Icon(Icons
                                          .save), //icon data for elevated button
                                      label: Text("Kaydet",style: TextStyle(
                                     color: Utils.textColor)), //label text
                                    )
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                  ]),
            ),
          ],
        ));
  }

  List<Widget> getEditList(mode) {
    return [
      if (mode == TorqueCalcMode.powertorque)
        EditWidgets.editBox(
          fieldList.power,
          calculate,
        ),
      EditWidgets.editBox(
        fieldList.speed,
        calculate,
      ),
      if (mode == TorqueCalcMode.torquepower)
        EditWidgets.editBox(
          fieldList.torque,
          calculate,
        ),
    ];
  }

  AppBar buildAppBar() {
    return AppBar(
      actions: [
        Center(
          child: DropdownButton<String>(
            dropdownColor: Utils.foregroundColor,
            value: calcMode,
            icon: const Icon(Icons.expand_more),
            elevation: 16,
            style: TextStyle(color: Utils.textColor, fontSize: 17),
            items: calcModes.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (value) {
              calcMode = value!;
              resetForm();
              localSetState();
            },
          ),
        )
      ],
      title: Text(
        "Tork",
        style: TextStyle(color: Utils.textColor),
      ),
      backgroundColor: Utils.primaryColor,
    );
  }

  Future<void> showInformationDialog(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              content: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: _textEditingController,
                        validator: (value) {
                          return value!.isNotEmpty ? null : "Enter any text";
                        },
                        decoration: InputDecoration(hintText: "Not Giriniz"),
                      ),
                    ],
                  )),
              actions: <Widget>[
                InkWell(
                  child: const Text('Kaydet'),
                  onTap: () async {
                    if (_formKey.currentState!.validate()) {
                      Map<String, dynamic> dataMap = {
                        'id': _TorqueScreenState.id,
                        'calcMode': calcMode,
                        'description': "Tork",
                        'note': _textEditingController.text,
                        'result': double.parse(inputs["result"]),
                        'date':
                            ("${DateTime.now().day}.${DateTime.now().month}.${DateTime.now().year}"),
                      };
                      String jsonString = jsonEncode(dataMap);
                      await Utils.prefs.setString(
                          _TorqueScreenState.id.toString(), jsonString);

                      _TorqueScreenState.id++;
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            );
          });
        });
  }
}
