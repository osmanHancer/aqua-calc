

import 'package:aquacalc/entity/unit.dart';
import 'package:aquacalc/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditWidgets {
  static Widget editBox(EditField field, Function()? onChange,
      {bool image = true}) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: ListTile(
        visualDensity: const VisualDensity(vertical: -4),
        leading: (field.image != null
            ? Image.asset("assets/icons/${field.image}.png")
            : null),
        title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Expanded(
                  flex: 3,
                  child: TextFormField(
                      cursorColor: Utils.primaryColor,
                      decoration: InputDecoration(
                          fillColor: Utils.foregroundColor,
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Utils.primaryColor),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Utils.inactiveColor),
                          ),
                          labelText: field.title,
                          labelStyle:
                              TextStyle(fontSize: 18, color: Utils.textColor)),
                      style: TextStyle(color: Utils.textColor),
                      initialValue: (field.val != null && !(field.val!.isNaN))
                          ? field.val.toString()
                          : null,
                      controller: (field.val != null && field.val!.isNaN)
                          ? TextEditingController(text: "")
                          : null,
                      keyboardType:TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.singleLineFormatter
                      ],
                      onChanged: (value) {
                        field.val = double.tryParse(value);
                        if (onChange != null) {
                          onChange();
                       
                        }
                      })),
              SizedBox(width: 40),
              Expanded(
                child: DropdownButton<String>(
                  dropdownColor: Utils.inactiveColor,
                  value: field.unit,
                  icon: const Icon(Icons.expand_more),
                  elevation: 16,
                  style: TextStyle(color: Utils.textColor),
                  onChanged: (value) {
                  
                    field.unit = value ?? "";
                    if (onChange != null) {
                      onChange();
                 
                    }
                  },
                  items: field.unitList
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(color: Utils.textColor),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ]),
      ),
    );
  }
}
