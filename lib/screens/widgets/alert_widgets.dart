import 'package:aquacalc/routes.dart';
import 'package:aquacalc/utils/utils.dart';
import 'package:flutter/material.dart';


class AlertWidgets {
  static void showSnackbar(String text,
      {Color backgroundColor = Colors.grey, int sec = 5}) {
    final SnackBar snackBar = SnackBar(
      backgroundColor: backgroundColor,
      duration: Duration(seconds: sec),
      content: Text(text),
    );

    ScaffoldMessenger.of(Routes.navigatorKey.currentContext!).clearSnackBars();
    ScaffoldMessenger.of(Routes.navigatorKey.currentContext!)
        .showSnackBar(snackBar);
  }

  static Future<void> showAlertDialog(String title, String content) {
    return showDialog(
      barrierDismissible: false,
      context: Routes.navigatorKey.currentContext!,
      builder: (_) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            MaterialButton(
              child: const Text("Tamam"),
              onPressed: () =>
                  Navigator.pop(Routes.navigatorKey.currentContext!),
            )
          ],
        );
      },
    );
  }

  static Future<bool> showConfirmDeleteSheet(
      String title, String content) async {
    bool? res = await showModalBottomSheet(
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
                  initialChildSize: 0.25,
                  minChildSize: 0.25,
                  maxChildSize: 0.9,
                  expand: false,
                  builder: (context, scrollController) => SafeArea(
                        child: Container(
                            padding: const EdgeInsets.all(16.0),
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
                                Text(
                                  content,
                                  style: TextStyle(
                                    color: Utils.textColor,
                                  ),
                                ),
                                const SizedBox(height: 25),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                        width: 115,
                                        height: 42,
                                        margin: const EdgeInsets.all(8.0),
                                        child: ElevatedButton.icon(
                                            onPressed: () =>
                                                Routes.pop(data: true),
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Utils.errorColor),
                                            icon: Icon(Icons.delete,
                                                color: Utils.textColor),
                                            label: Text(
                                              "Sil",
                                              style: TextStyle(
                                                  color: Utils.textColor),
                                            ))),
                                    Container(
                                        width: 115,
                                        height: 42,
                                        margin: const EdgeInsets.all(8.0),
                                        child: ElevatedButton.icon(
                                            onPressed: () =>
                                                Routes.pop(data: false),
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Utils.backgroundColor),
                                            icon: Icon(Icons.close,
                                                color: Utils.textColor),
                                            label: Text(
                                              "İptal",
                                              style: TextStyle(
                                                  color: Utils.textColor),
                                            ))),
                                  ],
                                )
                              ],
                            )),
                      ));
            }));

    res ??= false;
    return res;
  }

  static Future<int?> showFilterOptions(
      int selectedIndex, List<String> optionList) async {
    return await showDialog(
        context: Routes.navigatorKey.currentContext!,
        builder: (BuildContext context) {
          int selectedRadio = selectedIndex;

          return AlertDialog(
            backgroundColor: Utils.backgroundColor,
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children:
                      List<Widget>.generate(optionList.length, (int index) {
                    return InkWell(
                      onTap: selectedRadio == index
                          ? null
                          : () {
                              setState(() => selectedRadio = index);
                            },
                      child: ListTile(
                        leading: Radio<int>(
                          fillColor: MaterialStateColor.resolveWith(
                              (_) => Utils.textColor),
                          visualDensity: const VisualDensity(
                            horizontal: VisualDensity.minimumDensity,
                            vertical: VisualDensity.minimumDensity,
                          ),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          value: index,
                          groupValue: selectedRadio,
                          onChanged: null,
                        ),
                        title: Text(
                          optionList[index],
                          style: TextStyle(color: Utils.textColor),
                        ),
                      ),
                    );
                  }),
                );
              },
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  onPressed: () => Routes.pop(data: selectedRadio),
                  icon: const Icon(Icons.filter_alt),
                  color: Utils.textColor,
                ),
              ),
            ],
          );
        });
  }

  static void showError({String? text, Object? error}) {
    error = error.toString(); //Connection refused, Future not completed
    String emsg =  'Bilinmeyen bir hata oluştu';
    return showSnackbar("${text ?? ''} $emsg",
        backgroundColor: Utils.errorColor);
  }

  static void showSuccess({String? text}) =>
      showSnackbar(text ?? "Başarılı", backgroundColor: Utils.successColor);
}
