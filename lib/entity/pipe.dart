class Pipe {
  String name;
  double friction;
  String imagePath;

  Pipe({required this.name, required this.friction, required this.imagePath});
}

class SelectCable {
  String name;
  double friction;
  String imagePath;

  SelectCable(
      {required this.name, required this.friction, required this.imagePath});
}

class Measurements {
  int id;
  String date;
  String note;
  String description;
  String calcmode;
  String? img;
  double? result;

  Measurements(this.id,this.description,this.result,this.note,this.calcmode,this.date
   );

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map["calcmode"] = calcmode;
    map["description"] = description;
    map["note"] = note;
    map["date"] = date;
    map["result"] = result;
    map["id"] = id;
    
    return map;
  }

  // Product.withId({required this.id,required this.name,required this.description,required this.unitPrice});
}
