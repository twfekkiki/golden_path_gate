class ShipmentStatusModel {
  String name;
  int index;

  ShipmentStatusModel(this.index,this.name);

  factory ShipmentStatusModel.fromMap(Map<String,dynamic> data){
    return ShipmentStatusModel(
        data['index'],
        data['name']
    );
  }

  @override
  String toString() {
    return name;
  }
}

class ShipmentServiceTypeModel {
  String name;
  int index;

  ShipmentServiceTypeModel(this.index,this.name);

  factory ShipmentServiceTypeModel.fromMap(Map<String,dynamic> data){
    return ShipmentServiceTypeModel(
        data['index'],
        data['name']
    );
  }

}